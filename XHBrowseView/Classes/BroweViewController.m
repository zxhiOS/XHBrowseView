//
//  BroweViewController.m
//  XHUI
//
//  Created by 郑信鸿 on 16/11/8.
//  Copyright © 2016年 郑信鸿. All rights reserved.
//

#import "BroweViewController.h"
#import "BrowseViewCell.h"
//#import "MultimediaInfo.h"
//#import "UIImageView+RFCacheImage.h"
#import "UIView+browse.h"

static NSTimeInterval const kAnimationTimeInterval = 0.3;

@interface BroweViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSArray *imageArray;

@property(nonatomic, assign)NSInteger currentIndex;

@property(nonatomic, weak)UIImageView *currentImageView;


@end

@implementation BroweViewController


- (instancetype)initWithImages:(NSArray *)imageArr currentIndex:(NSInteger)currentIndex currentImageView:(UIImageView *)imageView{
    
    if (self = [super init]) {
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.imageArray = imageArr;
        self.currentIndex = currentIndex;
        self.currentImageView = imageView;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
   self.automaticallyAdjustsScrollViewInsets = NO;
    [self configCollectionView];
}

- (void)backAction{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    
    BrowseViewCell *cell = (BrowseViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *currentImageView = cell.imageView;
    self.currentImageView = [self.delgate broweView:self didScrollIndex:self.currentIndex];
    UIViewController *col = (UIViewController *)self.presentingViewController;
    CGRect targetTemp = [self.currentImageView.superview convertRect:self.currentImageView.frame toView:col.view];
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.clipsToBounds = YES;
    if (tempImageView.image) {
        
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
    }
    CGRect tempImageViewFrame = [currentImageView.superview convertRect:currentImageView.frame toView:self.view];
    tempImageView.frame = tempImageViewFrame;
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if (targetTemp.origin.y <= 0) {
        
        [UIView animateWithDuration:kAnimationTimeInterval animations:^{
            
            tempImageView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [tempImageView removeFromSuperview];
            
        }];
        
        
    }else{
        
        [UIView animateWithDuration:kAnimationTimeInterval
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             tempImageView.frame = targetTemp;
                         } completion:^(BOOL finished) {
                             
                             [tempImageView removeFromSuperview];
                             
                         }];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self showPhotoBrowser];
    
}



- (void)configCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth ,kScreenHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.view.width *self.imageArray.count, self.view.height);
    [self.view addSubview:_collectionView];
    _collectionView.hidden = YES;
    [_collectionView registerClass:[BrowseViewCell class] forCellWithReuseIdentifier:@"BrowseViewCell"];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
#pragma mark - 1.显示视图
- (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController]
         presentViewController:self
         animated:NO
         completion:nil];
    });
   
}

- (void)showPhotoBrowser
{
    
    UIViewController *col = (UIViewController *)self.presentingViewController;
    CGRect rect = [self.currentImageView.superview convertRect:self.currentImageView.frame toView:col.view];
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.frame = rect;
    tempImageView.image = self.currentImageView.image;
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    tempImageView.clipsToBounds = YES;
    CGFloat placeImageSizeW = tempImageView.image.size.width;
    CGFloat placeImageSizeH = tempImageView.image.size.height;
    if (!tempImageView.image) {
        placeImageSizeW = kScreenWidth;
        placeImageSizeH = kScreenHeight;
    }
  
    CGRect targetTemp;
    
    CGFloat placeHolderH = (placeImageSizeH *kScreenWidth)/placeImageSizeW;
    if (placeHolderH <= kScreenHeight) {
        targetTemp = CGRectMake(0, (kScreenHeight - placeHolderH) * 0.5 , kScreenWidth, placeHolderH);
    } else {
        targetTemp = CGRectMake(0, 0, kScreenWidth, placeHolderH);
    }
    
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
        self.collectionView.hidden = NO;
    }];
}


#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BrowseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BrowseViewCell" forIndexPath:indexPath];
    id image = self.imageArray[indexPath.item];
    if ([image isKindOfClass:[UIImage class]]) {
        cell.photo = image;
    }else{
        NSString *imageName = (NSString *)image;
        if ([imageName containsString:@"http"]) {
            cell.imageUrl = imageName;
        }else{
            NSLog(@"%@---",imageName);
            cell.photo = [UIImage imageNamed:imageName];
        }
    }
    if (cell.singleTapGestureBlock == nil) {
        
        __weak typeof(self) weakSelf = self;
        cell.singleTapGestureBlock = ^(){
            
          [weakSelf backAction];
            
        };

    }
    
    return cell;
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _currentIndex = offSet.x / self.view.width;
    if ([self.delgate respondsToSelector:@selector(broweView:didScrollIndex:)]) {
        
        [self.delgate broweView:self didScrollIndex:self.currentIndex];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
