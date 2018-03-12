//
//  ActivityViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/4.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ActivityViewController.h"

#import "EndedTableView.h"
#import "MJRefresh.h"

@interface ActivityViewController ()
{
    UIView * grayView;
    
    UIButton * ongoingBtn;
    
    UIButton * endedBtn;
    
    NSArray * dataArr;
    
    NSString * type;    //活动类型。（为2时查询进行中的活动列表，为其它值时查已结束活动列表）
    
    int  page;    //当前页。
    
    BOOL isNextPage;
    
}

@end


@implementation ActivityViewController{
    @private
    EndedTableView * endedTV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"我的活动"; //我的活动or活动列表
     isNextPage = false;
    
    type = @"3";
    
    page = 1;
   
    [self createUpview];
    
    [self loadData:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)loadData:(NSString*) method {
    
   
    
    if(method == nil || [method isEqualToString:REFRESH_METHOD]){
        page = 1;
        isNextPage=NO;
    }else{
        if (isNextPage == true) {
            [endedTV tableViewDidFinishedLoading];
            return;
        }else {
             page++;
      }
    }
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", type, @"type", @(page), @"page", @"10", @"pageSize", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"activity"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                
                [self createUIImageView];
                [SVProgressHUD dismiss];
                return;
            }

            NSDictionary * dataDic = dic[@"data"];
            
            isNextPage = [dataDic[@"isEnd"]boolValue];
            
            dataArr = dataDic[@"activity_list"];
            
            //if ([type isEqualToString:@"2"]) {
                NSString * str = [NSString stringWithFormat:@"已结束(%d)",[dataDic[@"no_count"] intValue]];
                [endedBtn setTitle:str forState:UIControlStateNormal];
            //} else {
                str = [NSString stringWithFormat:@"进行中(%d)",(int)[dataDic[@"ongoing_count"] intValue]];
                [ongoingBtn setTitle:str forState:UIControlStateNormal];
           // }
            
            if (endedTV) {
                if(method == nil || [method isEqualToString:REFRESH_METHOD]){
                    [endedTV.dataArr removeAllObjects];
                }
                [endedTV.dataArr addObjectsFromArray:dataArr];
                
                [endedTV reloadData];
                [endedTV tableViewDidFinishedLoading];
            } else {
                [self createSubviews];
            }
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
    }];

}

- (void)createSubviews {
    
    //[self createUpview];
    
    endedTV = [self createEndedTV];
    
    //endedTV.viewController = self;
    
    endedTV.dataArr = [[NSMutableArray alloc] initWithArray: dataArr];
}

- (EndedTableView *)createEndedTV {
    
    if (!endedTV) {
        
        endedTV = [[EndedTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), WIN_WIDTH, WIN_HEIGHT - CGRectGetMaxY(grayView.frame))];
        endedTV.viewController = self;
        [self.view addSubview:endedTV];
    }
    return endedTV;
}

- (void)createUpview {
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, 42)];
    grayView.backgroundColor = UIColorFromRGB(0xcfcfcf);
    
    [self.view addSubview:grayView];
    
    
    UIView * whiteView =  [[UIView alloc] initWithFrame:CGRectMake(0, 1, CGRectGetWidth(grayView.bounds), CGRectGetHeight(grayView.bounds) - 2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [grayView addSubview:whiteView];
    
    
    ongoingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ongoingBtn.frame = CGRectMake(0, 0, (CGRectGetWidth(whiteView.bounds) - 1) / 2, CGRectGetHeight(whiteView.frame));
    ongoingBtn.titleLabel.font = DESC_FONT;
    [ongoingBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [ongoingBtn setTitle:@"进行中(0)" forState:UIControlStateNormal];
    [ongoingBtn addTarget:self action:@selector(ongoingActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:ongoingBtn];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ongoingBtn.frame), 14, 1, 15)];
    view.backgroundColor = COLOR_LINE;
    
    [whiteView addSubview:view];
    
    endedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endedBtn.frame = CGRectMake(CGRectGetMaxX(view.frame), 0, CGRectGetWidth(ongoingBtn.bounds), CGRectGetHeight(ongoingBtn.bounds));
    endedBtn.titleLabel.font = DESC_FONT;
    [endedBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
    [endedBtn setTitle:@"已结束(0)" forState:UIControlStateNormal];
    [endedBtn addTarget:self action:@selector(endedActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    [whiteView addSubview:endedBtn];
    
    
    for (int i = 0; i < 2; i++) {
        
        CGFloat width = CGRectGetWidth(grayView.bounds) / 2;
        
        UIView * lowRedView = [[UIView alloc] initWithFrame:CGRectMake(i * width, CGRectGetMaxY(whiteView.frame), width, 1)];
        lowRedView.backgroundColor = APP_BTN_COLOR;
        lowRedView.tag = i + 600;
        
        [grayView addSubview:lowRedView];
        
        if (i == 1) {
            lowRedView.hidden = YES;
        }
    }
}

- (void)ongoingActivity:(UIButton *)sender {
    
    UIView * lowRedView_l = [grayView viewWithTag:600];
    
    if (lowRedView_l.hidden) {
        
        self.navigationBarTitleLabel.text= @"我的活动";
        isNextPage = false;
        [endedBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
        [ongoingBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
        
        lowRedView_l.hidden = NO;
        
        UIView * lowRedView_r = [grayView viewWithTag:601];
        lowRedView_r.hidden = YES;
        
        type = @"3";
        [self loadData:nil];
    }
}

- (void)endedActivity:(UIButton *)sender {
    
    UIView * lowRedView_r = [grayView viewWithTag:601];
    
    if (lowRedView_r.hidden) {
        
        self.navigationBarTitleLabel.text= @"活动列表";
        isNextPage = false;
        [ongoingBtn setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
        [endedBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
        
        UIView * lowRedView_l = [grayView viewWithTag:600];
        lowRedView_l.hidden = YES;
        
        lowRedView_r.hidden = NO;
        
        type = @"2";
        [self loadData:nil];
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
    if(!isNextPage){
        [self performSelector:@selector(loadData:) withObject:MORE_METHOD afterDelay:0.f];
    }else{
        [tableView tableViewDidFinishedLoading];
    }
    
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    
//    [endedTV tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [endedTV tableViewDidEndDragging:vScrollView];
//}

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
