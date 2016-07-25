//
//  PostCell.m
//  TodayTodo
//
//  Created by Hong on 16/7/25.
//  Copyright © 2016年 Hong. All rights reserved.
//

#import "PostCell.h"
#import "Masonry.h"
#import "Post.h"
#import "UIImageView+WebCache.h"

@interface PostCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *title;

@end

@implementation PostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _imgView = [[UIImageView alloc] init];
        self.imgView.clipsToBounds = YES;
        self.imgView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.imgView];
        
        _title = [[UILabel alloc] init];
        self.title.numberOfLines = 2;
        self.title.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_title];
        
        __weak PostCell *weakSelf = self;
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf);
            make.width.equalTo(weakSelf.imgView.mas_height).dividedBy(0.7);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(weakSelf.imgView.mas_trailing).offset(12);
            make.trailing.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.post.url]];
    self.title.text = self.post.title;
}

- (void)setPost:(Post *)post
{
    _post = post;
    
    [self setNeedsLayout];
}

+ (CGFloat)cellHeight
{
    return 116.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
