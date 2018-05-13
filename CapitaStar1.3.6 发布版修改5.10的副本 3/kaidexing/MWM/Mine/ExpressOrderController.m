//
//  ExpressOrderController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/22.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ExpressOrderController.h"
#import "ExpressView.h"
#import "GoViewController.h"

#define TEXTFIELD_H    M_WIDTH(32)
#define VIEW_TOP       M_WIDTH(10)
#define FromTheLeft    M_WIDTH(15)
#define VIEW_length    WIN_WIDTH-M_WIDTH(30)
#define VIEW_length_S  (VIEW_length-M_WIDTH(11))/3

@interface ExpressOrderController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong,nonatomic)UIScrollView    *scrollView1;
@property (strong,nonatomic)NSArray         *serveAry;
@property (strong,nonatomic)NSMutableArray  *dataAry;
@property (strong,nonatomic)NSMutableArray  *shengAry;
@property (strong,nonatomic)NSMutableArray  *shengIDAry;

@property (strong,nonatomic)NSMutableArray  *cityAry;
@property (strong,nonatomic)NSMutableArray  *cityIDAry;
@property (strong,nonatomic)NSMutableArray  *quAry;
@property (strong,nonatomic)NSMutableArray  *quIDAry;

@property (strong,nonatomic)NSMutableArray  *cityAry_2;
@property (strong,nonatomic)NSMutableArray  *cityIDAry_2;
@property (strong,nonatomic)NSMutableArray  *quAry_2;
@property (strong,nonatomic)NSMutableArray  *quIDAry_2;

@end

@implementation ExpressOrderController
{
    UIView   *fuwuView;//保存服务介绍
    UIView   *choiceView;//选择同城或者非同城
    UIView   *sendOutView;//寄件人信息
    UIView   *collectView;//收件人信息
    UIView   *ContentView;//快递内容
    //选择配送范围的控件
    UIImageView     *xuanzeImg_1;
    UIImageView     *xuanzeImg_2;
    UILabel         *xuanzeLab_1;
    UILabel         *xuanzeLab_2;
    UIView          *xuanzeView_1;
    UIView          *xuanzeView_2;
    
    //寄件人textF
    UITextField     *sendNameText;
    UITextField     *sendPhoneText;
    UITextField     *sendProvinceText;
    UITextField     *sendAddressText;
    UITextField     *sendZipCodeText;
    UITextField     *sendCityText;
    UITextField     *sendDistrictText;
    
    NSString        *prov_1;
    NSString        *city_1;
    NSString        *dictr_1;
   
    NSString        *prov_2;
    NSString        *city_2;
    NSString        *dictr_2;
    
    //收件人textF
    UITextField     *collectNameText;
    UITextField     *collectPhoneText;
    UITextField     *collectProvinceText;
    UITextField     *collectAddressText;
    UITextField     *collectZipCodeText;
    UITextField     *collectCityText;
    UITextField     *collectDistrictText;
    
    ExpressView     *eView;
    UITextView      *contentText;
    UIButton        *btn;
    UILabel         *placeholderLabel;
    int             serve_type;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"快递服务";
    self.serveAry       =[[NSArray alloc]init];
    self.shengAry       =[[NSMutableArray alloc]init];
    self.shengIDAry     =[[NSMutableArray alloc]init];
    self.cityAry        =[[NSMutableArray alloc]init];
    self.cityIDAry      =[[NSMutableArray alloc]init];
    self.quAry          =[[NSMutableArray alloc]init];
    self.quIDAry        =[[NSMutableArray alloc]init];
    
    self.cityAry_2      =[[NSMutableArray alloc]init];
    self.cityIDAry_2    =[[NSMutableArray alloc]init];
    self.quAry_2        =[[NSMutableArray alloc]init];
    self.quIDAry_2      =[[NSMutableArray alloc]init];
    
    self.scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.backgroundColor=[UIColor whiteColor];
    self.scrollView1.delegate=self;
    self.scrollView1.scrollEnabled=YES;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.8);
    [self.view addSubview:self.scrollView1];
    [self roadDate];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    self.dataAry =[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    NSLog(@"%@", self.dataAry);//直接打印数据。
    for (NSDictionary *dic in self.dataAry) {
        int type=[dic[@"type"]intValue];
        if (type==0) {
            NSString *name=dic[@"name"];
            NSString *cityid=dic[@"id"];
            [self.shengAry addObject:name];
            [self.shengIDAry addObject:cityid];
        }
    }
    
}


-(void)roadDate
{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"express"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@"4",@"mall_id",nil ] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            self.serveAry=dic[@"data"][@"deliveryRange"];
            [self initHeadView];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}


-(void)initHeadView
{
    //顶部的Logo
    UIImageView     *headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(100))];
    [headImg setImage:[UIImage imageNamed:@"banner"]];
    [self.scrollView1 addSubview:headImg];
    
    //服务说明View
    fuwuView=[[UIView alloc]init];
    
    UILabel *fuwuLab=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft, M_WIDTH(15), M_WIDTH(100), M_WIDTH(17))];
    fuwuLab.text=@"服务说明";
    fuwuLab.textAlignment=NSTextAlignmentLeft;
    fuwuLab.font=COMMON_FONT;
    [fuwuView addSubview:fuwuLab];
    
    UILabel  *shuoming_1=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft, CGRectGetMaxY(fuwuLab.frame)+M_WIDTH(8), VIEW_length, M_WIDTH(48))];
    NSString * cLabelString=@"为了更好地服务顾客，我们现在退出快递服务，立即兑换服务，凯德帮您送回家";
    [self labjianju:shuoming_1 :cLabelString];
    shuoming_1.frame=CGRectMake(FromTheLeft, CGRectGetMaxY(fuwuLab.frame)+M_WIDTH(8), VIEW_length, M_WIDTH(48));
    [fuwuView addSubview:shuoming_1];
    
    UILabel *shuoming_2=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft, CGRectGetMaxY(shuoming_1.frame)+M_WIDTH(14), VIEW_length, M_WIDTH(48))];
    NSString *shuoimgStr2=@"目前我们支持同城/非同城（仅限国内）的派送，派送仅限小件商品，暂不支持大件商品的派送，请见谅";
    [self labjianju:shuoming_2 :shuoimgStr2];
    [fuwuView addSubview:shuoming_2];
    
    UILabel *shuoming_3=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft, CGRectGetMaxY(shuoming_2.frame)+M_WIDTH(14), M_WIDTH(85), M_WIDTH(14))];
    shuoming_3.text=@"* 派送商品说明:";
    shuoming_3.textColor=COLOR_FONT_SECOND;
    shuoming_3.font=DESC_FONT;
    CGRect rect4=[shuoming_3.text boundingRectWithSize:CGSizeMake(M_WIDTH(120),M_WIDTH(14)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:shuoming_3.font} context:nil];
    shuoming_3.frame=CGRectMake(shuoming_3.frame.origin.x, shuoming_3.frame.origin.y, rect4.size.width, rect4.size.height);
    [fuwuView addSubview:shuoming_3];
    if (IS_IPHONE5_LATER) {
        UILabel *shuoming_4=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft+shuoming_3.frame.size.width+M_WIDTH(5), CGRectGetMaxY(shuoming_2.frame)+M_WIDTH(14),M_WIDTH(200), M_WIDTH(14))];
        shuoming_4.text=@"物品重量不超过xxKG,体积不";
        shuoming_4.textAlignment=NSTextAlignmentLeft;
        shuoming_4.font=DESC_FONT;
        [shuoming_4 sizeToFit];
        [fuwuView addSubview:shuoming_4];
        
        UILabel *shuoming_6=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft,CGRectGetMaxY(shuoming_3.frame)+M_WIDTH(10),M_WIDTH(200), M_WIDTH(14))];
        shuoming_6.text=@"超过xxM";
        shuoming_6.textAlignment=NSTextAlignmentLeft;
        shuoming_6.font=DESC_FONT;
        [shuoming_6 sizeToFit];
        [fuwuView addSubview:shuoming_6];
        
        UILabel *shuoming_5=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shuoming_6.frame), CGRectGetMaxY(shuoming_3.frame)+M_WIDTH(7),M_WIDTH(8), M_WIDTH(8))];
        shuoming_5.text=@"3";
        [shuoming_5 sizeToFit];
        shuoming_5.textAlignment=NSTextAlignmentLeft;
        shuoming_5.font=[UIFont systemFontOfSize:8];
        [fuwuView addSubview:shuoming_5];
        CGFloat henad_H=CGRectGetMaxY(shuoming_6.frame)+M_WIDTH(15);
        fuwuView.frame=CGRectMake(0, CGRectGetMaxY(headImg.frame), WIN_WIDTH,henad_H);
        
    }else{
        UILabel *shuoming_4=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft+shuoming_3.frame.size.width+M_WIDTH(5), CGRectGetMaxY(shuoming_2.frame)+M_WIDTH(14),M_WIDTH(200), M_WIDTH(14))];
        shuoming_4.text=@"物品重量不超过xxKG,体积不超过xxM";
        shuoming_4.textAlignment=NSTextAlignmentLeft;
        shuoming_4.font=DESC_FONT;
        [shuoming_4 sizeToFit];
        [fuwuView addSubview:shuoming_4];

        UILabel *shuoming_5=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shuoming_4.frame), CGRectGetMaxY(shuoming_2.frame)+M_WIDTH(10),M_WIDTH(8), M_WIDTH(8))];
        shuoming_5.text=@"3";
        [shuoming_5 sizeToFit];
        shuoming_5.textAlignment=NSTextAlignmentLeft;
        shuoming_5.font=[UIFont systemFontOfSize:8];
        [fuwuView addSubview:shuoming_5];

        CGFloat henad_H=CGRectGetMaxY(shuoming_3.frame)+M_WIDTH(15);
        fuwuView.frame=CGRectMake(0, CGRectGetMaxY(headImg.frame), WIN_WIDTH,henad_H);
    }
    [self.scrollView1 addSubview:fuwuView];
    [self initchoiceView];
        
}

//选择同城
-(void)initchoiceView
{
    NSDictionary *dic1=self.serveAry[0];
    NSDictionary *dic2=self.serveAry[1];
    
    serve_type=[[Util isNil:dic1[@"serve_type"]]intValue];
    
    choiceView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fuwuView.frame), WIN_WIDTH, M_WIDTH(102))];
    UIView *view1=[self redView_titleLab:@"选择配送范围"];
    view1.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(28));
    [choiceView addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view1.frame)+M_WIDTH(5), WIN_WIDTH, M_WIDTH(27))];
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(FromTheLeft, M_WIDTH(8), M_WIDTH(12), M_WIDTH(12))];
    colorView.backgroundColor=[UIColor whiteColor];
    colorView.layer.borderColor=[COLOR_LINE CGColor];
    colorView.layer.borderWidth=M_WIDTH(1);
    colorView.layer.masksToBounds=YES;
    colorView.layer.cornerRadius=colorView.frame.size.height/2;
    [view2 addSubview:colorView];
    
    
    xuanzeImg_1=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(2.5), M_WIDTH(2.5), M_WIDTH(7), M_WIDTH(7))];
    xuanzeImg_1.backgroundColor=[UIColor redColor];
    xuanzeImg_1.layer.masksToBounds=YES;
    xuanzeImg_1.layer.cornerRadius=xuanzeImg_1.frame.size.height/2;
    [colorView addSubview:xuanzeImg_1];
    
    
    xuanzeLab_1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colorView.frame)+M_WIDTH(6), 0,M_WIDTH(150), M_WIDTH(27))];
    xuanzeLab_1.text=[Util isNil:dic1[@"name"]];
    xuanzeLab_1.textAlignment=NSTextAlignmentLeft;
    xuanzeLab_1.textColor=[UIColor blackColor];
    xuanzeLab_1.font=DESC_FONT;
    [view2 addSubview:xuanzeLab_1];
    
    UILabel *jifenLab_1=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(165),0,M_WIDTH(150),M_WIDTH(27))];
    jifenLab_1.textColor=[UIColor redColor];
    jifenLab_1.textAlignment=NSTextAlignmentRight;
    int jifenint=[[Util isNil:dic1[@"cost"]]intValue];
    jifenLab_1.text=[NSString stringWithFormat:@"%d%@",jifenint,@"积分"];
    jifenLab_1.font=DESC_FONT;
    [view2 addSubview:jifenLab_1];
    
    xuanzeView_1=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(165),0,M_WIDTH(150),M_WIDTH(27))];
    xuanzeView_1.backgroundColor=[UIColor whiteColor];
    xuanzeView_1.alpha=0;
    [view2 addSubview:xuanzeView_1];
    
    //
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(view2.frame)+M_WIDTH(5), WIN_WIDTH, M_WIDTH(27))];
    
    UIView *colorView2=[[UIView alloc]initWithFrame:CGRectMake(FromTheLeft, M_WIDTH(8), M_WIDTH(12), M_WIDTH(12))];
    colorView2.backgroundColor=[UIColor whiteColor];
    colorView2.layer.borderColor=[COLOR_LINE CGColor];
    colorView2.layer.borderWidth=M_WIDTH(1);
    colorView2.layer.masksToBounds=YES;
    colorView2.layer.cornerRadius=colorView2.frame.size.height/2;
    [view3 addSubview:colorView2];
    
    
    xuanzeImg_2=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(2.5), M_WIDTH(2.5), M_WIDTH(7), M_WIDTH(7))];
    xuanzeImg_2.backgroundColor=[UIColor whiteColor];
    xuanzeImg_2.layer.masksToBounds=YES;
    xuanzeImg_2.layer.cornerRadius=xuanzeImg_1.frame.size.height/2;
    [colorView2 addSubview:xuanzeImg_2];
    
    xuanzeLab_2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colorView2.frame)+M_WIDTH(6), 0,M_WIDTH(150), M_WIDTH(27))];
    xuanzeLab_2.text=[Util isNil:dic2[@"name"]];
    xuanzeLab_2.textAlignment=NSTextAlignmentLeft;
    xuanzeLab_2.textColor=COLOR_FONT_SECOND;
    xuanzeLab_2.font=DESC_FONT;
    [view3 addSubview:xuanzeLab_2];
    
    UILabel *jifenLab_2=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(165),0,M_WIDTH(150),M_WIDTH(27))];
    jifenLab_2.textColor=[UIColor redColor];
    jifenLab_2.textAlignment=NSTextAlignmentRight;
    int jifenint2=[[Util isNil:dic2[@"cost"]]intValue];
    jifenLab_2.text=[NSString stringWithFormat:@"%d%@",jifenint2,@"积分"];
    jifenLab_2.font=DESC_FONT;
    [view3 addSubview:jifenLab_2];
    
    xuanzeView_2=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(165),0,M_WIDTH(150),M_WIDTH(27))];
    xuanzeView_2.backgroundColor=[UIColor whiteColor];
    xuanzeView_2.alpha=0.5;
    [view3 addSubview:xuanzeView_2];
    
    UITapGestureRecognizer *tapGes2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event2:)];
    [view2 addGestureRecognizer:tapGes2];
    UITapGestureRecognizer *tapGes3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event3:)];
    [view3 addGestureRecognizer:tapGes3];
    
    [choiceView addSubview:view2];
    [choiceView addSubview:view3];
    [self.scrollView1 addSubview:choiceView];
    [self initsendOutView];
}

//寄件人
-(void)initsendOutView
{
    sendOutView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(choiceView.frame),WIN_WIDTH,M_WIDTH(253))];
    UIView *view1=[self redView_titleLab:@"填写寄件人信息"];
    view1.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(28));
    [sendOutView addSubview:view1];
    
    sendNameText=[[UITextField alloc]init];
    UIView *nameView=[self textfield_w:sendNameText :@"姓名" :0];
    nameView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(view1.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [sendOutView addSubview:nameView];
    
    sendPhoneText=[[UITextField alloc]init];
    UIView *phoneView=[self textfield_w:sendPhoneText :@"手机" :0];
    phoneView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(nameView.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [sendOutView addSubview:phoneView];
    
    sendProvinceText=[[UITextField alloc]init];
    UIView *provinceView=[self textfield_w:sendProvinceText :@"省/直辖市" :1];
    provinceView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(phoneView.frame)+VIEW_TOP,VIEW_length_S,TEXTFIELD_H);
    [sendOutView addSubview:provinceView];
    
    sendCityText=[[UITextField alloc]init];
    UIView *cityView=[self textfield_w:sendCityText :@"市" :1];
    cityView.frame=CGRectMake(CGRectGetMaxX(provinceView.frame)+M_WIDTH(5.5),CGRectGetMaxY(phoneView.frame)+VIEW_TOP,VIEW_length_S,TEXTFIELD_H);
    [sendOutView addSubview:cityView];
    
    sendDistrictText=[[UITextField alloc]init];
    UIView *puView=[self textfield_w:sendDistrictText :@"区/县城" :1];
    puView.frame=CGRectMake(CGRectGetMaxX(cityView.frame)+M_WIDTH(5.5),CGRectGetMaxY(phoneView.frame)+VIEW_TOP,VIEW_length_S,TEXTFIELD_H);
    [sendOutView addSubview:puView];
    
    sendAddressText=[[UITextField alloc]init];
    UIView *addressView=[self textfield_w:sendAddressText :@"详细地址" :0];
    addressView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(provinceView.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [sendOutView addSubview:addressView];
    
    sendZipCodeText=[[UITextField alloc]init];
    UIView *zipView=[self textfield_w:sendZipCodeText :@"邮编" :0];
    zipView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(addressView.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [sendOutView addSubview:zipView];

    
    [self.scrollView1 addSubview:sendOutView];
    [self initcollectView];
}

//收件人
-(void)initcollectView
{
    collectView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(sendOutView.frame),WIN_WIDTH,M_WIDTH(253))];
    UIView *view1=[self redView_titleLab:@"填写寄件人信息"];
    view1.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(28));
    [collectView addSubview:view1];
    
    collectNameText=[[UITextField alloc]init];
    UIView *nameView=[self textfield_w:collectNameText :@"姓名" :0];
    nameView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(view1.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [collectView addSubview:nameView];
    
    collectPhoneText=[[UITextField alloc]init];
    UIView *phoneView=[self textfield_w:collectPhoneText :@"手机" :0];
    phoneView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(nameView.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [collectView addSubview:phoneView];
    
    collectProvinceText=[[UITextField alloc]init];
    UIView *provinceView=[self textfield_w:collectProvinceText :@"省/直辖市" :1];
    provinceView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(phoneView.frame)+VIEW_TOP,VIEW_length_S,TEXTFIELD_H);
    [collectView addSubview:provinceView];
    
    collectCityText=[[UITextField alloc]init];
    UIView *cityView=[self textfield_w:collectCityText :@"市" :1];
    cityView.frame=CGRectMake(CGRectGetMaxX(provinceView.frame)+M_WIDTH(5.5),CGRectGetMaxY(phoneView.frame)+VIEW_TOP,VIEW_length_S,TEXTFIELD_H);
    [collectView addSubview:cityView];
    
    collectDistrictText=[[UITextField alloc]init];
    UIView *puView=[self textfield_w:collectDistrictText :@"区/县城" :1];
    puView.frame=CGRectMake(CGRectGetMaxX(cityView.frame)+M_WIDTH(5.5),CGRectGetMaxY(phoneView.frame)+VIEW_TOP,VIEW_length_S,TEXTFIELD_H);
    [collectView addSubview:puView];
    
    collectAddressText=[[UITextField alloc]init];
    UIView *addressView=[self textfield_w:collectAddressText :@"详细地址" :0];
    addressView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(provinceView.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [collectView addSubview:addressView];
    
    collectZipCodeText=[[UITextField alloc]init];
    UIView *zipView=[self textfield_w:collectZipCodeText :@"邮编" :0];
    zipView.frame=CGRectMake(FromTheLeft,CGRectGetMaxY(addressView.frame)+VIEW_TOP,VIEW_length,TEXTFIELD_H);
    [collectView addSubview:zipView];
    
    [self.scrollView1 addSubview:collectView];
    [self initContentDetailsView];
}

-(void)initContentDetailsView
{
    ContentView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(collectView.frame),WIN_WIDTH,M_WIDTH(133))];
    UIView *view1=[self redView_titleLab:@"填写快递内容"];
    view1.frame=CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(28));
    [ContentView addSubview:view1];
    
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(15),CGRectGetMaxY(view1.frame)+VIEW_TOP,WIN_WIDTH-M_WIDTH(30),M_WIDTH(75))];
    view2.backgroundColor=UIColorFromRGB(0xf2f2f2);
    view2.layer.masksToBounds=YES;
    view2.layer.cornerRadius=5;
    placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(9),M_WIDTH(9),M_WIDTH(150),M_WIDTH(15))];
    placeholderLabel.text=@"快递内容详情...";
    placeholderLabel.textColor=COLOR_FONT_SECOND;
    placeholderLabel.textAlignment=NSTextAlignmentLeft;
    placeholderLabel.font=DESC_FONT;
    [view2 addSubview:placeholderLabel];
    
    contentText=[[UITextView alloc]initWithFrame:CGRectMake(M_WIDTH(5),M_WIDTH(4), view2.frame.size.width-M_WIDTH(18), view2.frame.size.height-M_WIDTH(18))];
    contentText.textAlignment=NSTextAlignmentLeft;
    contentText.backgroundColor=[UIColor clearColor];
    contentText.delegate=self;
    contentText.font=DESC_FONT;
    [view2 addSubview:contentText];
    [ContentView addSubview:view2];
    [self.scrollView1 addSubview:ContentView];
    
    [self tijiaoView];
}

-(void)tijiaoView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ContentView.frame), WIN_WIDTH, M_WIDTH(65))];
    view.backgroundColor=[UIColor whiteColor];
    
    btn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(15), M_WIDTH(4), WIN_WIDTH-M_WIDTH(30), M_WIDTH(37))];
    [btn setTitle:@"提交信息并兑换" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=COMMON_FONT;
    btn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    [btn addTarget:self action:@selector(tijiaoTouch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    [self.scrollView1 addSubview:view];
    CGFloat scr_H=CGRectGetMaxY(ContentView.frame)+view.frame.size.height;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, scr_H);
}


//textView点击事件
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [eView removeFromSuperview];
    if (textView==contentText) {
        CGFloat scr_H=CGRectGetMaxY(ContentView.frame)+M_WIDTH(65);
        self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, scr_H+M_WIDTH(220));
        return YES;
    }
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (![text isEqualToString:@""]){
        placeholderLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1){
        placeholderLabel.hidden = NO;
    }
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        CGFloat scr_H=CGRectGetMaxY(ContentView.frame)+M_WIDTH(65);
        self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, scr_H);
        [contentText resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self yingcangkey];
    CGFloat scr_H=CGRectGetMaxY(ContentView.frame)+M_WIDTH(65);
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, scr_H);
    return YES;
}

//textfield点击事件
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL  isresign;
    if (textField==sendProvinceText) {
        isresign=NO;
        [self yingcangkey];
        [self createPickerView:_shengAry :_shengIDAry :@"1"];
        
    }else if (textField==sendCityText) {
        isresign=NO;
        [self yingcangkey];
        [self createPickerView:_cityAry :_cityIDAry :@"2"];
    }else if (textField==sendDistrictText) {
        isresign=NO;
        [self yingcangkey];
        [self createPickerView:_quAry :_quIDAry :@"3"];
    }else if (textField==collectProvinceText) {
        isresign=NO;
        [self yingcangkey];
        [self createPickerView:_shengAry :_shengIDAry :@"4"];
    }else if (textField==collectCityText) {
        isresign=NO;
        [self yingcangkey];
        [self createPickerView:_cityAry_2 :_cityIDAry_2 :@"5"];
    }else if (textField==collectDistrictText) {
        isresign=NO;
        [self yingcangkey];
        [self createPickerView:_quAry_2 :_quIDAry_2 :@"6"];
    }else{
        isresign=YES;
        [eView removeFromSuperview];
    }
    if(textField==collectZipCodeText){
        CGFloat scr_H=CGRectGetMaxY(ContentView.frame)+M_WIDTH(65);
        self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, scr_H+M_WIDTH(220));
    }else{
        CGFloat scr_H=CGRectGetMaxY(ContentView.frame)+M_WIDTH(65);
        self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, scr_H);
    }
    
    return isresign;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [sendNameText       resignFirstResponder];
    [sendPhoneText      resignFirstResponder];
    [sendAddressText    resignFirstResponder];
    [sendZipCodeText    resignFirstResponder];
    
    [collectNameText    resignFirstResponder];
    [collectPhoneText   resignFirstResponder];
    [collectAddressText resignFirstResponder];
}

//选择地区的view PickerView
-(void)createPickerView:(NSMutableArray*)nameArray :(NSMutableArray*)idArray :(NSString*)index
{
    if (nameArray.count==0) {
        return;
    }
    CGFloat  view_hh=M_WIDTH(150);
    eView=[[ExpressView alloc]initWithFrame:CGRectMake(M_WIDTH(15), WIN_HEIGHT-view_hh, WIN_WIDTH-M_WIDTH(30), view_hh)];
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

-(void)setTouch:(id)exTouch
{
    [eView removeFromSuperview];
    NSArray *array=exTouch;
    NSString *tyepstr=array[0];
    if ([tyepstr isEqualToString:@"1"]) {
        if ([sendProvinceText.text isEqualToString:@""] || [sendProvinceText.text isEqualToString:array[1]]) {
        }else {
            sendCityText.text=@"";
            sendDistrictText.text=@"";
            city_1=@"";
            dictr_1=@"";
            [self.cityAry removeAllObjects];
            [self.cityIDAry removeAllObjects];
            [self.quAry removeAllObjects];
            [self.quIDAry removeAllObjects];
        }
        sendProvinceText.text=array[1];
        prov_1=array[2];
        NSMutableDictionary *dic=[self shaixuan:array[2]];
        self.cityAry=[dic objectForKey:@"cityName"];
        self.cityIDAry=[dic objectForKey:@"cityID"];
        
    }else if ([tyepstr isEqualToString:@"2"]) {
        if ([sendCityText.text isEqualToString:@""] || [sendCityText.text isEqualToString:array[1]]) {
        }else {
            sendDistrictText.text=@"";
            dictr_1=@"";
            [self.quAry   removeAllObjects];
            [self.quIDAry removeAllObjects];
        }
        NSMutableDictionary *dic=[self shaixuan:array[2]];
        self.quAry=[dic objectForKey:@"cityName"];
        self.quIDAry=[dic objectForKey:@"cityID"];
        sendCityText.text=array[1];
        city_1=array[2];
        
    }else if ([tyepstr isEqualToString:@"3"]) {
    
        sendDistrictText.text=array[1];
        dictr_1=array[2];
        
    }else if ([tyepstr isEqualToString:@"4"]) {
        if ([collectAddressText.text isEqualToString:@""] || [collectProvinceText.text isEqualToString:array[1]]) {
        }else {
            collectCityText.text=@"";
            collectDistrictText.text=@"";
            city_2=@"";
            dictr_2=@"";
            [self.cityAry_2 removeAllObjects];
            [self.cityIDAry_2 removeAllObjects];
            [self.quAry_2 removeAllObjects];
            [self.quIDAry_2 removeAllObjects];
        }
        collectProvinceText.text=array[1];
        NSMutableDictionary *dic=[self shaixuan:array[2]];
        self.cityAry_2=[dic objectForKey:@"cityName"];
        self.cityIDAry_2=[dic objectForKey:@"cityID"];
        collectProvinceText.text=array[1];
        prov_2=array[2];
    }else if ([tyepstr isEqualToString:@"5"]) {
        if ([collectCityText.text isEqualToString:@""] || [collectCityText.text isEqualToString:array[1]]) {
        }else {
            collectDistrictText.text=@"";
            dictr_2=@"";
            [self.quAry_2 removeAllObjects];
            [self.quIDAry_2 removeAllObjects];
        }
        collectProvinceText.text=array[1];
        NSMutableDictionary *dic=[self shaixuan:array[2]];
        self.quAry_2=[dic objectForKey:@"cityName"];
        self.quIDAry_2=[dic objectForKey:@"cityID"];
        collectCityText.text=array[1];
        city_2=array[2];
        
    }else if ([tyepstr isEqualToString:@"6"]) {
        collectDistrictText.text=array[1];
        dictr_2=array[2];
    }
    
}

-(NSMutableDictionary*)shaixuan:(NSString *)str
{
   
    NSMutableArray *nameAry=[[NSMutableArray alloc]init];
    NSMutableArray *idary=[[NSMutableArray alloc]init];
    int pidd=[str intValue];
    for (NSDictionary *dic in self.dataAry) {
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


-(void)yingcangkey
{
    [sendNameText       resignFirstResponder];
    [sendPhoneText      resignFirstResponder];
    [sendAddressText    resignFirstResponder];
    [sendZipCodeText    resignFirstResponder];
    
    [collectNameText    resignFirstResponder];
    [collectPhoneText   resignFirstResponder];
    [collectAddressText resignFirstResponder];
    [collectZipCodeText resignFirstResponder];
    
    [contentText        resignFirstResponder];
}


//texfield处理
-(UIView *)textfield_w:(UITextField*)textfiled :(NSString *)str :(int)type
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=UIColorFromRGB(0xf2f2f2);
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=5;
    
    textfiled.delegate=self;
    textfiled.placeholder=str;
    textfiled.font=DESC_FONT;
    if (type==0) {
        textfiled.frame=CGRectMake(M_WIDTH(9),0,VIEW_length-M_WIDTH(18),TEXTFIELD_H);
    }else {
        textfiled.frame=CGRectMake(M_WIDTH(9),0,VIEW_length_S-M_WIDTH(25),TEXTFIELD_H);
        UIImageView *downImg=[[UIImageView alloc]initWithFrame:CGRectMake(VIEW_length_S-M_WIDTH(17), M_WIDTH(13), M_WIDTH(10), M_WIDTH(5))];
        [downImg setImage:[UIImage imageNamed:@"down"]];
        [view addSubview:downImg];
    }
    [view addSubview:textfiled];
    return view;
}




//title文字处理
-(UIView *)redView_titleLab:(NSString*)str
{
    UIView *view=[[UIView alloc]init];
    UIView *redview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH(3), M_WIDTH(16))];
    redview.backgroundColor=[UIColor redColor];
    [view addSubview:redview];
    UILabel *titileLab=[[UILabel alloc]initWithFrame:CGRectMake(FromTheLeft, 0, M_WIDTH(200), M_WIDTH(16))];
    titileLab.textAlignment=NSTextAlignmentLeft;
    titileLab.font=COMMON_FONT;
    titileLab.text=str;
    [view addSubview:titileLab];
    UIView*lineview=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(27), WIN_WIDTH, 1)];
    lineview.backgroundColor=COLOR_LINE;
    [view addSubview:lineview];
    return view;
}

//Lab间距
-(void)labjianju:(UILabel*)lab :(NSString *)str
{
    lab.textColor=COLOR_FONT_SECOND;
    lab.font=DESC_FONT;
    lab.numberOfLines=0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:M_WIDTH(7)];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
    [lab setAttributedText:attributedString1];
    [lab sizeToFit];
}


//选择配送服务的点击事件
- (void)event2:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic=self.serveAry[0];
    serve_type=[[Util isNil:dic[@"serve_type"]]intValue];
    xuanzeImg_1.backgroundColor=[UIColor redColor];
    xuanzeImg_2.backgroundColor=[UIColor whiteColor];
    xuanzeLab_1.textColor=[UIColor blackColor];
    xuanzeLab_2.textColor=COLOR_FONT_SECOND;
    xuanzeView_1.alpha=0;
    xuanzeView_2.alpha=0.5;
}
- (void)event3:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic=self.serveAry[1];
    serve_type=[[Util isNil:dic[@"serve_type"]]intValue];
    xuanzeImg_2.backgroundColor=[UIColor redColor];
    xuanzeImg_1.backgroundColor=[UIColor whiteColor];
    xuanzeLab_2.textColor=[UIColor blackColor];
    xuanzeLab_1.textColor=COLOR_FONT_SECOND;
    xuanzeView_2.alpha=0;
    xuanzeView_1.alpha=0.5;
}

-(void)tijiaoTouch:(UIButton*)sender
{
    [self yingcangkey];
    btn.enabled=NO;
    if([Util isNull:sendNameText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人姓名为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:sendPhoneText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人手机号为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:sendProvinceText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人省份为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:sendCityText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人城市为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:sendDistrictText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人地区为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:sendAddressText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人详细地址为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:sendZipCodeText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"寄件人邮编为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectNameText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人姓名为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectPhoneText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人手机号为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectProvinceText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人省份为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectCityText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人城市为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectDistrictText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人地区为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectAddressText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人详细地址为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:collectZipCodeText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"收件人邮编为空"];
        btn.enabled=YES;
        
    }else if([Util isNull:contentText.text]){
        
        [SVProgressHUD showErrorWithStatus:@"快递内容详情为空"];
        btn.enabled=YES;
    }else {
        NSString *sendName      =sendNameText.text;//
        NSString *sendPhone     =sendPhoneText.text;
        int       sendProvince  =[prov_1 intValue];//省
        int       sendCity      =[city_1 intValue];//市
        int       sendDicstr    =[dictr_1 intValue];//区
        NSString *sendAdd       =[NSString stringWithFormat:@"%@,%@,%@,%@",sendProvinceText.text,sendCityText.text,sendDistrictText,sendAddressText.text];//地址
        NSString *sendZip       =sendZipCodeText.text;//邮编
        
        NSString *collectName      =collectNameText.text;//
        NSString *collectPhone     =collectPhoneText.text;
        int       collectProvince  =[prov_2 intValue];//省
        int       collectCity      =[city_2 intValue];//市
        int       collectDicstr    =[dictr_2 intValue];//区
        NSString *collectAdd       =[NSString stringWithFormat:@"%@,%@,%@,%@",collectProvinceText.text,collectCityText.text,collectDistrictText.text,collectAddressText.text];//地址
        NSString *collectZip       =collectZipCodeText.text;//邮编
        NSString *contentStr       =contentText.text;
        
        
        //    NSString *sendName      =@"123";//
        //    NSString *sendPhone     =@"15895310729";
        //    int       sendProvince  =[prov_1 intValue];//省
        //    int       sendCity      =[city_1 intValue];//市
        //    int       sendDicstr    =[dictr_1 intValue];//区
        //    NSString *sendAdd       =@"123";//地址
        //    NSString *sendZip       =@"210000";//邮编
        //
        //    NSString *collectName      =@"123";//
        //    NSString *collectPhone     =@"15895310729";
        //    int       collectProvince  =[prov_2 intValue];//省
        //    int       collectCity      =[city_2 intValue];//市
        //    int       collectDicstr    =[dictr_2 intValue];//区
        //    NSString *collectAdd       =@"12asdasd";//地址
        //    NSString *collectZip       =@"210000";//邮编
        //
        //    NSString *contentStr       =@"123";
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
        NSDictionary *diction=[[NSDictionary alloc]initWithObjectsAndKeys:
                               [Global sharedClient].member_id,@"member_id",
                               [Global sharedClient].nick_name,@"member_nick_name",
                               @"4",@"mall_id",
                               @(serve_type),@"serve_type_id",
                               sendName,@"send_name",
                               @(sendProvince),@"Send_province",
                               @(sendCity),@"send_city",
                               @(sendDicstr),@"send_area",
                               sendAdd,@"send_address",
                               sendZip,@"send_postcode",
                               sendPhone,@"send_phone",
                               collectName,@"collect_name",
                               @(collectProvince),@"collect_province",
                               @(collectCity),@"collect_city",
                               @(collectDicstr),@"collect_area",
                               collectAdd,@"collect_address",
                               collectZip,@"collect_postcode",
                               collectPhone,@"collect_phone",
                               contentStr,@"send_goods",
                               nil];
        
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"addexpress"] parameters:diction target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.enabled=YES;
                [SVProgressHUD dismiss];
                GoViewController *vc=[[GoViewController alloc]init];
                vc.path=[NSString stringWithFormat:@"%@",[Util isNil:dic[@"data"]]];
                [self.delegate.navigationController pushViewController:vc animated:YES];
                
            });
        }failue:^(NSDictionary *dic){
            NSLog(@"%@",dic);
        }];
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
