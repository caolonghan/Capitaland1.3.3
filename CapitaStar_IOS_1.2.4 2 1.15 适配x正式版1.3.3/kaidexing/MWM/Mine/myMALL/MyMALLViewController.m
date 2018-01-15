//
//  MyMALLViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/28.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyMALLViewController.h"
#import "AddMyMallViewController.h"
@interface MyMALLViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyMALLViewController{
    UIView *nilView1;
    UITableView *tableView1;
    NSMutableArray *dataAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"我的MALL";
    self.view.backgroundColor=[UIColor whiteColor];
    dataAry=[[NSMutableArray alloc]init];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self NetWorkRequest:0];
}
-(void)createTableView{
    tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView1.scrollEnabled=YES;
    [self.view addSubview:tableView1];
}

-(void)NetWorkRequest:(int)type{
    if (type==0) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    [nilView1 removeFromSuperview];
    
    NSString *cityStr;
    NSUserDefaults *userCity=[NSUserDefaults standardUserDefaults];
    if ([userCity valueForKey:@"city"]==nil) {
        cityStr=@"1";
    }else{
        cityStr=[userCity valueForKey:@"city"];
        
    }
    NSDictionary  *dicton=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"city",[Global sharedClient].member_id,@"member_id",@"100",@"pageSize",@"1",@"Page",nil ];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadmalllist"] parameters:dicton  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dataAry=dic[@"data"][@"fouce_malllist"];
            [tableView1 reloadData];
            [SVProgressHUD dismiss];
            if (dataAry.count==0) {
                [self initnilView];
            }
        });
    }failue:^(NSDictionary *dic){
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataAry.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat row_H;
    if (indexPath.row<dataAry.count) {
        row_H=M_WIDTH(47);
    }else{
        row_H=M_WIDTH(62);
    }
    return row_H;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier=@"cell1";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [UIUtil removeSubView:cell];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.row<dataAry.count) {
        UIView *view=[self createCellView:indexPath];
        [cell addSubview:view];
        return cell;
    }else{
        
        UIView *view=[self createButtomView];
        [cell addSubview:view];
        return cell;
    }
    
    return nil;
}

-(UIView*)createCellView:(NSIndexPath*)index{
    NSDictionary *dic=dataAry[index.row];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(47))];
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(13),M_WIDTH(18),M_WIDTH(17),M_WIDTH(14))];
    [iconImg setImage:[UIImage imageNamed:@"myMallhouse"]];
    iconImg.contentMode=UIViewContentModeScaleAspectFit;
    [view addSubview:iconImg];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(6),M_WIDTH(3),M_WIDTH(180),M_WIDTH(44))];
    titleLab.text=[Util isNil:dic[@"mall_name"]];
    titleLab.font=DESC_FONT;
    titleLab.textAlignment=NSTextAlignmentLeft;
    [view addSubview:titleLab];

    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(81),M_WIDTH(13),M_WIDTH(68),M_WIDTH(21))];
    cancelBtn.backgroundColor=UIColorFromRGB(0x959595);
    [cancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=DESC_FONT;
    cancelBtn.tag=index.row;
    cancelBtn.layer.masksToBounds=YES;
    cancelBtn.layer.cornerRadius=cancelBtn.frame.size.height/2;
    [cancelBtn addTarget:self action:@selector(cellTouch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    UIView *lineView=[[UIView  alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view.frame)-1,WIN_WIDTH,1)];
    lineView.backgroundColor=COLOR_FONT_SECOND;
    [view addSubview:lineView];

    return view;
}

-(UIView*)createButtomView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(62))];
    UIButton *okBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(9),M_WIDTH(22),WIN_WIDTH-M_WIDTH(18),M_WIDTH(40))];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"关注更多" forState:UIControlStateNormal];
    okBtn.backgroundColor=UIColorFromRGB(0xf15152);
    okBtn.layer.masksToBounds=YES;
    okBtn.layer.cornerRadius=3;
    [okBtn addTarget:self action:@selector(okTouch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:okBtn];
    return view;
}

-(void)cellTouch:(UIButton*)sender{
    NSDictionary *dic=dataAry[sender.tag];
    int markID=[[Util isNil:dic[@"mall_id"]]intValue];
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSDictionary *dicton=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id ,@"member_id",@(markID),@"coll_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"collection" tp:@"cancelattention"] parameters:dicton  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            [self performSelectorOnMainThread:@selector(yanchiLoadData) withObject:nil waitUntilDone:2.0];
            
        });
    }failue:^(NSDictionary *dic){
    }];
}

-(void)yanchiLoadData{
    [self NetWorkRequest:1];
}

-(void)okTouch:(UIButton*)sender{
    AddMyMallViewController *vc=[[AddMyMallViewController alloc]init];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//没有数据的时候显示的View
-(void)initnilView{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+M_WIDTH(62), WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(62))];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(180), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
