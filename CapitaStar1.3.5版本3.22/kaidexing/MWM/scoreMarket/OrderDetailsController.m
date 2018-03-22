//
//  OrderDetailsController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "OrderDetailsController.h"
#import "GoViewController.h"
#import "MyVoucherViewController.h"
@interface OrderDetailsController ()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView        *scrollView1;
@property (strong,nonatomic)NSArray             *dataAry;
@property (strong,nonatomic)NSArray             *addressAry;
@end

@implementation OrderDetailsController
{
    CGFloat      view_topH;
    UIView      *view;
    UIView      *cellView;
    UIView      *wuliuView;
    UIView      *dingdanView;
    UIView      *explainView;
    UIView      *shopView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry=[[NSArray alloc]init];
    self.addressAry=[[NSArray alloc]init];
    self.navigationBarTitleLabel.text=@"订单详情";
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.delegate=self;
    self.scrollView1.backgroundColor=UIColorFromRGB(0xf0f0f0);
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT * 1.1);
    [self.view addSubview:self.scrollView1];
    view_topH=0;
    int typeint = [_orderType intValue];
    if (typeint==1) {
        if (![Util isNull:_orderNO]) {
            [self loadnet];
        }
    }
    
    [self loadData];
}

-(void)loadnet
{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getaddress"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"model",@"rtype",_orderNO,@"aid",@"1",@"page",@"10",@"pageSize",nil ] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            self.addressAry=dic[@"data"];
            [self initdizhiView];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
    
    
}

-(void) loadData{
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getuserorder"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"0",@"order_status",_orderID,@"order_no",nil ] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"%@",dic);
            self.dataAry=dic[@"data"][@"order_list"];
            NSDictionary *diction=_dataAry[0];
            int  extract_type=[diction[@"extract_type"]intValue];
            if (extract_type==0) {
                [self createRow:0];
                [self initbtn];
                [self dingdanView];
            }else if (extract_type==1){
                [self createRow:1];
                [self initwuliuView];
                [self dingdanView];
            }else if (extract_type==2){
                [self createRow:1];
                [self initexplainView];
                [self dingdanView];
            }

        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}


-(void)initdizhiView
{
    NSDictionary *dic =_addressAry[0];
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(108))];
    view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    UIImageView  *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, M_WIDTH(11),WIN_WIDTH,M_WIDTH(97))];
    [backgroundImg setImage:[UIImage imageNamed:@"sharp_color"]];
    [backgroundImg setUserInteractionEnabled:YES];
    [view addSubview:backgroundImg];
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(12), M_WIDTH(13), M_WIDTH(12), M_WIDTH(16))];
    [iconImg setImage:[UIImage imageNamed:@"iconfont-zuobiao"]];
    [backgroundImg addSubview:iconImg];
    
    //名字+手机号
    UILabel  *name=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30), M_WIDTH(13), M_WIDTH(200), M_WIDTH(17))];
    name.text=[NSString stringWithFormat:@"%@  %@",[Util isNil:dic[@"name"]],[Util isNil:dic[@"telephone"]]];
    name.textAlignment=NSTextAlignmentLeft;
    name.font=COMMON_FONT;
    [backgroundImg addSubview:name];
    
    //地址
    UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30), CGRectGetMaxY(name.frame)+M_WIDTH(4), WIN_WIDTH-M_WIDTH(130), M_WIDTH(15))];
    dizhiLab.font=DESC_FONT;
    dizhiLab.textColor=COLOR_FONT_SECOND;
    dizhiLab.textAlignment=NSTextAlignmentLeft;
    dizhiLab.numberOfLines=2;
    dizhiLab.text=[Util isNil:dic[@"address"]];
    CGRect rect10=[dizhiLab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(130),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:dizhiLab.font} context:nil];
    dizhiLab.frame=CGRectMake(dizhiLab.frame.origin.x, dizhiLab.frame.origin.y, rect10.size.width, rect10.size.height);
    [backgroundImg addSubview:dizhiLab];
    
    //邮编
    UILabel  *eLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30), CGRectGetMaxY(backgroundImg.frame)-M_WIDTH(35), M_WIDTH(200), M_WIDTH(15))];
    eLab.text=[NSString stringWithFormat:@"%@ %@",@"邮编:",[Util isNil:dic[@"post_code"]]];
    eLab.textColor=COLOR_FONT_SECOND;
    eLab.textAlignment=NSTextAlignmentLeft;
    eLab.font=DESC_FONT;
    [backgroundImg addSubview:eLab];
    
    [self.scrollView1 addSubview:view];
    view_topH=view_topH+M_WIDTH(108);
}
-(void)createRow :(int)iskuaidi
{
    NSDictionary *dic=self.dataAry[0];
    cellView=[[UIView alloc]init];
    view_topH=view_topH+M_WIDTH(10);
    int  money=0;
    int  shopCount=0;
    cellView.backgroundColor=[UIColor whiteColor];
    //表示商城的图标
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(14.5),M_WIDTH(14.5),M_WIDTH(13))];
    [iconImg setImage:[UIImage imageNamed:@"house"]];
    [cellView addSubview:iconImg];
    //商城的名字
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(5),M_WIDTH(14), M_WIDTH(20), M_WIDTH(15))];
    nameLab.font=DESC_FONT;
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.text=[Util isNil:dic[@"mall_name"]];
    [nameLab sizeToFit];
    [cellView addSubview:nameLab];
    
    //中间第一条分割线
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(42), WIN_WIDTH,1)];
    line1.backgroundColor=COLOR_LINE;
    [cellView addSubview:line1];
    
    
    NSArray *itemArray=dic[@"good_list"];
    
    for (int i=0;i<itemArray.count;i++) {
        shopView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame)+M_WIDTH(11)+(M_WIDTH(85)*i), WIN_WIDTH, M_WIDTH(85))];
        NSDictionary *diction=itemArray[i];
        //购买的商品的Logo
        UIImageView  *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10),0, M_WIDTH(73), M_WIDTH(73))];
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        [logoImg setImageWithURL:[NSURL URLWithString:[Util isNil:diction[@"img_url"]]]];
        logoImg.layer.borderColor=[COLOR_LINE CGColor];
        logoImg.layer.borderWidth=1;
        [shopView addSubview:logoImg];
        
        //商品的名字
        UILabel  *commodityNameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10),0, M_WIDTH(220), M_WIDTH(20))];
        commodityNameLab.textAlignment=NSTextAlignmentLeft;
        commodityNameLab.text=[Util isNil:diction[@"title"]];
        commodityNameLab.numberOfLines=0;
        commodityNameLab.font=COMMON_FONT;
        CGRect rect2=[commodityNameLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(220),M_WIDTH(36)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:commodityNameLab.font} context:nil];
        commodityNameLab.frame=CGRectMake(commodityNameLab.frame.origin.x, commodityNameLab.frame.origin.y, rect2.size.width, rect2.size.height);
        [shopView addSubview:commodityNameLab];
        
        //商品描述
        UILabel  *describeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(commodityNameLab.frame)+M_WIDTH(2), M_WIDTH(220), M_WIDTH(12))];
        describeLab.textColor=COLOR_FONT_SECOND;
        describeLab.font=INFO_FONT;
        describeLab.textAlignment=NSTextAlignmentLeft;
        describeLab.text=[Util isNil:diction[@"good_name"]];
        [shopView addSubview:describeLab];
        
        //价格
        UILabel  *unitPriceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(logoImg.frame)-M_WIDTH(16), M_WIDTH(150), M_WIDTH(12))];
        int integtal=[[Util isNil:diction[@"integral"]]intValue];
        money=money+integtal;
        unitPriceLab.text=[NSString stringWithFormat:@"%d %@",integtal,@"积分"];
        unitPriceLab.textAlignment=NSTextAlignmentLeft;
        unitPriceLab.font=DESC_FONT;
        [shopView addSubview:unitPriceLab];
        
        //相同商品数量
        UILabel  *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(60), CGRectGetMaxY(logoImg.frame)-M_WIDTH(16), M_WIDTH(50), M_WIDTH(12))];
        numberLab.textAlignment=NSTextAlignmentRight;
        numberLab.font=DESC_FONT;
        int count=[[Util isNil:diction[@"qty"]]intValue];
        shopCount=shopCount+count;
        numberLab.text=[NSString stringWithFormat:@"%@%d",@"x",count];
        [shopView addSubview:numberLab];
        
        //----------------------
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        cellView.tag=i;
        [cellView addGestureRecognizer:tapGesture];
        
        [cellView addSubview:shopView];
    }
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(shopView.frame), WIN_WIDTH-M_WIDTH(10),1)];
    line2.backgroundColor=COLOR_LINE;
    [cellView addSubview:line2];
    if (iskuaidi==0) {
        UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), WIN_WIDTH, M_WIDTH(42))];
        buttomView.backgroundColor=[UIColor whiteColor];
        //显示多少积分的lab
        UILabel  *jifenLab=[[UILabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(13.5), M_WIDTH(100), M_WIDTH(17))];
        jifenLab.font=DESC_FONT;
        jifenLab.textAlignment=NSTextAlignmentRight;
        jifenLab.textColor=[UIColor redColor];
        int total_integral=[[Util isNil:dic[@"total_integral"]]intValue];
        jifenLab.text=[NSString stringWithFormat:@"%d%@",total_integral,@"星积分"];
        CGRect rect5=[jifenLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(200),M_WIDTH(17)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:jifenLab.font} context:nil];
        jifenLab.frame=CGRectMake(WIN_WIDTH-rect5.size.width-M_WIDTH(10), jifenLab.frame.origin.y, rect5.size.width, rect5.size.height);
        [buttomView addSubview:jifenLab];
        
        //商品数量
        UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH-jifenLab.frame.size.width-M_WIDTH(15), M_WIDTH(40))];
        numLab.text=[NSString stringWithFormat:@"%@%d%@",@"共",shopCount,@"件商品 实付:"];
        numLab.textAlignment=NSTextAlignmentRight;
        numLab.font=DESC_FONT;
        
        [buttomView addSubview:numLab];
        [cellView addSubview:buttomView];
        cellView.frame=CGRectMake(0,view_topH, WIN_WIDTH,M_WIDTH(95)+M_WIDTH(85)*itemArray.count+2);
        
    }else {
        UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), WIN_WIDTH, M_WIDTH(67))];
        buttomView.backgroundColor=[UIColor whiteColor];
        
        UILabel *yunLab=[[UILabel alloc]initWithFrame:CGRectMake(10,M_WIDTH(13), M_WIDTH(10), M_WIDTH(26))];
        yunLab.textColor=[UIColor redColor];
        int total_integral=[[Util isNil:dic[@"total_integral"]]intValue];
        int yunfei =total_integral-money;
        
        yunLab.text=[NSString stringWithFormat:@"%d%@",yunfei,@"星积分"];
        yunLab.textAlignment=NSTextAlignmentRight;
        yunLab.font=DESC_FONT;
        CGRect rect20=[yunLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(200),M_WIDTH(26)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:yunLab.font} context:nil];
        yunLab.frame=CGRectMake(WIN_WIDTH-rect20.size.width-M_WIDTH(10), yunLab.frame.origin.y, rect20.size.width, rect20.size.height);
        [buttomView addSubview:yunLab];
        
        
        UILabel *title1=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-yunLab.frame.size.width-M_WIDTH(105), M_WIDTH(7), M_WIDTH(90), M_WIDTH(26))];
        title1.text=@"运费:";
        title1.textAlignment=NSTextAlignmentRight;
        title1.font=DESC_FONT;
        [buttomView addSubview:title1];
        // 运费
        UILabel *fuLab=[[UILabel alloc]initWithFrame:CGRectMake(10,M_WIDTH(40), M_WIDTH(30), M_WIDTH(26))];
        fuLab.textColor=[UIColor redColor];
        fuLab.text=[NSString stringWithFormat:@"%d%@",total_integral,@"星积分"];
        fuLab.textAlignment=NSTextAlignmentRight;
        fuLab.font=DESC_FONT;
        CGRect rect4=[fuLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(200),M_WIDTH(14)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:fuLab.font} context:nil];
        fuLab.frame=CGRectMake(WIN_WIDTH-rect4.size.width-M_WIDTH(10), fuLab.frame.origin.y, rect4.size.width, rect4.size.height);
        [buttomView addSubview:fuLab];
        
        UILabel *title2=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-fuLab.frame.size.width-M_WIDTH(105),M_WIDTH(40), M_WIDTH(90), M_WIDTH(14))];
        title2.text=@"实付:";
        title2.textAlignment=NSTextAlignmentRight;
        title2.font=DESC_FONT;
        [buttomView addSubview:title2];
        [cellView addSubview:buttomView];
        cellView.frame=CGRectMake(0,view_topH, WIN_WIDTH,M_WIDTH(120)+M_WIDTH(85)*itemArray.count+2);
        
        }
        view_topH=view_topH+cellView.frame.size.height;
        [self.scrollView1 addSubview:cellView];
}


//物流  大字 15 小字14
-(void)initwuliuView
{
    NSDictionary *dic=self.dataAry[0];
    
    view_topH=view_topH+M_WIDTH(11);
    wuliuView=[[UIView alloc]initWithFrame:CGRectMake(0, view_topH, WIN_WIDTH, M_WIDTH(126))];
    wuliuView.backgroundColor=[UIColor whiteColor];
    
    UILabel *wuliLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(1), WIN_WIDTH/2, M_WIDTH(40))];
    wuliLab.font=COMMON_FONT;
    wuliLab.text=@"物流信息";
    wuliLab.textAlignment=NSTextAlignmentLeft;
    [wuliuView addSubview:wuliLab];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(41), WIN_WIDTH, 1)];
    lineView1.backgroundColor=COLOR_LINE;
    [wuliuView addSubview:lineView1];
    
    //发货商场
    UILabel  *shopLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(42),M_WIDTH(60), M_WIDTH(42))];
    shopLab.textAlignment=NSTextAlignmentLeft;
    shopLab.textColor=COLOR_FONT_SECOND;
    shopLab.text=@"发货商场";
    shopLab.font=DESC_FONT;
    [wuliuView addSubview:shopLab];
    
    UILabel  *guanchangLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(80), M_WIDTH(42), WIN_WIDTH-M_WIDTH(90), M_WIDTH(42))];
    guanchangLab.text=[NSString stringWithFormat:@"%@%@%@",@"由",[Util isNil:dic[@"mall_name"]],@"发出"];
    guanchangLab.textAlignment=NSTextAlignmentRight;
    guanchangLab.font=DESC_FONT;
    guanchangLab.textColor=COLOR_FONT_SECOND;
    [wuliuView addSubview:guanchangLab];
    
     //配送信息
    UIView *kuaidiView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(84), WIN_WIDTH, M_WIDTH(42))];
    kuaidiView.backgroundColor=UIColorFromRGB(0xfefcea);
   
    UILabel *peisongLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(0), M_WIDTH(70), M_WIDTH(42))];
    peisongLab.text=@"中通快递";
    peisongLab.font=COMMON_FONT;
    peisongLab.textAlignment=NSTextAlignmentLeft;
    peisongLab.font=[UIFont systemFontOfSize:15];
    [kuaidiView addSubview:peisongLab];
    //快递小箭头
    UIImageView *jiantou2=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(20),M_WIDTH(14), M_WIDTH(8), M_WIDTH(13))];
    [jiantou2 setImage:[UIImage imageNamed:@"right_2"]];
    [kuaidiView addSubview:jiantou2];
    //快递单号
    UILabel  *kuaidiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(80),M_WIDTH(0),WIN_WIDTH-M_WIDTH(105), M_WIDTH(42))];
    kuaidiLab.textAlignment=NSTextAlignmentRight;
    kuaidiLab.font=DESC_FONT;
    kuaidiLab.textColor=UIColorFromRGB(0xf3484b);
    kuaidiLab.text=@"中通快递：874641210212";
    [kuaidiView addSubview:kuaidiLab];
    [wuliuView addSubview:kuaidiView];
    [self.scrollView1 addSubview:wuliuView];
    view_topH=view_topH+M_WIDTH(126);
}

//订单信息
-(void)dingdanView
{
    NSDictionary *dic=self.dataAry[0];
    view_topH=view_topH+M_WIDTH(11);
    dingdanView=[[UIView alloc]initWithFrame:CGRectMake(0, view_topH, WIN_WIDTH, M_WIDTH(115))];
    dingdanView.backgroundColor=[UIColor whiteColor];
    
    UILabel *dingdanlab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(1), WIN_WIDTH/2, M_WIDTH(40))];
    dingdanlab.font=COMMON_FONT;
    dingdanlab.text=@"订单信息";
    dingdanlab.textAlignment=NSTextAlignmentLeft;
    [dingdanView addSubview:dingdanlab];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(41), WIN_WIDTH, 1)];
    lineView1.backgroundColor=COLOR_LINE;
    [dingdanView addSubview:lineView1];
    
    UIView *bottom=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(42), WIN_WIDTH, M_WIDTH(73))];
    bottom.backgroundColor=[UIColor whiteColor];
    
    //订单号
    UILabel *titieLab1=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(12), M_WIDTH(60), M_WIDTH(25))];
    titieLab1.textAlignment=NSTextAlignmentLeft;
    titieLab1.textColor=COLOR_FONT_SECOND;
    titieLab1.font=DESC_FONT;
    titieLab1.text=@"订单号";
    [bottom addSubview:titieLab1];
    
    UILabel  *haoLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(80), M_WIDTH(12), WIN_WIDTH-M_WIDTH(90), M_WIDTH(25))];
    haoLab.text=[Util isNil:dic[@"logistics_order_no"]];
    haoLab.textAlignment=NSTextAlignmentRight;
    haoLab.textColor=COLOR_FONT_SECOND;
    haoLab.font=DESC_FONT;
    [bottom addSubview:haoLab];
    
    //创建时间
    UILabel *titieLab2=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(titieLab1.frame), M_WIDTH(60), M_WIDTH(25))];
    titieLab2.textAlignment=NSTextAlignmentLeft;
    titieLab2.textColor=COLOR_FONT_SECOND;
    titieLab2.font=DESC_FONT;
    titieLab2.text=@"创建时间";
    [bottom addSubview:titieLab2];
    
    UILabel  *timeLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(80),CGRectGetMaxY(titieLab1.frame),WIN_WIDTH-M_WIDTH(90), M_WIDTH(25))];
    NSString *str=[Util isNil:dic[@"add_time_str"]];
    str=[str stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    str=[str stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    str=[str stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@"日 "];
    timeLab.text=str;
    timeLab.textAlignment=NSTextAlignmentRight;
    timeLab.textColor=COLOR_FONT_SECOND;
    timeLab.font=DESC_FONT;
    [bottom addSubview:timeLab];
    [bottom addSubview:timeLab];
    [dingdanView addSubview:bottom];
    [self.scrollView1 addSubview:dingdanView];
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH,view_topH+M_WIDTH(115));
    view_topH=view_topH+M_WIDTH(115);
}


//订单说明
-(void)initexplainView
{
    view_topH=view_topH+M_WIDTH(11);
    explainView=[[UIView alloc]init];
    explainView.backgroundColor=[UIColor whiteColor];
    //订单说明文字
    UILabel *titleLab1=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), 0,M_WIDTH(60), M_WIDTH(39))];
    titleLab1.font=COMMON_FONT;
    titleLab1.text=@"订单说明";
    titleLab1.textAlignment=NSTextAlignmentLeft;
    [explainView addSubview:titleLab1];
    
    UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(titleLab1.frame), WIN_WIDTH-M_WIDTH(25), M_WIDTH(39))];
    contentLab.textAlignment=NSTextAlignmentLeft;
    contentLab.font=DESC_FONT;
    contentLab.text=@"虚拟商品我们将以电子券形式发送到您的个人卡包,卡券详情请在个人中心卡券页面查看。";
    contentLab.textColor=COLOR_FONT_SECOND;
    contentLab.numberOfLines=0;
    
    CGRect rect200=[contentLab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(25),M_WIDTH(60)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:contentLab.font} context:nil];
    contentLab.frame=CGRectMake(contentLab.frame.origin.x, contentLab.frame.origin.y, rect200.size.width, rect200.size.height);
    
    [explainView addSubview:contentLab];
    
    UIView *lingview1=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(contentLab.frame)+M_WIDTH(16), WIN_WIDTH-M_WIDTH(10),1)];
    lingview1.backgroundColor=COLOR_LINE;
    [explainView addSubview:lingview1];
    
    //小箭头
    UIImageView *jiantou2=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(15),CGRectGetMaxY(lingview1.frame)+M_WIDTH(15), M_WIDTH(5), M_WIDTH(10))];
    [jiantou2 setImage:[UIImage imageNamed:@"right_2"]];
    [explainView addSubview:jiantou2];
    
    UILabel *chakanLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(120),CGRectGetMaxY(lingview1.frame), M_WIDTH(100), M_WIDTH(40))];
    chakanLab.text=@"立即查看卡券";
    chakanLab.font=DESC_FONT;
    chakanLab.textAlignment=NSTextAlignmentRight;
    [explainView addSubview:chakanLab];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(135), CGRectGetMaxY(lingview1.frame), M_WIDTH(130), M_WIDTH(40))];
    [btn addTarget:self action:@selector(chakanTouch) forControlEvents:UIControlEventTouchUpInside];
    [explainView addSubview:btn];
    
    explainView.frame=CGRectMake(0, view_topH, WIN_WIDTH, M_WIDTH(96)+contentLab.frame.size.height);
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH,view_topH+explainView.frame.size.height);
    [self.scrollView1 addSubview:explainView];
    view_topH = view_topH + explainView.frame.size.height;

}


//查看自提详情
-(void)initbtn
{
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, view_topH, WIN_WIDTH, M_WIDTH(63))];
    colorView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(15), WIN_WIDTH-M_WIDTH(20), M_WIDTH(43))];
    btn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"查看自提详情" forState:UIControlStateNormal];
    btn.titleLabel.font=COOL_FONT;
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=5;
    [btn addTarget:self action:@selector(zitiTouch) forControlEvents:UIControlEventTouchUpInside];
    [colorView addSubview:btn];
    [self.scrollView1 addSubview:colorView];
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH,view_topH+M_WIDTH(63));
    view_topH=view_topH+M_WIDTH(63);
    
}


//查看自提详情
-(void)zitiTouch
{
    GoViewController *oVC=[[GoViewController alloc]init];
    NSDictionary     *dic=self.dataAry[0];
    NSString         *url=dic[@"order_detail"];
    oVC.path=url;
    [self.delegate.navigationController pushViewController:oVC animated:YES];

}

//立即查看卡券
-(void)chakanTouch
{
    MyVoucherViewController * myVoucherVC = [[MyVoucherViewController alloc] init];
    [self.delegate.navigationController pushViewController:myVoucherVC animated:YES];
}
//购买物品详情
- (void)event:(UITapGestureRecognizer *)gesture
{
    GoViewController *oVC=[[GoViewController alloc]init];
    NSDictionary     *dic=self.dataAry[0];
    NSArray          *ary=dic[@"good_list"];
    NSDictionary     *diction=ary[shopView.tag];
    NSString         *url=diction[@"linkurl"];
    oVC.path=url;
    [self.delegate.navigationController pushViewController:oVC animated:YES];
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
