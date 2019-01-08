//
//  BroweViewController.h
//  XHUI
//
//  Created by 郑信鸿 on 16/11/8.
//  Copyright © 2016年 郑信鸿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BroweViewController;
@protocol BroweImageDelegate <NSObject>

@required;
- (UIImageView *)broweView:(BroweViewController *)browView didScrollIndex:(NSInteger)index;

@end

@interface BroweViewController : UIViewController

@property(nonatomic, weak)id<BroweImageDelegate> delgate;

- (instancetype)initWithImages:(NSArray *)imageArr currentIndex:(NSInteger)currentIndex currentImageView:(UIImageView *)imageView;


- (void)show;


@end
