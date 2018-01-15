//
//  MineViewController.m
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/4.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import "MineViewController.h"

#import "LoginViewController.h"
#import "UserCenterViewController.h"
#import "MyScoreViewController.h"
#import "MyVoucherViewController.h"
#import "MyMsgViewController.h"
#import "RootViewController.h"

#import "MembershipCardViewController.h"
#import "CreateStarBabyViewController.h"
#import "ActivityViewController.h"
#import "MyTicketViewController.h"
#import "GetVoucherViewController.h"
#import "ScanViewController.h"

#import "GoViewController.h"

#import "MyCollectionController.h"
#import "RecentBillsController.h"
#import "FeedbackViewController.h"
#import "BindingPlatesViewController.h"

#import "MyOrdersViewController.h"
#import "ExpressOrderController.h"
#import "MyExpressController.h"
#import "PFUIKit.h"
#import "MLabel.h"
#import "MyMALLViewController.h"
#import "UserInfoVM.h"
#import "UserInfo.h"
#import "AddressListViewController.h"

#import "OrderWebViewController.h"


#define nameLab_W M_WIDTH(200)

@interface MineViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView * mineTV;
    BOOL     isFirst;//防止未初始化先赋值，引起提前释放内存
    NSArray * labTitles;
    NSArray * iconImgs;
    UIView   *nilView1;
    UserInfoVM* userInfoVm;
    UILabel* nickNameLab;
    UIButton*jifenBtn;
   
}
@end

@implementation MineViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst=NO;
    self.navigationBarTitleLabel.text= @"个人中心";
    self.navigationBarTitleLabel.textColor=[UIColor whiteColor];
    self.navigationBar.backgroundColor=APP_BTN_COLOR;
//    labTitles = @[@[@"个人中心"],@[@"拍摄小票", @"卡券", @"车牌管理"],@[@"我的订单",@"小票上传记录",@"快递服务",@"兑换码领券",@"我的排号",@"我的活动",@"我的收藏",@"我的MALL",@"星宝贝"],@[@"积分捐赠",@"服务于反馈"]];
//    iconImgs  = @[@[@"aasd",],@[@"m_1",@"m_2",@"m_3"],@[@"m_4",@"m_5",@"m_6",@"m_7",@"m_8",@"m_9",@"m_10",@"m_11",@"m_12"],@[@"m_13",@"m_14"]];
    
    labTitles = @[@[@"asd"],@[@"我的车牌",@"我的订单",@"我的小票",@"我的排号",@"我的活动",@"我的收货地址",@"我的星宝贝"]];
    iconImgs  = @[@[@"asd"],@[@"m_1",@"m_2",@"m_3",@"m_4",@"m_5",@"loc",@"m_6"]];
    
//    if ([_typeStr isEqualToString:@"1"]) {
        self.leftBarItemView.hidden = YES;
//    }
  //  [self pinfoDataLoad];
    [self loadDataNum];
    [self navView];
//    userInfoVm = [[UserInfoVM alloc] init];
//    [userInfoVm.successObject subscribeNext:^(id data) {
//        [self updateUserInfo:data];
//    }];
    
}
- (void)pinfoDataLoad
{
    NSLog(@"会员ID=%@",[Global sharedClient].member_id );
    NSString * path = [Util makeRequestUrl:@"member" tp:@"pinfo"];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id ,@"member_id" ,@"1000", @"source", nil];
    
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        NSDictionary *dataDic = dic[@"data"];
        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"img_url"] forKey:@"img_url"];
        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"username"] forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"integralcount"] forKey:@"integralcount"];
        
         [mineTV reloadData];
        NSLog(@"个人中心%@",dataDic);
    } failue:^(NSDictionary *dic) {
        
    }];
}
//-(void) updateUserInfo:(UserInfo*) userInfo{
//    [nickNameLab setText:userInfo.username];
//
//    [UIUtil removeSubView:jifenBtn];
//    [self chuliView_btn:jifenBtn :@"purse" :@"星积分" :[NSString stringWithFormat:@"%.0f",userInfo.integralcount] :0];
//
//
//
//}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mineTV reloadData];
    [self isSignIn];
    
    if (isFirst==YES) {
        [self loadDataNum];
    }else{
        isFirst=YES;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self getUserInfo];
    [self pinfoDataLoad];
   
    
}
- (void)getUserInfo
{
    [userInfoVm getUserInfo];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)backBtnOnClicked:(id)sender{
    if (![_typeStr isEqualToString:@"1"]) {
        [super backBtnOnClicked:sender];
    }
}

-(void)loadDataNum{
    
    if (mineTV!=nil) {
        [mineTV removeFromSuperview];
    }
    [nilView1 removeFromSuperview];
    
    int zz;
    if([Util isNull:[Global sharedClient].markID]){
        zz=[[Global sharedClient].markID intValue];
        
    }else{
        zz=0;
    }
//    if([Util isNil:[Global sharedClient].member_id]){
        mineTV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT-BAR_HEIGHT-45) style:UITableViewStyleGrouped];
        mineTV.dataSource = self;
        mineTV.delegate = self;
        mineTV.separatorStyle=UITableViewCellSeparatorStyleNone;
        mineTV.backgroundColor=UIColorFromRGB(0xf4f4f4);
        [self.view addSubview:mineTV];
        
//    }else{
//        [SVProgressHUD showWithStatus:@"数据请求中"];
//        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @(zz),@"mall_id",@"1000", @"source", nil];
//
//        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"starintegral"] parameters:params target:self success:^(NSDictionary *dic) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSDictionary *dataDic=dic[@"data"];
//
//                [SVProgressHUD dismiss];
//            });
//            
//        } failue:^(NSDictionary *dic) {
//            [SVProgressHUD dismiss];
//            [self initnilView];
//        }];
//    }

}

-(void)navView{
    
//    UIButton *scanBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scanBtn1 setFrame:self.rigth_laft_BarItemView.bounds];
//    [scanBtn1 setImage:[UIImage imageNamed:@"mine"] forState:UIControlStateNormal];
//    scanBtn1.tag=1;
//    [scanBtn1 addTarget:self action:@selector(headIconTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rigth_laft_BarItemView addSubview:scanBtn1];
//    self.rigth_laft_BarItemView.hidden=NO;
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    scanBtn.tag=0;
    [scanBtn addTarget:self action:@selector(headIconTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden=NO;
}


- (void)pushToUserCenterViewController:(UIButton *)sender {
    if(![self isSignIn]){
        return;
    }
    UserCenterViewController * userCenterVC = [[UserCenterViewController alloc] init];
    [self.delegate.navigationController pushViewController:userCenterVC animated:YES];
}

- (UIView*)createTableHeaderView {
    
    UIButton * mineTHView = [UIButton buttonWithType:UIButtonTypeCustom];
    mineTHView.frame = CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(78));
    mineTHView.backgroundColor=[UIColor whiteColor];
    [mineTHView addTarget:self action:@selector(pushToUserCenterViewController:) forControlEvents:UIControlEventTouchUpInside];

   UIImageView *userIV = [[UIImageView alloc] initWithFrame:CGRectMake(M_WIDTH(11), M_WIDTH(11),M_WIDTH(56),M_WIDTH(56))];
    userIV.layer.cornerRadius = userIV.frame.size.height/2;
    userIV.layer.masksToBounds = YES;
    userIV.backgroundColor = [UIColor whiteColor];
    if ([Util isNull:[Global sharedClient].img_url]) {
        [userIV setImage:[UIImage imageNamed:@"user"]];
    }else {
         [userIV setImageWithURL:[NSURL URLWithString:[Global sharedClient].img_url]];
        
    }
    [mineTHView addSubview:userIV];
    
    nickNameLab = [[UILabel alloc] init];
    
    if ([Util isNull:[Global sharedClient].member_id]) {
        nickNameLab.frame=CGRectMake(CGRectGetMaxX(userIV.frame)+M_WIDTH(11),0,M_WIDTH(150),M_WIDTH(78));
        nickNameLab.font=COMMON_FONT;
        nickNameLab.text=@"    点击登陆";
    }else{
        nickNameLab.frame=CGRectMake(CGRectGetMaxX(userIV.frame)+M_WIDTH(11),M_WIDTH(20),M_WIDTH(150),M_WIDTH(16));
        nickNameLab.font = DESC_FONT;
        nickNameLab.textColor = [UIColor blackColor]; //color_white;
        
//        if ([Util isNull:[Global sharedClient].nick_name]) {
//            nickNameLab.text =@"请设置昵称";
//        } else {
//         //   nickNameLab.text = @"";
//            nickNameLab.text = [Global sharedClient].nick_name;
//        }
        
        if ([Util isNull:[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]]) {
                        nickNameLab.text =@"请设置姓名";
                    } else {
                        nickNameLab.text =[[NSUserDefaults standardUserDefaults]objectForKey:@"username"] ;
                    }
        
        jifenBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userIV.frame)+M_WIDTH(11),CGRectGetMaxY(nickNameLab.frame),M_WIDTH(150),M_WIDTH(30))];
        NSString *starScore = [[NSUserDefaults standardUserDefaults]objectForKey:@"integralcount"];
        
        
        [self chuliView_btn:jifenBtn :@"purse" :@"星积分" :starScore :0] ;
        jifenBtn.tag=0;
        [jifenBtn addTarget:self action:@selector(jifenxiaoxiTouch:) forControlEvents:UIControlEventTouchUpInside];
        [mineTHView addSubview:jifenBtn];
        
//        UIButton*xiaoxiBtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jifenBtn.frame)+M_WIDTH(15),CGRectGetMaxY(nickNameLab.frame),M_WIDTH(105),M_WIDTH(30))];
//        [self chuliView_btn:xiaoxiBtn :@"news" :@"我的消息" :[[Global sharedClient].xjf_Cq_Xx[2] stringValue] :1];
//        xiaoxiBtn.tag=1;
//        [xiaoxiBtn addTarget:self action:@selector(jifenxiaoxiTouch:) forControlEvents:UIControlEventTouchUpInside];
//        [mineTHView addSubview:xiaoxiBtn];

    }
    [mineTHView addSubview:nickNameLab];
    return mineTHView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return labTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ary=labTitles[section];
    return ary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor=UIColorFromRGB(0xf2f2f2);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor=UIColorFromRGB(0xf2f2f2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return M_WIDTH(78);
    }else{
        return M_WIDTH(39);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"MineTVCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [UIUtil removeSubView:cell];
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        UIView *view=[self createTableHeaderView];
        [cell addSubview:view];
        return cell;
    }else{
        UIView *view=[self cereateCellView:indexPath];
        [cell addSubview:view];
        return cell;
    }
    return nil;
}

-(UIView*)cereateCellView:(NSIndexPath*)indexPath{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(39))];
    view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(18),(view.frame.size.height-M_WIDTH(17))/2,M_WIDTH(17),M_WIDTH(17))];
    [iconImg setImage:[UIImage imageNamed:iconImgs[indexPath.section][indexPath.row]]];
    [view addSubview:iconImg];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(47),0,150,M_WIDTH(39))];
    titleLab.text = labTitles[indexPath.section][indexPath.row];
    titleLab.font = INFO_FONT;
    [view addSubview:titleLab];
    
    NSArray *ary = labTitles[indexPath.section];
    
    if (indexPath.row != ary.count-1) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(18),M_WIDTH(39)-1,WIN_WIDTH-M_WIDTH(18),1)];
        lineView.backgroundColor = COLOR_LINE;
        [view addSubview:lineView];
    }
    
    return view;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return;
//    }
//    if(![self isSignIn]){
//        return;
//    }
//    
//    if (indexPath.section == 1) {
//        
//        if (indexPath.row == 0) {
//        
//            //扫描小票
//            ScanViewController * srVC = [[ScanViewController alloc] init];
//            [self.delegate.navigationController pushViewController:srVC animated:YES];
//
//        }else if (indexPath.row == 1) {
//            
//            //我的卡券
//            MyVoucherViewController * myVoucherVC = [[MyVoucherViewController alloc] init];
//            [self.delegate.navigationController pushViewController:myVoucherVC animated:YES];
//            
//        }else if (indexPath.row == 2) {
//            
//            //车牌管理
//            BindingPlatesViewController *cVC = [[BindingPlatesViewController alloc]init];
//            [self.delegate.navigationController pushViewController:cVC animated:YES];
//        }
//        
//    }else if (indexPath.section == 2) {
//        
//        if (indexPath.row == 0) {
//            
//            //我的订单
//            MyOrdersViewController *mvc=[[MyOrdersViewController alloc]init];
//            [self.delegate.navigationController pushViewController:mvc animated:YES];
//            
//        }else if (indexPath.row == 1) {
//            
//            //小票上传记录
//            RecentBillsController *reVC=[[RecentBillsController alloc]init];
//            [self.delegate.navigationController pushViewController:reVC animated:YES];
//            
//        }else if (indexPath.row == 2) {
//            
//            //快递订单
//            MyExpressController  *vc=[[MyExpressController alloc]init];
//            [self.delegate.navigationController pushViewController:vc animated:YES];
//
//            
//        }else if (indexPath.row == 3) {
//            
//            //兑换码领券
//            GetVoucherViewController * gVVC = [[GetVoucherViewController alloc] init];
//            [self.delegate.navigationController pushViewController:gVVC animated:YES];
//
//        }else if (indexPath.row == 4) {
//            
//            //我的排号
//            MyTicketViewController * mtVC = [[MyTicketViewController alloc] init];
//            [self.delegate.navigationController pushViewController:mtVC animated:YES];
//            
//        }else if (indexPath.row == 5) {
//            
//            //我的活动/活动列表
//            ActivityViewController * activityVC = [[ActivityViewController alloc] init];
//            [self.delegate.navigationController pushViewController:activityVC animated:YES];
//            
//        }else if (indexPath.row == 6) {
//            
//            //我的收藏
//            MyCollectionController *myVC=[[MyCollectionController alloc]init];
//            [self.delegate.navigationController pushViewController:myVC animated:YES];
//            
//        }else if (indexPath.row == 7) {
//            
//            //我的MALL
//            MyMALLViewController    *vc=[[MyMALLViewController alloc]init];
//            [self.delegate.navigationController pushViewController:vc animated:YES];
//            
//        }else if (indexPath.row == 8) {
//            
//            //创建星宝贝
//            CreateStarBabyViewController * cSBVC = [[CreateStarBabyViewController alloc] init];
//            [self.delegate.navigationController pushViewController:cSBVC animated:YES];
//        }
//        
//    }else if (indexPath.section == 3) {
//        
//        if (indexPath.row == 0) {
//            
//            //我的星积分
//            MyScoreViewController * myScoreVC = [[MyScoreViewController alloc] init];
//            [self.delegate.navigationController pushViewController:myScoreVC animated:YES];
//
//        }else if (indexPath.row == 1) {
//            
//            //帮助与反馈
//            FeedbackViewController * feedbackVC = [[FeedbackViewController alloc] init];
//            [self.delegate.navigationController pushViewController:feedbackVC animated:YES];
//        }
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return;
    }
    if(![self isSignIn]){
        return;
    }
    if (indexPath.section==1) {
         if (indexPath.row == 0) {
            
            //车牌管理
            BindingPlatesViewController *cVC = [[BindingPlatesViewController alloc]init];
            [self.delegate.navigationController pushViewController:cVC animated:YES];
        }else if (indexPath.row == 1) {
            
            GoViewController *mvc = [[GoViewController alloc]init];
           // OrderWebViewController *mvc = [[OrderWebViewController alloc]init];
            mvc.path=[NSString stringWithFormat:@"%@integral_mall/order_index?vip_mall_id=%@",[Global sharedClient].HTTP_VIP,[Global sharedClient].markID];
            [self.delegate.navigationController pushViewController:mvc animated:YES];
            
        }else if (indexPath.row == 2) {
            
            //小票上传记录
            RecentBillsController *reVC=[[RecentBillsController alloc]init];
            [self.delegate.navigationController pushViewController:reVC animated:YES];
            
        }else if (indexPath.row == 3) {
            
            //我的排号
            MyTicketViewController * mtVC = [[MyTicketViewController alloc] init];
            [self.delegate.navigationController pushViewController:mtVC animated:YES];
            
        }else if (indexPath.row == 4) {
            
            //我的活动/活动列表
            ActivityViewController * activityVC = [[ActivityViewController alloc] init];
            [self.delegate.navigationController pushViewController:activityVC animated:YES];
            
        }else if (indexPath.row == 5) {
            
            //我的收货地址
            AddressListViewController * addVc = [[AddressListViewController alloc] init];
            [self.delegate.navigationController pushViewController:addVc animated:YES];
        }else if (indexPath.row == 6) {
            
            //创建星宝贝
            CreateStarBabyViewController * cSBVC = [[CreateStarBabyViewController alloc] init];
            [self.delegate.navigationController pushViewController:cSBVC animated:YES];
        }
    }
}


//头部
-(void)jifenxiaoxiTouch:(UIButton*)sender{
    
    if(![self isSignIn]){
        
        return;
    }
    if (sender.tag==0) {
        //我的星积分
        MyScoreViewController * myScoreVC = [[MyScoreViewController alloc] init];
        [self.delegate.navigationController pushViewController:myScoreVC animated:YES];
    }else{
        //我的消息
        MyMsgViewController * myMsgVC = [[MyMsgViewController alloc] init];
        [self.delegate.navigationController pushViewController:myMsgVC animated:YES];
    }
}

//顶部设置
-(void)headIconTouch:(UIButton*)sender{
    
    if(![self isSignIn]){
        return;
    }
    
    if (sender.tag==0) {
        //个人信息界面
        UserCenterViewController * userCenterVC = [[UserCenterViewController alloc] init];
        [self.delegate.navigationController pushViewController:userCenterVC animated:YES];
        
    }else{
        //我的会员卡
        MembershipCardViewController * mcVC = [[MembershipCardViewController alloc] init];
        [self.delegate.navigationController pushViewController:mcVC animated:YES];
    }
    
}

-(void)initnilView{
    
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50,WIN_HEIGHT/2-M_WIDTH(150),100,100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
}


-(void)chuliView_btn:(UIButton*)btn :(NSString*)imgName :(NSString*)title :(NSString*)num :(int)type{
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,M_WIDTH(10),11,11)];
    [iconImg setImage:  [UIImage imageNamed:imgName]];
    iconImg.contentMode=UIViewContentModeScaleAspectFit;
    [btn addSubview:iconImg];
    
    NSString *textTitle=[NSString stringWithFormat:@"%@: %@",title,num];
    
    MLabel *title1=[[MLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(5),M_WIDTH(15)-6,btn.frame.size.width,12)];
    title1.text=textTitle;
    title1.font=INFO_FONT;
    title1.textColor=UIColorFromRGB(0x2bb161);
    title1.textAlignment=NSTextAlignmentLeft;
    [title1 setAttrColor:0 end:(int)title.length+1 color:[UIColor blackColor]];
    [btn addSubview:title1];
    
//    if (type==0) {
//        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(btn.frame.size.width-1,M_WIDTH(15)-6,1,12)];
//        lineView.backgroundColor=COLOR_LINE;
//        [btn addSubview:lineView];
//    }
}
- (UIImage* )rotateImage:(UIImage *)image {
    int kMaxResolution = 320;
    // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width  /  height;
        if (ratio > 1 ) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch (orient) {
        case UIImageOrientationUp:
            //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0 );
            break;
        case UIImageOrientationDown:
            //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width );
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0 );
            break;
        case UIImageOrientationLeft:
            //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate( transform, 3.0 * M_PI / 2.0  );
            break;
        case UIImageOrientationRightMirrored:
            //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate( transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0 );
            break;
        default:
            //[NSExceptionraise:NSInternalInconsistencyExceptionformat:@"Invalid image orientation"];
            [NSException raise:NSInvalidArgumentException format:@"Last name must be Smith"];
            
            
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform );
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
@end
