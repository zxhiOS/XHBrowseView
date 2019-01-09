//
//  XHPhotoPreViewCell.m
//  图片详情浏览
//
//  Created by ZRAR on 16/2/17.
//  Copyright © 2016年 ZRAR. All rights reserved.
//

#import "BrowseViewCell.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "XHPanGestureRecognizer.h"
#import "UIView+browse.h"

@interface BrowseViewCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, assign)CGPoint startPoint;/**<#注释#>**/

@property (nonatomic, assign)CGPoint imageCenter;/**<#注释#>**/

@property (nonatomic, assign)CGRect imageFrame;/**<#注释#>**/

@end

@implementation BrowseViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageContainerView addSubview:_imageView];
        [self resizeSubviewsWithImage:[UIView browseImageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth, kScreenHeight)]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        XHPanGestureRecognizer *pan1 = [[XHPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan1.delegate = self;
        [self.imageContainerView addGestureRecognizer:pan1];
    }
    return self;
}


- (void)panAction:(UIPanGestureRecognizer *)panGecognizer{
    
    if (panGecognizer.state == UIGestureRecognizerStateBegan) {
      
       self.startPoint = [panGecognizer locationInView:self];
       self.imageCenter = self.imageContainerView.center;
       self.imageFrame = self.imageContainerView.frame;
    }else if(panGecognizer.state == UIGestureRecognizerStateEnded){
      
        CGPoint point = [panGecognizer locationInView:self];
        CGFloat diffY =  point.y - self.startPoint.y;
        
        if (fabs(diffY) > kScreenHeight / 2.5) {
            
            if (self.singleTapGestureBlock) {
                self.singleTapGestureBlock();
            }
        }else{
            
            self.imageContainerView.frame = self.imageFrame;
            self.imageContainerView.center = self.imageCenter;
            self.imageView.frame = self.imageContainerView.bounds;

        }
        
    
    }else{
        
        CGPoint point = [panGecognizer locationInView:self];
        
        CGFloat diffX = point.x - self.startPoint.x;
        CGFloat diffY = point.y - self.startPoint.y;
        
        CGFloat rate = (kScreenHeight - fabs(diffY))/kScreenHeight;
        CGFloat width = self.imageFrame.size.width * rate;
        CGFloat heigth = self.imageFrame.size.height * rate;
        self.imageContainerView.frame = CGRectMake(0, 0, width, heigth);
        CGFloat x = self.imageCenter.x + diffX;
        CGFloat y = self.imageCenter.y + diffY;
        self.imageContainerView.center = CGPointMake(x, y);
        self.imageView.frame = self.imageContainerView.bounds;
        
    }
    
}


- (void)setPhoto:(UIImage *)photo{
    _photo = photo;
    [_scrollView setZoomScale:1.0 animated:NO];
    self.imageView.image = photo;
    [self resizeSubviewsWithImage:photo];
}


- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_scrollView setZoomScale:1.0 animated:NO];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage new] options:SDWebImageProgressiveDownload completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (image) {
            
            [self resizeSubviewsWithImage:image];
            
        }
        
        
    }];
   
}

- (void)resizeSubviewsWithImage:(UIImage *)image {
    CGRect frame = _imageContainerView.frame;
    frame.origin =CGPointZero;
    frame.size.width = self.frame.size.width;
    _imageContainerView.frame = frame;
    
    if (image.size.height / image.size.width > self.height / self.width) {
        //floor向下取整
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        //是不是nan值，如果一个数是一个确定的数，那它就不是nan值，如果一个数是无穷大，无穷小，那它就是nan值
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        //把从scrollView里截取的矩形
        //        区域缩放到整个scrollView当前可视的frame里面。所以如果截取的区域大于scrollView的frame时，图片缩小，
        //        如果截取区域小于frame，会看到图片放大。一般情况下rect需要自己计算出来。
        //        比如，要把scrollView原来坐标点为(40,40)的内容周围内容在scrollView里放大一倍，可以求出需要从scrollView里
        //        截取图片的frame，当然主要是求截取图片坐标原点，可以想象，内容放大一倍，那么截取图片的大小宽度肯定是
        //        scrollView的frame大小一半。
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //设置imageCountainerView的中心位置，放大之后不会偏下
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


@end
