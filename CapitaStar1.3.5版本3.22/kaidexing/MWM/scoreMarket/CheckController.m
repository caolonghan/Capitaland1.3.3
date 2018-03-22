//
//  CheckController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/2.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CheckController.h"
#import "ExchangeSuccessController.h"

#define cell_Head       M_WIDTH(43)//93
#define cell_view_H     M_WIDTH(85)
#define cell_kuaidi     M_WIDTH(123)
#define cell_xuni       M_WIDTH(83)

@interface CheckController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView     *tableView1;

@end

@implementation CheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"确认订单";
    [self initHeadView];
    [self inittableView1];
    [self initButtomView];
}

-(void)loadData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getorder"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            
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
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [UIUtil removeSubView:cell];
    if (indexPath.section!=0) {
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
    if (indexPath.section!=0) {
        se_H = M_WIDTH(303);
    }else{
        se_H = M_WIDTH(108);
    }
    return se_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_WIDTH(10);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)creatCell_View:(NSIndexPath*)indexpath
{
    
    UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(303))];
    //表示商城的图标
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(15),M_WIDTH(14.5),M_WIDTH(13))];
    [iconImg setImage:[UIImage imageNamed:@"house"]];
    [cellView addSubview:iconImg];
    //商城的名字
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(5),(M_WIDTH(42)-M_WIDTH(14))/2, M_WIDTH(20), M_WIDTH(14))];
    nameLab.font=[UIFont systemFontOfSize:M_WIDTH(14)];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.text=@"000000000000";
    [nameLab sizeToFit];
    [cellView addSubview:nameLab];
    
    UIImageView *redImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(72), 0, M_WIDTH(60), M_WIDTH(29))];
    [redImg setImage:[UIImage imageNamed:@"bolang_red"]];
    [cellView addSubview:redImg];
    
    NSString *dingdanIndex=[NSString stringWithFormat:@"%d",(int)indexpath.section];
    UILabel *dingdanLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH(60), M_WIDTH(26))];
    dingdanLab.font=DESC_FONT;
    dingdanLab.textAlignment=NSTextAlignmentCenter;
    dingdanLab.textColor=[UIColor whiteColor];
    dingdanLab.text=[NSString stringWithFormat:@"%@%@",@"订单",[self translation:dingdanIndex]];
    [redImg addSubview:dingdanLab];
    
    //中间第一条分割线
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(42)-1, WIN_WIDTH,1)];
    line1.backgroundColor=COLOR_LINE;
    [cellView addSubview:line1];
    UIView *shopView;
    for (int i=0;i<2;i++) {
        
        shopView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(53)+cell_view_H*i, WIN_WIDTH, cell_view_H)];
        //购买的商品的Logo
        UIImageView  *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(0), M_WIDTH(73), M_WIDTH(73))];
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        logoImg.layer.borderColor=[COLOR_LINE CGColor];
        logoImg.layer.borderWidth=1;
        logoImg.backgroundColor=[UIColor redColor];
        [shopView addSubview:logoImg];
        
        //商品的名字
        UILabel  *commodityNameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10),0, M_WIDTH(220), M_WIDTH(20))];
        commodityNameLab.textAlignment=NSTextAlignmentLeft;
        commodityNameLab.text=@"商品的名字";
        commodityNameLab.numberOfLines=0;
        commodityNameLab.font=COMMON_FONT;
        CGRect rect2=[commodityNameLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(220),M_WIDTH(36)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:commodityNameLab.font} context:nil];
        commodityNameLab.frame=CGRectMake(commodityNameLab.frame.origin.x, commodityNameLab.frame.origin.y, rect2.size.width, rect2.size.height);
        [shopView addSubview:commodityNameLab];
        
        //价格
        UILabel  *unitPriceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(logoImg.frame)-M_WIDTH(15), M_WIDTH(150), M_WIDTH(12))];
        unitPriceLab.text=[NSString stringWithFormat:@"%d %@",12,@"积分"];
        unitPriceLab.textAlignment=NSTextAlignmentLeft;
        unitPriceLab.font=DESC_FONT;
        unitPriceLab.textColor=COLOR_FONT_SECOND;
        [shopView addSubview:unitPriceLab];
        
        //相同商品数量
        UILabel  *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(60), CGRectGetMaxY(logoImg.frame)-M_WIDTH(16), M_WIDTH(50), M_WIDTH(12))];
        numberLab.textAlignment=NSTextAlignmentRight;
        numberLab.font=DESC_FONT;
        int count=1;
        numberLab.text=[NSString stringWithFormat:@"%@%d",@"x",count];
        [shopView addSubview:numberLab];
        
        [cellView addSubview:shopView];
    }
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(shopView.frame)-1, WIN_WIDTH-M_WIDTH(10), 1)];
    line2.backgroundColor=COLOR_LINE;
    [cellView addSubview:line2];
    int z=1;
    if (z==0) {
        UILabel *jianziLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(line2.frame), WIN_WIDTH-M_WIDTH(20), M_WIDTH(40))];
        jianziLab.text=@"电子券商品将以卡券形式直接发送到您的用户卡包";
        jianziLab.textAlignment=NSTextAlignmentLeft;
        jianziLab.font=[UIFont systemFontOfSize:13];
        [cellView addSubview:jianziLab];
    }else if(z==1){
        UILabel  *typeLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line2.frame), M_WIDTH(80), M_WIDTH(40))];
        typeLab.text=@"快递给我";
        typeLab.textAlignment=NSTextAlignmentLeft;
        typeLab.font=DESC_FONT;
        [cellView addSubview:typeLab];
        
        UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),CGRectGetMaxY(line2.frame)+ M_WIDTH(8), M_WIDTH(190),M_WIDTH(13))];
        addressLab.textAlignment=NSTextAlignmentRight;
        addressLab.textColor=[UIColor redColor];
        addressLab.text=@"*由上海来福士广场发出";
        addressLab.font=INFO_FONT;
        [cellView addSubview:addressLab];
        
        UILabel *yunfeiLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),CGRectGetMaxY(addressLab.frame),M_WIDTH(190),M_WIDTH(14))];
        yunfeiLab.text=@"运费200积分";
        yunfeiLab.textAlignment=NSTextAlignmentRight;
        yunfeiLab.textColor=[UIColor redColor];
        yunfeiLab.font=INFO_FONT;
        [cellView addSubview:yunfeiLab];
 
    }else if(z==2){
        UILabel  *typeLab2=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line2.frame), M_WIDTH(80), M_WIDTH(40))];
        typeLab2.text=@"到商场自提";
        typeLab2.textAlignment=NSTextAlignmentLeft;
        typeLab2.font=DESC_FONT;
        [cellView addSubview:typeLab2];
        
        UILabel *addressLab2=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),CGRectGetMaxY(line2.frame), M_WIDTH(190),M_WIDTH(40))];
        addressLab2.textAlignment=NSTextAlignmentRight;
        addressLab2.textColor=[UIColor redColor];
        addressLab2.text=@"*请在商品所在商场领取";
        addressLab2.font=INFO_FONT;
        [cellView addSubview:addressLab2];
    }
    
        UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(line2.frame)+M_WIDTH(40)-1, WIN_WIDTH-M_WIDTH(10), 1)];
        line3.backgroundColor=COLOR_LINE;
        [cellView addSubview:line3];
        
        UILabel *shoplab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line3.frame), WIN_WIDTH-M_WIDTH(10), M_WIDTH(43))];
        NSString *str11=@"共一件商品  合计 : ";
        NSString *str22=@"700积分";
        shoplab.textAlignment=NSTextAlignmentRight;
        shoplab.font=DESC_FONT;
        [self colorLab:shoplab :str11 :str22 :nil];
        [cellView addSubview:shoplab];
    
    return cellView;
}


-(UIView*)initdizhiView
{
    UIView *addressView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(108))];
    addressView.backgroundColor=[UIColor whiteColor];
    UIImageView  *backgroundImg1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(3))];
    [backgroundImg1 setImage:[UIImage imageNamed:@"Color_rectangle"]];
    [backgroundImg1 setUserInteractionEnabled:YES];
    [addressView addSubview:backgroundImg1];
    
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(12), M_WIDTH(15), M_WIDTH(12), M_WIDTH(16))];
    [iconImg setImage:[UIImage imageNamed:@"iconfont-zuobiao"]];
    [addressView addSubview:iconImg];
    
    //名字+手机号
    UILabel  *name=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(28),M_WIDTH(15),M_WIDTH(300),M_WIDTH(17))];
    name.text=@"王晓晓 1234567955";
    name.textAlignment=NSTextAlignmentLeft;
    name.font=COMMON_FONT;
    [addressView addSubview:name];
    
    //地址
    UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30), CGRectGetMaxY(name.frame)+M_WIDTH(4),M_WIDTH(245), M_WIDTH(15))];
    dizhiLab.font=DESC_FONT;
    dizhiLab.textColor=COLOR_FONT_SECOND;
    dizhiLab.textAlignment=NSTextAlignmentLeft;
    dizhiLab.numberOfLines=2;
    dizhiLab.text=@"asdasdasdasdasdasdasdasdasdasdasdasdasdasd";
    CGRect rect10=[dizhiLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(245),M_WIDTH(40)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:dizhiLab.font} context:nil];
    dizhiLab.frame=CGRectMake(dizhiLab.frame.origin.x,dizhiLab.frame.origin.y, rect10.size.width, rect10.size.height);
    [addressView addSubview:dizhiLab];
    
    //邮编
    UILabel  *eLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(30),M_WIDTH(75),M_WIDTH(200),M_WIDTH(16))];
    eLab.text=[NSString stringWithFormat:@"%@",@"113555455@qq.com"];
    eLab.textColor=COLOR_FONT_SECOND;
    eLab.textAlignment=NSTextAlignmentLeft;
    eLab.font=DESC_FONT;
    [addressView addSubview:eLab];
    
    UIImageView  *backgroundImg2=[[UIImageView alloc]initWithFrame:CGRectMake(0,M_WIDTH(105),WIN_WIDTH,M_WIDTH(3))];
    [backgroundImg2 setImage:[UIImage imageNamed:@"Color_rectangle"]];
    [backgroundImg2 setUserInteractionEnabled:YES];
    [addressView addSubview:backgroundImg2];
    
    return addressView;
}

-(void)initHeadView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT,WIN_WIDTH, M_WIDTH(40))];
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
    
    UILabel *hejiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), 0, M_WIDTH(150), M_WIDTH(45))];
    hejiLab.textAlignment=NSTextAlignmentLeft;
    hejiLab.font=DESC_FONT;
    NSString *str1=@"合计：";
    NSString *str2=@"700积分";
    [self colorLab:hejiLab :str1 :str2 :nil];
    [buttomView addSubview:hejiLab];
    
    UIButton *querenBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(107),0,M_WIDTH(107),M_WIDTH(45))];
    [querenBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
    [querenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenBtn.titleLabel.font=BIG_FONT;
    querenBtn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    [querenBtn addTarget:self action:@selector(querenTouch) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:querenBtn];
    [self.view addSubview:buttomView];
}

//确认提交按钮
-(void)querenTouch
{
    ExchangeSuccessController *evc=[[ExchangeSuccessController alloc]init];
    [self.delegate.navigationController pushViewController:evc animated:YES];
}

//lab文字加工
-(void)colorLab:(UILabel *)lab :(NSString*)str1 :(NSString *)str2 :(NSString*)str3
{
    int  str1_l   =(int)str1.length;
    int  str2_l   =(int)str2.length;
    
    NSString    *labText = [NSString stringWithFormat:@"%@%@%@",str1,str2,[Util isNil:str3]];
    lab.text             = labText;
    lab.attributedText   = [Util getAttrColor:lab.text begin:str1_l end:str2_l color:[UIColor redColor]];
}



//阿拉伯数字转成中文数字
-(NSString *)translation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
