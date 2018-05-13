//
//  MyVoucherViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyVoucherViewController.h"

#import "MJRefresh.h"
#import "AllVoucherTView.h"

@interface MyVoucherViewController ()
{
    AllVoucherTView * allVoucherTV;
    
    NSMutableArray * btnTitles;
    
    UIView * grayView;
    
    UIView * whiteView;
    
    NSString * cashCoupon; //代金券数
    
    NSString * vouchersCoupon; //抵用券数
    
    NSString * parkCoupon; //停车券数
    
    NSArray * coupon_list; //卡券列表
    
    int page;    //当前页。
    
    NSString * isNextPage;  //是否有下一页 0：没有，1有
    
    NSArray * coupon_types; //卡券类型数组（-1.查全部，0.代金券，1.抵用券，2.停车券）。
}
@end

@implementation MyVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTitleLabel.text= @"我的卡券";
    
    _isLookLast = NO;
    
    btnTitles = [[NSMutableArray alloc] init];
    
    [btnTitles addObject:@"全部"];
    
    cashCoupon = @"0";
    vouchersCoupon = @"0";
    parkCoupon = @"0";
    
    _is_his = @"0";
    
    page = 1;
    _pageSize= @"10";
    
    coupon_types = @[@"-1", @"0", @"1", @"2"];
    
    _coupon_type = coupon_types.firstObject;
    self.navigationBarLine.hidden = YES;
    
    [self loadData:nil];
    
    
}

- (void)loadData:(NSString*) type {
    
    if (_isLookLast) {
        if ([grayView viewWithTag:500].hidden) {
            UIButton * allBtn = [whiteView viewWithTag:400];
            [allBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
            [grayView viewWithTag:500].hidden = NO;
            
            UIButton * daiJinQuanBtn = [whiteView viewWithTag:401];
            [daiJinQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:501].hidden = YES;
            
            UIButton * diYongQuanBtn = [whiteView viewWithTag:402];
            [diYongQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:502].hidden = YES;
            
            UIButton * tingCheQuanBtn = [whiteView viewWithTag:403];
            [tingCheQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:503].hidden = YES;
        }
    }
    if(type == nil || [type isEqualToString: REFRESH_METHOD]){
        page = 1;
        isNextPage = @"1";
    }else{
        page ++;
    }
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", _coupon_type, @"coupon_type", _is_his, @"is_his", @(page), @"page", @(10), @"pageSize", @"1000", @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"couponlist"]  parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [self createUIImageView];
                [SVProgressHUD dismiss];
                return;
            }

            NSDictionary * dataDic = dic[@"data"];
            
            isNextPage = dataDic[@"isend"];
            
            cashCoupon = dataDic[@"cashCoupon"];
            vouchersCoupon = dataDic[@"vouchersCoupon"];
            parkCoupon = dataDic[@"parkCoupon"];
            
            coupon_list = dataDic[@"coupon_list"];
            if (allVoucherTV) {
                if(type == nil || [type isEqualToString: REFRESH_METHOD]){
                    [allVoucherTV.dataArr removeAllObjects];
                }
                [allVoucherTV.dataArr addObjectsFromArray: coupon_list];
                
                [allVoucherTV reloadData];
                [allVoucherTV tableViewDidFinishedLoading];
            } else {
                [self createSubviews];
            }
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            
            //弹窗提示错误信息
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        });
    }];
}

- (void)createSubviews {
    
    NSString * daiJinQuan = [NSString stringWithFormat:@"代金券(%@)", cashCoupon];
    [btnTitles addObject:daiJinQuan];
    
    NSString * diYongQuan = [NSString stringWithFormat:@"抵用券(%@)", vouchersCoupon];
    [btnTitles addObject:diYongQuan];
    
    NSString * tingCheQuan = [NSString stringWithFormat:@"停车券(%@)", parkCoupon];
    [btnTitles addObject:tingCheQuan];
    
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, 42)];
    grayView.backgroundColor = UIColorFromRGB(0xcfcfcf);
    
    [self.view addSubview:grayView];
    
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, WIN_WIDTH, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [grayView addSubview:whiteView];
    
    
    for (int i = 0; i < 4; i++) {
        
        CGFloat width = (WIN_WIDTH - 3) / 4;
        CGFloat x = i * width + i;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, 0, width, 40);
        btn.titleLabel.font = DESC_FONT;
        [btn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.tag = i + 400;
        [btn addTarget:self action:@selector(lookDifferentKindsOfCardVouchers:) forControlEvents:UIControlEventTouchUpInside];
        
        [whiteView addSubview:btn];
        
        
        //选中时的红线
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(whiteView.frame) - 1, width, 3)];
        view.backgroundColor = APP_BTN_COLOR;
        view.hidden = YES;
        view.tag = i + 500;
        
        [grayView addSubview:view];
        
        
        if (i == 0) {
            
            for (int j=0; j<3; j++) {
                //按钮之间分割线
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake((j+1)*width+j, 12, 1, 15)];
                lineView.backgroundColor = COLOR_LINE;
                
                [whiteView addSubview:lineView];
            }
            //默认选中第一个
            view.hidden = NO;
            [btn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
        }
    }
    //全部，代金券，抵用券，停车券共用一个allVoucherTV
    allVoucherTV = [[AllVoucherTView alloc]
                    initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), WIN_WIDTH, WIN_HEIGHT - CGRectGetMaxY(grayView.frame)) pullingDelegate:self];
    
    allVoucherTV.parent = self;
    allVoucherTV.dataArr = [[NSMutableArray alloc] initWithArray:coupon_list];
    
    
    [self.view addSubview:allVoucherTV];
}

- (void)lookDifferentKindsOfCardVouchers:(UIButton *)sender {
    
    _isLookLast = NO;
    
    _is_his = @"0";
    
    if (!allVoucherTV.tableFooterView) {
        allVoucherTV.tableFooterView = _tableFooterView;
    }
    _pageSize = @"10";
    //选中按钮字颜色切换
    [sender setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    
    NSInteger i = sender.tag - 400;
    
    switch (i) {//按钮字颜色切换 & 红线的显示||隐藏
            
        case 0:{
            
            if (![grayView viewWithTag:500].hidden) {
                return;
            }
            [grayView viewWithTag:500].hidden = NO;
            
            UIButton * daiJinQuanBtn = [whiteView viewWithTag:401];
            [daiJinQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:501].hidden = YES;
            
            UIButton * diYongQuanBtn = [whiteView viewWithTag:402];
            [diYongQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:502].hidden = YES;
            
            UIButton * tingCheQuanBtn = [whiteView viewWithTag:403];
            [tingCheQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:503].hidden = YES;
            
            _coupon_type = coupon_types[i];
            page = 1;
            [self loadData:nil];
        }
            break;
            
        case 1:{
            
            if (![grayView viewWithTag:501].hidden) {
                return;
            }
            UIButton * allBtn = [whiteView viewWithTag:400];
            [allBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:500].hidden = YES;
            
            [grayView viewWithTag:501].hidden = NO;
            
            UIButton * diYongQuanBtn = [whiteView viewWithTag:402];
            [diYongQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:502].hidden = YES;
            
            UIButton * tingCheQuanBtn = [whiteView viewWithTag:403];
            [tingCheQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:503].hidden = YES;
            
            _coupon_type = coupon_types[i];
            page = 1;
            [self loadData:nil];
        }
            break;
            
        case 2:{
            
            if (![grayView viewWithTag:502].hidden) {
                return;
            }
            UIButton * allBtn = [whiteView viewWithTag:400];
            [allBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:500].hidden = YES;
            
            
            UIButton * daiJinQuanBtn = [whiteView viewWithTag:401];
            [daiJinQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:501].hidden = YES;
            
            
            [grayView viewWithTag:502].hidden = NO;
            [self.view viewWithTag:7002].hidden = NO;
            
            UIButton * tingCheQuanBtn = [whiteView viewWithTag:403];
            [tingCheQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:503].hidden = YES;
            
            _coupon_type = coupon_types[i];
            page = 1;
            [self loadData:nil];
        }
            break;
        case 3:{
            
            if (![grayView viewWithTag:503].hidden) {
                return;
            }
            UIButton * allBtn = [whiteView viewWithTag:400];
            [allBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:500].hidden = YES;
            
            
            UIButton * daiJinQuanBtn = [whiteView viewWithTag:401];
            [daiJinQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:501].hidden = YES;
            
            
            UIButton * diYongQuanBtn = [whiteView viewWithTag:402];
            [diYongQuanBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
            [grayView viewWithTag:502].hidden = YES;
            
            
            [grayView viewWithTag:503].hidden = NO;
            
            _coupon_type = coupon_types[i];
            page = 1;
            [self loadData:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData:) withObject:REFRESH_METHOD afterDelay:0.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [[NSDate alloc] init];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    if(![isNextPage isEqualToString:@"1"]){
        [self performSelector:@selector(loadData:) withObject:MORE_METHOD afterDelay:0.f];
    }else{
        [tableView tableViewDidFinishedLoading];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    
    [allVoucherTV tableViewDidScroll:vScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
    [allVoucherTV tableViewDidEndDragging:vScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUIImageView {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIN_WIDTH - 80) / 2, CGRectGetMaxY(grayView.frame) + 62, 80, 80)];
    imageView.image = [UIImage imageNamed:@"iconfont-shibai1"];
    [self.view addSubview:imageView];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame) + 16, 80, 21)];
    label.font = COMMON_FONT;
    label.textColor = COLOR_FONT_SECOND;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无数据";
    
    [self.view addSubview:label];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(16, 34, WIN_WIDTH - 16 * 2, 36);
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = APP_BTN_COLOR;
    btn.titleLabel.font = DESC_FONT;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"查看过往的券" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(lookPastCardVoucher:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)lookPastCardVoucher:(UIButton *)sender {
    
    _isLookLast = YES;
    
    /*
     coupon_type:卡券类型（-1.查全部，0.代金券，1.抵用券，2.停车券）。
     is_his:是否过期（1.查已过期已使用，0查当前可用）。
     */
    _coupon_type = @"-1";
    
    _is_his = @"1";
    
    _pageSize = @"100";
    
    [self loadData:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
