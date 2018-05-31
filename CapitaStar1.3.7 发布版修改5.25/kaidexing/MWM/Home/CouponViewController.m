//
//  CouponViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/27.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CouponViewController.h"
#import "PullingRefreshTableView.h"
#import "TextSearchController.h"
#import "GoViewController.h"
#import "SearchListController.h"
#import "ScreenViewController.h"
#import "MLabel.h"
#import "GoViewController.h"
#import "ReTableView.h"

@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)UIView               *hiddenView;//rootview
@property (strong,nonatomic)UISegmentedControl   *segment;
@property (strong,nonatomic)NSMutableArray       *dataArray;

@end

@implementation CouponViewController{
    
    UIView              *navView;
    ReTableView      *tableView1;
    
    NSString  *floorID;//楼层 //距离id
    NSString  *typeID;//业态 //商场id
    
    UIView      *nilView1; //主界面没有数据
    NSInteger    _page;//页数
    BOOL        isend;
    NSMutableArray   *dataArr;
    UIView      *shaixuanView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    floorID=@"0";
    typeID=@"0";
    isend=NO;
    _page=1;
    
    dataArr=[[NSMutableArray alloc]init];
    [self rightbar];
    [self createRootView];
    [self inittable];
    [self NetWorkRequest:nil];
}
-(void)rightbar{
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}
//点击筛选事件
-(void)img_rightTouch:(UIButton*)sender{
    shaixuanView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    shaixuanView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    ScreenViewController  *sView=[[ScreenViewController alloc]init];
    
    sView.typeStr=@"0";
    sView.vul_1=floorID;
    sView.vul_2=typeID;
    sView.screeDelegate=self;
    sView.view.backgroundColor=[UIColor whiteColor];
    sView.view.frame=CGRectMake(M_WIDTH(95),0,WIN_WIDTH-M_WIDTH(95),WIN_HEIGHT);
    [shaixuanView addSubview:sView.view];
    [self.view addSubview:shaixuanView];
}

-(void)setScreeViewValue:(id)val{
    floorID =val[0];
    typeID =val[1];
    [shaixuanView removeFromSuperview];
    [self NetWorkRequest:nil];
}

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{
    
    if (nilView1==Nil) {
    }else{
        [nilView1 removeFromSuperview];
    }
    
    if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
        _page = 1;
        isend=NO;
    }else {
        if (isend==YES) {
            [tableView1 tableViewDidFinishedLoading];
            [tableView1 noticeNoMoreData];
            return;
        }else {
            _page++;
        }
    }
    
    int       type1=[typeID intValue];
    NSString  *latitude;
    NSString  *longitude;
    NSUserDefaults *cityNSU=[NSUserDefaults standardUserDefaults];
    
    if ([Util isNull:[cityNSU valueForKey:@"latitude"]]) {
        latitude=@"0";
    }else{
        latitude=[cityNSU valueForKey:@"latitude"];
    }
    
    if ([Util isNull:[cityNSU valueForKey:@"longitude"]]) {
        longitude=@"0";
    }else{
        longitude=[cityNSU valueForKey:@"longitude"];
    }
    int cityID=[[cityNSU valueForKey:@"city"] intValue];
    
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(type1),@"mall_id",@(0),@"Floor",@(0),@"Type",latitude,@"lat",longitude,@"lng",@(cityID),@"city_id",@(1),@"is_discount",floorID,@"distance",@(_page),@"Page",@"10",@"pageSize",@"",@"Key", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmerchantact"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                    [dataArr removeAllObjects];
                    dataArr=[[NSMutableArray alloc]init];
                }
                isend =[dic[@"data"][@"isend"]boolValue];
                [dataArr addObjectsFromArray:dic[@"data"][@"shopactivitylist"]];
                [tableView1 reloadData];
                if (dataArr.count==0 &&_page==1) {
                    [self initnilView];
                }
            }else {
                
                [self initnilView];
            }
            [tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}

-(void)createRootView{
    self.hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    self.hiddenView.backgroundColor=UIColorFromRGB(0xf3f3f3);
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(67))];
    view.backgroundColor=APP_NAV_COLOR;
    [self.hiddenView addSubview:view];
    [self.view addSubview:self.hiddenView];
}


-(void)inittable{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,10, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-10) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.refreshTVDelegate=self;
    [self.hiddenView addSubview:tableView1];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(NetWorkRequest:) withObject:REFRESH_METHOD afterDelay:0.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [[NSDate alloc] init];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(NetWorkRequest:) withObject:MORE_METHOD afterDelay:0.f];
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [tableView1 tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return M_WIDTH(83);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return M_WIDTH(8);
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor=[UIColor clearColor];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier=@"cellID4";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView *view=[self createCellIndex:indexPath];
    [cell addSubview:view];
    return cell;
}

-(UIView*)createCellIndex:(NSIndexPath*)index{
    NSDictionary *dic=dataArr[index.section];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(8),0,WIN_WIDTH-M_WIDTH(16),M_WIDTH(83))];
    view.backgroundColor=[UIColor clearColor];
    
    UIImageView *bImgView=[[UIImageView alloc]initWithFrame:view.bounds];
    bImgView.userInteractionEnabled=YES;
    [bImgView setImage:[UIImage imageNamed:@"receive"]];
    
    UIImageView *bigImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11),M_WIDTH(11),M_WIDTH(85),M_WIDTH(61))];
    [bigImg setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"img_url"]]]];
    bigImg.userInteractionEnabled=YES;
    [bImgView addSubview:bigImg];
    
    MLabel *titleLab=[[MLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImg.frame)+M_WIDTH(11),M_WIDTH(10),M_WIDTH(120),M_WIDTH(15))];
    titleLab.text=[Util isNil:dic[@"title"]];
    titleLab.numberOfLines=2;
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.font=DESC_FONT;
    titleLab.maxHeight=M_WIDTH(30);
    [titleLab autoSize];
    
    [bImgView addSubview:titleLab];
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImg.frame)+M_WIDTH(11),CGRectGetMaxY(bigImg.frame)-M_WIDTH(15),M_WIDTH(11),M_WIDTH(12))];
    [iconImg setImage:[UIImage imageNamed:@"location"]];
    [bImgView addSubview:iconImg];
    
    UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(4),CGRectGetMaxY(bigImg.frame)-M_WIDTH(15), M_WIDTH(102),M_WIDTH(13))];
    addressLab.text=[Util isNil:dic[@"mall_name"]];
    addressLab.textColor=COLOR_FONT_SECOND;
    addressLab.font=INFO_FONT;
    [bImgView addSubview:addressLab];
    
    UIButton *lingquBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bImgView.frame)-M_WIDTH(73),0,M_WIDTH(73),bImgView.frame.size.height)];
    lingquBtn.tag=index.section;
    [lingquBtn addTarget:self action:@selector(lingquTouch:) forControlEvents:UIControlEventTouchUpInside];
    [bImgView addSubview:lingquBtn];
    [view addSubview:bImgView];
    return view;
}

-(void)lingquTouch:(UIButton*)sender{
    NSDictionary *dic=dataArr[sender.tag];
    GoViewController *vc=[[GoViewController alloc]init];
    vc.path=[Util isNil:dic[@"act_detail"]];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [dataArr objectAtIndex:indexPath.row];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = [dic valueForKey:@"shopdetail_url"];
    [self.delegate.navigationController pushViewController: vc animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [shaixuanView removeFromSuperview];
}
-(void)initnilView{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT- NAV_HEIGHT)];
    nilView1.backgroundColor=UIColorFromRGB(0xf3f3f3);
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
