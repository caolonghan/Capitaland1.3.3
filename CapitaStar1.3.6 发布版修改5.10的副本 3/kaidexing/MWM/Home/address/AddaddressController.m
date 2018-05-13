//
//  AddaddressController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AddaddressController.h"
#import "SelectAddressController.h"
#import "ExpressView.h"
#import "DBDeal.h"
#import <sqlite3.h>

@interface AddaddressController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong,nonatomic)UIScrollView   *scrollView1;
@property (strong,nonatomic)UITextField    *nameTextF;//名字
@property (strong,nonatomic)UITextField    *shengTextF;//省份
@property (strong,nonatomic)UITextField    *shiTextF;//市
@property (strong,nonatomic)UITextField    *quTextF;//区
@property (strong,nonatomic)UITextView     *dizhiTextV;//详细地址
@property (strong,nonatomic)UITextField    *youbianTextF;//邮编
@property (strong,nonatomic)UITextField    *phoneTextF;//手机号
@property (strong,nonatomic)UITextField    *emailTextF;//邮箱
@property (strong,nonatomic)UIImageView    *acceptImg;//是否接受订单信息
@property (strong,nonatomic)UIImageView    *defaultImg;//设置为默认收货地址

@end

@implementation AddaddressController
{
    
    CGFloat     scroll_H;//每一次的距上高度
    CGFloat     left_W;  //输入框距左宽度
    CGFloat     textF_W; //输入框的长度
    CGFloat     textF_H; //输入框的高度
    CGFloat     layer_W; //输入框的边框宽度
    BOOL        acceptBool;
    BOOL        defaultBool;
    
    NSArray          *dataAry;
    NSMutableArray   *shengAry;
    NSMutableArray   *shengIDAry;
    NSMutableArray   *shiAry;
    NSMutableArray   *shiIDAry;
    NSMutableArray   *quAry;
    NSMutableArray   *quIDAry;
    
    ExpressView      *eView;
    
    NSString    *shengIdStr;
    NSString    *shiIDStr;
    NSString    *quIDstr;
    UIButton    *baocunBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    shengAry    = [[NSMutableArray alloc]init];
    shengIDAry  = [[NSMutableArray alloc]init];
    shiAry      = [[NSMutableArray alloc]init];
    shiIDAry    = [[NSMutableArray alloc]init];
    quAry       = [[NSMutableArray alloc]init];
    quIDAry     = [[NSMutableArray alloc]init];
    [self shengArrrrry];
    self.navigationBarTitleLabel.text=@"新增收货地址";
    acceptBool=NO;
    defaultBool=NO;
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT);
    self.scrollView1.backgroundColor=UIColorFromRGB(0xffffff);
    self.scrollView1.scrollEnabled=YES;
    [self.view addSubview:self.scrollView1];
    scroll_H=M_WIDTH(19);
    left_W=M_WIDTH(72);
    textF_W=WIN_WIDTH-M_WIDTH(91);
    layer_W=0.5;
    textF_H=M_WIDTH(35);
    [self initView];

}

-(void)initView
{
    //收件人
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0,scroll_H+M_WIDTH(11),M_WIDTH(64),M_WIDTH(15))];
    nameLab.text=@"收件人";
    nameLab.textAlignment=NSTextAlignmentRight;
    nameLab.font=COMMON_FONT;
    [self.scrollView1 addSubview:nameLab];
    
    UIImageView *xing1=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(12),M_WIDTH(2),M_WIDTH(7), M_WIDTH(6))];
    [xing1 setImage:[UIImage imageNamed:@"r_5_star"]];
    [nameLab addSubview:xing1];
    
    self.nameTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W, scroll_H, textF_W, textF_H)];
    self.nameTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.nameTextF.layer.borderWidth=layer_W;
    self.nameTextF.placeholder=@" 姓名";
    self.nameTextF.text=[Util isNil:_nameStr];
    self.nameTextF.delegate=self;
    self.nameTextF.textAlignment=NSTextAlignmentLeft;
    self.nameTextF.font=DESC_FONT;
    [self.scrollView1 addSubview:self.nameTextF];
    scroll_H=scroll_H+M_WIDTH(11)+textF_H;
    
    //地址
    //省
    UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(0, scroll_H+M_WIDTH(11),M_WIDTH(64),M_WIDTH(15))];
    dizhiLab.text=@"地址";
    dizhiLab.textAlignment=NSTextAlignmentRight;
    dizhiLab.font=COMMON_FONT;
    [self.scrollView1 addSubview:dizhiLab];
    
    UIImageView *xing2=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(26),M_WIDTH(2),M_WIDTH(7),M_WIDTH(6))];
    [xing2 setImage:[UIImage imageNamed:@"r_5_star"]];
    [dizhiLab addSubview:xing2];
    
    
    self.shengTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W,scroll_H,(textF_W-M_WIDTH(8))/3,textF_H)];
    self.shengTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.shengTextF.layer.borderWidth=layer_W;
    self.shengTextF.placeholder=@" 省/直辖市";
    self.shengTextF.textAlignment=NSTextAlignmentLeft;
    if (![Util isNull:_shengfenidStr]) {
        self.shengTextF.text=[self id_name:_shengfenidStr :0];
        shengIdStr =_shengfenidStr;
    }
    self.shengTextF.font=DESC_FONT;
    self.shengTextF.delegate=self;
    //图标
    UIImageView *domn1=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(63),M_WIDTH(15.5),M_WIDTH(8),M_WIDTH(4))];
    [domn1 setImage:[UIImage imageNamed:@"sharp"]];
    [self.shengTextF addSubview:domn1];
    [self.scrollView1 addSubview:self.shengTextF];
    
    //市
    self.shiTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W+M_WIDTH(4)+(textF_W-M_WIDTH(8))/3, scroll_H, (textF_W-M_WIDTH(8))/3, textF_H)];
    self.shiTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.shiTextF.layer.borderWidth=layer_W;
    self.shiTextF.placeholder=@" 市";
    self.shiTextF.delegate=self;
    if (![Util isNull:_chengshiidStr]) {
         _shiTextF.text=[self id_name:_chengshiidStr:1];
        shiIDStr= _chengshiidStr;
    }
    self.shiTextF.textAlignment=NSTextAlignmentLeft;
    self.shiTextF.font=DESC_FONT;
    
    //图标
    UIImageView *domn2=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(63),M_WIDTH(15.5),M_WIDTH(8),M_WIDTH(4))];
    [domn2 setImage:[UIImage imageNamed:@"sharp"]];
    [self.shiTextF addSubview:domn2];
    [self.scrollView1 addSubview:self.shiTextF];
    
    //区
    self.quTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W+M_WIDTH(8)+2*(textF_W-M_WIDTH(8))/3, scroll_H, (textF_W-M_WIDTH(8))/3, textF_H)];
    self.quTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.quTextF.layer.borderWidth=layer_W;
    self.quTextF.placeholder=@" 区/县城";
    self.quTextF.delegate=self;
    self.quTextF.textAlignment=NSTextAlignmentLeft;
    self.quTextF.font=DESC_FONT;
    if (![Util isNull:_diquidStr]) {
        self.quTextF.text=[self id_name:_diquidStr :2];
        quIDstr = _diquidStr;
    }
    
    //图标
    UIImageView *domn3=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(63),M_WIDTH(15.5),M_WIDTH(8),M_WIDTH(4))];
    [domn3 setImage:[UIImage imageNamed:@"sharp"]];
    [self.quTextF addSubview:domn3];
    [self.scrollView1 addSubview:self.quTextF];

    for (int i=0; i<3; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((left_W+i*M_WIDTH(4)+i*(textF_W-M_WIDTH(8))/3), scroll_H, (textF_W-M_WIDTH(8))/3,textF_H)];
        btn.tag=i+100;
        [btn addTarget:self action:@selector(textfTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView1 addSubview:btn];
    }
    
    scroll_H=scroll_H+M_WIDTH(11)+textF_H;
    
    //详细地址
    
    self.dizhiTextV=[[UITextView alloc]initWithFrame:CGRectMake(left_W, scroll_H, textF_W, M_WIDTH(65))];
    self.dizhiTextV.delegate=self;
    self.dizhiTextV.textAlignment=NSTextAlignmentLeft;
    self.dizhiTextV.font=COMMON_FONT;
    self.dizhiTextV.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.dizhiTextV.layer.borderWidth=layer_W;
    if (![Util isNull:_xiangxiStr]) {
       self.dizhiTextV.text=_xiangxiStr;
    }
    [self.scrollView1 addSubview:self.dizhiTextV];
    
    scroll_H=scroll_H+M_WIDTH(76);

    //邮编
    
    UILabel *youbianLab=[[UILabel alloc]initWithFrame:CGRectMake(0,scroll_H+M_WIDTH(11),M_WIDTH(64),M_WIDTH(15))];
    youbianLab.text=@"邮编";
    youbianLab.textAlignment=NSTextAlignmentRight;
    youbianLab.font=COMMON_FONT;
    [self.scrollView1 addSubview:youbianLab];
    
    self.youbianTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W, scroll_H, textF_W, textF_H)];
    self.youbianTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.youbianTextF.layer.borderWidth=layer_W;
    self.youbianTextF.delegate=self;
    self.youbianTextF.textAlignment=NSTextAlignmentLeft;
    self.youbianTextF.font=DESC_FONT;
    if (![Util isNull:_youzhengStr]) {
        self.youbianTextF.text=_youzhengStr;
    }
    [self.scrollView1 addSubview:self.youbianTextF];
    scroll_H =scroll_H+11+textF_H;
    
    
    //手机
    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(0, scroll_H+M_WIDTH(11),M_WIDTH(64),M_WIDTH(15))];
    phoneLab.text=@"手机";
    phoneLab.textAlignment=NSTextAlignmentRight;
    phoneLab.font=COMMON_FONT;
    [self.scrollView1 addSubview:phoneLab];
    
    UIImageView *xing3=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(26),M_WIDTH(2),M_WIDTH(7),M_WIDTH(6))];
    [xing3 setImage:[UIImage imageNamed:@"r_5_star"]];
    [phoneLab addSubview:xing3];
    
    self.phoneTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W, scroll_H, textF_W, textF_H)];
    self.phoneTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.phoneTextF.layer.borderWidth=layer_W;
    self.phoneTextF.delegate=self;
    self.phoneTextF.textAlignment=NSTextAlignmentLeft;
    self.phoneTextF.font=DESC_FONT;
    if (![Util isNull:_shoujihaoStr]) {
        self.phoneTextF.text=_shoujihaoStr;
    }
    
    [self.scrollView1 addSubview:self.phoneTextF];
    scroll_H =scroll_H+M_WIDTH(11)+textF_H;
    
    //邮箱
    UILabel *emailLab=[[UILabel alloc]initWithFrame:CGRectMake(0,scroll_H+M_WIDTH(11),M_WIDTH(64),M_WIDTH(15))];
    emailLab.text=@"邮箱";
    emailLab.textAlignment=NSTextAlignmentRight;
    emailLab.font=COMMON_FONT;
    [self.scrollView1 addSubview:emailLab];
    
    self.emailTextF=[[UITextField alloc]initWithFrame:CGRectMake(left_W, scroll_H, textF_W, textF_H)];
    self.emailTextF.layer.borderColor=[COLOR_FONT_SECOND CGColor];
    self.emailTextF.layer.borderWidth=layer_W;
    self.emailTextF.delegate=self;
    self.emailTextF.textAlignment=NSTextAlignmentLeft;
    self.emailTextF.font=DESC_FONT;
    if (![Util isNull:_youxiang_str]) {
        self.emailTextF.text=[Util isNil:_youxiang_str];
    }
    
    [self.scrollView1 addSubview:self.emailTextF];
    scroll_H =scroll_H+M_WIDTH(11)+textF_H;
    
    //是否接受订单信息
    
    //模仿小方框 是否接受订单信息
    self.acceptImg=[[UIImageView alloc]initWithFrame:CGRectMake(left_W,scroll_H+M_WIDTH(4),M_WIDTH(12),M_WIDTH(12))];
    if ([Util isNull:_shoujihaoStr]) {
        [self.acceptImg setImage:[UIImage imageNamed:@"square"]];
    }else{
        int isjie=[_is_jieshouStr intValue];
        if ( isjie==1) {
            acceptBool=YES;
            [self.acceptImg setImage:[UIImage imageNamed:@"r_tick"]];
        }else{
            [self.acceptImg setImage:[UIImage imageNamed:@"square"]];
        }
    }
    
    
    [self.scrollView1 addSubview:self.acceptImg];
    
    UILabel *acceptLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.acceptImg.frame)+M_WIDTH(3), scroll_H, M_WIDTH(200), M_WIDTH(20))];
    acceptLab.textAlignment=NSTextAlignmentLeft;
    acceptLab.font=DESC_FONT;
    acceptLab.text=@"是否接受订单信息";
    [self.scrollView1 addSubview:acceptLab];

    //是否接受订单信息
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(left_W, scroll_H,M_WIDTH(130),M_WIDTH(20))];
    [btn1 addTarget:self action:@selector(jieshouTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:btn1];
    
    scroll_H=scroll_H+M_WIDTH(25);
    
    //模仿小方框 设置为默认收货地址
    self.defaultImg=[[UIImageView alloc]initWithFrame:CGRectMake(left_W,scroll_H+M_WIDTH(4),M_WIDTH(12),M_WIDTH(12))];
    if ([Util isNull:_is_morenStr]) {
        [self.defaultImg setImage:[UIImage imageNamed:@"square"]];
    }else{
        int ismo=[_is_morenStr intValue];
        if (ismo==1) {
            defaultBool=YES;
            [self.defaultImg setImage:[UIImage imageNamed:@"r_tick"]];
        }else {
            [self.defaultImg setImage:[UIImage imageNamed:@"square"]];
        }
    }
    
   
    [self.scrollView1 addSubview:self.defaultImg];
    
    UILabel *defaLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.defaultImg.frame)+M_WIDTH(3), scroll_H, M_WIDTH(200), M_WIDTH(20))];
    defaLab.textAlignment=NSTextAlignmentLeft;
    defaLab.font=DESC_FONT;
    defaLab.text=@"设置为默认收货地址";
    [self.scrollView1 addSubview:defaLab];
    
    //设置为默认收货地址
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(left_W, scroll_H,M_WIDTH(150),M_WIDTH(20))];
    [btn2 addTarget:self action:@selector(morenTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:btn2];
    
    scroll_H=scroll_H+M_WIDTH(37);
    
    //保存按钮
    baocunBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(10),scroll_H,WIN_WIDTH-M_WIDTH(20),M_WIDTH(38))];
    baocunBtn.backgroundColor=APP_BTN_COLOR;
    [baocunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baocunBtn setTitle:@"保存" forState:UIControlStateNormal];
    baocunBtn.layer.masksToBounds=YES;
    baocunBtn.layer.cornerRadius=5;
    [baocunBtn addTarget:self action:@selector(bancunTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:baocunBtn];
}


//点击了是否接受订单信息
-(void)jieshouTouch:(UIButton*)sender
{
    if (acceptBool==NO) {
        acceptBool=YES;
        [self.acceptImg setImage:[UIImage imageNamed:@"r_tick"]];
    }else {
        acceptBool=NO;
        [self.acceptImg setImage:[UIImage imageNamed:@"square"]];
    }
}

//点击设置为默认收货地址
-(void)morenTouch:(UIButton*)sender
{
    if (defaultBool==NO) {
        defaultBool=YES;
        [self.defaultImg setImage:[UIImage imageNamed:@"r_tick"]];
    }else {
        defaultBool=NO;
        [self.defaultImg setImage:[UIImage imageNamed:@"square"]];
    }
    
}

//点击了保存按钮
-(void)bancunTouch:(UIButton*)sender
{
//    NSLog(@"点击了保存");
//    if ([Util isNull:_nameTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人姓名为空"];
//        
//    }else if ([Util isNull:_shengTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人省份为空"];
//        
//    }else if ([Util isNull:_shiTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人城市为空"];
//        
//    }else if ([Util isNull:_quTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人区/县为空"];
//        
//    }else if ([Util isNull:_dizhiTextV.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人详细地址为空"];
//        
//    }else if ([Util isNull:_youbianTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人邮编为空"];
//        
//    }else if ([Util isNull:_phoneTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人手机号为空"];
//        
//    }else if ([Util isNull:_emailTextF.text]) {
//        
//        [SVProgressHUD showErrorWithStatus:@"收件人邮箱为空"];
//        
//    }else{
//        

//        NSString *nameStr=_nameTextF.text;
//        NSString *youbianStr=_youbianTextF.text;//邮编
//        NSString *phoneStr=_phoneTextF.text;
//        NSString *emailStr=_emailTextF.text;//邮箱
//        NSString *dizhiStr=[NSString stringWithFormat:@"%@ %@ %@ %@",_shengTextF.text,_shiTextF.text,_quTextF.text,_dizhiTextV.text];
    
    
        NSString *nameStr=@"11";
        NSString *youbianStr=@"11";//邮编
        NSString *phoneStr=@"11111111111";
        NSString *dizhiStr=@"11";
        NSString *emailStr=@"youxiang";
    
        int  shengint= [shengIdStr intValue];
        int  shiint  = [shiIDStr intValue];
        int  quint   = [quIDstr intValue];
        
        NSString  *isInformation;//是否希望收取优惠信息? 是否接受订单信息
        NSString  *isDefault;//是否设置成默认地址
        if (acceptBool==NO) {
            isInformation=@"0";
        }else {
            isInformation=@"1";
        }
        if (defaultBool==NO) {
            isDefault=@"0";
        }else {
            isDefault=@"1";
        }
    

        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nameStr,@"name",_typeStr,@"id",@(shengint),@"province",@(shiint),@"city",@(quint),@"area",dizhiStr,@"address",youbianStr,@"postCode",phoneStr,@"telephone",isInformation,@"isInformation",isDefault,@"isDefault",emailStr,@"email",@"1000", @"source", nil];
        [SVProgressHUD showWithStatus:@"数据加载中"];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"addaddress"] parameters:params target:self success:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",dic);
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"添加地址成功"];
                [self.delegate.navigationController popViewControllerAnimated:YES];
            });
        } failue:^(NSDictionary *dic) {
            
        }];
}

-(void)yicangkey
{
    [self.nameTextF     resignFirstResponder];
    [self.dizhiTextV    resignFirstResponder];
    [self.emailTextF    resignFirstResponder];
    [self.phoneTextF    resignFirstResponder];
    [self.youbianTextF  resignFirstResponder];
}


-(void)textfTouch:(UIButton*)sender
{
    [self yicangkey];
    switch (sender.tag) {
        case 100:
            NSLog(@"点击了省");
           
            [self createPickerView:shengAry : shengIDAry :@"1"];
            break;
         case 101:
             NSLog(@"点击了市");
            [self createPickerView:shiAry   : shiIDAry   :@"2"];
            break;
         case 102:
             NSLog(@"点击了区");
            [self createPickerView:quAry    : quIDAry    :@"3"];
            break;
        default:
            break;
    }
}
-(void)shengArrrrry
{
    NSArray      *array=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@",@" where type = 0"]];
    for (NSDictionary *dic in array) {
            NSString *name=dic[@"name"];
            NSString *cityid=dic[@"id"];
            [shengAry addObject:name];
            [shengIDAry addObject:cityid];
        }
}

-(void)setTouch:(id)exTouch
{
    [eView removeFromSuperview];
    NSArray *array=exTouch;
    NSString *tyepstr=array[0];
    if ([tyepstr isEqualToString:@"1"]) {
        if ([_shengTextF.text isEqualToString:@""] || [_shengTextF.text isEqualToString:[NSString stringWithFormat:@" %@",array[1]]]) {
        }else {
            _shiTextF.text=@"";
            _quTextF.text=@"";
            shiIDStr=@"";
            quIDstr=@"";
            [shiAry     removeAllObjects];
            [shiIDAry   removeAllObjects];
            [quAry      removeAllObjects];
            [quIDAry    removeAllObjects];
        }
        _shengTextF.text=[NSString stringWithFormat:@" %@",array[1]];
        shengIdStr      =array[2];
        NSMutableDictionary *dic=[self shaixuan:array[2]];
        shiAry          =[dic objectForKey:@"cityName"];
        shiIDAry        =[dic objectForKey:@"cityID"];
        
    }else if ([tyepstr isEqualToString:@"2"]) {
        if ([_shiTextF.text isEqualToString:@""] || [NSString stringWithFormat:@" %@",array[1]]) {
        }else {
            _quTextF.text=@"";
            quIDstr      =@"";
            [quAry   removeAllObjects];
            [quIDAry removeAllObjects];
        }
        NSMutableDictionary *dic=[self shaixuan:array[2]];
        quAry   = [dic objectForKey:@"cityName"];
        quIDAry = [dic objectForKey:@"cityID"];
        _shiTextF.text=[NSString stringWithFormat:@" %@",array[1]];
        shiIDStr = array[2];
        
    }else if ([tyepstr isEqualToString:@"3"]) {
        _quTextF.text = [NSString stringWithFormat:@" %@",array[1]];
        quIDstr       = array[2];
    }
}


//选择地区的view PickerView
-(void)createPickerView:(NSMutableArray*)nameArray :(NSMutableArray*)idArray :(NSString*)index
{
    if (nameArray.count==0) {
        return;
    }
    CGFloat  view_hh=M_WIDTH(150);
    eView=[[ExpressView alloc]initWithFrame:CGRectMake(M_WIDTH(10), WIN_HEIGHT-view_hh, WIN_WIDTH-M_WIDTH(20), view_hh)];
    eView.layer.masksToBounds=YES;
    eView.layer.cornerRadius=8;
    eView.backgroundColor=UIColorFromRGB(0xf6f6f6);
    eView.exDelegate=self;
    eView.dataAry=nameArray;
    eView.idArray=idArray;
    eView.titleStr=@"省份";
    eView.typeStr=index;
    [self.view addSubview: eView];
    
}

//点击输入框的触发事件
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==_shengTextF || textField==_shiTextF || textField==_quTextF) {
        
        
    }
    
    NSLog(@"点击了textf");
}
//点击输入框弹出键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL  zhuangtai;
    if (textField==_shengTextF || textField==_shiTextF || textField==_quTextF) {
        zhuangtai=NO;
    }else{
        zhuangtai=YES;
    }
    return zhuangtai;
}

-(NSMutableDictionary*)shaixuan:(NSString *)str
{
    NSMutableArray *nameAry=[[NSMutableArray alloc]init];
    NSMutableArray *idary  =[[NSMutableArray alloc]init];
    int pidd=[str intValue];
    NSArray      *array=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@",@""]];
    for (NSDictionary *dic in array) {
        int type=[dic[@"pid"]intValue];
        if (type==pidd) {
            NSString *name=dic[@"name"];
            NSString *cityid=dic[@"id"];
            [nameAry addObject:name];
            [idary addObject:cityid];
        }
    }
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:nameAry forKey:@"cityName"];
    [dic setObject:idary   forKey:@"cityID"];
    return dic;
}


//根据id得到对应的城市名字
-(NSString*)id_name:(NSString *)str :(int)type
{

    NSArray      *array=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@ %@",@" where  id = ",str]];
    NSDictionary *dic=array[0];
    NSString     *name=dic[@"name"];
    NSString     *pid =dic[@"pid"];
    if (type==0) {
        
//        NSArray *array1=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@",@" where type = 0"]];
//        for (NSDictionary *diction in array1) {
//            NSString *name=diction[@"name"];
//            NSString *ids =diction[@"id"];
//            [shengAry   addObject:name];
//            [shengIDAry addObject:ids];
//        }
        
    }else if(type==1){
        NSArray *array1=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@ %@",@" where pid = ",pid]];
        for (NSDictionary *diction in array1) {
            NSString *name=diction[@"name"];
            NSString *ids =diction[@"id"];
            [shiAry   addObject:name];
            [shiIDAry addObject:ids];
        }
    }else if(type==2){
        NSArray *array1=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@ %@",@" where pid = ",pid]];
        for (NSDictionary *diction in array1) {
            NSString *name=diction[@"name"];
            NSString *ids =diction[@"id"];
            [quAry   addObject:name];
            [quIDAry addObject:ids];
        }
    }
    
    return name;
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
