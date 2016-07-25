//
//  APIClient.m
//  TodayTodo
//
//  Created by Hong on 16/7/21.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (instancetype)sharedClient
{
    static APIClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.idailycast.com"] sessionConfiguration:configuration];
    });
    return client;
}

@end
