//
//  NewListViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/27.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "NewListViewController.h"
#import "SelectionBoxView.h"
#import "SearchDetailsCell.h"
#import "ShopeDetailViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodsDetailViewController.h"
#import "GoViewController.h"
#import "SearchListController.h"
#import "ScreenViewController.h"
#import "ReTableView.h"
@interface NewListViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)UIView              *hiddenView;//rootview
@property (strong,nonatomic)SelectionBoxView    *selectionView;//选择框

@end

@implementation NewListViewController{
    
    ReTableView   *tableView1;
    NSString  *juliID;//距离id
    NSString  *markID;//商场id
    
    NSInteger  pageNum;
    UIView    *nilView1; //主界面没有数据
    
    UIView    *curDealView;
    BOOL       isend;
    UIView    *btnView;
    UIView    *shaixuanView;
    NSMutableArray   *dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isend=NO;
    pageNum=1;
    markID=@"0";
    juliID=@"0";
    dataArr = [[NSMutableArray alloc]init];
    [self createRootView];
    [self rightbar];
    [self initableview];
    [self NetWorkRequest:nil];
}

-(void)createRootView{
    self.hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    self.hiddenView.backgroundColor=UIColorFromRGB(0xf3f3f3);
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(67))];
    view.backgroundColor=APP_NAV_COLOR;
    [self.hiddenView addSubview:view];
    
}

-(void)rightbar{
    UIButton *scanBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn1 setFrame:self.rigth_laft_BarItemView.bounds];
    [scanBtn1 setImage:[UIImage imageNamed:@"search_Icon"] forState:UIControlStateNormal];
    [scanBtn1 addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigth_laft_BarItemView addSubview:scanBtn1];
    self.rigth_laft_BarItemView.hidden = FALSE;
    
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
    sView.vul_1=juliID;
    sView.vul_2=markID;
    sView.screeDelegate=self;
    sView.view.backgroundColor=[UIColor whiteColor];
    sView.view.frame=CGRectMake(M_WIDTH(95),0,WIN_WIDTH-M_WIDTH(95),WIN_HEIGHT);
    [shaixuanView addSubview:sView.view];
    [self.view addSubview:shaixuanView];
}

-(void)setScreeViewValue:(id)val{
    juliID =val[0];
    markID =val[1];
    [self NetWorkRequest:nil];
}
-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}
#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{
    
    [nilView1 removeFromSuperview];
    
    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
        isend=NO;
        pageNum=1;
    }else if (isend==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [tableView1 tableViewDidFinishedLoading];
        [tableView1 noticeNoMoreData];
        return;
    }else {
        pageNum++;
    }
    
    if (type == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    
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
    int mallID=[markID intValue];
    
    [nilView1 removeFromSuperview];
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(mallID),@"mall_id",latitude,@"lat",longitude,@"lng",@(cityID),@"city_id",@(0),@"Type",juliID,@"distance",@(pageNum),@"Page",@(0),@"is_recommend",@"10",@"pageSize",@"",@"Key", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getshoplist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                    [dataArr removeAllObjects];
                }
                
                NSLog(@"%@",dic);
                NSArray *array=dic[@"data"][@"shoplist"];
                isend  =[dic[@"data"][@"isEnd"]boolValue];
                [dataArr addObjectsFromArray:array];
                [tableView1 reloadData];
            }
            if (dataArr.count==0 ) {
                [self initnilView];
            }
            
            [tableView1 tableViewDidFinishedLoading];
            
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}


-(void)initableview{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,10, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-10) style:UITableViewStylePlain];
    
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.refreshTVDelegate=self;
    [self.hiddenView addSubview:tableView1];
    [self.view addSubview:_hiddenView];
    
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
    SearchDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[SearchDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    UIView* delView = [cell viewWithTag:90000];
    UIView* delView1= [cell viewWithTag:80000];
    UIView* delview2= [cell viewWithTag:70000];
    
    
    [delView removeFromSuperview];
    [delView1 removeFromSuperview];
    [delview2 removeFromSuperview];
    NSString* logStr = [Util isNil:dataArr[indexPath.section][@"logo_img_url"]];
    [cell.bigImgView setImageWithURL:[NSURL URLWithString:logStr]];
    NSString    *shop_name     =[Util isNil:dataArr[indexPath.section][@"shop_name"]];
    cell.nameLab.text=shop_name;
    [cell.nameLab sizeToFit];
    NSString    *type_name     =[Util isNil:dataArr[indexPath.section][@"type_name"]];
    cell.explainLab.text=type_name;
    [cell.explainLab sizeToFit];
    
    //促
    UILabel*cuLab=[[UILabel alloc]init];
    cuLab.backgroundColor=UIColorFromRGB(0xfe6732);
    cuLab.text=@"促";
    cuLab.font=INFO_FONT;
    cuLab.textAlignment=NSTextAlignmentCenter;
    cuLab.textColor=[UIColor whiteColor];
    cuLab.tag = 90000;
    
    //排
    UILabel* paiLab=[[UILabel alloc]init];
    paiLab.backgroundColor=UIColorFromRGB(0xaabeb);
    paiLab.text=@"排";
    paiLab.font=INFO_FONT;
    paiLab.textAlignment=NSTextAlignmentCenter;
    paiLab.textColor=[UIColor whiteColor];
    paiLab.tag=80000;
    
    //券
    UILabel *juanLab=[[UILabel alloc]init];
    juanLab.text=@"券";
    juanLab.backgroundColor=UIColorFromRGB(0x5ab628);
    juanLab.font=INFO_FONT;
    juanLab.textAlignment=NSTextAlignmentCenter;
    juanLab.textColor=[UIColor whiteColor];
    juanLab.tag=70000;
    
    float     lab_top=M_WIDTH(11);
    CGFloat   lab_H=M_WIDTH(13);
    
    CGFloat   lab_laft_w_1=CGRectGetMaxX(cell.nameLab.frame)+M_WIDTH(10);
    CGFloat   lab_laft_w_2=CGRectGetMaxX(cell.nameLab.frame)+M_WIDTH(26);
    CGFloat   lab_laft_w_3=CGRectGetMaxX(cell.nameLab.frame)+M_WIDTH(42);
    
    NSString    *queue_status  =[Util isNil:dataArr[indexPath.section][@"queue_status"]];
    NSString    *sale_status  =[Util isNil:dataArr[indexPath.section][@"sale_status"]];
    NSString    *coupon_status =[Util isNil:dataArr[indexPath.section][@"coupon_status"]];
    if ([queue_status isEqualToString:@"1"]) {
        if ([sale_status isEqualToString:@"1"]) {
            if ([coupon_status isEqualToString:@"1"]) {
                paiLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
                cuLab   .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
                juanLab .frame=CGRectMake(lab_laft_w_3, lab_top, lab_H, lab_H);
                [cell addSubview:paiLab];
                [cell addSubview:cuLab];
                [cell addSubview:juanLab];
                
            }else{
                paiLab.frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
                cuLab .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
                [cell addSubview:paiLab];
                [cell addSubview:cuLab];
            }
        }else if ([coupon_status isEqualToString:@"1"]) {
            
            paiLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            juanLab .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
            [cell addSubview:paiLab];
            [cell addSubview:juanLab];
            
        }else {
            paiLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            [cell addSubview:paiLab];
        }
        
        
    }else if ([sale_status isEqualToString:@"1"]) {
        if ([coupon_status isEqualToString:@"1"]) {
            cuLab   .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            juanLab .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
            [cell addSubview:cuLab];
            [cell addSubview:juanLab];
        }else {
            cuLab.frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            [cell addSubview:cuLab];
        }
    }else if ([coupon_status isEqualToString:@"1"]) {
        juanLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
        [cell addSubview:juanLab];
    }else{
    }
    
    NSString    *floor_name    =[Util isNil:dataArr[indexPath.section][@"floor_name"]];
    cell.addressLab.text=floor_name;
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [tableView1 tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [dataArr objectAtIndex:indexPath.section];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = [dic valueForKey:@"link_url"];
    [self.delegate.navigationController pushViewController: vc animated:YES];
    
}


-(void)initnilView{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+40, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-40)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.hiddenView addSubview:nilView1];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [shaixuanView removeFromSuperview];
    [self.view endEditing:YES];
    [tableView1 endEditing:YES];
}


-(void)img_BtnTouch:(UIButton*)sender
{
    SearchListController *vc=[[SearchListController alloc]init];
    vc.typeStr=@"0";
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

@end
