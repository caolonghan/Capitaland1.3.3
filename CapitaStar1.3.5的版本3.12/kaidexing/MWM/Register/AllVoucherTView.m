//
//  AllVoucherTView.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AllVoucherTView.h"

#import "VoucherTVCell.h"
#import "Const.h"
#import "UIView+UIViewController.h"
#import "MyVoucherViewController.h"
#import "VoucherDetailViewController.h"
#import "GoViewController.h"

@implementation AllVoucherTView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        
        [self createTableFooterView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate {
    
    if (self = [super initWithFrame:frame ]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.pullingDelegate = aPullingDelegate;
        
        self.backgroundColor = UIColorFromRGB(0xfafafa);
        
        [self createTableFooterView];
    }
    return self;
}

- (void)createTableFooterView {
    
    _allfooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 104)];
    _allfooterView.backgroundColor = UIColorFromRGB(0xfafafa);
    
    self.tableFooterView = _allfooterView;
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(32, 34, CGRectGetWidth(_allfooterView.bounds)- 32 * 2, 36);
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = APP_BTN_COLOR;
    btn.titleLabel.font = DESC_FONT;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"查看过往的券" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(lookPastCardVoucher:) forControlEvents:UIControlEventTouchUpInside];
    
    [_allfooterView addSubview:btn];
}

- (void)lookPastCardVoucher:(UIButton *)sender {
    
    self.parent.isLookLast = YES;
    
    /*
     coupon_type:卡券类型（-1.查全部，0.代金券，1.抵用券，2.停车券）。
     is_his:是否过期（1.查已过期已使用，0查当前可用）。
     */
    self.parent.coupon_type = @"-1";
    
    self.parent.is_his = @"1";
    
    self.parent.pageSize = @"100";
    
//    self.tableFooterView.hidden = YES;
    self.tableFooterView = nil;
    [_parent loadData:nil];
    
//    CGRect frame = self.frame;
//    frame.size.height -= 104;
//    self.frame = frame;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 15)];
    view.backgroundColor = UIColorFromRGB(0xfafafa);
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"VoucherTVCell";
    VoucherTVCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[VoucherTVCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataDic = _dataArr[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyVoucherViewController * mvVC = (MyVoucherViewController *)self.viewController;
    
    NSDictionary *dic=_dataArr[indexPath.section];
    NSString *linkurl=dic[@"link_url"];
    GoViewController *gvc=[[GoViewController alloc]init];
    gvc.path=linkurl;
    
    [mvVC.delegate.navigationController pushViewController:gvc animated:YES];
}

-(void) loadData:(NSString*) type{
    [_parent loadData:type];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData:) withObject:REFRESH_METHOD afterDelay:0.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [[NSDate alloc] init];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData:) withObject:MORE_METHOD afterDelay:0.f];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    
    [self tableViewDidScroll:vScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
    [self tableViewDidEndDragging:vScrollView];
}

- (void)setParent:(MyVoucherViewController *)parent {
    
    _parent = parent;
    
    _parent.tableFooterView = _allfooterView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
