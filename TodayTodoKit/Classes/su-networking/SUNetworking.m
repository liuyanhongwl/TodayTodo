//
//  SUNetworking.m
//  Pods
//
//  Created by Hong on 16/1/27.
//
//

#import "SUNetworking.h"
#import "SUNetworkingHeader.h"

@implementation SUNetworking

+ (instancetype)defaultNetworking
{
    static SUNetworking *networking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networking = [[SUNetworking alloc] init];
    });
    return networking;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
