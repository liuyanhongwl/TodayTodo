//
//  SUHTTPSessionManager.m
//  NSURLSession-test
//
//  Created by Hong on 15/12/3.
//  Copyright © 2015年 Hong. All rights reserved.
//

#import "SUHTTPSessionManager.h"
#import "SUMutableURLRequest.h"

static dispatch_queue_t url_session_manager_creation_queue() {
    static dispatch_queue_t af_url_session_manager_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_url_session_manager_creation_queue = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_SERIAL);
    });
    
    return af_url_session_manager_creation_queue;
}

static NSString * const SUHTTPSessionManagerLockName = @"com.su.networking.session.manager.lock";

typedef void (^SUURLSessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);

#pragma mark - SUSessionManagerTaskDelegate

@interface SUSessionManagerTaskDelegate : NSObject

@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, copy) SUURLSessionTaskCompletionHandler completionHandler;

@end

@implementation SUSessionManagerTaskDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableData = [NSMutableData data];
    }
    return self;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSLog(@"task identifier : %lu", (unsigned long)task.taskIdentifier);
        NSLog(@"%@ status code : %lu", task.currentRequest.URL.absoluteString, (long)[(NSHTTPURLResponse *)task.response statusCode]);
    }
    
    if (error) {
        NSLog(@"%@", error);
        if (self.completionHandler) {
            self.completionHandler(task.response, self.mutableData, error);
        }
    } else {
        if (self.completionHandler) {
            self.completionHandler(task.response, self.mutableData, nil);
        }
    }
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.mutableData appendData:data];
}


@end

#pragma mark -

@interface SUHTTPSessionManager ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURL *baseURL;
@property (readwrite, nonatomic, strong) NSLock *lock;
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;

@end

@implementation SUHTTPSessionManager

+ (instancetype)defaultManager
{
    static SUHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SUHTTPSessionManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    return [self initWithBaseURL:nil sessionConfiguration:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    self.sessionConfiguration = configuration;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
    
    self.mutableTaskDelegatesKeyedByTaskIdentifier = [[NSMutableDictionary alloc] init];
    
    self.lock = [[NSLock alloc] init];
    self.lock.name = SUHTTPSessionManagerLockName;
    
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    self.baseURL = url;
    
    return self;
}

#pragma mark -

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      encrypt:(BOOL)encrypt
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    SUMutableURLRequest *request = [SUMutableURLRequest baseURLRequestWithString:URLString baseURL:self.baseURL encrypt:encrypt];
    [request addURLParams:parameters];
    [request setContentType:SURequestContentTypeUrlencoded];
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPRequest:request success:success failure:failure];
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                bodyParameters:(NSDictionary *)bodyParameters
                       encrypt:(BOOL)encrypt
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    SUMutableURLRequest *request = [SUMutableURLRequest baseURLRequestWithString:URLString baseURL:self.baseURL encrypt:encrypt];
    [request setHTTPMethod:@"POST"];
    [request addURLParams:parameters];
    [request addPostParams:bodyParameters];
    if (encrypt) {
        [request setContentType:SURequestContentTypeStream];
    }else{
        [request setContentType:SURequestContentTypeUrlencoded];
    }
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPRequest:request success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  bodyParameters:(NSDictionary *)bodyParameters
                         encrypt:(BOOL)encrypt
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    SUMutableURLRequest *request = [SUMutableURLRequest baseURLRequestWithString:URLString baseURL:self.baseURL encrypt:encrypt];
    [request setHTTPMethod:@"DELETE"];
    [request addURLParams:parameters];
    [request addPostParams:bodyParameters];
    if (encrypt) {
        [request setContentType:SURequestContentTypeStream];
    }else{
        [request setContentType:SURequestContentTypeUrlencoded];
    }
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPRequest:request success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
               bodyParameters:(NSDictionary *)bodyParameters
                      encrypt:(BOOL)encrypt
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    SUMutableURLRequest *request = [SUMutableURLRequest baseURLRequestWithString:URLString baseURL:self.baseURL encrypt:encrypt];
    [request setHTTPMethod:@"PUT"];
    [request addURLParams:parameters];
    [request addPostParams:bodyParameters];
    if (encrypt) {
        [request setContentType:SURequestContentTypeStream];
    }else{
        [request setContentType:SURequestContentTypeUrlencoded];
    }
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPRequest:request success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)normalGET:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(NSURLSessionTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:URLString];
    SUMutableURLRequest *request = [[SUMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = 10;
    [request addURLParams:parameters];
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPRequest:request success:success failure:failure];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPRequest:(NSURLRequest *)request
                                          success:(void (^)(NSURLSessionDataTask *, id))success
                                          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    __block NSURLSessionDataTask *dataTask = nil;
    //在串行队列中，创建task。
    dispatch_sync(url_session_manager_creation_queue(), ^{
        dataTask = [self.session dataTaskWithRequest:request];
    });
    
    [self addDelegateForDataTask:dataTask completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error){
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downLoadResult" object:nil];
            
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}

#pragma mark - set delegate

- (void)addDelegateForDataTask:(NSURLSessionDataTask *)dataTask
             completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    SUSessionManagerTaskDelegate *delegate = [[SUSessionManagerTaskDelegate alloc] init];
    delegate.completionHandler = completionHandler;
    
    [self setDelegate:delegate forTask:dataTask];
}

- (void)setDelegate:(SUSessionManagerTaskDelegate *)delegate
            forTask:(NSURLSessionTask *)task
{
    NSParameterAssert(task);
    NSParameterAssert(delegate);
    
    [self.lock lock];
    self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
    [self.lock unlock];
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task {
    NSParameterAssert(task);
    
    [self.lock lock];
    [self.mutableTaskDelegatesKeyedByTaskIdentifier removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

- (void)removeAllDelegates {
    [self.lock lock];
    [self.mutableTaskDelegatesKeyedByTaskIdentifier removeAllObjects];
    [self.lock unlock];
}

- (SUSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
    NSParameterAssert(task);
    
    SUSessionManagerTaskDelegate *delegate = nil;
    [self.lock lock];
    delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)];
    [self.lock unlock];
    
    return delegate;
}

#pragma mark - Delegate

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    SUSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
    
    // delegate may be nil when completing a task in the background
    if (delegate) {
        [delegate URLSession:session task:task didCompleteWithError:error];

        [self removeDelegateForTask:task];
    }
    
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    SUSessionManagerTaskDelegate *delegate = [self delegateForTask:dataTask];
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}


@end
