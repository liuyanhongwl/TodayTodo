//
//  SUHTTPSessionManager.h
//  NSURLSession-test
//
//  Created by Hong on 15/12/3.
//  Copyright © 2015年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AESEncryption.h"

@interface SUHTTPSessionManager : NSObject

@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLSession *session;

+ (instancetype)defaultManager;

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      encrypt:(BOOL)encrypt
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                bodyParameters:(NSDictionary *)bodyParameters
                       encrypt:(BOOL)encrypt
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                  bodyParameters:(NSDictionary *)bodyParameters
                         encrypt:(BOOL)encrypt
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
               bodyParameters:(NSDictionary *)bodyParameters
                      encrypt:(BOOL)encrypt
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)normalGET:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(NSURLSessionTask *task, id responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
