//
//  XHTableViewController.m
//  XHBrowseView_Example
//
//  Created by 郑信鸿 on 2019/1/4.
//  Copyright © 2019年 zXinHong. All rights reserved.
//

#import "XHTableViewController.h"
#import "XHTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BroweViewController.h"

@interface XHTableViewController ()<BroweImageDelegate,XHTableViewCellDelegate>

@property (nonatomic, strong)NSArray *dataList;/**数据**/

@end

@implementation XHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    self.dataList = @[@"http://tupian.qqjay.com/u/2017/1221/7_143642_10.jpg",@"http://img0.imgtn.bdimg.com/it/u=1823267536,4281926562&fm=11&gp=0.jpg",@"http://img1.imgtn.bdimg.com/it/u=1105909031,4008718830&fm=26&gp=0.jpg",@"http://img5.imgtn.bdimg.com/it/u=2277535473,2247214968&fm=11&gp=0.jpg",@"image1",@"image2",@"image3",@"image1",@"image2",@"image3",@"http://tupian.qqjay.com/u/2017/1221/7_143642_10.jpg",@"http://img0.imgtn.bdimg.com/it/u=1823267536,4281926562&fm=11&gp=0.jpg",@"http://img1.imgtn.bdimg.com/it/u=1105909031,4008718830&fm=26&gp=0.jpg",@"http://img5.imgtn.bdimg.com/it/u=2277535473,2247214968&fm=11&gp=0.jpg",@"image1",@"image2",@"image3",@"image1",@"image2",@"image3"];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XHTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    NSInteger index = indexPath.row * 2;
    NSString *imageName = self.dataList[index];
    NSString *imageName1 = self.dataList[index + 1];
    if ([imageName containsString:@"http"]) {
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:imageName]];
    }else{
        cell.leftImageView.image = [UIImage imageNamed:imageName];
    }
    if ([imageName1 containsString:@"http"]) {
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:imageName1]];
    }else{
        cell.rightImageView.image = [UIImage imageNamed:imageName1];
    }
    return cell;
}


- (void)tableViewCell:(XHTableViewCell *)cell tapImageView:(UIImageView *)imageView{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger index = indexPath.row * 2 + imageView.tag - 100;
    BroweViewController *col = [[BroweViewController alloc] initWithImages:self.dataList currentIndex:index currentImageView:imageView];
    col.delgate = self;
    [col show];
}

- (UIImageView *)broweView:(BroweViewController *)browView didScrollIndex:(NSInteger)index{
    NSInteger row = index / 2;
    NSInteger first = index % 2;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    XHTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (first) {
        return cell.rightImageView;
    }else{
        return cell.leftImageView;
    }
}

@end
