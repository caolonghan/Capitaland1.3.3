//
//  NoLineUpController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "NoLineUpController.h"

@interface NoLineUpController ()

@property (strong,nonatomic)UIView  *rootView;
@end

@implementation NoLineUpController
{
    NSDictionary *dataDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataDic=[[NSDictionary alloc]init];
    self.navigationBarTitleLabel.text=@"我要排号";
   
    [self loadwork];
}

-(void)loadwork
{
    int dataID=[_dataStr intValue];
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(dataID),@"serialId",[Global sharedClient].phone,@"phone_num",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"quenenumberdetail"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            dataDic=dic[@"data"];
             [self initheadView_2];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
    
}

-(void)initheadView_2
{
    self.rootView=[[UIView alloc]init];
    self.view.backgroundColor=[UIColor whiteColor];
    _rootView.frame=CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT);
    
    //带边框的view
    UIView  *layerView=[[UIView alloc]initWithFrame:CGRectMake(8,21, WIN_WIDTH-16, 88)];
    layerView.layer.masksToBounds=YES;
    layerView.layer.cornerRadius=5;
    layerView.layer.borderColor=[COLOR_LINE CGColor];;
    layerView.layer.borderWidth=1;
    
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(13, 11, 200, 18)];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.text=[Util isNil:dataDic[@"merchant_name"]];
    nameLab.font=DESC_FONT;
     [layerView  addSubview:nameLab];
    //排队图标
    UIImageView *paiImg=[[UIImageView alloc]initWithFrame:CGRectMake(layerView.frame.size.width-56, 13.5, 14, 14)];
    [paiImg setImage:[UIImage imageNamed:@"crowd"]];
    [layerView addSubview:paiImg];
    
    //排队中的文字
    
    UILabel *paiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(paiImg.frame)+6, 15, 35, 11)];
    paiLab.text=@"排队中";
    paiLab.textAlignment=NSTextAlignmentLeft;
    paiLab.textColor=UIColorFromRGB(0x4ed9aa);
    paiLab.font=INFO_FONT;
    [layerView addSubview:paiLab];
    NSString *str1=[NSString stringWithFormat:@"%@ %@",@"排队时间：",[Util isNil:dataDic[@"add_time"]]];
    NSString *str2=[NSString stringWithFormat:@"%@ %@%@",@"排队人数：",[Util isNil:dataDic[@"peopleNum"]],@"人"];
    NSString *str3=[NSString stringWithFormat:@"%@",[Util isNil:dataDic[@"floor_name"]]];
    
    NSArray *array=[[NSArray alloc]initWithObjects:str1,str2,str3, nil];
    NSArray *imgAry=[[NSArray alloc]initWithObjects:@"pickren",@"picktime",@"diqu", nil];
    
    for (int i=0; i<3; i++) {
        UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(13,36 +16*i, 10, 10)];
        iconImg.contentMode=UIViewContentModeScaleAspectFit;
        [iconImg setImage:[UIImage imageNamed:imgAry[i]]];
        
        UILabel  *itmeLab=[[UILabel alloc]initWithFrame:CGRectMake(29,36 +16*i, 160, 11)];
        itmeLab.text=array[i];
        itmeLab.textAlignment=NSTextAlignmentLeft;
        itmeLab.font=INFO_FONT;
        itmeLab.textColor=COLOR_FONT_SECOND;
        [layerView addSubview:iconImg];
        [layerView addSubview:itmeLab];
    }
    
    [_rootView   addSubview:layerView];
    
    //说明
    UILabel *shuomingLab=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(layerView.frame)+24, 260, 12)];
    shuomingLab.text=@"* 等待商户确认中，请稍后点击刷新按钮!";
    shuomingLab.textAlignment=NSTextAlignmentLeft;
    shuomingLab.font=DESC_FONT;
    [_rootView addSubview:shuomingLab];
    
    //刷新按钮
    
    UIButton *shuaxinBtn=[[UIButton alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(shuomingLab.frame)+25, WIN_WIDTH-16, 40)];
    shuaxinBtn.backgroundColor=APP_BTN_COLOR;
    [shuaxinBtn setTitle:@"取消排队" forState:UIControlStateNormal];
    [shuaxinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shuaxinBtn.titleLabel.font=COMMON_FONT;
    shuaxinBtn.layer.masksToBounds=YES;
    shuaxinBtn.layer.cornerRadius=5;
    [shuaxinBtn addTarget:self action:@selector(shuaxinTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_rootView addSubview:shuaxinBtn];
    
    [self.view  addSubview:_rootView];
}

//取消排队的按钮
-(void)shuaxinTouch:(UIButton*)sender
{
   
    int dataID=[_dataStr intValue];
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(dataID),@"serialId",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"cancelquenenumber"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
    
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
