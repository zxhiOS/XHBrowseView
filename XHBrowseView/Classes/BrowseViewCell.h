//
//  XHPhotoPreViewCell.h
//  图片详情浏览
//
//  Created by ZRAR on 16/2/17.
//  Copyright © 2016年 ZRAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImage *photo;

@property (nonatomic, strong)NSString *imageUrl;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

@end
