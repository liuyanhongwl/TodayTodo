//
//  NetworkConstant.h
//  TodayTodo
//
//  Created by Hong on 16/7/25.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "SUNetworkingProtocol.h"

@interface NetworkConstant : NSObject<SUNetworkingProtocol>

@property (nonatomic, strong) NSString *urlHost;
@property (nonatomic, strong) NSString *aesKey;

+ (instancetype)defaultConstant;

@end
