//
//  搜索列表 SearchListController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/16.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SearchListController.h"
#import "PullingRefreshTableView.h"
#import "GoViewController.h"
#import "KDSearchBar.h"
#import "ReTableView.h"
@interface SearchListController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)KDSearchBar         *homeTextF;
@property (strong,nonatomic)NSMutableArray      *pushAry;//获取的所有数据

@end

@implementation SearchListController
{
    BOOL        isSearch;
    NSInteger   _page;
    NSMutableArray      *dataAry;
    NSString    *jiluStr;
    NSString    *sousuoStr;
    BOOL        isend;
    int         twoTime;
    NSTimer     *relodeTime;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


-(void)initnvc
{
    self.homeTextF=[[KDSearchBar alloc]initWithFrame:CGRectMake(40, 6 + STATUS_BAR_HEIGHT , WIN_WIDTH-65, 32)];
    self.homeTextF.newFrame = self.homeTextF.bounds;
    self.homeTextF.placeholder=@"输入门店名、品牌名";
    self.homeTextF.delegate=self;
    self.homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    self.homeTextF.returnKeyType=UIReturnKeySearch;
    [self.navigationBar addSubview:self.homeTextF];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushAry=[[NSMutableArray alloc]init];
     jiluStr=[NSString stringWithFormat:@"%@%@",@"julu",_typeStr];
    isend=NO;
    isSearch=NO;
    relodeTime= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [relodeTime setFireDate:[NSDate distantFuture]];
    dataAry=[[NSMutableArray alloc]init];
    [self initlieshi];
    [self initnvc];
   [self.homeTextF becomeFirstResponder];//弹出键盘
}
//搜索记录
-(void)initlieshi
{
    NSUserDefaults * result    =[NSUserDefaults standardUserDefaults];
    NSMutableArray * tihuanAry =[result valueForKey:jiluStr];
    if ([Util isNull:tihuanAry]) {
        dataAry  = [result valueForKey:jiluStr];
    }else {
        dataAry=[self addquanbu:tihuanAry :@"清空历史记录"];
    }
    [self inittableView];
}

//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   
    [self.homeTextF resignFirstResponder];
}
//搜索内容改变的时候，在这个方法里面实现实时显示结果
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    twoTime=2;
    [relodeTime setFireDate:[NSDate distantPast]];
}
-(void)timeFireMethod
{
    twoTime--;
    if (twoTime==0) {
        NSUserDefaults  *result=[NSUserDefaults standardUserDefaults];
        NSString        *textF=self.homeTextF.text;
        NSMutableArray  *resulrAry1=[[NSMutableArray alloc]init];
        NSMutableArray  *resulrAry2=[[NSMutableArray alloc]init];
        resulrAry1=[[result valueForKey:jiluStr]mutableCopy];
        if (![textF isEqualToString:@""]) {
            if([self initpandan:resulrAry1 text:textF]==NO){
                resulrAry2=[[self addquanbu:resulrAry1 :textF] mutableCopy];
                [result setValue:resulrAry2 forKey:jiluStr];
            }
        }
        isSearch=YES;
        sousuoStr=self.homeTextF.text;
        [self NetWorkRequest :nil];
        [relodeTime setFireDate:[NSDate distantFuture]];
    }
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

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type
{
    
    if (isSearch==NO) {
        [SVProgressHUD dismiss];
        [self.tableView1 tableViewDidFinishedLoading];
        return;
    }
        int zz=[[Global sharedClient].markID intValue];
        NSString *path;
        NSDictionary*diction;
    
        if(type == nil || [type isEqualToString:REFRESH_METHOD]){
            _page = 1;
            isend=NO;
        }else{
            if (isend==YES) {
                [SVProgressHUD dismiss];
                [self.tableView1 tableViewDidFinishedLoading];
                [self.tableView1 noticeNoMoreData];
                return;
            }else {
                _page++;
            }
        }
        if ([Util isNull:sousuoStr] || sousuoStr.length==0) {
            sousuoStr=@"";
            [dataAry removeAllObjects];
            [_pushAry removeAllObjects];
            [self initlieshi];
            [self.tableView1 reloadData];
            return;
        }
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
        if ([_typeStr isEqualToString:@"0"]) {
            
            path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadfoodlist"];
            diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@"0",@"Floor",@(0),@"Type",@(1),@"sort",@(_page),@"Page",@"10",@"pageSize",sousuoStr,@"Key", nil];
            
        }else if([_typeStr isEqualToString:@"1"]){
            
            path=[Util makeRequestUrl:@"mallshoplist" tp:@"shopactivitylist"];
             diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(0),@"Floor",@(0),@"Type",@(1),@"Page",@"10",@"pageSize",sousuoStr,@"Key", nil];
            
        }else if([_typeStr isEqualToString:@"2"]){
            
            path=[Util makeRequestUrl:@"mallshoplist" tp:@"mallactivitylist"];
            diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(0),@"Floor",@(0),@"Type",@(1),@"Page",@"10",@"pageSize",sousuoStr,@"Key", nil];
            
        }else if([_typeStr isEqualToString:@"3"]){
            
            path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadshoplist"];
            diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(0),@"Floor",@(0),@"Type",@(0),@"sort",@(1),@"Page",@"10",@"pageSize",sousuoStr,@"Key", nil];
            
        }
        [HttpClient requestWithMethod:@"POST" path:path parameters:diction  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                if([dic[@"data"] isKindOfClass:[NSDictionary class]])
                {
                    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                        [dataAry removeAllObjects];
                        [_pushAry removeAllObjects];
                    }
                    NSArray  *array;
                    if ([_typeStr isEqualToString:@"0"]) {
                           array=dic[@"data"][@"foodlist"];
                        for (NSDictionary *dict in array) {
                            NSString *nameSt=[Util isNil:dict[@"shop_name"]];
                            NSString *link_url=[Util isNil:dict[@"link_url"]];
                            [dataAry addObject:nameSt];
                            [_pushAry addObject:link_url];
                        }

                    }else if([_typeStr isEqualToString:@"1"]){
                           array=dic[@"data"][@"shopactivitylist"];
                        for (NSDictionary *dict in array) {
                            NSString *nameSt=[Util isNil:dict[@"title"]];
                            NSString *link_url=[Util isNil:dict[@"act_detail"]];
                            [dataAry addObject:nameSt];
                            [_pushAry addObject:link_url];
                        }
  
                    }else if([_typeStr isEqualToString:@"2"]){
                            array=dic[@"data"][@"mallactivitylist"];
                        for (NSDictionary *dict in array) {
                            NSString *nameSt=[Util isNil:dict[@"name"]];
                            NSString *link_url=[Util isNil:dict[@"act_detail"]];
                            [dataAry addObject:nameSt];
                            [_pushAry addObject:link_url];
                        }
                    }else if([_typeStr isEqualToString:@"3"]){
                            array=dic[@"data"][@"shoplist"];
                        for (NSDictionary *dict in array) {
                            NSString *nameSt=[Util isNil:dict[@"shop_name"]];
                            NSString *link_url=[Util isNil:dict[@"shopdetail_url"]];
                            [dataAry addObject:nameSt];
                            [_pushAry addObject:link_url];
                        }
                    }
                    isend=[dic[@"data"][@"isEnd"]boolValue];
                    if ([Util isNull:dataAry] || dataAry.count==0) {
                        [SVProgressHUD showErrorWithStatus:@"未找到您搜索的内容"];
                    }
                    [self.tableView1 reloadData];
                }
                [self.tableView1 tableViewDidFinishedLoading];
                [SVProgressHUD dismiss];
            });
        }failue:^(NSDictionary *dic){
            
        }];
}

-(void)inittableView
{
    self.tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    self.tableView1.dataSource=self;
    self.tableView1.delegate  =self;
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView1.scrollEnabled=YES;
    self.tableView1.refreshTVDelegate=self;
    [self.view addSubview:self.tableView1];
}

- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    [self.homeTextF resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return M_WIDTH(42);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellID3";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    UIView *deleView=[cell viewWithTag:1000];
    [deleView removeFromSuperview];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 13, 280, 17)];
    nameLab.text=dataAry[indexPath.row];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=COMMON_FONT;
    nameLab.tag=1000;
    
    UIView  *lineVIew=[[UIView alloc]initWithFrame:CGRectMake(14, 41, WIN_WIDTH-14, 1)];
    lineVIew.backgroundColor=COLOR_LINE;
    
    [cell addSubview:nameLab];
    [cell addSubview:lineVIew];
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearch==NO) {
        if (indexPath.row==0) {
            [dataAry removeAllObjects];
            NSUserDefaults  *result=[NSUserDefaults standardUserDefaults];
            [result setValue:dataAry forKey:jiluStr];
            [self.tableView1 reloadData];
        }else {
            sousuoStr=dataAry[indexPath.row];
            self.homeTextF.text=dataAry[indexPath.row];
            isSearch=YES;
            [dataAry removeAllObjects];
            [self NetWorkRequest:nil];
        }
    }else {
        
        GoViewController *gVC=[[GoViewController alloc]init];
        gVC.path=_pushAry[indexPath.row];
        [self.delegate.navigationController pushViewController:gVC animated:YES];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
