//
//  SearchController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SearchController.h"
#import "StoreDetailsController.h"

@interface SearchController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITextField     *homeTextF;
@property (strong,nonatomic)UITableView     *tableView_2;
@end


//--------------------------城市内搜索商店------------------------

@implementation SearchController
{
    UIView          *nvcView1;//加载在导航栏上的view
    NSMutableArray  *cell_nameAry;
    NSMutableArray  *cell_idAry;
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.delegate.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];//导航栏字体颜色
    [self.delegate.navigationController setNavigationBarHidden:NO];
    [self.delegate.navigationController.navigationItem setHidesBackButton:YES];
    [self.delegate.navigationItem setHidesBackButton:YES];
    [self.delegate.navigationController.navigationBar.backItem setHidesBackButton:YES];
    
    [self initnvc];
    
}

-(void)initnvc
{
    nvcView1=[[UIView alloc]initWithFrame:CGRectMake(60, 7, 210, 32)];
    
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 210, 32)];
    
    colorView.layer.masksToBounds=YES;
    colorView.layer.cornerRadius=5;
    //搜索框里的放大镜
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10,8,14, 14)];
    [imgView setImage:[UIImage imageNamed:@"search_Icon"]];
    [colorView addSubview:imgView];
    
    self.homeTextF=[[UITextField alloc]initWithFrame:CGRectMake(29,2,WIN_WIDTH-110, 32)];
    self.homeTextF.placeholder=@"请输入要搜索的商城名";
     self.homeTextF.delegate=self;
    self.homeTextF.font=DESC_FONT;
    [colorView addSubview:imgView];
    [colorView addSubview:self.homeTextF];
    
    [nvcView1 addSubview:colorView];
    [self.delegate.navigationController.navigationBar addSubview:nvcView1];
    [self initTableview];
    
}
#pragma mark ---请求网络---
-(void)NetWorkRequest
{
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
     NSUserDefaults *userCity=[NSUserDefaults standardUserDefaults];
     NSString *strid=[userCity objectForKey:@"city"];
    
    if ([Util isNull:strid]) {
        strid=@"1";
    }
    NSString *memberID=[Global sharedClient].member_id;
    if ([Util isNull:memberID]) {
        memberID=@"";
    }
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadmalllist"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:strid,@"city",memberID,@"member_id",@"10",@"pageSize",@(1),@"Page",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            

            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
    }];
    
    
}


-(void)initTableview
{
    
    self.tableView_2=[[UITableView alloc]initWithFrame:CGRectMake(0,64, WIN_WIDTH, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tableView_2.delegate=self;
    self.tableView_2.dataSource=self;
    self.tableView_2.scrollEnabled=YES;
    self.tableView_2.separatorStyle=UITableViewCellSeparatorStyleNone;
    

    [self.view addSubview:self.tableView_2];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cell_nameAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(14, 11, 240,20)];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.text=cell_nameAry[indexPath.row];
    lab.font=COMMON_FONT;
    
    UILabel *juliLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-67, 15, 53, 12)];
    juliLab.textAlignment=NSTextAlignmentRight;
    juliLab.textColor=COLOR_FONT_SECOND;
    juliLab.font=DESC_FONT;
    juliLab.text=@"13.2公里";

    [cell addSubview:lab];
    [cell addSubview:juliLab];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    StoreDetailsController *sVC=[[StoreDetailsController alloc]init];
    
    
    
    [self.delegate.navigationController pushViewController:sVC animated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.nameArray=[[NSMutableArray alloc]init];
//    self.idArray  =[[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [nvcView1 removeFromSuperview];
    
}

-(void)textFieldDidChange:(id)sender
{
    

    
    
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
