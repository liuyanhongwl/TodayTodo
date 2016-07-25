//
//  NetworkConstant.m
//  TodayTodo
//
//  Created by Hong on 16/7/25.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "NetworkConstant.h"
#import "SUNetworking.h"

@implementation NetworkConstant

+ (instancetype)defaultConstant
{
    static NetworkConstant *constant = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        constant = [[NetworkConstant alloc] init];
        constant.urlHost = @"http://api.idailycast.com";
        constant.aesKey = @"MP8sKqnxAw32xcf4W429Gw==";
        SUNetworking *networking = [SUNetworking defaultNetworking];
        networking.network = constant;
    });
    return constant;
}

@end
