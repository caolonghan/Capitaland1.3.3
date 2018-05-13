//
//  PickController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "PickController.h"
#import "NoLineUpController.h"
@interface PickController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic)UIScrollView      *scrollView1;
@property (strong,nonatomic)UITextField       *textF1;
@end

@implementation PickController
{
    CGFloat     view_H;
    NSString    *dizhiStr;
    NSString    *shopNameStr;
    NSArray     *tableListAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    view_H=NAV_HEIGHT;
    self.navigationBarTitleLabel.text=@"在线排号";
    self.scrollView1=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView1.delegate=self;
    self.scrollView1.backgroundColor=[UIColor whiteColor];
    self.scrollView1.scrollEnabled=YES;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.1);
    [self.view addSubview:self.scrollView1];
    [self NetWorkRequest];
}

-(void)NetWorkRequest
{
    int shopid=[_shopID intValue];
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(shopid),@"shop_id",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"quenenumberinfo"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
           
            NSArray *array=dic[@"data"][@"tableList"];
//            NSString *canQuene=dic[@"data"][@"canQuene"];
            
            
            if(array.count==0)
            {
                shopNameStr = [Util isNil:dic[@"data"][@"merchant_name"]];
                dizhiStr    = [Util isNil:dic[@"data"][@"address"]];
                [self initheadView_1];
                
            }else{
                shopNameStr = [Util isNil:dic[@"data"][@"merchant_name"]];
                dizhiStr    = [Util isNil:dic[@"data"][@"address"]];
                tableListAry= dic[@"data"][@"tableList"];
                
                [self initheadView];
            }
            
            
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
    
    
}




-(void)initheadView
{
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(10, view_H+22, WIN_WIDTH/2, 15)];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=COMMON_FONT;
    nameLab.text=shopNameStr;
    [self.scrollView1 addSubview:nameLab];
    
    CGFloat  view_w=WIN_WIDTH-20;
    
    UIView *colorview=[[UIView alloc]initWithFrame:CGRectMake(10, view_H+46, view_w, 34)];
    colorview.backgroundColor=[UIColor redColor];
    NSArray *array=[[NSArray alloc]initWithObjects:@"餐桌类型",@"等待桌数",@"预计等待", nil];
    for (int i=0; i<3 ;i++) {
        UILabel *typeLab=[[UILabel alloc]initWithFrame:CGRectMake(1+i*view_w/3 , 0, view_w/3 -2, 34)];
        typeLab.textColor=[UIColor whiteColor];
        typeLab.font=DESC_FONT;
        typeLab.textAlignment=NSTextAlignmentCenter;
        typeLab.text=array[i];
        [colorview addSubview:typeLab];
        if (i==1 || i==2) {
            UIView  *x_line=[[UIView alloc]initWithFrame:CGRectMake(i*view_w/3, 11, 1, 12)];
            x_line.backgroundColor=[UIColor whiteColor];
            [colorview addSubview:x_line];
        }
    }
    [self.scrollView1 addSubview:colorview];
    
    view_H=view_H+80;
    
    for (NSDictionary *dic in tableListAry) {
        UIView *beijingView=[[UIView alloc]initWithFrame:CGRectMake(10, view_H, view_w, 35)];
        beijingView.backgroundColor=UIColorFromRGB(0xf2f5f5);
        //桌子大小
        UILabel *zhuoLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 3, view_w/3, 17)];
        zhuoLab.textAlignment=NSTextAlignmentCenter;
        zhuoLab.text=[Util isNil:dic[@"tableName"]];
        zhuoLab.font=DESC_FONT;
        //人数
        UILabel *renshu=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zhuoLab.frame), view_w/3, 11)];
        renshu.text=[Util isNil:dic[@"peopleNum"]];
        renshu.font=INFO_FONT;
        renshu.textAlignment=NSTextAlignmentCenter;
        renshu.textColor=COLOR_FONT_SECOND;
        //等待桌数
        UILabel *equalLab=[[UILabel alloc]initWithFrame:CGRectMake(view_w/3, 9,view_w/3,17)];
        equalLab.textColor=[UIColor redColor];
        NSString *zhuostr=[Util isNil:dic[@"waitNum"]];
        equalLab.text=[NSString stringWithFormat:@"%@%@",zhuostr,@"桌"];

        equalLab.textAlignment=NSTextAlignmentCenter;
        NSMutableAttributedString* attrText= [Util getAttrFont:equalLab.text begin:equalLab.text.length-1 end:1 font:DESC_FONT];
        [attrText addAttribute:NSForegroundColorAttributeName  value:[UIColor blackColor] range:NSMakeRange(equalLab.text.length-1,1)];
        equalLab.attributedText = attrText;
        
        //预计等待时间
        UILabel *timeLab=[[UILabel alloc]initWithFrame:CGRectMake(2*view_w/3,11, view_w/3, 15)];
        timeLab.textAlignment=NSTextAlignmentCenter;
        timeLab.font=COMMON_FONT;
        timeLab.text=[Util isNil:dic[@"waitNum"]];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, 34, view_w, 1)];
        lineView1.backgroundColor=COLOR_LINE;
        [beijingView addSubview:zhuoLab];
        [beijingView addSubview:renshu];
        [beijingView addSubview:equalLab];
        [beijingView addSubview:timeLab];
        [beijingView addSubview:lineView1];
        [self.scrollView1 addSubview:beijingView];
        view_H=view_H+35;
    }
    
    //就餐人数leb
    UILabel  *jiucanLab=[[UILabel alloc]initWithFrame:CGRectMake(10, view_H+30,67, 15)];
    jiucanLab.text=@"就餐人数";
    jiucanLab.textAlignment=NSTextAlignmentLeft;
    jiucanLab.font=DESC_FONT;
    [self.scrollView1 addSubview:jiucanLab];
    
    //就餐人数输入框
    self.textF1=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiucanLab.frame), view_H+25, 120,25)];
    self.textF1.delegate=self;
    self.textF1.placeholder=@"填写就餐人数";
    self.textF1.font=DESC_FONT;
    self.textF1.textAlignment= NSTextAlignmentLeft;
    self.textF1.keyboardType = UIKeyboardTypeNumberPad;
    [self.scrollView1 addSubview:self.textF1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,view_H+57,WIN_WIDTH-10, 1)];
    lineView2.backgroundColor=COLOR_LINE;
    [self.scrollView1 addSubview:lineView2];
    
    //立即领号
    UIButton *linghaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, view_H+75, WIN_WIDTH-20, 40)];
    linghaoBtn.backgroundColor=[UIColor redColor];
    linghaoBtn.layer.masksToBounds=YES;
    linghaoBtn.layer.cornerRadius=5;
    linghaoBtn.titleLabel.font=COMMON_FONT;
    [linghaoBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    [linghaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [linghaoBtn addTarget:self action:@selector(lingquTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:linghaoBtn];
    
    view_H = view_H +135;
    
    //介绍
    UILabel *jieshaoLab=[[UILabel alloc]initWithFrame:CGRectMake(10, view_H, WIN_WIDTH-80, 16)];
    jieshaoLab.textAlignment=NSTextAlignmentLeft;
    jieshaoLab.text=@"* 过号请重新取号，谢谢配合!";
    jieshaoLab.font=DESC_FONT;
    [self.scrollView1 addSubview:jieshaoLab];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    [self.textF1 resignFirstResponder];
}


-(void)lingquTouch:(UIButton*)sender
{
    if ([Util isNull:[Global sharedClient].member_id]) {
        [self isSignIn];
    }else {
        int   num=[self.textF1.text intValue];
        if (num>0 && num<50) {
            int shopid=[_shopID intValue];
            NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(shopid),@"shop_id",[Global sharedClient].member_id,@"member_id",[Global sharedClient].phone,@"phone_num",@(num),@"peoplenum",nil];
            
            [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"getquenenumber"] parameters:diction  target:self success:^(NSDictionary *dic){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",dic);
                  
                    NoLineUpController *nvc=[[NoLineUpController alloc]init];
                    nvc.dataStr=dic[@"data"];
    //                nvc.dataStr=@"305910161";
                    [self.delegate.navigationController pushViewController:nvc animated:YES];
                    [SVProgressHUD dismiss];
                });
            }failue:^(NSDictionary *dic){
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"您输入的人数过多"];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textF1) {
        if (textField.text.length >1){
            self.textF1.text=[textField.text substringToIndex:1];
        }
    }
    return YES;
}

//不用排队

-(void)initheadView_1
{
    UIView   *headView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, 165)];
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(8, 10,150, 16)];
    nameLab.font=COMMON_FONT;
    nameLab.text=shopNameStr;
    nameLab.textAlignment=NSTextAlignmentLeft;
    
    //说明
    UILabel  *shuomingLab=[[UILabel alloc]initWithFrame:CGRectMake(8, 36, 300, 18)];
    shuomingLab.textAlignment=NSTextAlignmentLeft;
    shuomingLab.textColor=COLOR_FONT_SECOND;
    shuomingLab.font=DESC_FONT;
    shuomingLab.text=@"十分抱歉，本店暂不支持在线排队。";
    
    //门店
    
    UILabel   *mendainLab=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(shuomingLab.frame)+5,65 , 16)];
    mendainLab.text=@"门店地址：";
    mendainLab.textAlignment=NSTextAlignmentLeft;
    mendainLab.font=INFO_FONT;
    mendainLab.textColor=COLOR_FONT_SECOND;
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mendainLab.frame), CGRectGetMaxY(shuomingLab.frame)+6, 10, 13)];
    [imgView setImage:[UIImage imageNamed:@"diqu"]];
    
    //地址
    UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+4, CGRectGetMaxY(shuomingLab.frame)+5, 150, 16)];
    dizhiLab.textAlignment=NSTextAlignmentLeft;
    dizhiLab.font=DESC_FONT;
    dizhiLab.text=dizhiStr;
    
    
    
    UIButton *fanhuibtn=[[UIButton alloc]initWithFrame:CGRectMake(8, 127, WIN_WIDTH-16, 36)];
    fanhuibtn.backgroundColor=[UIColor redColor];
    [fanhuibtn setTitle:@"返回" forState:UIControlStateNormal];
    fanhuibtn.layer.masksToBounds=YES;
    fanhuibtn.layer.cornerRadius=5;
    [fanhuibtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fanhuibtn addTarget:self action:@selector(fanhuiTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:nameLab];
    [headView addSubview:shuomingLab];
    [headView addSubview:mendainLab];
    [headView addSubview:imgView];
    [headView addSubview:dizhiLab];
    [headView addSubview:fanhuibtn];
    [self.scrollView1 addSubview:headView];
    
    
}
//不用排队，返回上一层的按钮
-(void)fanhuiTouch:(UIButton*)sender
{
    [self.delegate.navigationController popViewControllerAnimated:YES];
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
