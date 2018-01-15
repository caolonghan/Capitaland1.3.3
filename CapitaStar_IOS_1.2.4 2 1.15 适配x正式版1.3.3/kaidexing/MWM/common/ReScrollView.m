//
//  ReScrollView.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ReScrollView.h"
#import "MJRefresh.h"
#import "Const.h"

@interface ReScrollView()
@property (strong,nonatomic)NSMutableArray *idleImages;
@property (strong,nonatomic)NSMutableArray *refreshingImages;

@end

@implementation ReScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (![Global sharedClient].is_EndRefresh) {
            NSLog(@"刷新");
            if (![Global sharedClient].is_EndheadRefresh){
                // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
                MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
                [header setImages:self.idleImages forState:MJRefreshStateIdle];//设置普通状态的动画图片
                // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
                [header setImages:self.refreshingImages forState:MJRefreshStatePulling];
                // 设置正在刷新状态的动画图片
                [header setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
                header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
                header.stateLabel.tag=200;
                header.stateLabel.hidden=YES;
                self.mj_header = header;
            }
        }
    }
    return self;
}

-(void)loadNewData{
    NSLog(@"刷新tableView");
    
    if(_refreshScrollDelegate &&[_refreshScrollDelegate respondsToSelector:@selector(tableView_refresh:)]){
        [_refreshScrollDelegate tableView_refresh:REFRESH_METHOD];
    }
}

-(void)tableViewDidFinishedLoading{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
-(void)endHeadRefresh{
    [self.mj_header endRefreshing];
}


-(NSMutableArray*)idleImages{
    if (!_idleImages) {
        // 设置普通状态的动画图片
        _idleImages = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"smallLogo"]];
        [_idleImages addObject:image];
    }
    return _idleImages;
}

-(NSMutableArray*)refreshingImages{
    if (!_refreshingImages) {
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        _refreshingImages = [NSMutableArray array];
        for (int i = 1; i<=5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"smallLogo"]];
            [_refreshingImages addObject:image];
        }
    }
    return _refreshingImages;
}

@end
