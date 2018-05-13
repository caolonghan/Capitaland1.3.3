//
//  ParkingLotController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/17.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ParkingLotController.h"
#import "MLabel.h"
#import "ParkingController.h"
#import "PaymentDetailsController.h"

@interface ParkingLotController ()<UIScrollViewDelegate>

@end

@implementation ParkingLotController{
    
    UIScrollView *scrollView;
    NSArray      *dataAry;
    UIView       *nilView1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xf3f3f3);
    dataAry=[[NSArray alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

-(void)loadData{
    [scrollView removeFromSuperview];
    [self create_RootView];
    NSUserDefaults *cityNSU=[NSUserDefaults standardUserDefaults];
    NSString *cityID=[cityNSU valueForKey:@"city"];
    if ([Util isNull:cityID]) {
        cityID=@"0";
    }
    
    NSDictionary * dic=[[NSDictionary alloc]initWithObjectsAndKeys:cityID,@"city_id",[Global sharedClient].member_id,@"member_id", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getparklist"] parameters:dic target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]]){
                dataAry=dic[@"data"][@"parkinfolist"];
                int is_o_1;
                is_o_1=0;
                for(NSDictionary * dic in dataAry){
                    int park_num=[[Util isNil:dic[@"park_num"]] intValue];
                    if(park_num>0){
                        is_o_1=1;
                        break;
                    }
                }
                if (dataAry.count>0) {
                    if (is_o_1==0) {
                        [self createCellView_1];
                    }else{
                        [self createCellView_0];
                    }
                }else{
                    [self initnilView];
                }
            }
        });
    }failue:^(NSDictionary *dic){
         [self initnilView];
    }];

}

-(void)create_RootView{
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT,WIN_WIDTH,M_WIDTH(65))];
    rootView.backgroundColor=APP_BTN_COLOR;
    [self.view addSubview:rootView];
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
}


//已停车时显示
-(void)createCellView_0{
    

    CGFloat  beijing_H=M_WIDTH(118);//有停车背景高度
    CGFloat  bigView_H=M_WIDTH(167);//有停车整个View的高度
    CGFloat  s_view_H =M_WIDTH(47); //没有停车的View的高度
    
    CGFloat  view_TOP_H;//控件距上高度
    
    int first_row=0;
    view_TOP_H=M_WIDTH(10);
    for (int j=0; j<dataAry.count; j++) {
        NSDictionary *dic=dataAry[j];
        int park_num=[[Util isNil:dic[@"park_num"]] intValue];
        if(park_num==0){
            if (first_row==0) {
                first_row=1;
                UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),view_TOP_H+M_WIDTH(4),M_WIDTH(150),M_WIDTH(44))];
                titleLab.text=@"当前城市其他停车场";
                titleLab.textColor=APP_BTN_COLOR;
                titleLab.textAlignment=NSTextAlignmentLeft;
                titleLab.font=DESC_FONT;
                [scrollView addSubview:titleLab];
                view_TOP_H=view_TOP_H+s_view_H+M_WIDTH(4);
            }
            
            UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,view_TOP_H,WIN_WIDTH,s_view_H)];
            view2.backgroundColor=[UIColor whiteColor];
            view2.tag=j*1000;
            NSString *parkName=[Util isNil:dic[@"parklot_name"]];
            [self chuliCellView:view2 :parkName :0];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)];
            [view2 addGestureRecognizer:tap];
            [scrollView addSubview:view2];
            view_TOP_H=view_TOP_H+s_view_H;
           
        }else{
            CGFloat row_H=(park_num-1)*(beijing_H + M_WIDTH(8)) + bigView_H;
            
            UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(8),view_TOP_H+M_WIDTH(10),WIN_WIDTH-M_WIDTH(16),row_H)];
            headView.backgroundColor=[UIColor whiteColor];
            NSDictionary *dic0=dataAry[0];
            NSString *parkName0=[Util isNil:dic0[@"parklot_name"]];
            
            CGFloat cell_view_H=M_WIDTH(41);
            UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(8),0,WIN_WIDTH-M_WIDTH(16),M_WIDTH(41))];
            [self chuliCellView:view1 :parkName0 :3];
            view1.tag=j*100;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)];
            [view1 addGestureRecognizer:tap];
            
            [headView addSubview:view1];
            
            int z=0;
            for (NSDictionary * diction in dic[@"parklist"]) {
                UIImageView *beijingIMG=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(7.5),cell_view_H,view1.frame.size.width-M_WIDTH(15),beijing_H)];
                beijingIMG.userInteractionEnabled=YES;
                [beijingIMG setImage:[UIImage imageNamed:@"g_background"]];
                
                MLabel *myCar=[[MLabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(26),view1.frame.size.width,M_WIDTH(19))];
                myCar.text=[NSString stringWithFormat:@"我的车牌: %@",[Util isNil:diction[@"carNo"]]];
                myCar.textColor=[UIColor redColor];
                myCar.textAlignment=NSTextAlignmentCenter;
                myCar.font=BIG_FONT;
                [myCar setAttrColor:0 end:5 color:[UIColor blackColor]];
                [myCar setAttrFont:0 end:5 font:DESC_FONT];
                [beijingIMG addSubview:myCar];
                
                UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(beijingIMG.frame.size.width/2 -M_WIDTH(60),CGRectGetMaxY(myCar.frame)+M_WIDTH(19),M_WIDTH(120),M_WIDTH(28))];
                btn.layer.masksToBounds=YES;
                btn.layer.cornerRadius=btn.frame.size.height/2;
                btn.backgroundColor=APP_BTN_COLOR;
                [btn setTitle:@"查询缴费" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.tag=j*100+z;
                z++;
                [btn addTarget:self action:@selector(chaxunTouch:) forControlEvents:UIControlEventTouchUpInside];
                [beijingIMG addSubview:btn];
                [headView addSubview:beijingIMG];
                
                cell_view_H=cell_view_H+beijing_H+M_WIDTH(8);
            }
            
            view_TOP_H = view_TOP_H +row_H;
            [scrollView addSubview:headView];
        }
    }

    [self.view addSubview:scrollView];
}

//未停车时显示
-(void)createCellView_1{
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(15),0,WIN_WIDTH-M_WIDTH(30),M_WIDTH(42))];
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.textColor=[UIColor whiteColor];
    titleLab.text=@"当前城市共有以下停车场";
    titleLab.font=DESC_FONT;
    [scrollView addSubview:titleLab];
    
    for (int i=0; i<dataAry.count; i++) {
        NSDictionary *dic=dataAry[i];
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(8),CGRectGetMaxY(titleLab.frame)+i*M_WIDTH(47),WIN_WIDTH-M_WIDTH(16),M_WIDTH(47))];
        view2.backgroundColor=[UIColor whiteColor];
        view2.tag=i;
        NSString *parkName=[Util isNil:dic[@"parklot_name"]];
        [self chuliCellView:view2 :parkName :1];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)];
        [view2 addGestureRecognizer:tap];
        [scrollView addSubview:view2];
    }
}

//选择商城点击事件
-(void)onItemTap:(UITapGestureRecognizer*)tap{
    
    NSDictionary *dic=dataAry[(int)tap.view.tag/100];
    ParkingController *vc=[[ParkingController alloc]init];
    vc.mall_id=[Util isNil:dic[@"mall_id"]];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//
-(void)chaxunTouch:(UIButton*)sender{
    NSDictionary *dic=dataAry[(int)sender.tag/100];
    NSDictionary *diction=dic[@"parklist"][sender.tag%100];
    PaymentDetailsController *vc=[[PaymentDetailsController alloc]init];
    vc.car_no=[Util isNil:diction[@"carNo"]];
    vc.mall_id=[Util isNil:dic[@"mall_id"]];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//0屏幕宽度带下划线  1左右留白带下划线  3左右留白不带下划线
-(void)chuliCellView:(UIView*)view :(NSString*)title :(int)type{
    CGFloat juzuo_W;
    if (type==0) {
        juzuo_W=M_WIDTH(15);
    }else{
        juzuo_W=M_WIDTH(7.5);
    }

    UIImageView  *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(juzuo_W,(view.frame.size.height/2 -M_WIDTH(7)),M_WIDTH(14),M_WIDTH(14))];
    imgView.layer.masksToBounds=YES;
    imgView.layer.cornerRadius=imgView.frame.size.width/2;
    [imgView setImage:[UIImage imageNamed:@"park_y"]];
    [view addSubview:imgView];
    
    UILabel *titileLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+M_WIDTH(5),0,view.frame.size.width-juzuo_W*2-M_WIDTH(30),view.frame.size.height)];
    titileLab.text=title;
    titileLab.textAlignment=NSTextAlignmentLeft;
    titileLab.font=DESC_FONT;
    [view addSubview:titileLab];
    
    UIImageView *fanhuiImg=[[UIImageView alloc]initWithFrame:CGRectMake(view.frame.size.width-juzuo_W-M_WIDTH(12),(view.frame.size.height-M_WIDTH(11))/2,M_WIDTH(7),M_WIDTH(11))];
    [fanhuiImg setImage:[UIImage imageNamed:@"p_right"]];
    [view addSubview:fanhuiImg];
    
    if (type==0) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(juzuo_W,view.frame.size.height-1,view.frame.size.width-juzuo_W,1)];
        lineView.backgroundColor=COLOR_LINE;
        [view addSubview:lineView];
    }else if(type==1){
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,view.frame.size.height-1,view.frame.size.width-juzuo_W,1)];
        lineView.backgroundColor=COLOR_LINE;
        [view addSubview:lineView];
    }
    
}

//没有数据的时候显示的View
-(void)initnilView{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    nilView1.backgroundColor=UIColorFromRGB(0xf3f3f3);
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
