//
//  XHTableViewCell.h
//  XHBrowseView_Example
//
//  Created by 郑信鸿 on 2019/1/4.
//  Copyright © 2019年 zXinHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XHTableViewCell;

@protocol XHTableViewCellDelegate <NSObject>

- (void)tableViewCell:(XHTableViewCell *)cell tapImageView:(UIImageView *)imageView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XHTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic, weak)id<XHTableViewCellDelegate> delegate;/**<#注释#>**/

@end

NS_ASSUME_NONNULL_END
