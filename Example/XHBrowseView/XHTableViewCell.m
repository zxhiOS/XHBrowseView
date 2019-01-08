//
//  XHTableViewCell.m
//  XHBrowseView_Example
//
//  Created by 郑信鸿 on 2019/1/4.
//  Copyright © 2019年 zXinHong. All rights reserved.
//

#import "XHTableViewCell.h"

@implementation XHTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.leftImageView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightImageView addGestureRecognizer:tap2];
}

- (void)tapAction:(UIGestureRecognizer *)gesture{
    UIImageView *imageView = (UIImageView *)gesture.view;
    if ([_delegate respondsToSelector:@selector(tableViewCell:tapImageView:)]) {
        [_delegate tableViewCell:self tapImageView:imageView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
