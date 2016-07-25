//
//  PostCell.h
//  TodayTodo
//
//  Created by Hong on 16/7/25.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface PostCell : UITableViewCell

@property (nonatomic, strong) Post *post;

+ (CGFloat)cellHeight;

@end
