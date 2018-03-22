//
//  BillViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BillViewController.h"
#import "BillTableViewCell.h"
#import "billModel.h"
#import "MJRefresh.h"
@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,assign)NSInteger pageCount;
@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    self.navigationBarTitleLabel.text = @"账单";

    self.navigationBarTitleLabel.textColor =[UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self createTableView];
    _dataArray = [[NSMutableArray alloc]init];
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}

- (void)loadData{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",@(5),@"pageSize",@(_index),@"pageIndex",nil];
    [SVProgressHUD showWithStatus:@"正在加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_pay_log"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        [SVProgressHUD dismiss];
       NSArray *arr = dic[@"data"][@"dataList"];
        _pageCount = [dic[@"pageCount"] integerValue];
        [_dataArray addObjectsFromArray:arr];
        [self.tableView reloadData];

        
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        
     
        NSString *result = [NSString stringWithFormat:@"%@",dic[@"result"]];
        if ([result isEqualToString:@"-1"]) {
            [_tableView removeFromSuperview];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-75, 100, 150)];
            [self.view addSubview:imageView];
            imageView.image = [UIImage imageNamed:@"norecode"];
            [SVProgressHUD dismiss];
        }else{
               [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
}
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArray removeAllObjects];
        _index = 1;
        [self loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (_index == _pageCount) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                self.tableView.mj_footer.hidden = YES;
            });
        }else{
        _index++;
        [self loadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
            
        }
    }];
    _tableView.mj_footer = footer;
    [footer setTitle:@"正在加载更多数据" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    footer.automaticallyHidden = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *billArray = _dataArray[section][@"pay_log_list"];
    return billArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 97;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==3) {
        return 44;
    }else{
        return 0.1;
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section==2) {
//        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 44)];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-22, 0, 100, 44)];
//        label.font = COMMON_FONT;
//        label.text = @"没有更多了";
//        [bottomView addSubview:label];
//        return  bottomView;;
//}
//    return nil;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BillTableViewCell";
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *dic =  _dataArray[indexPath.section];
    
    NSDictionary  *billDic =dic[@"pay_log_list"][indexPath.row];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil][0];
        
        
        
        cell.payLabel.text = [NSString stringWithFormat:@"支出%@  收入%@",billDic[@"origTxnAmt"],billDic[@""]];

        NSString *shopStr = billDic[@"shopName"];
        NSArray *shopArr = [shopStr componentsSeparatedByString:@"|"];
        cell.companyLabel.text =shopArr.lastObject;

        cell.timeLabel.text = billDic[@"add_time"];

        cell.moneyLabel.text =[NSString stringWithFormat:@"-%@",billDic[@"origTxnAmt"]];

        cell.saleLabel.text =[NSString stringWithFormat:@"优惠%@", billDic[@"discountAmt"]];
        if ([billDic[@"respMsg"] rangeOfString:@"成功"].location !=NSNotFound) {
            cell.payStyleLabel.text = @"支付成功";
            cell.payStyleLabel.textColor = [UIColor colorWithRed:0 green:135/255.0 blue:140/255.0 alpha:1];

        }else
        {
            cell.payStyleLabel.textColor = [UIColor redColor];
            cell.payStyleLabel.text = @"支付失败";
        }
    }
    return cell;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _dataArray[section][@"add_time_date"];
}
@end
