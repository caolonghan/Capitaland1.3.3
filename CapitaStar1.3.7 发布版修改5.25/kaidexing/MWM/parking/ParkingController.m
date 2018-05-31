//
//  ParkingController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/29.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ParkingController.h"
#import "SuccessBookingController.h"
#import "ShopingCartController.h"
#import "ParkingPayController.h"
#import "AddCarController.h"
#import "SuccessLockingController.h"
#import "GoViewController.h"


#define color_b  UIColorFromRGB(0x38c0a5)
#define color_r  UIColorFromRGB(0xf15152)
#define color_h  UIColorFromRGB(0x959595)


@interface ParkingController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSMutableArray  *dataAry;


@end

@implementation ParkingController
{
    UITableView *tableView1;
    int          index_Big;
    UIView      *sView;
    BOOL        is_Refresh;
    NSInteger   carNum;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (is_Refresh==YES) {
        is_Refresh=NO;
        [self NetWorkRequest];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    is_Refresh=NO;
    self.navigationBarTitleLabel.text=@"智能停车";
    _dataAry=[[NSMutableArray alloc]init];
    index_Big=0;
    [self creterTableView];
    [self NetWorkRequest];
}

//--------检查商场ID-------

//获取数据
-(void)NetWorkRequest{
//    [Global sharedClient].markID
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",[Global sharedClient].markID,@"mall_id",@"1000",@"source",nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:@"carnolist"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataAry=dic[@"data"][@"carlist"];
            if ([Util isNull:dic[@"data"][@"freespace"]]) {
                carNum=0;
            }else{
                carNum  =[dic[@"data"][@"freespace"] count];
            }
            if (_dataAry.count!=0 && _dataAry.count==index_Big) {
                index_Big--;
            }
            [tableView1 reloadData];
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
        
    }];
}


//预定车位接口
-(void)yudingNet:(NSString*)car_no{
    car_no = [car_no stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",[Global sharedClient].markID,@"mall_id",car_no,@"car_no", nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"park" tp:@"reservepark"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int reserve_money=[dic[@"data"][@"isprepay"]intValue];
            if (reserve_money==0){
                SuccessBookingController *sVC=[[SuccessBookingController alloc]init];
                sVC.park_id=dic[@"data"][@"park_id"];
                sVC.car_no=car_no;
                is_Refresh=YES;
                [self.delegate.navigationController pushViewController:sVC animated:YES];
            }else {
                SuccessLockingController *sVC=[[SuccessLockingController alloc]init];
                sVC.park_id         = [Util isNil:dic[@"data"][@"park_id"]];
                sVC.car_no          = car_no;
                is_Refresh=YES;
                [self.delegate.navigationController pushViewController:sVC animated:YES];
            }
            [SVProgressHUD dismiss];
        });
    } failue:^(NSDictionary *dic) {
    }];
}
//解除绑定
- (void)loadData:(NSString*)car_no {
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", car_no, @"car_no", @"1000", @"source", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"removecarno"] parameters:params target:self success:^(NSDictionary *dic) {
        [self NetWorkRequest];
    } failue:^(NSDictionary *dic) {
    }];
}

//我要找车
- (void)zhaocheloadData:(NSString*)car_no {
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:car_no,@"park_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"findcar"] parameters:params target:self success:^(NSDictionary *dic) {dispatch_async(dispatch_get_main_queue(), ^{
        if (![Util isNull:dic[@"data"]]) {
            GoViewController *gvc=[[GoViewController alloc]init];
            gvc.path=dic[@"data"];
            [self.delegate.navigationController pushViewController:gvc animated:YES];
        }
        });
    } failue:^(NSDictionary *dic) {
    }];
}



-(void)creterTableView{
    tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStyleGrouped];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.scrollEnabled=YES;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView1.backgroundColor=UIColorFromRGB(0xf1f4f4);
    [self.view addSubview:tableView1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataAry.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  sention_H;
    if(_dataAry.count==0){
       if (indexPath.section==0) {
           sention_H=M_WIDTH(60);
       }
    }else if (indexPath.section==index_Big) {
              NSDictionary *dic=_dataAry[indexPath.section];
            if (![[Util isNil:dic[@"book_button"]]isEqualToString:@"预订车位"]){
                sention_H=M_WIDTH(128);
            }else{
                sention_H=M_WIDTH(108);
            }
    }else {
        sention_H=M_WIDTH(60);
    }
    return sention_H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (carNum==0) {
        if (section==0) {
            return M_WIDTH(40);
        }else{
            return M_WIDTH(10);
        }
    }else{
        if (section == 0) {
            return M_WIDTH(140);
        }else{
            return M_WIDTH(10);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    UILabel *titleLab;
    UIView  *cellVIew;
    UILabel *lab;
    UIButton *btn;
    UILabel *buttomLab;
    [UIUtil removeSubView:bgView];
    if (bgView==nil) {//UIColorFromRGB(0xf1f4f4);
        
        if (carNum==0) {
            bgView = [[UIView alloc]init];
            bgView.backgroundColor =UIColorFromRGB(0xf1f4f4);
            if (section==0) {
                buttomLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(150),M_WIDTH(40))];
                buttomLab.text=@"已绑定车牌";
                buttomLab.textAlignment=NSTextAlignmentLeft;
                buttomLab.font=COMMON_FONT;
                [bgView addSubview:buttomLab];
            }
        }else{
            if (section==0) {
                
                bgView=[[UIView alloc]init];
                bgView.backgroundColor=UIColorFromRGB(0xf1f4f4);
                titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0, M_WIDTH(150),M_WIDTH(40))];
                titleLab.text=@"停车场现有空位查询";
                titleLab.textAlignment=NSTextAlignmentLeft;
                titleLab.font=COMMON_FONT;
                [bgView addSubview:titleLab];
                
                cellVIew=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(40),WIN_WIDTH, M_WIDTH(60))];
                cellVIew.backgroundColor=[UIColor whiteColor];
                NSString *str1=@"剩余车位：";
                NSString *str2=[NSString stringWithFormat:@"%d",carNum];
                NSString *str3=@"个";
                lab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(150),M_WIDTH(60))];
                lab.font=COMMON_FONT;
                lab.textAlignment=NSTextAlignmentLeft;
                [self colorLab:lab :str1 :str2 :str3];
                [cellVIew addSubview:lab];
                
                btn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(91),M_WIDTH(19.5),M_WIDTH(81),M_WIDTH(21))];
                btn.layer.masksToBounds=YES;
                btn.layer.cornerRadius=btn.frame.size.height/2;
                btn.layer.borderColor=APP_BTN_COLOR.CGColor;
                btn.layer.borderWidth=1;
                btn.titleLabel.font=DESC_FONT;
                [btn setTitle:@"更新信息" forState:UIControlStateNormal];
                [btn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(shuaxinTouch) forControlEvents:UIControlEventTouchUpInside];
                [cellVIew addSubview:btn];
                [bgView addSubview:cellVIew];
                
                buttomLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(100),M_WIDTH(150),M_WIDTH(40))];
                buttomLab.text=@"已绑定车牌";
                buttomLab.textAlignment=NSTextAlignmentLeft;
                buttomLab.font=COMMON_FONT;
                [bgView addSubview:buttomLab];
                
            }else{
                bgView = [[UIView alloc]init];
                bgView.backgroundColor =UIColorFromRGB(0xf1f4f4);
                if (section==0) {
                    UILabel *buttomLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(150),M_WIDTH(40))];
                    buttomLab.text=@"已绑定车牌";
                    buttomLab.textAlignment=NSTextAlignmentLeft;
                    buttomLab.font=COMMON_FONT;
                    [bgView addSubview:buttomLab];
                }
            }
        }
    }
    return bgView;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [UIUtil removeSubView:cell];
    if (indexPath.section<_dataAry.count) {
        UIView *view=[self createView:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addSubview:view];
        return cell;
    }else {
        UIView *view=[self createBtnView1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        [cell addSubview:view];
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==index_Big) {
    }else{
        index_Big=(int)indexPath.section;
        [tableView1 reloadData];
    }
}


-(UIView*)createView:(NSIndexPath*)index_sen
{
    NSDictionary *dic=_dataAry[index_sen.section];
    UIView *rootView=[[UIView alloc]init];
    rootView.backgroundColor=[UIColor whiteColor];
    UIView *headView=[[UIView alloc]init];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(12),60,M_WIDTH(19))];
    titleLab.text=@"车牌号:";
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.font=COMMON_FONT;
    [headView addSubview:titleLab];
    
    UILabel *chapaiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLab.frame),M_WIDTH(12), M_WIDTH(115), M_WIDTH(19))];
    chapaiLab.text = [[Util isNil:dic[@"car_no"]] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    chapaiLab.textAlignment=NSTextAlignmentLeft;
    chapaiLab.textColor=UIColorFromRGB(0xdf2b2a);
    chapaiLab.font=COMMON_FONT;
    [headView addSubview:chapaiLab];

    if (index_sen.section==index_Big) {
        //判断是否预定
        if (![[Util isNil:dic[@"book_button"]]isEqualToString:@"预订车位"]){
            UILabel  *yudingLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(titleLab.frame), M_WIDTH(87), M_WIDTH(24))];
            yudingLab.text=@"已预订车位:";
            yudingLab.textAlignment=NSTextAlignmentLeft;
            yudingLab.font=COMMON_FONT;
            [headView addSubview:yudingLab];
            
            UILabel *shoppingLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yudingLab.frame), CGRectGetMaxY(titleLab.frame), M_WIDTH(200), M_WIDTH(24))];
            shoppingLab.textAlignment=NSTextAlignmentLeft;
            shoppingLab.text=[Util isNil:dic[@"park_name"]];
            shoppingLab.textColor=UIColorFromRGB(0xdf2b2a);
            shoppingLab.font=COMMON_FONT;
            [headView addSubview:shoppingLab];
            headView.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(80));
            rootView.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(128));
        }else{
            headView.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(60));
            rootView.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(108));
        }
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame)-1,WIN_WIDTH,1)];
        lineView.backgroundColor=COLOR_LINE;
        [rootView addSubview:lineView];
        
        CGFloat btn_W=(WIN_WIDTH-M_WIDTH(54))/3;
//        NSArray *colorAry=[[NSArray alloc]initWithObjects:APP_BTN_COLOR,APP_BTN_COLOR,UIColorFromRGB(0x959595),nil];
        NSArray *colorAry=[[NSArray alloc]initWithObjects:color_b,color_r,color_h,nil];

        NSArray *titleAry=[[NSArray alloc]initWithObjects:[Util isNil:dic[@"book_button"]],@"停车查询",@"解除绑定",nil];
        UIButton *btn;
        for (int i=0; i<3; i++) {
            btn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(12)+i*(btn_W+M_WIDTH(15)),CGRectGetMaxY(lineView.frame)+M_WIDTH(11), btn_W, M_WIDTH(23))];
            [self colorBtn:btn :colorAry[i] :titleAry[i]];
            btn.tag=index_sen.section*100 + i;
            [btn addTarget:self action:@selector(itemTouch:) forControlEvents:UIControlEventTouchUpInside];
            if (carNum==0) {
                if (i!=0) {
                    [rootView addSubview:btn];
                }
            }else{
                [rootView addSubview:btn];
            }
        }
        
    }else{
        headView.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(60));
        rootView.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(60));
    }
    
    UILabel *timeLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(headView.frame)-M_WIDTH(26), M_WIDTH(105), M_WIDTH(12))];
    timeLab.text=[Util isNil:dic[@"creat_time"]];
    timeLab.textAlignment=NSTextAlignmentLeft;
    timeLab.font=INFO_FONT;
    timeLab.textColor=COLOR_FONT_SECOND;
    [headView addSubview:timeLab];
    
    UIImageView  *downImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(35), (headView.frame.size.height-M_WIDTH(25))/2, M_WIDTH(25), M_WIDTH(25))];
    [downImg setImage:[UIImage imageNamed:@"zhankai_g"]];
    [headView addSubview:downImg];
    
    
    if (![Util isNull:dic[@"book_status"]]) {
        UILabel *shixiaoLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(44)-M_WIDTH(75),(headView.frame.size.height-M_WIDTH(25))/2,M_WIDTH(75),M_WIDTH(25))];
        shixiaoLab.layer.masksToBounds=YES;
        shixiaoLab.layer.cornerRadius=shixiaoLab.frame.size.height/2;
        shixiaoLab.textColor=COLOR_FONT_SECOND;
        shixiaoLab.backgroundColor=UIColorFromRGB(0xf1f4f4);
        shixiaoLab.textAlignment=NSTextAlignmentCenter;
        shixiaoLab.font=DESC_FONT;
        shixiaoLab.text=[Util isNil:dic[@"book_status"]];
        [headView addSubview:shixiaoLab];
    }
    [rootView addSubview:headView];
    return rootView;
}

-(UIView*)createBtnView1
{
    UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 52)];
    buttomView.backgroundColor=[UIColor clearColor];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(15),M_WIDTH(7), WIN_WIDTH-M_WIDTH(30),M_WIDTH(38))];
    btn.backgroundColor=APP_BTN_COLOR;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    [btn setTitle:@"新增车牌号" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=COMMON_FONT;
    [btn addTarget:self action:@selector(xinzengTouch:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:btn];
    return buttomView;
}


-(void)itemTouch:(UIButton*)sender{
    int  index_sention=((int)sender.tag/100);
    int  index_item   =(int)sender.tag%100;
    
    NSLog(@"点击了第 %d 行，第 %d 个",index_sention,index_item);
    NSDictionary *dic=_dataAry[index_sention];
    NSString *book_button=[Util isNil:dic[@"book_button"]];
    if (index_item==0) {
        if ([book_button isEqualToString:@"预订车位"]){
            [self yudingNet:[Util isNil:dic[@"car_no"]]];
        }else if ([book_button isEqualToString:@"查看详情"]){
            
            SuccessBookingController *sVC=[[SuccessBookingController alloc]init];
            sVC.park_id=[Util isNil:dic[@"park_id"]];
            sVC.car_no=[Util isNil:dic[@"car_no"]];
            is_Refresh=YES;
            [self.delegate.navigationController pushViewController:sVC animated:YES];

        }else if ([book_button isEqualToString:@"我要找车"]){
            [self zhaocheloadData:[Util isNil:dic[@"park_id"]]];
        }else{
            
        }
    }else if(index_item==1){
//        if (![book_button isEqualToString:@"车位预定"]) {
            ParkingPayController *pvc=[[ParkingPayController alloc]init];
            pvc.car_no    =[Util isNil:dic[@"car_no"]];
            pvc.park_idStr=[Util isNil:dic[@"park_id"]];
            [self.delegate.navigationController pushViewController:pvc animated:YES];
//        }else{
//            [self showMsg:@"您还未停车"];
//        }
    }else if(index_item==2){
        [self confirm:@"确认解除绑定？" afterOK:^{
            [self loadData:[Util isNil:dic[@"car_no"]]];
        }];
    }
}


//空车查询更新信息
-(void)shuaxinTouch
{
     [self NetWorkRequest];
}

//提示框代理返回删除界面
-(void)guanbiTouch{
    [sView removeFromSuperview];
}


-(void)xinzengTouch:(UIButton *)sender{
    NSLog(@"点击新增车牌按钮");
    is_Refresh=YES;
    [self.delegate.navigationController pushViewController:[[AddCarController alloc] init] animated:YES];
}

-(void)colorBtn:(UIButton*)btn :(UIColor*)colorl :(NSString*)title{
//    btn.layer.masksToBounds=YES;
//    btn.layer.borderWidth=1;
//    btn.layer.borderColor=colorl.CGColor;
    btn.backgroundColor=colorl;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=M_WIDTH(10);
    btn.titleLabel.font=INFO_FONT;
//    [btn setTitleColor:colorl forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn setTitle:title forState:UIControlStateNormal];
}

//Lab字颜色处理
-(void)colorLab:(UILabel *)lab :(NSString*)str1 :(NSString *)str2 :(NSString*)str3
{
    int  str1_l   =(int)str1.length;
    int  str2_l   =(int)str2.length;
    
    NSString    *labText = [NSString stringWithFormat:@"%@%@%@",str1,str2,[Util isNil:str3]];
    lab.text             = labText;
    lab.attributedText   = [Util getAttrColor:lab.text begin:str1_l end:str2_l color:[UIColor redColor]];
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
