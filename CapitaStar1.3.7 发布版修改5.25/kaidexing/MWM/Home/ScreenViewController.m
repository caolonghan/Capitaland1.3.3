//
//  ScreenViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ScreenViewController.h"
#import "PFUIKit.h"

#define SC_WIN_W WIN_WIDTH-M_WIDTH(95)

@interface ScreenViewController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIView *rootView;

@end

@implementation ScreenViewController{
    
    NSString     *firstVul;
    NSString     *secondVul;
    NSString     *thirdVVul;
    
    UIScrollView *scrollView;
    UIButton     *selectBtn;
    UIButton     *selectBtn_2;
    UIButton     *selectBtn_3;
    
    NSMutableArray *firstArray;
    NSMutableArray *secondArray;
    NSMutableArray *thirdArray;
    
    NSMutableArray *firstIdArray;
    NSMutableArray *secondIdArray;
    NSMutableArray *thirdIdArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_typeStr);
    self.leftBarItemView.hidden=YES;
    self.navigationBar.backgroundColor=[UIColor whiteColor];
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, SC_WIN_W, 44)];
    titleLab.text=@"筛选";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=BIG_FONT;
    [self.navigationBar addSubview:titleLab];

    self.navigationBarLine.backgroundColor=[UIColor whiteColor];
    [self createButtomScrollView];
    [self createButtomViewBtn];
}

-(void)createButtomScrollView{
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,SC_WIN_W,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(54))];
    scrollView.delegate=self;
    scrollView.contentSize=CGSizeMake(SC_WIN_W,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(54));
    scrollView.scrollEnabled=YES;
    [self.view addSubview:scrollView];
    
    if([Util isNull:_typeStr]){
        _typeStr=@"0";
    }
    
    if ([_typeStr isEqualToString:@"0"]) {
        
        firstArray=[[NSMutableArray alloc]initWithObjects:@"1Km",@"3Km",@"5Km",@"10Km",@"全城",nil];
        firstIdArray=[[NSMutableArray alloc]initWithObjects:@"1000",@"3000",@"5000",@"10000",@"0",nil];
        if ([Util isNull:secondArray]) {
            [self loadData_0];
        }else{
            [self createShaixuanView:@[@"按距离",@"按商场"]];
        }
        
    }else if ([_typeStr isEqualToString:@"1"]) {
        if ([Util isNull:firstArray]) {
            [self NetWorkRequest2];
        }else{
            [self createShaixuanView:@[@"选择楼层",@"全部业态"]];
        }
    }else if ([_typeStr isEqualToString:@"2"]) {
        
        if ([Util isNull:firstArray]) {
            [self NetWorkRequest2];
        }else{
            [self createShaixuanView:@[@"全部楼层",@"全部菜系",@"智能排序"]];
        }
        
    }else if ([_typeStr isEqualToString:@"3"]) {
        if ([Util isNull:firstArray]) {
            [self NetWorkRequest2];
        }else{
            [self createShaixuanView:@[@"全部楼层",@"全部业态",@"智能排序"]];
        }
    }else if ([_typeStr isEqualToString:@"5"]) {
        if ([Util isNull:firstArray]) {
            [self NetWorkRequest3];
        }else{
            [self createShaixuanView:@[@"选择业态",@"选择排序"]];
        }
    }
    
}


#pragma mark ---- 商场筛选视图 ----
-(void)createShaixuanView:(NSArray*)titleAry{
    CGFloat view_H=0;
    
    if (firstArray.count!=0) {
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0,0,SC_WIN_W,M_WIDTH(35))];
        [self chuliview:view1 :titleAry[0]];
        [scrollView addSubview:view1];
        view_H=CGRectGetMaxY(view1.frame)+M_WIDTH(13);
        
        int seInt=[self setAry_Index:firstIdArray indexStr:_vul_1 type:0];
        for (int i=0; i<firstArray.count; i++) {
            int x=i%2;
            int y=i/2;
            UIButton *btn=[PFUIKit buttonWithFrame_2:CGRectMake(M_WIDTH(10)+x*M_WIDTH(107),view_H+y*M_WIDTH(35),M_WIDTH(100),M_WIDTH(26)) titlt:firstArray[i] image:[UIImage imageNamed:@"rectangle"] selectImage:[UIImage imageNamed:@"r_right"] bColor:[UIColor whiteColor] tag:i tColor:[UIColor blackColor] stateTColor:[UIColor redColor] font:INFO_FONT target:self acdaction:@selector(firstBtn:)];
            
            if (i==seInt) {
                btn.selected = YES;//默认一个选中状态
                selectBtn = btn;
                firstVul = firstIdArray[seInt];
            }
            [scrollView addSubview:btn];
        }
        float cell_num_0=ceilf(firstArray.count/2.0);
        view_H=view_H+cell_num_0*M_WIDTH(35);
        scrollView.contentSize=CGSizeMake(SC_WIN_W,view_H);
    }
    
    if (secondArray.count!=0) {
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,view_H+M_WIDTH(13),SC_WIN_W,M_WIDTH(35))];
        [self chuliview:view2 :titleAry[1]];
        [scrollView addSubview:view2];
        
        view_H=view_H+M_WIDTH(61);
        int seInt=[self setAry_Index:secondIdArray indexStr:_vul_2 type:1];
        for (int i=0; i<secondArray.count; i++) {
            int x=i%2;
            int y=i/2;
            UIButton *btn2=[PFUIKit buttonWithFrame_2:CGRectMake(M_WIDTH(10)+x*M_WIDTH(107),view_H+y*M_WIDTH(35),M_WIDTH(100),M_WIDTH(26)) titlt:secondArray[i] image:[UIImage imageNamed:@"rectangle"] selectImage:[UIImage imageNamed:@"r_right"] bColor:[UIColor whiteColor] tag:i tColor:[UIColor blackColor] stateTColor:[UIColor redColor] font:INFO_FONT target:self acdaction:@selector(secondTouch:)];
            
            if (i==seInt) {
                btn2.selected = YES;//默认第一个的时候是选中状态
                selectBtn_2 = btn2;
                secondVul = secondIdArray[i];
            }
            
            [scrollView addSubview:btn2];
        }
        
        float cell_num_1=ceilf(secondArray.count/2.0);
        view_H=view_H+cell_num_1*M_WIDTH(35);
        scrollView.contentSize=CGSizeMake(SC_WIN_W,view_H);
    }
    
    
    if (thirdArray.count!=0) {
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,view_H+M_WIDTH(13),SC_WIN_W,M_WIDTH(35))];
        [self chuliview:view2 :titleAry[2]];
        [scrollView addSubview:view2];
        
        view_H=view_H+M_WIDTH(61);
        int seInt=[self setAry_Index:firstIdArray indexStr:_vul_3 type:2];
        for (int i=0; i<thirdArray.count; i++) {
            int x=i%2;
            int y=i/2;
            UIButton *btn3=[PFUIKit buttonWithFrame_2:CGRectMake(M_WIDTH(10)+x*M_WIDTH(107),view_H+y*M_WIDTH(35),M_WIDTH(100),M_WIDTH(26)) titlt:thirdArray[i] image:[UIImage imageNamed:@"rectangle"] selectImage:[UIImage imageNamed:@"r_right"] bColor:[UIColor whiteColor] tag:i tColor:[UIColor blackColor] stateTColor:[UIColor redColor] font:INFO_FONT target:self acdaction:@selector(thirdTouch:)];
            if (i==seInt) {
                btn3.selected = YES;//默认第一个的时候是选中状态
                selectBtn_3 = btn3;
                thirdVVul = thirdIdArray[i];
            }
            
            [scrollView addSubview:btn3];
        }
        
        float cell_num_1=ceilf(thirdArray.count/2.0);
        view_H=view_H+cell_num_1*M_WIDTH(35);
        scrollView.contentSize=CGSizeMake(SC_WIN_W,view_H);
    }
}


#pragma mark ---- 底部按钮 ----
-(void)createButtomViewBtn{
    for(int i=0;i<2;i++){
        UIButton *btn3=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(13)+i*(M_WIDTH(109)),self.view.frame.size.height-M_WIDTH(42),M_WIDTH(96),M_WIDTH(30))];
        [self chuliButtomBtn:btn3 :i];
        btn3.tag=i;
        [btn3 addTarget:self action:@selector(buttomTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn3];
    }
}


#pragma mark ---- 有商城id的网络请求 ----

-(void)NetWorkRequest2{
    
    NSString *path;
    NSDictionary *loadDic;
    if ([_typeStr isEqualToString:@"2"]) {
        
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"];
        loadDic=[[NSDictionary alloc]initWithObjectsAndKeys:@"food",@"t",@([[Global sharedClient].markID intValue]),@"mall_id",nil];
    }else if ([_typeStr isEqualToString:@"3"] ||[_typeStr isEqualToString:@"1"]) {
        
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"];
        loadDic=[[NSDictionary alloc]initWithObjectsAndKeys:@([[Global sharedClient].markID intValue]),@"mall_id",@"",@"t",nil];
    }
    
    [HttpClient requestWithMethod:@"POST" path:path parameters:loadDic target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self chuliVul:dic];
            
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}

-(void)NetWorkRequest3{
    
    NSString *path;
    NSDictionary *loadDic;
    if ([_typeStr isEqualToString:@"5"]) {
        
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"];
        loadDic=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"mall_id",@"",@"t",nil];
    }
    [HttpClient requestWithMethod:@"POST" path:path parameters:loadDic target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self chuliVul:dic];
            
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}


#pragma mark ---请求网络---
-(void)loadData_0{
    
    NSUserDefaults *userCity=[NSUserDefaults standardUserDefaults];
    NSString *strid=[userCity objectForKey:@"city"];
    if ([Util isNull:strid]) {
        strid=@"1";
    }else {
    }
    NSString *memberID=[Global sharedClient].member_id;
    if ([Util isNull:memberID]) {
        memberID=@"";
    }
    secondArray  =[[NSMutableArray alloc]init];
    secondIdArray=[[NSMutableArray alloc]init];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadmalllist"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:strid,@"city",memberID,@"member_id",nil ] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]]){
                NSArray  *dataAry1=dic[@"data"][@"fouce_malllist"];
                NSArray  *dataAry2=dic[@"data"][@"nofouce_malllist"];
                
                if (dataAry1.count!=0) {
                    for (NSDictionary *diction in dataAry1) {
                         NSString *mallID  = [Util isNil:diction[@"mall_id"]];
                         NSString *mallName=[Util isNil:diction[@"mall_name"]];
                         [secondIdArray addObject:mallID];
                         [secondArray addObject:mallName];
                    }
                }
                
                if (dataAry2.count!=0) {
                    for (NSDictionary *diction in dataAry2) {
                         NSString *mallID  = [Util isNil:diction[@"mall_id"]];
                         NSString *mallName=[Util isNil:diction[@"mall_name"]];
                         [secondIdArray addObject:mallID];
                         [secondArray addObject:mallName];
                    }
                }
                
               [self createShaixuanView:@[@"按距离",@"按商场"]];
                
                
            }
        });
    }failue:^(NSDictionary *dic){
    }];
}



#pragma mark ---- 处理数据 ----

-(void)chuliVul:(NSDictionary*)dic{
    firstArray    =[[NSMutableArray alloc]init];
    firstIdArray  =[[NSMutableArray alloc]init];
    
    secondArray   =[[NSMutableArray alloc]init];
    secondIdArray =[[NSMutableArray alloc]init];
    
    thirdArray    =[[NSMutableArray alloc]init];
    thirdIdArray  =[[NSMutableArray alloc]init];
    
    
    NSArray * shopFloor    = dic[@"data"][@"ShopFloor"];
    NSArray * ShopType     = dic[@"data"][@"ShopType"];
    
    NSString *nameStr;
    if ([_typeStr isEqualToString:@"2"]) {
        nameStr=@"全部菜系";
    }else{
        nameStr=@"全部业态";
    }
    
    if (shopFloor.count!=0) {
        [firstArray addObject:@"全部楼层"];
        [firstIdArray  addObject:@"0"];
        
        for (NSDictionary *dic1 in shopFloor) {
            NSString *nameStr  = [Util isNil:dic1[@"name"]];
            NSString *idStr    = [Util isNil:dic1[@"id"]];
            [firstArray addObject:nameStr];
            [firstIdArray  addObject:idStr];
        }
    }
    
    if (ShopType.count!=0) {
        [secondArray addObject:nameStr];
        [secondIdArray  addObject:@"0"];
        for (NSDictionary *dic2 in ShopType) {
            NSString *idStr    = [Util isNil:dic2[@"id"]];
            NSString *nameStr  = [Util isNil:dic2[@"name"]];
            [secondArray addObject:nameStr];
            [secondIdArray  addObject:idStr];
        }
    }
    
    if ([_typeStr isEqualToString:@"2"] || [_typeStr isEqualToString:@"3"] ) {
        
        NSArray* paixuID = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
        [thirdIdArray addObjectsFromArray:paixuID];
        NSArray *paixutitleAry=[[NSArray alloc]initWithObjects:@"默认排序",@"人气最高",@"有团购",@"有促销优惠",@"A-Z字母排序",@"有卡券",@"有报名",@"有排队", nil];
        [thirdArray addObjectsFromArray:paixutitleAry];
        
        [self createShaixuanView:@[@"选择楼层",nameStr,@"智能排序"]];
        
    }else{
        [self createShaixuanView:@[@"选择楼层",nameStr]];
    }
}

-(void)chuliVul3:(NSDictionary*)dic{
    firstArray    =[[NSMutableArray alloc]init];
    firstIdArray  =[[NSMutableArray alloc]init];

    secondArray   =[[NSMutableArray alloc]initWithObjects:@"默认排序",@"人气最高",@"有团购",@"有促销优惠",@"A-Z字母排序",@"有卡券",@"有报名",@"有排队", nil];
    secondIdArray =[[NSMutableArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    
    NSArray * ShopType     = dic[@"data"][@"ShopType"];

    
    if (ShopType.count!=0) {
        [firstArray addObject:@"全部楼层"];
        [firstIdArray  addObject:@"0"];
        
        for (NSDictionary *dic1 in ShopType) {
            NSString *nameStr  = [Util isNil:dic1[@"name"]];
            NSString *idStr    = [Util isNil:dic1[@"id"]];
            [firstArray addObject:nameStr];
            [firstIdArray  addObject:idStr];
        }
    }
    
    [self createShaixuanView:@[@"选择业态",@"选择排序"]];
}


#pragma mark ---- 点击事件 ----
-(void)firstBtn:(UIButton*)sender{
    
    if (selectBtn !=nil) {
        selectBtn.selected = NO;
    }
    sender.selected = YES;
    selectBtn =sender;
    firstVul=firstIdArray[sender.tag];
}


-(void)secondTouch:(UIButton*)sender{
    if (selectBtn_2 !=nil) {
        selectBtn_2.selected = NO;
    }
    sender.selected = YES;
    selectBtn_2 =sender;
    secondVul = secondIdArray[sender.tag];
}

-(void)thirdTouch:(UIButton*)sender{
    if (selectBtn_3 !=nil) {
        selectBtn_3.selected = NO;
    }
    sender.selected = YES;
    selectBtn_3 =sender;
    thirdVVul =thirdIdArray[sender.tag];
}

//底部的确认 和重置 按钮
-(void)buttomTouch:(UIButton*)sender{
    
    if (sender.tag==0) {
        
        [scrollView removeFromSuperview];
        [self createButtomScrollView];
        
    }else{
        if ([Util isNull:thirdVVul]) {
            thirdVVul=@"0";
        }
        
        NSArray *array=[[NSArray alloc]initWithObjects:firstVul,secondVul,thirdVVul, nil];
        if (_screeDelegate && [_screeDelegate respondsToSelector:@selector(setScreeViewValue:)]) {
            [_screeDelegate setScreeViewValue:array];
        }
        
    }
}


-(void)chuliview:(UIView*)view :(NSString*)text{
    view.backgroundColor=UIColorFromRGB(0xf9f9f9);
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),0,M_WIDTH(100),view.frame.size.height)];
    lab.font=DESC_FONT;
    lab.text=text;
    lab.textAlignment=NSTextAlignmentLeft;
    [view addSubview:lab];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0,0,view.frame.size.width,1)];
    line1.backgroundColor=COLOR_LINE;
    [view addSubview:line1];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0,view.frame.size.height-1,view.frame.size.width,1)];
    line2.backgroundColor=COLOR_LINE;
    [view addSubview:line2];
    
}

-(void)chuliBtn:(UIButton*)btn btnText:(NSString*)text {
    btn.layer.borderColor=COLOR_LINE.CGColor;
    btn.layer.borderWidth=1;
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(8),0,btn.frame.size.width-M_WIDTH(16),btn.frame.size.height)];
    lab.text=text;
    [btn addSubview:lab];
}

-(void)chuliButtomBtn:(UIButton*)btn :(int)colorType{
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=btn.frame.size.height/2;
    if(colorType == 0){
        [btn setTitle:@"重置" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor=APP_BTN_COLOR;
    }else{
        [btn setTitle:@"确认" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.backgroundColor=APP_BTN_COLOR;
    }
}
//type 是第几部分
-(int)setAry_Index:(NSMutableArray*)dataary indexStr:(NSString*)str type:(int)type{
    int index;
    if ([Util isNull:str]) {
        if (type==0) {
            if ([_typeStr isEqualToString:@"0"]) {
                index=(int)dataary.count-1;
            }else{
                index=0;
            }
        }else{
            index=0;
        }
    }else{
        for (int i=0; i<dataary.count; i++) {
            if ([str isEqualToString:dataary[i]]) {
                index=i;
                break;
            }
        }
    }
    return index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
