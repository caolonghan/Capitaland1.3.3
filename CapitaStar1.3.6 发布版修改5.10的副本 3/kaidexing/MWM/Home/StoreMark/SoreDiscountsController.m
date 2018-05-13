//
//  SoreDiscountsController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/20.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SoreDiscountsController.h"

@interface SoreDiscountsController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong,nonatomic)UITableView             *tableView1;
@property (strong,nonatomic)UIScrollView            *scrollView1;
@property (strong,nonatomic)NSMutableArray          *iconAry;//保存图标的数组

@end

//--------------------------公告促销---------------------------

@implementation SoreDiscountsController
{
    CGFloat  view_H;
    NSMutableArray  *titleAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"商场活动详情";
    view_H=0;
    self.iconAry=[[NSMutableArray alloc]initWithObjects:@"collect",@"time",@"phone",@"loc", nil];//未收藏
    
    titleAry    =[[NSMutableArray alloc]initWithObjects:@"我要收藏",@"无限期",@"0411-846465456",@"驾驶的骄傲了手机打卡机的", nil];
    self.scrollView1=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.5);
    [self.view addSubview:self.scrollView1];
    [self initview];
    
}

-(void)initview
{
    UIImageView  *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, 150)];
    [logoImg setUserInteractionEnabled:YES];
    logoImg.backgroundColor=[UIColor redColor];
    logoImg.contentMode=UIViewContentModeScaleAspectFill;
    
    
    UIView  *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImg.frame)-24, WIN_WIDTH,24)];
    colorView.backgroundColor=[UIColor blackColor];
    colorView.alpha=0.8;
    
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(6, 5, WIN_WIDTH-30, 15)];
    nameLab.textColor=[UIColor whiteColor];
    nameLab.text=@"测试";
    nameLab.font=DESC_FONT;
    nameLab.textAlignment=NSTextAlignmentLeft;
    
    
    [colorView addSubview:nameLab];
    [self.scrollView1 addSubview:logoImg];
    [self.scrollView1 addSubview:colorView];
    view_H=NAV_HEIGHT+178;
    [self initTableView];
    [self inithuodongView];
}

-(void)initTableView
{
    self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH,164) style:UITableViewStylePlain];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.tableView1.backgroundColor=[UIColor whiteColor];
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView1.scrollEnabled=NO;
    [self.scrollView1 addSubview:self.tableView1];
}
//活动详情
-(void)inithuodongView
{
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView1.frame), WIN_WIDTH, 38)];
    colorView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(6, 13, 150, 13)];
    titlelab.font=DESC_FONT;
    titlelab.text=@"活动详情";
    titlelab.textAlignment=NSTextAlignmentLeft;
    
    [colorView addSubview:titlelab];
    [self.scrollView1 addSubview:colorView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UIImageView   *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(8, 12.5, 16,16)];
    iconImg.contentMode=UIViewContentModeScaleAspectFit;
    [iconImg setImage:[UIImage imageNamed:_iconAry[indexPath.row]]];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(35,12.5, 260, 15)];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=DESC_FONT;
    lab.text=titleAry[indexPath.row];
    
    if (indexPath.row==2  || indexPath.row==3) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        lab.textColor=COLOR_FONT_SECOND;
    }

    
    [cell addSubview:iconImg];
    [cell addSubview:lab];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row) {
        [self.iconAry removeAllObjects];
        NSMutableArray  *iAry=[[NSMutableArray alloc]initWithObjects:@"collected",@"time",@"phone",@"loc_sore", nil];//已收藏
        self.iconAry=[iAry mutableCopy];
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
