//
//  ExchangeSuccessController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/2.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ExchangeSuccessController.h"

#define cell_jiange M_WIDTH(11)

@interface ExchangeSuccessController ()<UIScrollViewDelegate>
@property (strong,nonatomic)UIScrollView    *scrollView1;

@end

@implementation ExchangeSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"支付成功";
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.scrollEnabled=YES;
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT);
    self.scrollView1.backgroundColor=UIColorFromRGB(0xf4f4f4);
    [self.view addSubview:self.scrollView1];
    [self initHeadView];
    [self initcellView];
}

-(void)initHeadView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0,cell_jiange, WIN_WIDTH,M_WIDTH(206))];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(25), M_WIDTH(32), M_WIDTH(50), M_WIDTH(50))];
    [logoImg setImage:[UIImage imageNamed:@""]];
    [headView addSubview:logoImg];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(logoImg.frame)+M_WIDTH(16),WIN_WIDTH, M_WIDTH(28))];
    lab1.text=@"谢谢您!";
    lab1.font=[UIFont systemFontOfSize:20];
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.textColor=[UIColor redColor];
    [headView addSubview:lab1];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab1.frame),WIN_WIDTH,M_WIDTH(25))];
    lab2.text=@"您的订单已经支付成功!";
    lab2.font=BIG_FONT;
    lab2.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:lab2];
    
    UILabel *lab3=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab2.frame),WIN_WIDTH,M_WIDTH(28))];
    lab3.text=@"已支付积分：2200积分";
    lab3.font=DESC_FONT;
    lab3.textAlignment=NSTextAlignmentCenter;
    lab3.textColor=COLOR_FONT_SECOND;
    [headView addSubview:lab3];
    
    [self.scrollView1 addSubview:headView];
}
-(void)initcellView
{
    CGFloat view_TOP=cell_jiange*2+M_WIDTH(206);
    
    UIView *itemView;
    for (int i=0; i<2; i++) {
        CGFloat view_H;
        itemView=[[UIView alloc]init];
        itemView.backgroundColor=[UIColor whiteColor];

        UILabel *dingdanIndex=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,M_WIDTH(100),M_WIDTH(42))];
        dingdanIndex.textAlignment=NSTextAlignmentLeft;
        dingdanIndex.font=COMMON_FONT;
        NSString *index=[self translation:[NSString stringWithFormat:@"%d",i]];
        dingdanIndex.text=[NSString stringWithFormat:@"%@%@",@"订单",index];
        [itemView addSubview:dingdanIndex];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(42-1),WIN_WIDTH,1)];
        lineView.backgroundColor=COLOR_LINE;
        [itemView addSubview:lineView];
        
        UILabel *typeLab=[[UILabel alloc]init];
        typeLab.textColor=[UIColor redColor];
        typeLab.font=DESC_FONT;
        typeLab.textAlignment=NSTextAlignmentRight;
        
        if(i==0){
            typeLab.text=@"自提";
            typeLab.frame=CGRectMake(WIN_WIDTH-M_WIDTH(100), 0, M_WIDTH(75), M_WIDTH(42));
            UIImageView *rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(typeLab.frame)+M_WIDTH(7), (M_WIDTH(42)-M_WIDTH(13))/2, M_WIDTH(8),M_WIDTH(13))];
            [rightImg setImage:[UIImage imageNamed:@"right_2"]];
            [itemView addSubview:rightImg];
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(100), 0,M_WIDTH(100), M_WIDTH(42))];
            btn.tag=i;
            [btn addTarget:self action:@selector(zitiTouch:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:btn];
            
            UILabel *cLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(lineView.frame), M_WIDTH(300), M_WIDTH(43))];
            cLab.text=[NSString stringWithFormat:@"%@%@",@"自提商城",@"上海来福士"];
            [self labchuli:cLab];
            [itemView addSubview:cLab];
            view_H=M_WIDTH(85);
        
        }else{
            typeLab.text=@"自提";
            typeLab.frame=CGRectMake(WIN_WIDTH-M_WIDTH(85), 0, M_WIDTH(75), M_WIDTH(42));
            
            UILabel *fahuoLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(lineView.frame)+M_WIDTH(12), M_WIDTH(300), M_WIDTH(14))];
            fahuoLab.text=[NSString stringWithFormat:@"%@%@",@"发货商场：",@"上海闵行龙之梦"];
            [self labchuli:fahuoLab];
            [itemView addSubview:fahuoLab];
            
            UILabel *shouhuoLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(fahuoLab.frame)+M_WIDTH(9), M_WIDTH(300), M_WIDTH(14))];
            shouhuoLab.text=[NSString stringWithFormat:@"%@%@",@"收件人：",@"王晓晓"];
            [self labchuli:shouhuoLab];
            [itemView addSubview:shouhuoLab];
        
            UILabel *dizhiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(shouhuoLab.frame)+M_WIDTH(6),75, 14)];
            dizhiLab.text=[NSString stringWithFormat:@"%@",@"收件地址："];
            [self labchuli:dizhiLab];
            [itemView addSubview:dizhiLab];
            
            UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10)+75,CGRectGetMaxY(shouhuoLab.frame)+M_WIDTH(3),WIN_WIDTH-M_WIDTH(20)-75, M_WIDTH(36))];
            addressLab.text=@"asdasdjaklsjdajsdalksjdlkajsdklajsldjkaldjslka";
            addressLab.numberOfLines=0;
            [self labchuli:addressLab];
            CGRect rect20=[addressLab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(20)-75,M_WIDTH(36)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:addressLab.font} context:nil];
            addressLab.frame=CGRectMake(addressLab.frame.origin.x, addressLab.frame.origin.y, rect20.size.width, rect20.size.height);
            [itemView addSubview:addressLab];

            view_H=M_WIDTH(106)+rect20.size.height;

        }
        
        itemView.frame=CGRectMake(0,view_TOP, WIN_WIDTH, view_H);
        [itemView addSubview:typeLab];
        view_TOP=view_TOP+view_H+cell_jiange;
        [self.scrollView1 addSubview:itemView];
    }
    
    UIButton *zhifuBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17),CGRectGetMaxY(itemView.frame)+M_WIDTH(23),(WIN_WIDTH-M_WIDTH(51))/2,M_WIDTH(42))];
    zhifuBtn.layer.masksToBounds=YES;
    zhifuBtn.layer.cornerRadius=5;
    zhifuBtn.backgroundColor=UIColorFromRGB(0xaaaaaa);
    [zhifuBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    zhifuBtn.titleLabel.font=COOL_FONT;
    [zhifuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zhifuBtn addTarget:self action:@selector(zhifuTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:zhifuBtn];
    
    UIButton *weixinBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhifuBtn.frame)+M_WIDTH(17),CGRectGetMaxY(itemView.frame)+M_WIDTH(23),(WIN_WIDTH-M_WIDTH(51))/2,M_WIDTH(42))];
    weixinBtn.layer.masksToBounds=YES;
    weixinBtn.layer.cornerRadius=5;
    weixinBtn.backgroundColor=UIColorFromRGB(0xe12b2b);
    [weixinBtn setTitle:@"继续购物" forState:UIControlStateNormal];
    weixinBtn.titleLabel.font=COOL_FONT;
    [weixinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:weixinBtn];
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, CGRectGetMaxY(weixinBtn.frame)+M_WIDTH(17));
    
    
}

//点击了查看订单
-(void)zhifuTouch
{
    
}

//点击了继续购物
-(void)weixinBtnTouch
{
    
}


//点击了自提
-(void)zitiTouch:(UIButton*)sender
{
    
    
    
}

-(void)labchuli:(UILabel*)lab
{
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=COLOR_FONT_SECOND;
    lab.font=DESC_FONT;
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
