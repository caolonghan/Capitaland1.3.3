//
//  SinceController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SinceController.h"

@interface SinceController ()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView     *scrollView1;
@end

@implementation SinceController
{
    UIView *headView;
    UIView *addressView;
    UIView *mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"商场自提";
    self.view.backgroundColor=UIColorFromRGB(0xf4f4f4);
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.2);
    [self.view addSubview:self.scrollView1];
    [self initheadView];
}

-(void)initheadView
{
    headView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(11), WIN_WIDTH,M_WIDTH(240))];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(14.5),M_WIDTH(14.5),M_WIDTH(13))];
    [iconImg setImage:[UIImage imageNamed:@"house"]];
    [headView addSubview:iconImg];
    
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(31), 0, M_WIDTH(280), M_WIDTH(41))];
    shopName.textAlignment=NSTextAlignmentLeft;
    shopName.font=COMMON_FONT;
    shopName.text=@"上海来福士";
    [headView addSubview:shopName];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(41), WIN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_LINE;
    [headView addSubview:lineView];
    
    UILabel *maLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+M_WIDTH(8), WIN_WIDTH, M_WIDTH(50))];
    maLab.textAlignment=NSTextAlignmentCenter;
    maLab.font=COOL_FONT;
    maLab.textColor=[UIColor redColor];
    maLab.text=@"销核码： 7552 78962 6541";
    [headView addSubview:maLab];
    
    UIView *layerview=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(56.5), CGRectGetMaxY(maLab.frame),M_WIDTH(113), M_WIDTH(113))];
    layerview.backgroundColor=[UIColor whiteColor];
    layerview.layer.masksToBounds=YES;
    layerview.layer.cornerRadius=5;
    layerview.layer.borderColor=[COLOR_LINE CGColor];
    layerview.layer.borderWidth=1;
    [headView addSubview:layerview];
    
    UIImageView     *twoImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(4), M_WIDTH(4),layerview.frame.size.height-M_WIDTH(8),layerview.frame.size.height-M_WIDTH(8))];
    [twoImg setImage:[UIImage imageNamed:@""]];
    twoImg.backgroundColor=[UIColor redColor];
    [layerview addSubview:twoImg];
    
    [self.scrollView1 addSubview:headView];
    [self initaddressView];
}

-(void)initaddressView
{
    addressView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+M_WIDTH(11), WIN_WIDTH, M_WIDTH(155))];
    addressView.backgroundColor=[UIColor whiteColor];
    
    UILabel *addressName=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), 0, M_WIDTH(280), M_WIDTH(41))];
    addressName.textAlignment=NSTextAlignmentLeft;
    addressName.font=COMMON_FONT;
    addressName.text=@"商场地址";
    [addressView addSubview:addressName];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(41), WIN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_LINE;
    [addressView addSubview:lineView];
    
    CGFloat lab_Left=M_WIDTH(10);
    CGFloat lab_W   =WIN_WIDTH-M_WIDTH(20);
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(lab_Left,CGRectGetMaxY(lineView.frame)+ M_WIDTH(8), lab_W, M_WIDTH(32))];
    [self initred_layerLab:nameLab];
    nameLab.text=@"凯德虹口龙之梦";
    [addressView addSubview:nameLab];
    
    UILabel  *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(lab_Left, CGRectGetMaxY(nameLab.frame), lab_W, M_WIDTH(19))];
    addressLab.text=@"地址： 上海虹口区西江碗路388号";
    [self initred_layerLab:addressLab];
    [addressView addSubview:addressLab];
    
    UILabel  *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(lab_Left, CGRectGetMaxY(addressLab.frame), lab_W, M_WIDTH(19))];
    phoneLab.text=@"电话： 021-2356355545";
    [self initred_layerLab:phoneLab];
    [addressView addSubview:phoneLab];
    [self.scrollView1 addSubview:addressView];
    [self initmapView];
}

-(void)initmapView
{
    mapView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(addressView.frame)+M_WIDTH(11), WIN_WIDTH, M_WIDTH(282)+1)];
    mapView.backgroundColor=[UIColor whiteColor];
    
    UILabel *mapLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), 0, M_WIDTH(280), M_WIDTH(41))];
    mapLab.textAlignment=NSTextAlignmentLeft;
    mapLab.font=COMMON_FONT;
    mapLab.text=@"商场地址";
    [mapView addSubview:mapLab];
    //右边箭头
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(18), M_WIDTH(14.5), M_WIDTH(7), M_WIDTH(12))];
    iconImg.backgroundColor=[UIColor blackColor];
    [mapView addSubview:iconImg];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(41), WIN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_LINE;
    [mapView addSubview:lineView];
    
    UIView *baiduMapView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), WIN_WIDTH, M_WIDTH(241))];
    baiduMapView.backgroundColor=[UIColor redColor];
    [mapView addSubview:baiduMapView];
    
    [self.scrollView1 addSubview:mapView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
//商场地址字体
-(void)initred_layerLab:(UILabel*)lab
{
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=COLOR_FONT_SECOND;
    lab.font=INFO_FONT;
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
