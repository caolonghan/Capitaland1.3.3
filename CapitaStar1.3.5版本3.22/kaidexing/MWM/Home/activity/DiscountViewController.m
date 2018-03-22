//
//  DiscountViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "DiscountViewController.h"
#import "PullingRefreshTableView.h"
#import "GoViewController.h"
#import "ReTableView.h"

@interface DiscountViewController()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource,ZhuRefreshTableView>

@property (strong,nonatomic)UIView          *hiddenView;//rootview/
@property (strong,nonatomic)NSMutableArray  *dataAry;//所有数据

@end

@implementation DiscountViewController{
    
    UIView              *nvcView;
    CGFloat             view_H;
    UIView *nilView1; //主界面没有数据
    
    ReTableView * tableView1;
    int  _page;//页数
    BOOL    isend;//是否还有数据
    UIButton *scanBtn;
}


-(void)initnvc{
    
    scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"search_Icon"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}
-(void)img_BtnTouch:(UIButton*)sender{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initnvc];
    self.view.backgroundColor=COLOR_MAIN_BG;
    self.dataAry=[[NSMutableArray alloc]init];
    _page=1;
    isend=NO;
    
    [self redefineBackBtn];
    [self initTableView1];
    [self NetWorkRequest:nil];//获取数据
}
-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}
#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{
    
    NSString *string=[Util makeRequestUrl:@"index" tp:@"getmerchantact"];
    int zz=[[Global sharedClient].markID intValue];;
    if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
        _page = 1;
        isend=NO;
    }else if (isend==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [tableView1 tableViewDidFinishedLoading];
        [tableView1 noticeNoMoreData];
        return;
    }else {
        _page++;
    }
    
    if (type == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    
    
    [nilView1 removeFromSuperview];
    NSDictionary *diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(0),@"Floor",@(0),@"Type",@(_page),@"Page",@"10",@"pageSize",@(0),@"distance",@(0),@"is_discount",@"",@"city_id",@"",@"lng",@"",@"lat",@"",@"Key",nil];
    
    [HttpClient requestWithMethod:@"POST" path:string parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
                [nilView1 removeFromSuperview];
                
                [self.dataAry removeAllObjects];
                self.dataAry=[[NSMutableArray alloc]init];
            }
            if([dic[@"data"] isKindOfClass:[NSDictionary class]]){
                
                isend  = [dic[@"data"][@"isEnd"]boolValue];
                [self.dataAry addObjectsFromArray:dic[@"data"][@"shopactivitylist"]];
                    
                if (self.dataAry.count==0) {
                    [self initnilView];
                }
                
            }else {
                
                [self initnilView];
            }
            [tableView1 tableViewDidFinishedLoading];
            [tableView1 reloadData];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
    
}


-(void)initTableView1{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,M_WIDTH(43), WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(43)) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView1.refreshTVDelegate=self;
    [self.hiddenView addSubview:tableView1];
    
}

//#pragma mark - PullingRefreshTableViewDelegate
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(NetWorkRequest:) withObject:REFRESH_METHOD afterDelay:0.f];
//}
//
//- (NSDate *)pullingTableViewRefreshingFinishedDate{
//    return [[NSDate alloc] init];
//}
//
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(NetWorkRequest:) withObject:MORE_METHOD afterDelay:0.f];
//    
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return M_WIDTH(8);
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor=[UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return M_WIDTH(87.5);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier=@"cellID4";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    UIView *deleView=[cell viewWithTag:1000];
    [deleView removeFromSuperview];

    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(UIView*)createCellView:(NSIndexPath*)index{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    
    
    return view;
}


//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [tableView1 tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoViewController *vc=[[GoViewController alloc]init];
    vc.path=self.dataAry[indexPath.row][@"act_detail"];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


//没有数据的时候显示的View
-(void)initnilView{
    nilView1=[[UIView alloc]initWithFrame:tableView1.bounds];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.hiddenView addSubview:nilView1];
}


-(void)shoucangTouch:(UIButton*)sender{
    NSLog(@"点击了第%d个btn",(int)sender.tag);
}


@end
