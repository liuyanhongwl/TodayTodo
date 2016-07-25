//
//  Post.h
//  TodayTodo
//
//  Created by Hong on 16/7/21.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import <YYModel/YYModel.h>

@interface Post : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

+ (void)getPostCompletion:(void (^)(NSArray *posts, NSError *error))completion;

+ (void)loadDataCompletion:(void (^)(NSArray <Post *> *posts))completion;

@end
