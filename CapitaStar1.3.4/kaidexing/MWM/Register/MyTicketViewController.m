//
//  MyTicketViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyTicketViewController.h"

#import "OverdueTView.h"
#import "MJRefresh.h"

@interface MyTicketViewController ()
{
    UIView * grayView;
    
    UIButton * currentBtn;
    
    UIButton * overdueBtn;
    
    NSString * type;    //活动类型。（0为当前号 1为过期号）
    
    NSString * page;    //页码
    
    NSString * isNextPage;  //“isEnd”:”true”,    跟isend是一样。true=1：有；false=0：没有
    
    NSArray * queneNumberList;
}
@property(nonatomic, retain)OverdueTView * overdueTV;

@end

@implementation MyTicketViewController{
    UIView *nilView1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"我的号单";
    
    type = @"0";
    
    page = @"1";
    
    [self createUpView];
    
    [self networkRequest];
    
    //[self createTableView];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)networkRequest {
   
    [nilView1 removeFromSuperview];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", type, @"type", page, @"page", @"10", @"pageSize", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"queuelist"]  parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (![dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [self createUIImageView];
                [SVProgressHUD dismiss];
                return;
            }
            NSDictionary * dataDic = dic[@"data"];
            
            isNextPage = dataDic[@"isEnd"];
            
            queneNumberList = dataDic[@"queneNumberList"];
            
            if (_overdueTV) {
                
                _overdueTV.dataArr = queneNumberList;
                
                [_overdueTV reloadData];
            } else {
                [self createTableView];
                _overdueTV.mj_footer.hidden=YES;
            }
            
            if (_overdueTV.dataArr.count==0) {
                [self nvcImgView];
            }
            
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        
    }];
}

- (void)createTableView {
    
    self.overdueTV.viewController = self;
    
    self.overdueTV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (![isNextPage isEqualToString:@"1"]) {
            
            [SVProgressHUD showErrorWithStatus:@"没有更多数据!"];
            [_overdueTV.mj_footer endRefreshing];
            _overdueTV.mj_footer.hidden=YES;
            return;
        }
        //页数增加
        NSInteger currentPage = page.integerValue;
        
        currentPage++;
        
        page = [NSString stringWithFormat:@"%ld", currentPage];
        
        [self networkRequest];
        
        [_overdueTV.mj_footer endRefreshing];

    }];
    _overdueTV.dataArr = queneNumberList;
}

- (OverdueTView *)overdueTV {
    
    if (!_overdueTV) {
        
        _overdueTV = [[OverdueTView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), WIN_WIDTH, WIN_HEIGHT - CGRectGetMaxY(grayView.frame)) style:UITableViewStylePlain];
        
        [self.view addSubview:_overdueTV];
    }
    return _overdueTV;
}

- (void)createUpView {
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, 36)];
    
    [self.view addSubview:grayView];
    
    UIView * whiteView =  [[UIView alloc] initWithFrame:CGRectMake(0, 1, CGRectGetWidth(grayView.bounds), CGRectGetHeight(grayView.bounds) - 2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [grayView addSubview:whiteView];
    
    
    currentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    currentBtn.frame = CGRectMake(0, 0, (CGRectGetWidth(whiteView.bounds) - 1) / 2, CGRectGetHeight(whiteView.frame));
    currentBtn.titleLabel.font = DESC_FONT;
    [currentBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [currentBtn setTitle:@"当前号单" forState:UIControlStateNormal];
    [currentBtn addTarget:self action:@selector(currentTicket:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:currentBtn];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentBtn.frame), 10, 1, 14)];
    view.backgroundColor = COLOR_LINE;
    
    [whiteView addSubview:view];
    
    overdueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    overdueBtn.frame = CGRectMake(CGRectGetMaxX(view.frame), 0, CGRectGetWidth(currentBtn.bounds), CGRectGetHeight(currentBtn.bounds));
    overdueBtn.titleLabel.font = DESC_FONT;
    [overdueBtn setTitleColor:UIColorFromRGB(0x6e6e6e) forState:UIControlStateNormal];
    [overdueBtn setTitle:@"过期号单" forState:UIControlStateNormal];
    [overdueBtn addTarget:self action:@selector(overdueTicket:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:overdueBtn];
    
    
    for (int i = 0; i < 2; i++) {
        CGFloat width = CGRectGetWidth(grayView.bounds) / 2;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(i * width, CGRectGetMaxY(whiteView.frame), width, 1)];
        lineView.backgroundColor = COLOR_LINE;
        
        [grayView addSubview:lineView];
        
        
        UIView * lowRedView = [[UIView alloc] initWithFrame:CGRectMake(i * width, CGRectGetMaxY(whiteView.frame), width, 1)];
        lowRedView.backgroundColor = APP_BTN_COLOR;
        lowRedView.tag = i + 600;
        
        [grayView addSubview:lowRedView];
        
        if (i == 1) {
            
            lowRedView.hidden = YES;
        }
    }
}

- (void)currentTicket:(UIButton *)sender {
    
    UIView * lowRedView_l = [grayView viewWithTag:600];
    
    if (lowRedView_l.hidden) {
        
        [overdueBtn setTitleColor:UIColorFromRGB(0x6e6e6e) forState:UIControlStateNormal];
        [currentBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
        
        lowRedView_l.hidden = NO;
        
        UIView * lowRedView_r = [grayView viewWithTag:601];
        lowRedView_r.hidden = YES;
        
        [self networkRequest];
    }
}

- (void)overdueTicket:(UIButton *)sender {
    
    UIView * lowRedView_r = [grayView viewWithTag:601];
    
    if (lowRedView_r.hidden) {
        
        [currentBtn setTitleColor:UIColorFromRGB(0x6e6e6e) forState:UIControlStateNormal];
        [overdueBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
        
        UIView * lowRedView_l = [grayView viewWithTag:600];
        lowRedView_l.hidden = YES;
        
        lowRedView_r.hidden = NO;
        
        [self networkRequest];
    }
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initnilView{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+40, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-40)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
    
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
