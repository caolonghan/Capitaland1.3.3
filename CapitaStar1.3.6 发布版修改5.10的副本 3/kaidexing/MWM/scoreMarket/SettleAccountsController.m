//
//  SettleAccountsController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/1.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SettleAccountsController.h"
#import "CheckController.h"
#import "AddressController.h"

#define cell_Head       M_WIDTH(133)//93
#define cell_view_H     M_WIDTH(85)
#define cell_dizhi_H    M_WIDTH(140)

@interface SettleAccountsController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView             *tableView1;
@property (strong,nonatomic)NSMutableDictionary     *dataDic;
@property (strong,nonatomic)NSMutableDictionary     *dizhiDic;

@end

@implementation SettleAccountsController
{
    UILabel *hejiLab;
    NSArray  *dataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"确认订单";
    self.dataDic   = [[NSMutableDictionary alloc]init];
    self.dizhiDic  = [[NSMutableDictionary alloc]init];
    dataAry        = [[NSArray alloc]init];
    [self initHeadView];
    [self initButtomView];
    [self inittableView1];
    [self loadData];
    [self dizhiLoafData:nil];
}

-(void)loadData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getorder"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            dataAry=dic[@"data"];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}

-(void)dizhiLoafData : (NSString *)addressID
{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getaddress"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"",@"",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            NSArray *array=[[NSArray alloc]init];
            array=dic[@"data"][@"list"];
            if (array.count!=0) {
                if ([Util isNull:addressID]) {
                     self.dizhiDic=array[0];
                }else {
                    int addressint=[addressID intValue];
                    for (NSDictionary *diction in array) {
                        int idstr=[[Util isNil:diction[@"id"]]intValue];
                        if (idstr == addressint) {
                            self.dizhiDic=(NSMutableDictionary*)diction;
                            break;
                        }
                    }
                }
                [self yunfeiLoadData:self.dizhiDic[@"province"]];
            }
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}

-(void)yunfeiLoadData :(NSString *)cityid{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getfreight"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",cityid,@"province_id",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            NSArray *array=dic[@"data"];
            
            self.dataDic =[self chuliAry:dataAry :array];
            [self jiesuanMoney];
            [self.tableView1 reloadData];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}

-(void)inittableView1
{
    _tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+M_WIDTH(40), WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(85)) style:UITableViewStylePlain];
    _tableView1.backgroundColor=[UIColor clearColor];
    _tableView1.delegate=self;
    _tableView1.dataSource=self;
    _tableView1.scrollEnabled=YES;
    _tableView1.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView1];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array=[[NSArray alloc]init];
    array=[_dataDic allKeys];
    
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [UIUtil removeSubView:cell];
    if (indexPath.section<array.count) {
        UIView *view=[self creatCell_View:indexPath];
        [cell addSubview:view];
    }else{
        UIView *view=[self initdizhiView];
        [cell addSubview:view];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat se_H;
    NSArray *array=[[NSArray alloc]init];
    array=[_dataDic allKeys];
    if (indexPath.section < array.count) {
        NSArray *array1=[_dataDic objectForKey:array[indexPath.section]];
        NSDictionary *dic=array1[0];
        int  type=[[Util isNil:dic[@"freight_type"]]intValue];
        if (type==0) {
            se_H=cell_Head+cell_view_H*array1.count;
        }else  if (type==1){
            se_H =cell_Head+cell_view_H*array1.count +M_WIDTH(40);
        }
    }else{
        se_H = cell_dizhi_H;
    }
    return se_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_WIDTH(10);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *array=[[NSArray alloc]init];
    array=[_dataDic allKeys];
    return array.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)creatCell_View:(NSIndexPath*)indexpath
{
    CGFloat se_H;
    NSArray *array=[[NSArray alloc]init];
    array=[_dataDic allKeys];
    NSArray *array1=[_dataDic objectForKey:array[indexpath.section]];
    NSDictionary *dic=array1[0];
    int  type=[[Util isNil:dic[@"freight_type"]]intValue];
    if (type==0) {
        se_H=cell_Head+cell_view_H*array1.count;
    }else  if (type==1){
        se_H =cell_Head+cell_view_H*array1.count +M_WIDTH(40);
    }
    
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, se_H)];
    //表示商城的图标
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(15),M_WIDTH(14.5),M_WIDTH(13))];
    [iconImg setImage:[UIImage imageNamed:@"house"]];
    [cellView addSubview:iconImg];
    //商城的名字
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(5),(M_WIDTH(42)-M_WIDTH(14))/2, M_WIDTH(20), M_WIDTH(14))];
    nameLab.font=[UIFont systemFontOfSize:M_WIDTH(14)];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.text=array[indexpath.section];
    [nameLab sizeToFit];
    [cellView addSubview:nameLab];
    
    //中间第一条分割线
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(42)-1, WIN_WIDTH,1)];
    line1.backgroundColor=COLOR_LINE;
    [cellView addSubview:line1];
    UIView *shopView;
    int countNum  =0;//一共多少件商品
    int jifenNum  =0;//一共多少积分
    int yunfeiNum =0;//一共多少运费
    for (int i=0;i<array1.count;i++) {
        NSDictionary *diction=array1[i];
        shopView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(53)+cell_view_H*i, WIN_WIDTH, cell_view_H)];
        //购买的商品的Logo
        UIImageView  *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(0), M_WIDTH(73), M_WIDTH(73))];
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        logoImg.layer.borderColor=[COLOR_LINE CGColor];
        logoImg.layer.borderWidth=1;
        [logoImg setImageWithURL:[NSURL URLWithString:[Util isNil:diction[@"img_url"]]]];
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
        
        //价格
        UILabel  *unitPriceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(logoImg.frame)-M_WIDTH(15), M_WIDTH(150), M_WIDTH(12))];
        int integral=[[Util isNil:diction[@"integral"]]intValue]; //单品积分
        int cartnum=[[Util isNil:diction[@"cartnum"]]intValue];//单个商品数量
        int yunfeivalue=[[Util isNil:diction[@"freight"]]intValue];//单个商品的运费
        int num=integral*cartnum;
        countNum=countNum+integral;
        jifenNum=jifenNum+num;
        yunfeiNum =yunfeiNum+yunfeivalue;
        
        unitPriceLab.text=[NSString stringWithFormat:@"%d %@",num,@"积分"];
        unitPriceLab.textAlignment=NSTextAlignmentLeft;
        unitPriceLab.font=DESC_FONT;
        unitPriceLab.textColor=COLOR_FONT_SECOND;
        [shopView addSubview:unitPriceLab];
        
        //相同商品数量
        UILabel  *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(60), CGRectGetMaxY(logoImg.frame)-M_WIDTH(16), M_WIDTH(50), M_WIDTH(12))];
        numberLab.textAlignment=NSTextAlignmentRight;
        numberLab.font=DESC_FONT;
        numberLab.text=[NSString stringWithFormat:@"%@%d",@"x",cartnum];
        [shopView addSubview:numberLab];
        
        [cellView addSubview:shopView];
    }
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(shopView.frame)-1, WIN_WIDTH-M_WIDTH(10), 1)];
    line2.backgroundColor=COLOR_LINE;
    [cellView addSubview:line2];
    
    
    if (type==0) {
        UILabel *jianziLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(line2.frame), WIN_WIDTH-M_WIDTH(20), M_WIDTH(40))];
        jianziLab.text=@"电子券商品将以卡券形式直接发送到您的用户卡包";
        jianziLab.textAlignment=NSTextAlignmentLeft;
        jianziLab.font=[UIFont systemFontOfSize:13];
        [cellView addSubview:jianziLab];
        UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(jianziLab.frame)-1, WIN_WIDTH-M_WIDTH(10), 1)];
        line3.backgroundColor=COLOR_LINE;
        [cellView addSubview:line3];
        
        UILabel *shoplab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line3.frame), WIN_WIDTH-M_WIDTH(10), M_WIDTH(43))];
        NSString *str11=[NSString stringWithFormat:@"%@%d%@",@"共",countNum,@"件商品  合计 : "];
        NSString *str22=[NSString stringWithFormat:@"%d%@",jifenNum,@"积分"];
        shoplab.textAlignment=NSTextAlignmentRight;
        shoplab.font=DESC_FONT;
        [self colorLab:shoplab :str11 :str22 :nil];
        [cellView addSubview:shoplab];
        
    }else {
        
        UIView *yuanView1=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line2.frame)+M_WIDTH(12.5),M_WIDTH(15), M_WIDTH(15))];
        yuanView1.layer.masksToBounds=YES;
        yuanView1.layer.cornerRadius=yuanView1.frame.size.height/2;
        yuanView1.layer.borderColor=COLOR_LINE.CGColor;
        yuanView1.layer.borderWidth=1;
        yuanView1.backgroundColor=[UIColor whiteColor];
        [cellView addSubview:yuanView1];
        
        UIView *red_yuan1=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(3), M_WIDTH(3), M_WIDTH(9), M_WIDTH(9))];
        red_yuan1.backgroundColor=[UIColor redColor];
        red_yuan1.layer.masksToBounds=YES;
        red_yuan1.layer.cornerRadius=red_yuan1.frame.size.height/2;
        
        UILabel  *typeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yuanView1.frame)+M_WIDTH(7),CGRectGetMaxY(line2.frame), M_WIDTH(80), M_WIDTH(40))];
        typeLab.text=@"快递给我";
        typeLab.textAlignment=NSTextAlignmentLeft;
        typeLab.font=DESC_FONT;
        [cellView addSubview:typeLab];
        
        UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),CGRectGetMaxY(line2.frame)+ M_WIDTH(8), M_WIDTH(190),M_WIDTH(13))];
        addressLab.textAlignment=NSTextAlignmentRight;
        addressLab.textColor=[UIColor redColor];
        addressLab.text=[NSString stringWithFormat:@"%@%@%@",@"*由",array[indexpath.section],@"发出"];
        addressLab.font=INFO_FONT;
        
        UILabel *yunfeiLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),CGRectGetMaxY(addressLab.frame),M_WIDTH(190),M_WIDTH(14))];
        yunfeiLab.text=[NSString stringWithFormat:@"%@%d%@",@"运费",yunfeiNum,@"积分"];
        yunfeiLab.textAlignment=NSTextAlignmentRight;
        yunfeiLab.textColor=[UIColor redColor];
        yunfeiLab.font=INFO_FONT;
        
        UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line2.frame)+M_WIDTH(40)-1, WIN_WIDTH-M_WIDTH(10), 1)];
        line3.backgroundColor=COLOR_LINE;
        [cellView addSubview:line3];
        
        UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), WIN_WIDTH, M_WIDTH(40))];
        btn1.tag=indexpath.section*100;
        [btn1 addTarget:self action:@selector(itemTypeTouch:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:btn1];
        
        UIView *yuanView2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line3.frame)+M_WIDTH(12.5),M_WIDTH(15), M_WIDTH(15))];
        yuanView2.layer.masksToBounds=YES;
        yuanView2.layer.cornerRadius=yuanView2.frame.size.height/2;
        yuanView2.layer.borderColor=COLOR_LINE.CGColor;
        yuanView2.layer.borderWidth=1;
        yuanView2.backgroundColor=[UIColor whiteColor];
        [cellView addSubview:yuanView2];
        
        UIView *red_yuan2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(3), M_WIDTH(3), M_WIDTH(9), M_WIDTH(9))];
        red_yuan2.backgroundColor=[UIColor redColor];
        red_yuan2.layer.masksToBounds=YES;
        red_yuan2.layer.cornerRadius=red_yuan2.frame.size.height/2;
        
        UILabel  *typeLab2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yuanView2.frame)+M_WIDTH(7),CGRectGetMaxY(line3.frame), M_WIDTH(80), M_WIDTH(40))];
        typeLab2.text=@"到商场自提";
        typeLab2.textAlignment=NSTextAlignmentLeft;
        typeLab2.font=DESC_FONT;
        [cellView addSubview:typeLab2];
        
        UILabel *addressLab2=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),CGRectGetMaxY(line3.frame), M_WIDTH(190),M_WIDTH(40))];
        addressLab2.textAlignment=NSTextAlignmentRight;
        addressLab2.textColor=[UIColor redColor];
        addressLab2.text=@"*请在商品所在商场领取";
        addressLab2.font=INFO_FONT;
        
        UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line3.frame)+M_WIDTH(40)-1, WIN_WIDTH-M_WIDTH(10), 1)];
        line4.backgroundColor=COLOR_LINE;
        [cellView addSubview:line4];
        
        UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line3.frame), WIN_WIDTH, M_WIDTH(40))];
        btn2.tag=indexpath.section*100+1;
        [btn2 addTarget:self action:@selector(itemTypeTouch:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:btn2];
        
        UILabel *shoplab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line4.frame), WIN_WIDTH-M_WIDTH(10), M_WIDTH(43))];
        NSString *str11=[NSString stringWithFormat:@"%@%d%@",@"共",countNum,@"件商品  合计 : "];
        NSString *str22=[NSString stringWithFormat:@"%d%@",jifenNum,@"积分"];
        shoplab.textAlignment=NSTextAlignmentRight;
        shoplab.font=DESC_FONT;
        [self colorLab:shoplab :str11 :str22 :nil];
        [cellView addSubview:shoplab];
        
        if([dic[@"kuaidiType"]isEqualToString:@"0"]){
            [yuanView1 addSubview:red_yuan1];
            [cellView  addSubview:addressLab];
            [cellView  addSubview:yunfeiLab];
            typeLab2.textColor=COLOR_FONT_SECOND;
        }else{
            typeLab.textColor=COLOR_FONT_SECOND;
            [yuanView2 addSubview:red_yuan2];
            [cellView addSubview:addressLab2];
        }
    }
    
    return cellView;
}


-(UIView*)initdizhiView
{
    UIView *addressView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH,cell_dizhi_H)];
    addressView.backgroundColor=[UIColor whiteColor];
    UIImageView  *backgroundImg1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(3))];
    [backgroundImg1 setImage:[UIImage imageNamed:@"Color_rectangle"]];
    [backgroundImg1 setUserInteractionEnabled:YES];
    [addressView addSubview:backgroundImg1];
    
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(12), M_WIDTH(15), M_WIDTH(12), M_WIDTH(16))];
    [iconImg setImage:[UIImage imageNamed:@"iconfont-zuobiao"]];
    [addressView addSubview:iconImg];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(28),CGRectGetMaxY(backgroundImg1.frame)+M_WIDTH(13), M_WIDTH(150), M_WIDTH(14))];
    titleLab.text=@"选择收货地址";
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.font=DESC_FONT;
    [addressView addSubview:titleLab];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(backgroundImg1.frame)+M_WIDTH(40)-1, WIN_WIDTH,1)];
    line1.backgroundColor=COLOR_LINE;
    [addressView addSubview:line1];
    
    //名字+手机号
    UILabel  *name=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(28),CGRectGetMaxY(line1.frame)+M_WIDTH(11), M_WIDTH(300), M_WIDTH(17))];
    NSString *str11=[NSString stringWithFormat:@"%@  %@",[Util isNil:_dizhiDic[@"name"]],[Util isNil:_dizhiDic[@"telephone"]]];
    name.text=str11;
    name.textAlignment=NSTextAlignmentLeft;
    name.font=COMMON_FONT;
    [addressView addSubview:name];
    
    //地址
    UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30), CGRectGetMaxY(name.frame)+M_WIDTH(4),M_WIDTH(245), M_WIDTH(15))];
    dizhiLab.font=DESC_FONT;
    dizhiLab.textColor=COLOR_FONT_SECOND;
    dizhiLab.textAlignment=NSTextAlignmentLeft;
    dizhiLab.numberOfLines=2;
    dizhiLab.text=[Util isNil:_dizhiDic[@"address"]];
    CGRect rect10=[dizhiLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(245),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:dizhiLab.font} context:nil];
    dizhiLab.frame=CGRectMake(dizhiLab.frame.origin.x, dizhiLab.frame.origin.y, rect10.size.width, rect10.size.height);
    [addressView addSubview:dizhiLab];
    
    UIImageView *rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(20),CGRectGetMaxY(line1.frame)+M_WIDTH(37), M_WIDTH(8),M_WIDTH(13))];
    [rightImg setImage:[UIImage imageNamed:@"right_2"]];
    [addressView addSubview:rightImg];
    
    //邮编
    UILabel  *eLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30),M_WIDTH(110), M_WIDTH(200), M_WIDTH(16))];
    eLab.text=[Util isNil:_dizhiDic[@"email"]];
    eLab.textColor=COLOR_FONT_SECOND;
    eLab.textAlignment=NSTextAlignmentLeft;
    eLab.font=DESC_FONT;
    [addressView addSubview:eLab];
    
    UIImageView  *backgroundImg2=[[UIImageView alloc]initWithFrame:CGRectMake(0,cell_dizhi_H-M_WIDTH(3),WIN_WIDTH,M_WIDTH(3))];
    [backgroundImg2 setImage:[UIImage imageNamed:@"Color_rectangle"]];
    [backgroundImg2 setUserInteractionEnabled:YES];
    [addressView addSubview:backgroundImg2];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(backgroundImg1.frame)+M_WIDTH(40), WIN_WIDTH,cell_dizhi_H-CGRectGetMaxY(backgroundImg1.frame)-M_WIDTH(40))];
    [btn addTarget:self action:@selector(dizhiTouch) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:btn];
    return addressView;
}

-(void)initHeadView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,M_WIDTH(40))];
    headView.backgroundColor=UIColorFromRGB(0xf4f4f4);
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,WIN_WIDTH/2,M_WIDTH(40))];
    titlelab.text=@"请选择商品配送方式";
    titlelab.textAlignment=NSTextAlignmentLeft;
    titlelab.font=COMMON_FONT;
    
    [headView addSubview:titlelab];
    [self.view addSubview:headView];
}

-(void)initButtomView
{
    UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-M_WIDTH(45),WIN_WIDTH,M_WIDTH(45))];
    buttomView.backgroundColor=[UIColor whiteColor];
    
    hejiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), 0, M_WIDTH(150), M_WIDTH(45))];
    hejiLab.textAlignment=NSTextAlignmentLeft;
    hejiLab.font=DESC_FONT;
//    NSString *str1=@"合计：";
//    NSString *str2=[NSString stringWithFormat:@"%d%@",zongJifen,@"积分"];
//    [self colorLab:hejiLab :str1 :str2 :nil];
    [buttomView addSubview:hejiLab];
    
    UIButton *querenBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(107),0,M_WIDTH(107),M_WIDTH(45))];
    [querenBtn setTitle:@"确认订单" forState:UIControlStateNormal];
    [querenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenBtn.titleLabel.font=BIG_FONT;
    querenBtn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    [querenBtn addTarget:self action:@selector(querenTouch) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:querenBtn];
    [self.view addSubview:buttomView];
}

//选择地址
-(void)dizhiTouch
{
    AddressController *vc=[[AddressController alloc]init];
    vc.dizhiiddelegate=self;
    vc.typeStr=@"1";
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//确认订单
-(void)querenTouch
{
    CheckController *cVC=[[CheckController alloc]init];
    [self.delegate.navigationController pushViewController:cVC animated:YES];
}
//选择地址返回代理方法
-(void)setid_contents:(id)contents
{
    [self dizhiLoafData:contents];
}

//选择送货方式点击事件
-(void)itemTypeTouch:(UIButton *)sender
{
    int  item_s=(int)sender.tag/100;
    int  item_c=(int)sender.tag%100;
    NSArray *array=[[NSArray alloc]init];
    array=[_dataDic allKeys];
    if (item_c==0) {
        [_dataDic objectForKey:array[item_s]][0][@"kuaidiType"]=@"0";
    }else{
        [_dataDic objectForKey:array[item_s]][0][@"kuaidiType"]=@"1";
    }
    [self jiesuanMoney];
    [self.tableView1 reloadData];
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
}

//计算积分
-(void)jiesuanMoney
{
    NSArray *array=[[NSArray alloc]init];
    array=[_dataDic allKeys];
    int jifen=0;
    for (int i=0; i<array.count; i++) {
        NSArray *itemAry=[_dataDic objectForKey:array[i]];
        for (int j=0; j<itemAry.count; j++) {
            NSDictionary *dic=itemAry[j];
            int cartnum  =[[Util isNil:dic[@"cartnum"]]intValue];
            int integral =[[Util isNil:dic[@"integral"]]intValue];
            jifen=jifen+(cartnum * integral);
            if ([[Util isNil:dic[@"kuaidiType"]]isEqualToString:@"0"]) {
                int yunfei=[dic[@"freight"]intValue];
                jifen=jifen +yunfei;
            }
        }
    }
    NSString *str1=@"合计：";
    NSString *str2=[NSString stringWithFormat:@"%d%@",jifen,@"积分"];
    [self colorLab:hejiLab :str1 :str2 :nil];

}


//处理获取到的数据
-(NSMutableDictionary*)chuliAry:(NSArray*)mAry :(NSArray *)yunfeiAry;
{
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];

    
    for (NSDictionary *dic in mAry) {
        
        NSMutableDictionary    *diction=[dic mutableCopy];
        NSString *str1=[Util isNil:dic[@"mall_name"]];
        int idstr=[[Util isNil:dic[@"id"]]intValue];
        
        for (NSDictionary *dic2 in yunfeiAry) {
            int goodid=[[Util isNil:dic2[@"good_id"]]intValue];
            if (goodid==idstr) {
                [diction setObject:[Util isNil:dic2[@"freight"]] forKey:@"freight"]; //
                [diction setObject:[Util isNil:dic2[@"good_id"]] forKey:@"good_id"]; //
            }
        }
        [diction setObject:@"0" forKey:@"kuaidiType"]; //在每条数据里面塞一个变量
        NSArray *itemAry=dataDic[str1];
        if (itemAry==nil) {
            NSMutableArray *itemmuAry=[[NSMutableArray alloc]init];
            [itemmuAry addObject:diction];
            [dataDic setObject:itemmuAry forKey:str1];
        }else {
            [dataDic[str1] addObject:diction];
        }
    }
    return dataDic;
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
