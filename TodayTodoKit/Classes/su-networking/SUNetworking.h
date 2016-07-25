//
//  SUNetworking.h
//  Pods
//
//  Created by Hong on 16/1/27.
//
//

#import <Foundation/Foundation.h>
#import "SUNetworkingProtocol.h"

@interface SUNetworking : NSObject

+ (instancetype)defaultNetworking;

@property (nonatomic, strong) id <SUNetworkingProtocol> network;

@end
