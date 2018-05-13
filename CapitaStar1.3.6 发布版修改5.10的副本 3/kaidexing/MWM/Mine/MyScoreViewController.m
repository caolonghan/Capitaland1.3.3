//
//  MyScoreViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyScoreViewController.h"

#import "StarScoreTView.h"
#import "StarBabyTView.h"

@interface MyScoreViewController ()
{
    StarBabyTView * starBabyTV;
    
    UILabel * starScoreOrCoin;
    
    UILabel * yuELab;
    
    NSMutableArray * btnTitles;
    
    UIView * btnView;
    
    NSString * integral_brance; //星积分余额
    
    NSString * coin_balance;    //星币余额
    
    NSString * expiry_integral; //有期限的星积分
    
    NSString * expiry_date;    //期限时间段
    
    NSArray * integral;
    
    NSMutableArray * sparkids;  //星宝贝ID（传0时查我，不为0时查询对应的星宝贝）。
    
    BOOL isHaveStarBaby;
}
@end

@implementation MyScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"我的星积分";
    
    btnTitles = [[NSMutableArray alloc] init];
    [btnTitles addObject:@"我的星积分"];
    
    sparkids = [[NSMutableArray alloc] init];
    
    [self networkRequestWithSparkid:@"0"];
    
    //[self createSubviews];
}

- (void)networkRequestWithSparkid:(NSString *)sparkid {
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", sparkid, @"spark_id", @"1000", @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"starintegral" ] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary * dataDic = dic[@"data"];
            [btnTitles addObject:@"我的星积分"];
            if (!integral_brance) {
                
                integral_brance = dataDic[@"integral_balance"];
                coin_balance = dataDic[@"coin_balance"];
                expiry_integral = dataDic[@"expiry_integral"];

//                expiry_date = [DateUtil stringDateFromString:dataDic[@"expiry_date"] format:DF_8 toFormat:DF_6];
                
                expiry_date=dataDic[@"expiry_date"];
            }
            integral = dataDic[@"integral"];  //星积分交易数据
            
            NSArray * sparks = dataDic[@"sparks"];
            
            if (sparks.count) {
                [sparkids removeAllObjects];
                [btnTitles removeAllObjects];
                [btnTitles addObject:@"我的星积分"];
                [sparkids addObject:@"0"];
                for (NSDictionary * dic in sparks) {
                    
                    [btnTitles addObject:[NSString stringWithFormat:@"%@%@",@"星宝贝",dic[@"spark_name"]]];
                    [sparkids addObject:[NSString stringWithFormat:@"%@",dic[@"id"]]];
                }
                isHaveStarBaby = YES;
                
            } else {
                isHaveStarBaby = NO;
            }
            if (starBabyTV) {
                
                starBabyTV.dataArr = integral;
                starBabyTV.xingBBId = sparkid;
                
                [starBabyTV reloadData];
            } else {
                [self createSubviews];
            }
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
    }];
}

- (void)createSubviews {
    
    UIImageView * introImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, M_WIDTH(82))];
    introImgV.image = [UIImage imageNamed:@"lightblue_background"];
    
    [self.view addSubview:introImgV];
    
    
//    UIImageView * coverIV = [[UIImageView alloc] initWithFrame:CGRectMake(M_WIDTH(8), M_WIDTH(16), M_WIDTH(50), M_WIDTH(50))];
//    coverIV.layer.cornerRadius =coverIV.frame.size.height/2;
//    coverIV.layer.masksToBounds = YES;
//    coverIV.contentMode =  UIViewContentModeScaleAspectFill;
//    coverIV.clipsToBounds = YES;
//    coverIV.backgroundColor = [UIColor whiteColor];
//
//    [coverIV setImageWithString:[Global sharedClient].img_url placeholderImage:[UIImage imageNamed:@"user"]];
//    
//    [introImgV addSubview:coverIV];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(M_WIDTH(8), M_WIDTH(25), M_WIDTH(80), M_WIDTH(12))];
    label.font = DESC_FONT;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"星积分：%@", integral_brance];
    [label sizeToFit];
    
    [introImgV addSubview:label];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + M_WIDTH(8), M_WIDTH(25), 1, M_WIDTH(12))];
    view.backgroundColor = COLOR_LINE;
    
    [introImgV addSubview:view];
    
    
    UILabel * label_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(view.frame) + M_WIDTH(8), M_WIDTH(25), M_WIDTH(100), M_WIDTH(12))];
    label_1.font = DESC_FONT;
    label_1.textColor = [UIColor whiteColor];
    label_1.text = [NSString stringWithFormat:@"星币：%@", coin_balance];
    [label_1 sizeToFit];
    [introImgV addSubview:label_1];
    
    
    UILabel * label_2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) + M_WIDTH(11), introImgV.frame.size.width - CGRectGetMinX(label.frame) - 10, M_WIDTH(10))];
    label_2.font = INFO_FONT;
    label_2.textColor = UIColorFromRGB(0xe6edf8);
    label_2.text = [NSString stringWithFormat:@"星积分%@ 有效期至%@", expiry_integral, expiry_date];
    
    [introImgV addSubview:label_2];
    
    //根据网络请求的参数判断是否添加了星宝贝
    
    if (isHaveStarBaby) {
        
        btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introImgV.frame), WIN_WIDTH, M_WIDTH(39))];
        btnView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:btnView];
        
        CGFloat btnWidth = (WIN_WIDTH - 2) / 3;
        
        for (int i = 0; i < btnTitles.count; i++) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * (btnWidth + 1), 0, btnWidth, 39);
            btn.tag = i + 900;
            btn.titleLabel.font = DESC_FONT;
            [btn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(starScoreOrStarBaby:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnView addSubview:btn];
            
            //按钮选中时底下的红线
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame) - 2, CGRectGetWidth(btn.frame), 2)];
            view.tag = i + 5000;
            view.backgroundColor = APP_BTN_COLOR;
            view.hidden = YES;
            
            [btn addSubview:view];
            
            if (i == 0) {
                
                [btn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
                view.hidden = NO;
                
                for (int j = 0; j < 2; j++) {
                    
                    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.frame) * (j+1) + j, 15, 1, 11)];
                    lineView.backgroundColor = COLOR_LINE;
                    
                    [btnView addSubview:lineView];
                }
            }
        }
        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnView.frame), WIN_WIDTH, 35)];
        grayView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        [self.view addSubview:grayView];
        
        
        starScoreOrCoin = [[UILabel alloc] initWithFrame:CGRectMake(M_WIDTH(15), 10, M_WIDTH(170), 15)];
        starScoreOrCoin.font = DESC_FONT;
        starScoreOrCoin.textColor = COLOR_FONT_SECOND;
        starScoreOrCoin.text = @"我最近的星积分交易";
        
        [grayView addSubview:starScoreOrCoin];
        
        
        yuELab = [[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH - M_WIDTH(16) - M_WIDTH(200), 12, M_WIDTH(200), 10)];
        yuELab.font = DESC_FONT;
        yuELab.textAlignment = NSTextAlignmentRight;
        yuELab.textColor = COLOR_FONT_BLACK;
        yuELab.text = [NSString stringWithFormat:@"星积分余额：%@", integral_brance];
        yuELab.attributedText = [Util getAttrColor:yuELab.text begin:6 end:yuELab.text.length - 6 color:UIColorFromRGB(0xff7800)];
        
        [grayView addSubview:yuELab];
        
        
        //我的星积分 & 我的星宝贝共用一个tableView;
        starBabyTV = [[StarBabyTView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), WIN_WIDTH, WIN_HEIGHT - CGRectGetMaxY(grayView.frame)) style:UITableViewStylePlain];
        starBabyTV.dataArr = integral;
        starBabyTV.typestr=[NSString stringWithFormat:@"%d",0];
        [self.view addSubview:starBabyTV];
        
    } else {
        UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introImgV.frame), WIN_WIDTH, 35)];
        grayView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        
        [self.view addSubview:grayView];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(M_WIDTH(8), 12, M_WIDTH(130), 10)];
        label.font = DESC_FONT;
        label.textColor = COLOR_FONT_SECOND;
        label.text = @"我最近的星积分交易";
        
        [grayView addSubview:label];
        
        
        UILabel * label_1 = [[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH -M_WIDTH(150), 12,M_WIDTH(140), 10)];
        label_1.font = DESC_FONT;
        label_1.textAlignment = NSTextAlignmentRight;
        label_1.textColor = COLOR_FONT_BLACK;
        label_1.text = [NSString stringWithFormat:@"星积分余额：%@", integral_brance];
        label_1.attributedText = [Util getAttrColor:label_1.text begin:6 end:label_1.text.length - 6 color:UIColorFromRGB(0xff7800)];
        
        [grayView addSubview:label_1];
        
        
        StarScoreTView * starScoreTV = [[StarScoreTView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(grayView.frame), WIN_WIDTH, WIN_HEIGHT - CGRectGetMaxY(grayView.frame)) style:UITableViewStylePlain];
        starScoreTV.dataArr = integral;
        
        [self.view addSubview:starScoreTV];
    }
}

- (void)starScoreOrStarBaby:(UIButton *)sender {
    //选中按钮字颜色切换
    [sender setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    NSInteger i = sender.tag - 900;
    if(i == 0){
        [starBabyTV removeFooterView];
    }else{
        NSArray *jifenARy=[[NSArray alloc]initWithObjects:integral_brance,expiry_date,expiry_integral,sparkids[i],nil];
        [starBabyTV createSubviews :jifenARy];
    }
    switch (i) {

        case 0:{
            
            if (![sender viewWithTag:5000].hidden) {
                return;
            }
            //按钮字颜色切换 & 红线的显示||隐藏
            [sender viewWithTag:5000].hidden = NO;
            
            UIButton * centerBtn = [btnView viewWithTag:901];
            [centerBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [centerBtn viewWithTag:5001].hidden = YES;
            
            //未必有第二个星宝贝
            if ([btnView viewWithTag:902]) {
                UIButton * rightBtn = [btnView viewWithTag:902];
                [rightBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
                [rightBtn viewWithTag:5002].hidden = YES;
            }
            [self networkRequestWithSparkid:@"0"];
            
        }
            break;
        case 1:{
            
            if (![sender viewWithTag:5001].hidden) {
                return;
            }
            //按钮字颜色切换 & 红线的显示||隐藏
            UIButton * leftBtn = [btnView viewWithTag:900];
            [leftBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [leftBtn viewWithTag:5000].hidden = YES;
            
            [sender viewWithTag:5001].hidden = NO;
            
            //未必有第二个星宝贝
            if ([btnView viewWithTag:902]) {
                UIButton * rightBtn = [btnView viewWithTag:902];
                [rightBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
                [rightBtn viewWithTag:5002].hidden = YES;
            }
            [self networkRequestWithSparkid:sparkids[i]];
        }
            break;
        case 2:{
            
            if (![sender viewWithTag:5002].hidden) {
                return;
            }
            //按钮字颜色切换 & 红线的显示|隐藏
            UIButton * leftBtn = [btnView viewWithTag:900];
            [leftBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [leftBtn viewWithTag:5000].hidden = YES;
            
            UIButton * centerBtn = [btnView viewWithTag:901];
            [centerBtn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [centerBtn viewWithTag:5001].hidden = YES;
            
            [sender viewWithTag:5002].hidden = NO;
            
            [self networkRequestWithSparkid:sparkids[i]];
        }
            break;
        default:
            break;
    }
    if (i == 0) {
        starScoreOrCoin.text = @"我最近的星积分交易";
        yuELab.text = [NSString stringWithFormat:@"星积分余额：%@", integral_brance];
        yuELab.attributedText = [Util getAttrColor:yuELab.text begin:6 end:yuELab.text.length - 6 color:UIColorFromRGB(0xff7800)];
    } else {
        starScoreOrCoin.text = @"我最近的星币交易";
        yuELab.text = [NSString stringWithFormat:@"星币余额：%@", coin_balance];
        yuELab.attributedText = [Util getAttrColor:yuELab.text begin:5 end:yuELab.text.length - 5 color:UIColorFromRGB(0xff7800)];
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
