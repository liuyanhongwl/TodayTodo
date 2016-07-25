//
//  APIClient.h
//  TodayTodo
//
//  Created by Hong on 16/7/21.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "SUHTTPSessionManager.h"

@interface APIClient : SUHTTPSessionManager

+ (instancetype)sharedClient;

@end
