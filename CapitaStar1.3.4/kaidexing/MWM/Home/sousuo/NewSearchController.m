//
//  NewSearchController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "NewSearchController.h"
#import "KDSearchBar.h"
#import "GoViewController.h"
#import "StoreDetailsViewC.h"

@interface NewSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView *tableView1;
@end

@implementation NewSearchController{
    KDSearchBar  *homeTextF;
    NSMutableArray      *dataAry;
    int           twoTime;
    NSTimer      *relodeTime;
    NSString     *searchStr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftBarItemView.hidden=YES;
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    dataAry = [[NSMutableArray alloc]init];
    searchStr=@"";
    relodeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [self createNavView];
    [self createtableView];
}
-(void)createNavView{
    
    UIView *headRootView = [[UIView alloc]initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT, WIN_WIDTH,44)];
    headRootView.backgroundColor=[UIColor whiteColor];
    
    UIButton* backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [backButton setImage:[UIImage imageNamed:@"heiblack36"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popTouch:) forControlEvents:UIControlEventTouchUpInside];
    [headRootView addSubview:backButton];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backButton.frame),7,WIN_WIDTH-60,28)];
    homeTextF=[[KDSearchBar alloc]initWithFrame:headView.bounds];
    homeTextF.newFrame = homeTextF.frame;
    homeTextF.placeholder=@"请输入商户名";
    homeTextF.delegate=self;
    homeTextF.searchBarStyle=UISearchBarStyleMinimal;
    homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    homeTextF.returnKeyType=UIReturnKeySearch;
    homeTextF.tintColor = [UIColor whiteColor];
    [headView addSubview:homeTextF];
    [headRootView addSubview:headView];
    
    UIView *topLineView =[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(43)-1,WIN_WIDTH,1)];
    topLineView.backgroundColor = COLOR_LINE;
    [headRootView addSubview:topLineView];
    
    [self.navigationBar addSubview:headRootView];
}
-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

-(void)createtableView{
    self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    self.tableView1.dataSource=self;
    self.tableView1.delegate  =self;
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView1.scrollEnabled=YES;
    [self.view addSubview:self.tableView1];
}


#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{
    type = [type stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([type isEqualToString:@""]) {
        [dataAry removeAllObjects];
        [self.tableView1 reloadData];
        return;
    }
    
    NSDictionary*diction = [[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"page",@"20",@"pageSize",@"0",@"type",@"0",@"city",type,@"key", nil];
    [SVProgressHUD showWithStatus:@"正在努力加载中"];

    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"nomallloadshop"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [dataAry removeAllObjects];
            [dataAry addObjectsFromArray:dic[@"data"][@"shoplist"]];
            [self.tableView1 reloadData];

            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}

//搜索内容改变的时候，在这个方法里面实现实时显示结果
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    twoTime=2;
    searchStr=searchText;
    [relodeTime setFireDate:[NSDate distantPast]];
}

-(void)timeFireMethod{
    twoTime--;
    if (twoTime==0) {
        [self NetWorkRequest:searchStr];
        [relodeTime setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    [homeTextF resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
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
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 0, 280, 42)];
    nameLab.text=dataAry[indexPath.row][@"shop_name"];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=DESC_FONT;
    nameLab.tag=1000;
    
    UIView  *lineVIew=[[UIView alloc]initWithFrame:CGRectMake(14, 41, WIN_WIDTH-14, 1)];
    lineVIew.backgroundColor=COLOR_LINE;
    
    [cell addSubview:nameLab];
    [cell addSubview:lineVIew];
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = [dataAry objectAtIndex:indexPath.row];
    [homeTextF resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreDetailsViewC *vc = [[StoreDetailsViewC alloc]init];
    vc.shopId = dic[@"shop_id"];
    vc.headTitle = dic[@"shop_name"];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [homeTextF resignFirstResponder];
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
