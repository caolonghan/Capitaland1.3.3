//
//  SearchDetailsController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ActivityController.h"
#import "ActivityViewCell.h"
#import "SelectionBoxView.h"
#import "SoreDiscountsController.h"
#import "PullingRefreshTableView.h"
#import "SoreDiscountsController.h"
#import "RegistrationController.h"
#import "GroupViewController.h"
#import "GoViewController.h"
#import "SearchListController.h"
#import "SearchDetailsCell.h"
#import "MTableBar.h"
#import "ScreenViewController.h"
#import "ReTableView.h"
@interface  ActivityController()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>

@property (strong,nonatomic)UIView          *hiddenView;//rootview/
@property (strong,nonatomic)NSMutableArray  *dataAry;//所有数据

@end

@implementation ActivityController{
    UIView              *nvcView;
    NSMutableString     *tpStr;
    BOOL                _activityType;
    CGFloat             view_H;
    NSString *floorID;//返回的楼层ID   //距离
    NSString *typeID; //返回的业态ID   //商场id
    UIView *nilView1; //主界面没有数据
    ReTableView* tableView1;
    int  _page;//页数
    BOOL    isend;//是否还有数据
    UIView  *shaixuanView;
    UIButton *scanBtn1;
    UIButton *scanBtn;
    UISegmentedControl       *segment;
    
}

//商点右上方按钮
-(void)rightbar{
    scanBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-88,20,44, 44)];
    [scanBtn1 setImage:[UIImage imageNamed:@"search_Icon"] forState:UIControlStateNormal];
    [scanBtn1 addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:scanBtn1];
    
    scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}
//商场右上方按钮
-(void)rightbar_2{
    scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"search_Icon"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}

//点击筛选事件
-(void)img_rightTouch:(UIButton*)sender{
    shaixuanView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    shaixuanView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    ScreenViewController  *sView=[[ScreenViewController alloc]init];
    sView.typeStr=_isType;
    sView.vul_1=floorID;
    sView.vul_2=typeID;
    sView.screeDelegate=self;
    sView.view.backgroundColor=[UIColor whiteColor];
    sView.view.frame=CGRectMake(M_WIDTH(95),0,WIN_WIDTH-M_WIDTH(95),WIN_HEIGHT);
    [shaixuanView addSubview:sView.view];
    [self.view addSubview:shaixuanView];
}
-(void)setScreeViewValue:(id)val{
    floorID=val[0];//
    typeID=val[1];//
    [shaixuanView removeFromSuperview];
    [self NetWorkRequest:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self rightbar];
    self.navigationBarTitleLabel.text=@"活动";
    self.view.backgroundColor=COLOR_MAIN_BG;
    self.dataAry=[[NSMutableArray alloc]init];
    _activityType=NO;
    floorID=@"0";
    typeID =@"0";
    _page=1;
    isend=NO;
    [self createRootView];
    [self initTableView1];
    [self NetWorkRequest:nil];//获取数据
}
-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}
#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{
    
    NSString *string=[self chuliType];
    int zz=[[Global sharedClient].markID intValue];;
    NSDictionary*diction;
    
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
    
    int froor = [floorID intValue];
    int aType = [typeID intValue];
    if (_activityType==NO) {
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(froor),@"Floor",@(aType),@"Type",@(_page),@"Page",@"10",@"pageSize",@"",@"Key", nil];
    }else {
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(froor),@"Floor",@(aType),@"Type",@(_page),@"Page",@"10",@"pageSize",@"",@"Key", nil];
    }
    
    [HttpClient requestWithMethod:@"POST" path:string parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
                [nilView1 removeFromSuperview];
                
                [self.dataAry removeAllObjects];
                self.dataAry=[[NSMutableArray alloc]init];
            }
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                isend  = [dic[@"data"][@"isEnd"]boolValue];
                if (_activityType==NO) {
                    
                    [self.dataAry addObjectsFromArray:dic[@"data"][@"shopactivitylist"]];
                }else{
                    
                    [self.dataAry addObjectsFromArray:dic[@"data"][@"mallactivitylist"]];
                }
                
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


-(void)createRootView{
    self.hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    self.hiddenView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(43))];
    headView.backgroundColor  = [UIColor whiteColor];
    
    segment = [[UISegmentedControl alloc]initWithItems:nil];
    segment.frame=CGRectMake((WIN_WIDTH-M_WIDTH(299))/2,M_WIDTH(8),M_WIDTH(299),M_WIDTH(27));
    segment.tintColor=APP_BTN_COLOR;
    [segment insertSegmentWithTitle: @"商户活动" atIndex: 0 animated: NO ];
    [segment insertSegmentWithTitle: @"商场活动" atIndex: 1 animated: NO ];
    segment.selectedSegmentIndex =0;//设置默认选择项索引
    //设置跳转的方法
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [headView addSubview:segment];
    [self.hiddenView addSubview:headView];
    [self.view addSubview:self.hiddenView];
}

-(void)change:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
            
        case 0:{
            if (_activityType!=NO) {
                _activityType=NO;
                [scanBtn removeFromSuperview];
//                [self rightbar];
                isend=NO;
                _page=1;
                [self NetWorkRequest:nil];
            }
            break;
        }
        case 1:{
            if (_activityType!=YES) {
                _activityType=YES;
                [scanBtn removeFromSuperview];
                [scanBtn1 removeFromSuperview];
//                [self rightbar_2];
                isend=NO;
                _page=1;
                [self NetWorkRequest:nil];
            }
            break;
        }
        default:
            break;
    }
}


-(void)initTableView1{
    CGFloat table_buttom;
    if (![Util isNull:_buttomH] && [_buttomH isEqualToString:@"1"]) {
        table_buttom=45;
    }else{
        table_buttom=0;
    }
    
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,M_WIDTH(43), WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(43)-table_buttom) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.refreshTVDelegate=self;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.hiddenView addSubview:tableView1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return M_WIDTH(8);
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return M_WIDTH(0.01);
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor=[UIColor clearColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat tableView_H;
    if (_activityType==NO) {
        tableView_H=M_WIDTH(83);
    }else if (_activityType==YES){
        tableView_H=M_WIDTH(208);
    }
    return tableView_H;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic=self.dataAry[indexPath.section];
    if (_activityType==NO) {
        static NSString *reuseIdentifier=@"cellID4";
        SearchDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell==nil) {
            cell=[[SearchDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        UIView *deleView=[cell viewWithTag:1000];
        [deleView removeFromSuperview];
        
        [cell.bigImgView setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"img_url"]]]];
        cell.nameLab.text=[Util isNil:dic[@"title"]];
        //        [cell.nameLab sizeToFit];
        cell.explainLab.text=[Util isNil:dic[@"type"]];
        
        cell.addressLab.text=[Util isNil:dic[@"sale_type_name"]];
        
        UIImageView   *actImg=[[UIImageView alloc]init];
        
        int actInt=[dic[@"act_type"]intValue];
        
        if (actInt == 0) {
            actImg.frame=CGRectMake(M_WIDTH(20), M_WIDTH(10), M_WIDTH(31), M_WIDTH(14));
            [actImg setImage:[UIImage imageNamed:@"sales"]];
        }else {
            actImg.frame=CGRectMake(M_WIDTH(20), M_WIDTH(10),M_WIDTH(50),M_WIDTH(14));
            [actImg setImage:[UIImage imageNamed:@"coupona"]];
        }
        
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(_activityType==YES){
        static NSString *reuseIdentifier=@"cellID2";
        ActivityViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell==nil) {
            cell=[[ActivityViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        UIView  *deleView=[cell viewWithTag:1000];
        [deleView removeFromSuperview];
        
        [cell.bigImgView setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"img_url"]]]];
        cell.nameLab.text=[Util isNil:dic[@"name"]];
        cell.huodongType.hidden = NO;
        switch ([dic[@"type"] intValue]) {
            case 6:
                cell.huodongType.text=@"亲友团";
                break;
            case 2:
                cell.huodongType.text=@"公告促销";
                break;
            case 4:
                cell.huodongType.text=@"报名";
                break;
            case 7:
            {
                switch ([dic[@"lottery_type"] intValue]) {
                    case 0:
                        cell.huodongType.text=@"摇一摇";
                        break;
                    case 2:
                        cell.huodongType.text=@"跑马灯";
                        break;
                    case 3:
                        cell.huodongType.text=@"老虎机";
                        break;
                    case 4:
                        cell.huodongType.text=@"砸金蛋";
                        break;
                    case 5:
                        cell.huodongType.text=@"摇一摇";
                        break;
                    default:
                        cell.huodongType.text=@"公告促销";
                        break;
                }
            }
                break;
                
            default:
                cell.huodongType.text=@"";
                cell.huodongType.hidden = YES;
                break;
        }
        
        
        
        
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoViewController *vc=[[GoViewController alloc]init];
    vc.path=self.dataAry[indexPath.section][@"act_detail"];
    //vc.isShare=@"share";
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//没有数据的时候显示的View
-(void)initnilView{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+M_WIDTH(43),WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(43)-45)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.hiddenView addSubview:nilView1];
    
}
-(void)img_BtnTouch:(UIButton*)sender{
    SearchListController *vc=[[SearchListController alloc]init];
    if (_activityType==NO) {
        vc.typeStr=@"1";
    }else {
        vc.typeStr=@"2";
    }
    
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

-(void)shoucangTouch:(UIButton*)sender
{
    NSLog(@"点击了第%d个btn",(int)sender.tag);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shaixuanView removeFromSuperview];
}


-(NSString*)chuliType{
    NSString *str;
    if ([_isType isEqualToString:@"0"]) {//未选择商场进入的
        if (_activityType==NO) {
            
            str=[Util makeRequestUrl:@"index" tp:@"getmerchantact"];
        }else{
            str=[Util makeRequestUrl:@"index" tp:@"getmallact"];
        }
    }else{
        //选择商场进入的
        if (_activityType==NO) {
            
            str=[Util makeRequestUrl:@"mallshoplist" tp:@"shopactivitylist"];
        }else{
            str=[Util makeRequestUrl:@"mallshoplist" tp:@"mallactivitylist"];
        }
    }
    return str;
}

@end
