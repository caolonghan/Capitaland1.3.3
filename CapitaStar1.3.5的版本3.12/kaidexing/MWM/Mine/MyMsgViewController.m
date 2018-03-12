//
//  MyMsgViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyMsgViewController.h"

#import "MsgTVCell.h"
#import "ScoreTVCell.h"
#import "PullingRefreshTableView.h"
#import "ReTableView.h"

static NSString * identifier_voucher = @"MsgTVCell";
static NSString * identifier_score = @"ScoreTVCell";

@interface MyMsgViewController () <UITableViewDataSource, UITableViewDelegate,ZhuRefreshTableView>
{
    //UITableView * tableV;
    ReTableView * tabV;
    
    int page;    //当前页。
    
    NSString * isNextPage;
    
    NSMutableArray * messagelist;
}
@end

@implementation MyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"我的消息";
    
    [self loadData:nil];
    messagelist = [[NSMutableArray alloc] init];
    //[self createTableView];
}

-(void)tableView_refresh:(NSString *)type{
    [self loadData:type];
}

- (void)loadData:(NSString *)type {
    
    if(type == nil || [type isEqualToString: REFRESH_METHOD]){
        page = 1;
        isNextPage = @"1";
    }else{
        page ++;
    }
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @(page), @"page", @"10", @"pageSize", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"message"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![dic [@"data"] isKindOfClass:[NSDictionary class]]) {
                [self createUIImageView];
                [SVProgressHUD dismiss];
                return;
            }
            NSDictionary * dataDic = dic[@"data"];
            
            isNextPage = dataDic[@"isend"];
            
            NSArray * array = dataDic[@"messagelist"];
            [messagelist addObjectsFromArray:array];
            
            if (tabV) {
                
                [tabV reloadData];
                [tabV tableViewDidFinishedLoading];
            } else {
                [self createTableView];
            }
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
        
    }];
}


- (void)createTableView {
    
    tabV = [[ReTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT-BAR_HEIGHT) style:UITableViewStylePlain];
    NSLog(@"BAR_HEIGHT%f",BAR_HEIGHT);
    tabV.dataSource = self;
    tabV.delegate = self;
    tabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tabV];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return messagelist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //每次去取出“title”根据它算出高度
    NSDictionary* dic = [messagelist objectAtIndex:indexPath.section];
    CGRect rect1=[[self dealText:[dic valueForKey:@"msg"] ] boundingRectWithSize:CGSizeMake(SCREEN_FRAME.size.width - 16,900) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:COMMON_FONT} context:nil];
    //return rect1.size.height + 84+8;
    return rect1.size.height + 65 + 8;
}

-(NSString*) dealText:(NSString*) str{
    if([Util isNull:str]){
        return @"";
        
    }
    NSString* str1 = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    
    NSRange range = [str1 rangeOfString:@"<"];
    while(range.location != NSNotFound){
        NSRange endRange = [str1 rangeOfString:@">"];
        range.length = endRange.location + 1 - range.location;
        str1 = [str1 stringByReplacingCharactersInRange:range withString:@""];
        range = [str1 rangeOfString:@"<"];
    }
    range = NSMakeRange(str1.length - 1, 1);
    NSString* subStr = [str1 substringWithRange:range];
    while ([subStr isEqualToString:@"\r"] || [subStr isEqualToString:@"\n"]) {
        str1 = [str1 stringByReplacingCharactersInRange:range withString:@""];
        range = NSMakeRange(str1.length - 1, 1);
        subStr = [str1 substringWithRange:range];
    }
    range = NSMakeRange(0, 1);
    subStr = [str1 substringWithRange:range];
    while ([subStr isEqualToString:@"\r"] || [subStr isEqualToString:@"\n"]) {
        str1 = [str1 stringByReplacingCharactersInRange:range withString:@""];
        range = NSMakeRange(0, 1);
        subStr = [str1 substringWithRange:range];
    }
    return str1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ScoreTVCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier_score];
    
    if (!cell) {
        
        cell = [[ScoreTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_score];
    }
    cell.dataDic = messagelist[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 6)];
    view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //发通知给cell，改变相应文字颜色？？？？
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData:) withObject:REFRESH_METHOD afterDelay:0.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [[NSDate alloc] init];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    if(![isNextPage isEqualToString:@"true"]){
        [self performSelector:@selector(loadData:) withObject:MORE_METHOD afterDelay:0.f];
    }else{
        [tableView tableViewDidFinishedLoading];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    
//    [tabV tableViewDidScroll:vScrollView];
    if (vScrollView == tabV)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (vScrollView.contentOffset.y<=sectionHeaderHeight&&vScrollView.contentOffset.y>=0) {
            vScrollView.contentInset = UIEdgeInsetsMake(-vScrollView.contentOffset.y, 0, 0, 0);
        } else if (vScrollView.contentOffset.y>=sectionHeaderHeight) {
            vScrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tabV tableViewDidEndDragging:vScrollView];
//}

- (void)createUIImageView {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIN_WIDTH - 80) / 2, NAV_HEIGHT + 97, 80, 80)];
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
