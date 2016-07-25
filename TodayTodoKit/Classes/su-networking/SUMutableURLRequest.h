//
//  SUMutableURLRequest.h
//  NSURLSession-test
//
//  Created by Hong on 15/12/4.
//  Copyright © 2015年 Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SURequestContentType){
    SURequestContentTypeStream,
    SURequestContentTypeUrlencoded
};

@interface SUMutableURLRequest : NSMutableURLRequest

@property (nonatomic, assign) SURequestContentType contentType;

+ (SUMutableURLRequest *)baseURLRequestWithString:(NSString *)urlString baseURL:(NSURL *)baseURL encrypt:(BOOL)encrypt;

- (void)addURLParams:(NSDictionary *)params;
- (void)addPostParams:(NSDictionary *)params;

@end
