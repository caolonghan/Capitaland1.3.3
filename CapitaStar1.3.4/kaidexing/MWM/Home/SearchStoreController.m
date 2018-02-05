//
//  SearchStoreController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SearchStoreController.h"
#import "FoodViewController.h"
#import "SNObjt.h"
#import "GoViewController.h"
#import "ActivityController.h"
#import "IntegralController.h"
#import "FindStoreController.h"
#import "CitySearchController.h"
#import "TextSearchController.h"
#import "KDSearchBar.h"

@interface SearchStoreController ()<UISearchBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)KDSearchBar     *homeTextF;
@property (strong,nonatomic)UIView          *headView; //搜索之前的上面一部分视图
@property (strong,nonatomic)UIView          *rootView;// 第一层view
//@property (strong,nonatomic)NSMutableArray  *sousuoAry;//保存搜索内容的
@property (strong,nonatomic)UITableView     *tableview1;

@property (strong,nonatomic)UIView          *resultView;//搜索出来的结果

@end

@implementation SearchStoreController
{
    TextSearchController  *textVC;
    UIView          *nvcView1;
    UIPageControl   *pagecontrol;
    NSInteger        viewTag;
    NSDictionary    *ceshiDic1;//测试保存id
    NSMutableArray  *hotArray;//保存热门词汇
    NSArray         *ImgArray;//保存图片
    NSMutableArray  *titltAry;//保存文字
    NSMutableArray  *titleIDAry;//保存id
    NSMutableArray  *sousuoTitleAry;//接受搜索的数据
    NSString        *nsUesrStr;
    BOOL             textbecome;//是否出现了搜索界面
    int              twoTime;
    NSTimer         *relodeTime;
    NSMutableArray  *urlAry;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}


-(void)initnvc
{
    
    nvcView1=[[UIView alloc]initWithFrame:CGRectMake(40, STATUS_BAR_HEIGHT + 6, WIN_WIDTH-65, 32)];
    nvcView1.backgroundColor=[UIColor clearColor];
    nvcView1.layer.masksToBounds=YES;
    nvcView1.layer.cornerRadius=5;
    
    self.homeTextF=[[KDSearchBar alloc]initWithFrame:nvcView1.bounds];
    self.homeTextF.newFrame = self.homeTextF.frame;
    self.homeTextF.placeholder=@"请输入要搜索的商户";
    self.homeTextF.delegate=self;
    self.homeTextF.searchBarStyle=UISearchBarStyleMinimal;
    self.homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    self.homeTextF.returnKeyType=UIReturnKeySearch;
    
    [nvcView1 addSubview:self.homeTextF];
    [self.navigationBar addSubview:nvcView1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    textbecome=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    nsUesrStr=[NSString stringWithFormat:@"%@%@",@"resultAry",_hotType];
    hotArray=[[NSMutableArray alloc]init];
    sousuoTitleAry=[[NSMutableArray alloc]init];
    urlAry=[[NSMutableArray alloc]init];
    relodeTime= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    ImgArray =[[NSArray alloc]initWithObjects:@"0003", @"0001",@"0007",@"0010",@"0005",@"0006",@"0009",@"0011",@"0002",@"0004", nil];
    titleIDAry=[[NSMutableArray alloc]init];
    titltAry  =[[NSMutableArray alloc]init];
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    [self initnvc];
    [self NetWorkRequest];
}

#pragma mark ---请求网络---
-(void)NetWorkRequest
{
    
    self.rootView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    [self.view addSubview:self.rootView];
    int zz;
    NSDictionary*diction;
    if ([_hotType isEqualToString:@"0"]) {
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"t",@"0",@"mall_id",nil];
    }else {
        zz=[[Global sharedClient].markID intValue];
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"t",@(zz),@"mall_id",nil];
    }
    
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
           NSLog(@"%@",dic);
           NSArray  *dataArray=dic[@"data"][@"hot_keyword"];
           NSArray  *titleAry1 =dic[@"data"][@"ShopType"];
            for (NSDictionary *dict1 in titleAry1) {
                NSString  *idstr  =[Util isNil:dict1[@"id"]];
                NSString  *nameStr=[Util isNil:dict1[@"name"]];
                [titleIDAry addObject:idstr];
                [titltAry   addObject:nameStr];
            }
            
            for (NSDictionary *dict in dataArray) {
                NSString      *nameStr=[Util isNil:dict[@"name"]];
                [hotArray addObject:nameStr];
            }
            [self initHeadView];
            [self initFooderView];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}
#pragma mark ---创建视图---
-(void)initHeadView
{
    self.headView=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(9), WIN_WIDTH, M_WIDTH(235))];
    self.headView.backgroundColor=UIColorFromRGB(0xffffff);
    
    NSInteger   count=10;
    UIView      *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(235))];
        
        for (int y=0; y<3; y++) {
            for (int x=0; x<4; x++) {
                if (count>0) {
                    count=count-1;
                    
                    UIView *kuaiview=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(7)+x*(WIN_WIDTH-M_WIDTH(14))/4,M_WIDTH(10)+(y*M_WIDTH(66)),(WIN_WIDTH-M_WIDTH(14))/4,M_WIDTH(66))];

                    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(14))/8 -M_WIDTH(19),M_WIDTH(12),M_WIDTH(38), M_WIDTH(38))];
                    [img setImage:[UIImage imageNamed:ImgArray[ImgArray.count-count-1]]];
                    
                    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+M_WIDTH(5),kuaiview.frame.size.width, M_WIDTH(14))];
                    lab.text=titltAry[titltAry.count-count-1];
                    lab.font=INFO_FONT;
                    lab.textAlignment=NSTextAlignmentCenter;
                    
                    UIButton *btn=[[UIButton alloc]initWithFrame:kuaiview.bounds];
                    btn.tag=titltAry.count-count-1;
                    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [kuaiview   addSubview:img];
                    [kuaiview   addSubview:lab];
                    [kuaiview   addSubview:btn];
                    [buttomView addSubview:kuaiview];
                }
            }
        }
        [self.headView addSubview:buttomView];
    
    [self.rootView addSubview:self.headView];
    
}


-(void)initFooderView
{
    NSInteger  count=hotArray.count;
    int zzz;
    if (count<=3) {
        zzz=1;
    }else if (count<=6){
        zzz=2;
    }else if (count<=9){
        zzz=3;
    }else if (count<=12){
        zzz=4;
    }
    UIView *fooderView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame)+M_WIDTH(9), WIN_WIDTH, M_WIDTH(35))];
    fooderView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *hotImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(8), M_WIDTH(12), M_WIDTH(12), M_WIDTH(12))];
    [hotImgView setImage:[UIImage imageNamed:@"hot1"]];
    [fooderView addSubview:hotImgView];
    
    UILabel *hotLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotImgView.frame)+M_WIDTH(3), M_WIDTH(11), M_WIDTH(80), M_WIDTH(14))];
    hotLab.text=@"热门搜索";
    hotLab.font=DESC_FONT;
    hotLab.textAlignment=NSTextAlignmentLeft;
    hotLab.textColor=UIColorFromRGB(0x999999);
    [fooderView addSubview:hotLab];
    [self.rootView addSubview:fooderView];
    
  
    for (int j=0; j<zzz; j++) {
        for (int i=0; i<3; i++) {
            if (count>0) {
                UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/3*i,CGRectGetMaxY(fooderView.frame)+(j*M_WIDTH(38)), WIN_WIDTH/3, M_WIDTH(38))];
                [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn1 setTitle:hotArray[hotArray.count-count] forState:UIControlStateNormal];
                btn1.titleLabel.font=DESC_FONT;
                btn1.backgroundColor=[UIColor whiteColor];
                btn1.tag=hotArray.count-count;
                btn1.layer.borderColor=[COLOR_LINE CGColor];
                btn1.layer.borderWidth=0.5;
        
                [btn1 addTarget:self action:@selector(hotTouch:) forControlEvents:UIControlEventTouchUpInside];
                [self.rootView addSubview:btn1];
                count--;
            }
        }
    }
}


//点击输入框出现的tableview
-(void)inittableview
{
    self.tableview1=[[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    self.tableview1.dataSource=self;
    self.tableview1.delegate  =self;
    self.tableview1.scrollEnabled=YES;
    self.tableview1.backgroundColor=[UIColor whiteColor];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableview1 setTableFooterView:v];
    [self.view addSubview:self.tableview1];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return sousuoTitleAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *cellID=@"cellid";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UIView  *deleView=[cell viewWithTag:1000];
    [deleView removeFromSuperview];
    
    UILabel *sousuoLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, WIN_WIDTH-30, 20)];
    sousuoLab.font=COMMON_FONT;
    sousuoLab.textAlignment=NSTextAlignmentLeft;
    sousuoLab.text=sousuoTitleAry[indexPath.row];
    
    sousuoLab.tag=1000;
    
    UIView *linview=[[UIView alloc]initWithFrame:CGRectMake(20, 39.5, WIN_WIDTH-20,0.5)];
    linview.backgroundColor=COLOR_LINE;
    
    
    [cell addSubview:sousuoLab];
    [cell addSubview:linview];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (textbecome==NO) {
        if (sousuoTitleAry!=0) {
            if (indexPath.row==0){
                [sousuoTitleAry removeAllObjects];
                NSUserDefaults  *result=[NSUserDefaults standardUserDefaults];
                [result setValue:sousuoTitleAry forKey:nsUesrStr];
                [self.tableview1 reloadData];
            }else{
                [self NetWorkRequest_sousuo:sousuoTitleAry[indexPath.row]];
            }
        }
        [self.homeTextF resignFirstResponder];
    }else{
        GoViewController *vc=[[GoViewController alloc]init];
        vc.path=urlAry[indexPath.row];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    [self.homeTextF resignFirstResponder];
}
//搜索内容改变的时候，在这个方法里面实现实时显示结果
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    textbecome=YES;
    twoTime=2;
    [relodeTime setFireDate:[NSDate distantPast]];
}
-(void)timeFireMethod{
    twoTime--;
    if (twoTime==0) {
        NSUserDefaults  *result=[NSUserDefaults standardUserDefaults];
        NSString        *textF=self.homeTextF.text;
        NSMutableArray  *resulrAry1=[[NSMutableArray alloc]init];
        NSMutableArray  *resulrAry2=[[NSMutableArray alloc]init];
        resulrAry1=[[result valueForKey:nsUesrStr]mutableCopy];
        if (![textF isEqualToString:@""]) {
            if([self initpandan:resulrAry1 text:textF]==NO){
                resulrAry2=[[self addquanbu:resulrAry1 :textF] mutableCopy];
                [result setValue:resulrAry2 forKey:nsUesrStr];
           }
        }
        [self NetWorkRequest_sousuo :self.homeTextF.text];
        [relodeTime setFireDate:[NSDate distantFuture]];
    }
}


#pragma mark ---请求网络---
-(void)NetWorkRequest_sousuo :(NSString*)textStr
{
    [sousuoTitleAry removeAllObjects];
    NSDictionary*diction;
    [SVProgressHUD showWithStatus:@"正在努力加载中"];

    NSString  *path;
    if ([_hotType isEqualToString:@"1"]) {
        
        int zz=[[Global sharedClient].markID intValue];
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(0),@"Floor",@"0",@"Type",@"0",@"sort",@(1),@"Page",@"10",@"pageSize",textStr,@"Key", nil];
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadshoplist"];
        
    }else {
        int zz;
        NSUserDefaults *cityNSU=[NSUserDefaults standardUserDefaults];
        if ([cityNSU valueForKey:@"city"]==nil) {
            zz=1;
        }else{
            zz=[[cityNSU valueForKey:@"city"] intValue];
        }
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"city",@"0",@"Type",@"0",@"sort",@(1),@"Page",@"10",@"pageSize",textStr,@"Key", nil];
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"nomallloadshop"] ;
    }
    
    [HttpClient requestWithMethod:@"POST" path:path parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSArray  *array=dic[@"data"][@"shoplist"];
                for (NSDictionary *dict in array) {
                    NSString *name=[Util isNil:dict[@"shop_name"]];
                    NSString *urlS=[NSString stringWithFormat:@"%@",[Util isNil:dict[@"shopdetail_url"]]];
                    [sousuoTitleAry addObject:name];
                    [urlAry addObject:urlS];
                }
                [self.tableview1 reloadData];
            }
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}




//输入框点击return
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.homeTextF resignFirstResponder];
}


//判断搜索的内容是否重复
-(BOOL)initpandan:(NSMutableArray*)nsmutAry text:(NSString*)str
{
    BOOL  isContain = false;
    for (int i=0; i<nsmutAry.count; i++) {
        if ([str isEqualToString:nsmutAry[i]]) {
            isContain=YES;
            break;
        }else{
            isContain=NO;
            break;
        }
    }
    return isContain;
}

//目的是把最新输入的内容放在最上面
-(NSMutableArray*)addquanbu:(NSMutableArray *)mAry :(NSString*)quanbuStr
{
    NSMutableArray *muAry=[[NSMutableArray alloc]init];
    [muAry addObject:quanbuStr];
    for (int i=0; i<mAry.count; i++) {
        NSString *str=mAry[i];
        [muAry addObject:str];
    }
    return muAry;
}

//热门点击事件
-(void)hotTouch:(UIButton*)sender
{
     NSString *soucuoStr=hotArray[sender.tag];
    if ([_hotType isEqualToString:@"0"]) {
        
        CitySearchController *tVC=[[CitySearchController alloc]init];
        tVC.pushkeyStr=soucuoStr;
        [self.delegate.navigationController pushViewController:tVC animated:YES];
        
    }else {
        
        FindStoreController *tVC=[[FindStoreController alloc]init];
        tVC.pushkeyStr=soucuoStr;
        [self.delegate.navigationController pushViewController:tVC animated:YES];
    }
    
}

//功能点击事件
-(void)btnTouch:(UIButton*)sender
{
    NSString  *strid=titleIDAry[sender.tag];
    NSString  *title=titltAry[sender.tag];
    if ([_hotType isEqualToString:@"0"]) {
        CitySearchController *vc1=[[CitySearchController  alloc]init];
        vc1.caixiID  = strid;
        vc1.yetaiStr = title;
        [self.delegate.navigationController pushViewController:vc1 animated:YES];
    }else {
        FindStoreController  *vc=[[FindStoreController alloc]init];
        vc.caixiID  = strid; //业态id
        vc.yetaiStr = title;
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }

}

-(void)settexthidden:(id)hidden
{
    GoViewController *gvc=[[GoViewController alloc]init];
    gvc.path=hidden;
    [self.delegate.navigationController pushViewController:gvc animated:YES];
    
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
 if (textbecome==NO) {
    [hotArray   removeAllObjects];
    [titleIDAry removeAllObjects];
    [titltAry   removeAllObjects];
    [self.rootView removeFromSuperview];

    NSUserDefaults * result    =[NSUserDefaults standardUserDefaults];
    NSMutableArray * tihuanAry =[result valueForKey:nsUesrStr];
    if (tihuanAry.count==0) {
        sousuoTitleAry  = [result valueForKey:nsUesrStr];
    }else {
       sousuoTitleAry=[self addquanbu:tihuanAry :@"清空历史记录"];
    }
    [self inittableview];
 }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
