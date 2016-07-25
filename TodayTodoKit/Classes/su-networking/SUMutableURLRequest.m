//
//  SUMutableURLRequest.m
//  NSURLSession-test
//
//  Created by Hong on 15/12/4.
//  Copyright © 2015年 Hong. All rights reserved.
//

#import "SUMutableURLRequest.h"
#import "SUNetworkingHeader.h"
#import "NSData+AESEncryption.h"
#import "SUNetworking.h"

@interface SUMutableURLRequest ()

@property (nonatomic, assign) BOOL encrypt;

@end

@implementation SUMutableURLRequest

+ (SUMutableURLRequest *)baseURLRequestWithString:(NSString *)urlString baseURL:(NSURL *)baseURL encrypt:(BOOL)encrypt
{
    if (!baseURL) {
        baseURL = [NSURL URLWithString:[SUNetworking defaultNetworking].network.urlHost];
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL.absoluteString, urlString]];
    
    SUMutableURLRequest *mutableRequest = [[SUMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setCachePolicy:REQUEST_DEFAULT_ShouldHandleCookies];
    [mutableRequest setHTTPShouldHandleCookies:REQUEST_DEFAULT_ShouldHandleCookies];
    [mutableRequest setTimeoutInterval:REQUEST_DEFAULT_Timeout];
    mutableRequest.encrypt = encrypt;
    
    [mutableRequest addURLParams:[SUMutableURLRequest stableURLParams]];
    
    return mutableRequest;
}

- (void)addURLParams:(NSDictionary *)params
{
    NSMutableString *urlQuery = [NSMutableString string];
    for (NSString *key in [params allKeys]) {
        NSString *value = [params objectForKey:key];

        [urlQuery appendFormat:@"%@=%@&", [self encodeToPercentEscapeString:key], [self encodeToPercentEscapeString:value]];

    }
    if ([urlQuery hasSuffix:@"&"]) {
        [urlQuery deleteCharactersInRange:NSMakeRange(urlQuery.length - 1, 1)];
    }
    
    self.URL = [NSURL URLWithString:[self.URL.absoluteString stringByAppendingFormat:self.URL.query ? @"&%@" : @"?%@", urlQuery]];
}

- (void)addPostParams:(NSDictionary *)params
{
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];

    
    if (self.encrypt) {
        paramsData = [paramsData AESEncryptWithKey:[SUNetworking defaultNetworking].network.aesKey];
    }
    
    [self setHTTPBody:paramsData];
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
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

#pragma mark - Setters

- (void)setContentType:(SURequestContentType)contentType
{
    _contentType = contentType;
    switch (contentType) {
        case SURequestContentTypeStream:
            [self setValue:@"application/octet-stream; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            break;
        case SURequestContentTypeUrlencoded:
            [self setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            
            break;
        default:
            break;
    }
}

+ (NSDictionary *)stableURLParams
{
    NSDictionary *stableParams = @{
                                   @"dm" : @"iPhone",
                                   @"from" : @"com.sube.dailycast",
                                   @"idfa" : @"DA986558-9991-44F6-AF32-05933038BFCF",
                                   @"lc" : @"appstore",
                                   @"locale" : @"English (United States)",
                                   @"nw" : @"wifi",
                                   @"on" : @"ios",
                                   @"op" : @"US",
                                   @"sdk" : @"9.3",
                                   @"trace" : [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000],
                                   @"tz" : @"Asia/Shanghai",
                                   @"vc" : @"254",
                                   @"vn" : @"3.0.7",
                                   @"an" : @"1000",
                                   @"count" : @"20",
                                   @"udid" : @"C21D9828-7EEF-46EC-A51A-66F7006F3888"
                                   };
    
    return stableParams;
}



@end


