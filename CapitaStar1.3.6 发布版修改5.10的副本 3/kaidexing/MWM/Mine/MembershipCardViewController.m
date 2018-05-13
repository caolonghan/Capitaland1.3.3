//
//  MembershipCardViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MembershipCardViewController.h"

#import "MembershipCardCView.h"

@interface MembershipCardViewController ()
{
    NSMutableArray * vipCards;
}
@end

@implementation MembershipCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"我的会员卡";
    
    vipCards = [[NSMutableArray alloc] init];
    
    [self networkRequest];
    
    //[self createSubviews];
}

- (void)networkRequest {
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @"1000",  @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"vipcard"] parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
 
            NSDictionary * dataDic =dic[@"data"];
            
            NSString * spark_name = dataDic[@"parentName"];
            NSString * spark_member_number = dataDic[@"parentMemberNo"];
            NSString * capital_member_card = dataDic[@"vipimgurl"];
            NSDictionary * parent = [NSDictionary dictionaryWithObjectsAndKeys:spark_name, @"spark_name", spark_member_number, @"spark_member_number", capital_member_card, @"capital_member_card", nil];
            
            [vipCards addObject:parent];
            
            [vipCards addObjectsFromArray:dataDic[@"sparksvipcard"]];
            
            [self createSubviews];
            
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
        
        
    }];
}

- (void)createSubviews {
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemHeight = WIN_HEIGHT - NAV_HEIGHT;
    
    flowLayout.itemSize = CGSizeMake(WIN_WIDTH, itemHeight);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    MembershipCardCView * membershipCV = [[MembershipCardCView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, itemHeight) collectionViewLayout:flowLayout];
    membershipCV.dataArr = vipCards;
    
    [self.view addSubview:membershipCV];
    
    if (vipCards.count<2) {
        return;
    }
    UIImageView * promptImgV = [[UIImageView alloc] initWithFrame:CGRectMake((WIN_WIDTH - 36) / 2, WIN_HEIGHT - 22 - 36, 36, 36)];
    promptImgV.layer.cornerRadius = 18;
    promptImgV.layer.masksToBounds = YES;
    promptImgV.image = [UIImage imageNamed:@"sharp_2"];
    
    [self.view addSubview:promptImgV];
    
    membershipCV.imgV = promptImgV;
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
