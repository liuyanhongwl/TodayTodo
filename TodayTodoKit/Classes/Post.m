//
//  Post.m
//  TodayTodo
//
//  Created by Hong on 16/7/21.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "Post.h"
#import "APIClient.h"
#import "NetworkConstant.h"

@implementation Post

#pragma mark - YYModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    NSDictionary *d = [dic objectForKey:@"thumbnail"];
    if (d) {
        d = [d objectForKey:@"standard"];
        if (d) {
            NSString *url = [d objectForKey:@"url"];
            if (url) {
                self.url = url;
            }
        }
    }
    
    return YES;
}

#pragma mark - Public

+ (void)getPostCompletion:(void (^)(NSArray *posts, NSError *error))completion
{
    
    [[APIClient sharedClient] GET:@"/api/v3/videos/extension" parameters:nil encrypt:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        
        id jsonObject = [self jsonObjectFromResponseObject:responseObject encrypt:YES];
        
        //NSLog(@"%@",jsonObject);
        
        NSArray *allItems = [jsonObject objectForKey:@"items"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        
        for (id jsonItem in allItems) {
            Post *post = [Post yy_modelWithJSON:jsonItem];
            if (post) {
                [items addObject:post];
            }
        }
        
        if (completion) {
            completion(items, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

+ (void)loadDataCompletion:(void (^)(NSArray <Post *> *posts))completion
{
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wlnana17.today"];
    NSArray *jsonList = [groupDefaults objectForKey:@"today-second"];
    if (jsonList && jsonList.count) {
        NSMutableArray *items = [NSMutableArray array];
        for (NSString *jsonString in jsonList) {
            Post *post = [Post yy_modelWithJSON:jsonString];
            if (post) {
                [items addObject:post];
            }
        }
        if (completion) {
            completion(items);
        }
    }else{
        
        [Post getPostCompletion:^(NSArray *posts, NSError *error) {
            if (completion) {
                completion(posts);
            }
            [Post saveData:posts];
        }];
    }
}

+ (void)saveData:(NSArray <Post *>*)posts
{
    NSUserDefaults *groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wlnana17.today"];
    NSMutableArray *items = [NSMutableArray array];
    for (Post *post in posts) {
        NSString *string = [post yy_modelToJSONString];
        if (string) {
            [items addObject:string];
        }
    }
    [groupDefaults setObject:items forKey:@"today-second"];
    [groupDefaults synchronize];
}

#pragma mark - Helper

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    CFStringRef cfString = CFURLCreateStringByAddingPercentEscapes(
                                                                   NULL, /* allocator */
                                                                   (__bridge CFStringRef)input,
                                                                   NULL, /* charactersToLeaveUnescaped */
                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                   kCFStringEncodingUTF8);
    NSString *baseString = [[NSString stringWithString:(__bridge NSString *)cfString] copy];
    //释放
    CFRelease(cfString);
    
    return baseString;
}

+ (id)jsonObjectFromResponseObject:(id)responseObject encrypt:(BOOL)encrypt
{
    NSError *err = nil;
    id jsonObject;
    
    if (encrypt) {
        NSData *decryptData = [responseObject AESDecryptWithKey:[[NetworkConstant defaultConstant] aesKey]];
        if (decryptData) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:decryptData options:kNilOptions error:&err];
        }
    }else{
        if (responseObject) {
            jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&err];
        }
    }
    
    if (err) {
        NSLog(@"response error : %@", err);
    }
    
    return jsonObject;
}

@end
