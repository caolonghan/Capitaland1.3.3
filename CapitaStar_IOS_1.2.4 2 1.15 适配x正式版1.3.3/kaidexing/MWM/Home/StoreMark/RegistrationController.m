//
//  RegistrationController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/21.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "RegistrationController.h"

@interface RegistrationController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)UIScrollView            *scrollView1;
@property (strong,nonatomic)UIImageView             *shoucangImg;//表示收藏的小图标
@property (strong,nonatomic)UILabel                 *shoucangLab;//表示收藏的文字
@property (strong,nonatomic)UIButton                *baomingBtn; //表示报名的btn
@property (strong,nonatomic)UITableView             *tableView1;

@end


//---------------------------------我要报名---------------------------------

@implementation RegistrationController
{
    CGFloat   view_H;
    NSArray   *titleAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"商场活动详情";
    view_H=0;
    titleAry=[[NSArray alloc]initWithObjects:@"活动详情",@"报名需要扣除1个积分哦",@"查看图文详情",@"使用商场",@"asdasd", nil];
    self.scrollView1=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.1);
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
    
    //活动名字
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(6, 5,240, 15)];
    nameLab.textColor=[UIColor whiteColor];
    nameLab.text=@"测试";
    nameLab.font=DESC_FONT;
    nameLab.textAlignment=NSTextAlignmentLeft;
    
    //活动人数
    UILabel  *numLab=[[UILabel alloc]initWithFrame:CGRectMake(6,6,240, 15)];
    numLab.textColor=[UIColor whiteColor];
    numLab.text=@"已报名12300";
    numLab.font=INFO_FONT;
    numLab.textAlignment=NSTextAlignmentLeft;
    CGRect rect1=[numLab.text boundingRectWithSize:CGSizeMake(108,11) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:numLab.font} context:nil];
    numLab.frame=CGRectMake(WIN_WIDTH-rect1.size.width-10,numLab.frame.origin.y, rect1.size.width, rect1.size.height);
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-numLab.frame.size.width-21,8, 9, 9)];
    [iconImg setImage:[UIImage imageNamed:@"ok"]];
    
    
    [colorView addSubview:nameLab];
    [colorView addSubview:numLab];
    [colorView addSubview:iconImg];
    
    [self.scrollView1 addSubview:logoImg];
    [self.scrollView1 addSubview:colorView];
    view_H=view_H+150+NAV_HEIGHT;
    [self initView2];
}
//图片下面的视图
-(void)initView2
{
    //介绍lab
    UILabel  *jieshaoLab=[[UILabel alloc]initWithFrame:CGRectMake(6, view_H+13, WIN_WIDTH/2, 13)];
    jieshaoLab.text=@"报名需要扣除1个积分哦";
    jieshaoLab.textAlignment=NSTextAlignmentLeft;
    jieshaoLab.font=DESC_FONT;
    [self.scrollView1 addSubview:jieshaoLab];
    if (/* DISABLES CODE */ (1)>2) {
        //期限lab
        UILabel *qixianLab=[[UILabel alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(jieshaoLab.frame)+8, WIN_WIDTH/2, 12)];
        qixianLab.text=@"无期限";
        qixianLab.textColor=COLOR_FONT_SECOND;
        qixianLab.font=INFO_FONT;
        qixianLab.textAlignment=NSTextAlignmentLeft;
        [self.scrollView1 addSubview:qixianLab];
        
        //多少人感兴趣
        UILabel  *xingquLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-150, CGRectGetMaxY(jieshaoLab.frame)+8, 140, 12)];
        xingquLab.text=@"157人感兴趣";
        xingquLab.textColor=COLOR_FONT_SECOND;
        xingquLab.font=INFO_FONT;
        xingquLab.textAlignment=NSTextAlignmentRight;
        [self.scrollView1 addSubview:xingquLab];
        view_H=view_H+52;
        
    }else {
        //免费
        UILabel *mianfeiLab=[[UILabel alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(jieshaoLab.frame)+9, 50, 26)];
        mianfeiLab.text=@"免费";
        mianfeiLab.textAlignment=NSTextAlignmentLeft;
        mianfeiLab.font=[UIFont systemFontOfSize:22];
        mianfeiLab.textColor=[UIColor redColor];
        [self.scrollView1 addSubview:mianfeiLab];
        
        //原价
        UILabel *yuanjiaLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mianfeiLab.frame),CGRectGetMaxY(jieshaoLab.frame)+20, 100, 10)];
        yuanjiaLab.textColor=COLOR_FONT_SECOND;
        NSString *yuanjiaStr=[NSString stringWithFormat:@"%@%@",@"￥",@"123456"];
        yuanjiaLab.text=yuanjiaStr;
        yuanjiaLab.textAlignment=NSTextAlignmentLeft;
        yuanjiaLab.font=DESC_FONT;
        CGRect rect1=[yuanjiaLab.text boundingRectWithSize:CGSizeMake(100,11) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:yuanjiaLab.font} context:nil];
        yuanjiaLab.frame=CGRectMake(yuanjiaLab.frame.origin.x, yuanjiaLab.frame.origin.y, rect1.size.width, rect1.size.height);
        
        //在加个上面画一条横线
        UIView *x_view=[[UIView alloc]initWithFrame:CGRectMake(1,7, yuanjiaLab.frame.size.width-1, 0.5)];
        x_view.backgroundColor=COLOR_FONT_SECOND;
        [yuanjiaLab addSubview:x_view];
        
        [self.scrollView1 addSubview:yuanjiaLab];
        view_H=view_H+66;
    }
    
    
    
    //我要收藏上面第一条线
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 0.5)];
    lineView1.backgroundColor=COLOR_LINE;
    [self.scrollView1 addSubview:lineView1];
    
    //表示收藏的图片
    self.shoucangImg=[[UIImageView alloc]initWithFrame:CGRectMake(50,CGRectGetMaxY(lineView1.frame)+7, 14, 14)];
    [self.shoucangImg setImage:[UIImage imageNamed:@"collect"]];
    [self.scrollView1 addSubview:self.shoucangImg];
    
    self.shoucangLab=[[UILabel alloc]initWithFrame:CGRectMake(71,CGRectGetMaxY(lineView1.frame)+7, 55, 14)];
    self.shoucangLab.text=@"我要收藏";
    self.shoucangLab.textAlignment=NSTextAlignmentLeft;
    self.shoucangLab.font=DESC_FONT;
    [self.scrollView1 addSubview:self.shoucangLab];
    
    UIButton *shoucangBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView1.frame), WIN_WIDTH/2, 27)];
    [shoucangBtn addTarget:self action:@selector(shoucangTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:shoucangBtn];
    
    //我要报名
    self.baomingBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2,CGRectGetMaxY(lineView1.frame), WIN_WIDTH/2, 27)];
    [self.baomingBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    [self.baomingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.baomingBtn.backgroundColor=[UIColor redColor];
    self.baomingBtn.titleLabel.font=DESC_FONT;
    [self.scrollView1 addSubview:self.baomingBtn];
    
    view_H=view_H+27;
    [self inittableView];
    [self initlingjuanView];
}

-(void)inittableView
{
    self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 185) style:UITableViewStylePlain];
    self.tableView1.dataSource=self;
    self.tableView1.delegate=self;
    self.tableView1.backgroundColor=[UIColor whiteColor];
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView1.scrollEnabled=NO;
    [self.scrollView1 addSubview:self.tableView1];
    view_H=view_H+185;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 37;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if(indexPath.row==0 || indexPath.row==3){
        cell.backgroundColor=UIColorFromRGB(0xf0f0f0);
    }else {
        cell.backgroundColor=[UIColor whiteColor];
    }
    
    if (indexPath.row==2) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row==1 || indexPath.row>3){
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 36.5, WIN_WIDTH, 0.5)];
        lineView.backgroundColor=COLOR_LINE;
        [cell addSubview:lineView];
    }
    
    if (indexPath.row==4) {
        UIView *y_view=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH-46, 2, 0.5, 35)];
        y_view.backgroundColor=COLOR_LINE;
        [cell addSubview:y_view];
        UIImageView *phoneImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-31, 10, 18, 18)];
        phoneImg.contentMode=UIViewContentModeScaleAspectFit;
        [phoneImg setImage:[UIImage imageNamed:@"r_phone"]];
        [cell addSubview:phoneImg];
    }
    
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(6,11, 260,14)];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=DESC_FONT;
    lab.text=titleAry[indexPath.row];
    
    [cell addSubview:lab];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row ==0  || indexPath.row==1 || indexPath.row==3 ) {
        
    }else if(indexPath.row==2){
        NSLog(@"点击了图文详情");
        
    }else{
        NSLog(@"点击了商场的电话");
    }
    
    
    
}

//领卷的使用通知
-(void)initlingjuanView
{
    UIView *colorView1=[[UIView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 37)];
    colorView1.backgroundColor=UIColorFromRGB(0xf0f0f0);
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(6,11, 260,14)];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.font=DESC_FONT;
    lab.text=@"使用须知";
    [colorView1 addSubview:lab];
    [self.scrollView1 addSubview:colorView1];
    
    //有效期文字
    UILabel *youxiaoLab=[[UILabel alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(colorView1.frame)+12, WIN_WIDTH/2, 13)];
    youxiaoLab.font=DESC_FONT;
    youxiaoLab.textColor=[UIColor redColor];
    youxiaoLab.textAlignment=NSTextAlignmentLeft;
    youxiaoLab.text=@"有效期";
    [self.scrollView1 addSubview:youxiaoLab];
    //有效期日期
    UILabel *riqiLab=[[UILabel alloc]initWithFrame:CGRectMake(6, CGRectGetMaxY(youxiaoLab.frame)+4, WIN_WIDTH-20, 13)];
    riqiLab.font=DESC_FONT;
    riqiLab.textColor=[UIColor blackColor];
    riqiLab.textAlignment=NSTextAlignmentLeft;
    riqiLab.text=@"2015年05月4号-2020年6月9号";
    [self.scrollView1 addSubview:riqiLab];
    
}


//点击了我要收藏
-(void)shoucangTouch
{
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
