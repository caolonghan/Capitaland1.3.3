//
//  StoreDetailsController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//
#import "UIViewExt.h"
#import "ARWebViewController.h"
#import "RootViewController.h"
#import "StoreDetailsController.h"
#import "ImageScrollView.h"
#import "SearchStoreController.h"
#import "FoodViewController.h"
#import "ScanViewController.h"
#import "GoViewController.h"
#import "MJRefresh.h"
#import "ActivityController.h"
#import "IntegralController.h"
#import "SoreDiscountsController.h"
#import "SignedController.h"
#import "MineViewController.h"
#import "LineUpHomeController.h"
#import "RegisterViewController.h"
#import "FindStoreController.h"
#import "GoodsRootController.h"
#import "RegisterViewController.h"
#import "SignedController.h"
#import "BindingPlatesViewController.h"
#import "CreateStarBabyViewController.h"
#import "ShopingCartController.h"
#import "IndoorMapController.h"
#import "ExpressOrderController.h"
#import "NewRegisterController.h"
#import "PFUIKit.h"
#import "KDSearchBar.h"
#import "NotLoggedInController.h"
#import "MyApplicationViewController.h"
#import "MyVoucherViewController.h"
#import "MLabel.h"
#import "InfoListViewController.h"
#import "NewSearchController.h"
#import "MyMembershipCardView.h"
#import "RTMInterfaceController.h"
#import "PaymentCodeController.h"
#import "SaoMaPayController.h"
#import "ShowPayViewController.h"
//easrAr
#import "ARShowViewController.h"
#import "SPARManager.h"
//#import "ViewControllerAR.h"
#define KPreLoadId @"d277cb923acf488f9815bd0d5a55418a"
//#define KPreLoadId @"ebd03b82fc404fb9913ce880c524019f"
//
#import "ShopViewController.h"
#import "ParkingController.h"
#import "ParkingLotController.h"
#import "ParkingLotController.h"
#import "NewRegisterController.h"
#import <AlipaySDK/AlipaySDK.h>

//统一店铺view
#import "UnifiedShopViewC.h"

//相机
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define ORIGINAL_MAX_WIDTH 640.0f

//判断相机权限
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


#import "ReScrollView.h"

//定位
#import "LocationUtil.h"
#import "MalllistViewController.h"
#import "ScanBankPayController.h"
#import "ScanTypeViewController.h"
#import "ShowPayViewController.h"
//轮播图
#import "SDCycleScrollView.h"

#import "CompanyVC.h"

#import "TipDialogView.h"

#import "InfoListViewController.h"


//每个模块的间距
#define VIEW_distance M_WIDTH(10)
#define FUN_HIGHT  M_WIDTH(85)


@interface StoreDetailsController ()<UITextFieldDelegate,UIScrollViewDelegate,UISearchBarDelegate,MyguanliDelegate,UIImagePickerControllerDelegate, VPImageCropperDelegate,LocationDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate,UISearchBarDelegate>
@property (strong,nonatomic)UIScrollView    *headScrollView;//顶部的
@property (strong,nonatomic)ReScrollView    *scrollView;//底层的View
@property (strong,nonatomic)NSDictionary    *dataDic;//拿到的所有数据
@property (strong,nonatomic)NSMutableArray  *integralAry;//底部积分数据
@property (strong,nonatomic)ReScrollView    *bgScrollView;
@property (nonatomic,strong)UIView *scanPopView;
@property (nonatomic,strong)NSArray *orderListArr;//菜单列表

@property (nonatomic,strong)NSMutableArray *urls;//banner跳转链接

@property (nonatomic,strong)UISearchBar *homeTextF;
@property (nonatomic,strong)UIView *coverView;
@property (nonatomic,strong)UIScrollView *orderScrollView;
@property (nonatomic,strong)UIScrollView *bannerScrollView;
@end

@implementation StoreDetailsController{
    CGFloat  scroll_TOP_H;
    int      pageNum;
    BOOL     isend1;
    CGFloat  headView_HHH;//顶部scrollview的高度
    CGFloat  buttomView_HHH;//下面scrollview的高度
    // UIView   *functionView;
    UIView   *integralView;
    //KDSearchBar  *homeTextF;
    
    NSDictionary *ceshiDic;
    NSDictionary *huodongDic;
    UIView* navView;
    UIView* nav1View;
    //固定操作按钮view
    UIView *headtitleView;
    
    UIView   *confirmPayView;//
    
    
    //相机
    NSData* userImgData;
    UIImage *portraitImg;
    UIView  *cameraMsgView;//点开相机注意事项弹出框
    
    //定位
    LocationUtil* loc;
    BOOL      isLocation;//返回时候开启定位
    BOOL      isFirst;//防止重复加载数据
    UIButton  *dingweiBtn;
    BOOL       isLight;//进入到身份验证时不开启顶部颜色更换
    UIView* infoView ;
    
    UILabel *_underlineLabel;
    UIView *_bgView;
    NSString *_bannerUrl;
}
- (NSMutableArray *)urls
{
    if (!_urls) {
        _urls = [[NSMutableArray alloc]init];
    }
    return _urls;
}
- (NSArray *)orderListArr
{
    if (!_orderListArr) {
        _orderListArr = [NSArray array];
    }
    return _orderListArr;
}

-(UILabel *)underlineLabel
{
    if (!_underlineLabel) {
        _underlineLabel = [[UILabel alloc]init];
        _underlineLabel.text =@"我是有底线的";
        _underlineLabel.textColor = [UIColor lightGrayColor];
        
        _underlineLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _underlineLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([Util isNull:[Global sharedClient].member_id]){
        return;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    isLight=NO;
    if ([Util isNull:[Global sharedClient].markID]) {
        
        MalllistViewController *vc = [[MalllistViewController alloc]init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (![Util isNull:[Global sharedClient].pushLoadData] && [[Global sharedClient].pushLoadData isEqualToString:@"1"] ) {
        [self createCoverView];
        [Global sharedClient].pushLoadData=@"0";
        [_functionView removeFromSuperview];
        [self.scrollView removeFromSuperview];
        _functionView = nil;
        
            [self loadAD];
            [self loadOrderListData];
            [self loadData];
        
        
    }
    
}



-(void)viewDidLoad{
    [super viewDidLoad];
    isFirst=YES;
    //    _bgScrollView = [[ReScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+FUN_HIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT+FUN_HIGHT)];
    //    _bgScrollView.delegate = self;
    //    [self.view addSubview:_bgScrollView];
    self.dataDic = [[NSDictionary alloc]init];
    
    self.navigationBar.hidden=YES;
    [self createNav];
    [self createNav1];
    [self devNavDic];
    [self crateHeadScrollView];
    
    if (![Util isNull:[Global sharedClient].markID]) {
        [self createCoverView];
        [self loadAD];
        [self loadOrderListData];
        [self loadData];
        
    }
}
- (void)createCoverView{
    
    BOOL isFirstOpen = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstOpen1.3.7"]boolValue];
    if (isFirstOpen) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstOpen1.3.7"];
    _coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.delegate.navigationController.view addSubview:_coverView];
    
    UIImageView *iconImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/16+M_WIDTH(4), NAV_HEIGHT+WIN_WIDTH/16-M_WIDTH(11),WIN_WIDTH/8-M_WIDTH(8) ,WIN_WIDTH/8-M_WIDTH(8))];
    [iconImageView1 setImage:[UIImage imageNamed:@"saoyisao"]];
    [_coverView addSubview:iconImageView1];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/4+WIN_WIDTH/16+M_WIDTH(4), NAV_HEIGHT+WIN_WIDTH/16-M_WIDTH(11),WIN_WIDTH/8-M_WIDTH(8) ,WIN_WIDTH/8-M_WIDTH(8))];
    [iconImageView setImage:[UIImage imageNamed:@"paycode"]];
    [_coverView addSubview:iconImageView];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame)+M_WIDTH(10), WIN_WIDTH/4, M_WIDTH(20))];
    titleLabel1.font=COMMON_FONT;
    titleLabel1.text = @"扫一扫";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.textColor=[UIColor whiteColor];
    [_coverView addSubview:titleLabel1];
   
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/4, CGRectGetMaxY(iconImageView.frame)+M_WIDTH(10), WIN_WIDTH/4, M_WIDTH(20))];
    titleLabel.font=COMMON_FONT;
    titleLabel.text = @"付款码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [_coverView addSubview:titleLabel];
    
    UIImageView *scanCodeNocView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel1.frame)-M_WIDTH(20), CGRectGetMinY(titleLabel1.frame),M_WIDTH(120), M_WIDTH(240))];
    [scanCodeNocView setImage:[UIImage imageNamed:@"SaomaCoverView"]];
    [_coverView addSubview:scanCodeNocView];
    
    UIImageView *paycodeNocView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)-M_WIDTH(51), CGRectGetMinY(titleLabel.frame),M_WIDTH(120), M_WIDTH(130))];
    [paycodeNocView setImage:[UIImage imageNamed:@"paycodeCoverView"]];
    [_coverView addSubview:paycodeNocView];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(25), WIN_HEIGHT-M_WIDTH(120), M_WIDTH(50), M_WIDTH(50))];
    [cancleBtn setImage:[UIImage imageNamed:@"cancleX"] forState:UIControlStateNormal];
    [cancleBtn addTarget: self action:@selector(cancleXClick:) forControlEvents:UIControlEventTouchUpInside];
    [_coverView addSubview:cancleBtn];
    
}
-(void)cancleXClick:(UIButton *)sender{
    [_coverView removeFromSuperview];
}
- (void)loadAD
{
    RootViewController *root = (RootViewController*)self.delegate;
    if (root.haveRemotemsg) {
        return;
    }
    
    int zz=[[Global sharedClient].markID intValue];
    //    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    [self displayLoading];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",[Global sharedClient].member_id,@"member_id",nil];
    
    [HttpClient requestPostWithPath:[Util makeRequestUrl:@"index" tp:@"getmallindexadvert"] parameters:diction success:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        NSDictionary *data = dic[@"data"];
        _bannerUrl = data[@"link_url"];
        [self showBanner];
        [((UIImageView*)[_bgView viewWithTag:123]) setImageWithString:[data objectForKey:@"img_url"]];
    } failue:^(NSDictionary *dic) {
        [self removeLoading];
    }];
    //18056006825
    //    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmallindexadvert"] parameters:diction  target:self success:^(NSDictionary *dic){
    //
    //
    //        NSLog(@"%@",dic);
    //        NSDictionary *data = dic[@"data"];
    //        _bannerUrl = data[@"link_url"];
    //        [self showBanner];
    //        [((UIImageView*)[_bgView viewWithTag:123]) setImageWithString:[data objectForKey:@"img_url"]];
    //
    //    }failue:^(NSDictionary *dic){
    //        [self removeLoading];
    //    }];
}
- (void)showBanner
{
    _bgView = [[UIView alloc]initWithFrame:self.view.frame];
    _bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    
    [self.delegate.view insertSubview:_bgView atIndex:[self.delegate.view.subviews count]];
    
    UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH*0.25/2, WIN_HEIGHT*0.38/2, WIN_WIDTH*0.75, WIN_HEIGHT*0.62)];
    
    //ima.backgroundColor = [UIColor blackColor];
    ima.userInteractionEnabled = YES;
    ima.tag = 123;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerclick)];
    [ima addGestureRecognizer:tap];
    [_bgView addSubview:ima];
    
    UIButton *remove = [UIButton buttonWithType:UIButtonTypeCustom];
    remove.frame = CGRectMake(ima.width-45, 5, 40, 40);
    
    [remove setBackgroundImage:[UIImage imageNamed:@"main_dialog_close"] forState:UIControlStateNormal];
    [ima addSubview:remove];
    [remove addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
}
- (void)bannerclick
{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:_bannerUrl,@"link_url",[Global sharedClient].member_id,@"member_id",nil];
    [HttpClient requestPostWithPath:[Util makeRequestUrl:@"index" tp:@"addindexadvert"] parameters:diction success:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic);
        
    } failue:^(NSDictionary *dic) {
        [self removeLoading];
    }];
    
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = _bannerUrl;
    [self remove];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
- (void)remove
{
    [_bgView removeFromSuperview];
}
//创建两个导航
-(void) createNav{
    CGFloat btn_H=FUN_HIGHT;
    UIImageView * nvcView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, WIN_WIDTH ,NAV_HEIGHT+btn_H)];
    nvcView.backgroundColor=[UIColor clearColor];
    [nvcView setUserInteractionEnabled:YES];
    [nvcView setImage:[UIImage imageNamed:@"1.3.6navRectangle"]];
    // nvcView.backgroundColor = NAVBGCOLOR;
    [self.view addSubview:nvcView];
    
    navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, WIN_WIDTH, NAV_HEIGHT);
    navView.backgroundColor = [UIColor clearColor];
    
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(11),7+STATUS_BAR_HEIGHT,M_WIDTH(212),30)];
    headView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
    //    headView.layer.masksToBounds=YES;
    //    headView.layer.cornerRadius=15;
    _homeTextF=[[UISearchBar alloc]initWithFrame:headView.bounds];
    _homeTextF.tintColor = [UIColor clearColor];
    _homeTextF.barStyle = UIBarStyleDefault;
    _homeTextF.searchBarStyle = UISearchBarStyleDefault;
    _homeTextF.translucent = YES;
    [_homeTextF setBackgroundImage:[UIImage new]];
    [_homeTextF setTranslucent:YES];
    //homeTextF.newFrame = homeTextF.frame;
    _homeTextF.placeholder=@"请输入商户名";
    // [_homeTextF setPositionAdjustment:UIOffsetMake(-M_WIDTH(6), 0) forSearchBarIcon:UISearchBarIconSearch];
    [_homeTextF setContentMode:UIViewContentModeLeft];
    _homeTextF.searchBarStyle = UISearchBarStyleMinimal;
    //加上如下命令效果如下
    _homeTextF.barTintColor = [UIColor clearColor];
    //给searchBar中的textField添加背景图
    [_homeTextF setSearchFieldBackgroundImage:[UIImage imageNamed:@"backgroundImage"] forState:UIControlStateNormal];
    UITextField *searchField = [_homeTextF valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    _homeTextF.delegate=self;
    //homeTextF.searchBarStyle=UISearchBarStyleMinimal;
    
    _homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    _homeTextF.returnKeyType=UIReturnKeySearch;
    
    //[headView addSubview:_homeTextF];
    
    UIImageView *searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchImg setImage:[UIImage imageNamed:@"searchBtn"]];
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    placeLabel.font = [UIFont systemFontOfSize:14];
    placeLabel.text = @"请输入商户名";
    placeLabel.textColor = [ UIColor whiteColor];
    [headView addSubview:searchImg];
    [headView addSubview:placeLabel];
    [navView addSubview:headView];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(11),7+STATUS_BAR_HEIGHT,M_WIDTH(212),30)];
    [searchBtn addTarget:self action:@selector(searchTouch:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:searchBtn];
    
    UIButton *cityBtn =[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headView.frame),STATUS_BAR_HEIGHT,M_WIDTH(63),44)];
    [cityBtn setTitle:@"切换商场" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cityBtn.titleLabel.font=INFO_FONT;
    cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cityBtn addTarget:self action:@selector(qiehuanShopping:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cityBtn];
    
    dingweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(30),STATUS_BAR_HEIGHT+8,M_WIDTH(15),30)];
    [dingweiBtn setImage:[UIImage imageNamed:@"homeLoc"] forState:UIControlStateNormal];
    [dingweiBtn addTarget:self action:@selector(dingweiTouch:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:dingweiBtn];
    
    [self.view addSubview:navView];
}

//首页定位获取位置开始

-(void) afterLoc:(NSString *)city loc:(CLLocation *)loc{
    if(loc.coordinate.latitude == 0 && loc.coordinate.longitude == 0){
        return;
    }
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* lng = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    NSString* lat = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    [userDefaults setValue:lng forKey:@"cllocation_lng"];
    [userDefaults setValue:lat forKey:@"cllocation_lat"];
    if (isFirst == NO) {
        [self netWorkRequest:lng :lat];
    }
}

-(void)userLocChoice:(int)type{
    if (isFirst == NO) {
        if (type == 5 || type == 6) {
            [SVProgressHUD showWithStatus:@"正在努力定位中"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"定位服务未开启"];
        }
    }
}

-(void)dingweiTouch:(UIButton*)sender{
    dingweiBtn.enabled=NO;
    if(isFirst == YES){
        isFirst=NO;
        loc=  [[LocationUtil alloc] init];
        loc.locDelegate = self;
        isLocation = [loc isLocate];
    }
}

-(void)netWorkRequest:(NSString*)lng :(NSString*)lat{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmalllist"] parameters:[[NSDictionary alloc] initWithObjectsAndKeys:lng,@"lng",lat,@"lat", nil]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            isFirst=YES;
            [SVProgressHUD dismiss];
            dingweiBtn.enabled=YES;
            if ([Util isNull:dic[@"data"][@"near_mall"]]) {
                [SVProgressHUD showErrorWithStatus:@"抱歉，您周围没有商场！"];
            }else{
                NSDictionary *diction =dic[@"data"][@"near_mall"];
                NSString *mall_id=[NSString stringWithFormat:@"%@",diction[@"mall_id"]];
                NSString *oldMall_id=[NSString stringWithFormat:@"%@",[Global sharedClient].markID];
                
                if (![oldMall_id isEqualToString:mall_id]) {
                    
                    if (_indexDedegate &&[_indexDedegate respondsToSelector:@selector(createLocationPrompt:type:)]) {
                        [_indexDedegate createLocationPrompt:diction type:@"0"];
                    }
                }else{
                    if (_indexDedegate &&[_indexDedegate respondsToSelector:@selector(createLocationPrompt:type:)]) {
                        [_indexDedegate createLocationPrompt:diction type:@"1"];
                    }
                }
            }
        });
    }failue:^(NSDictionary *dic){
        dingweiBtn.enabled=YES;
    }];
}



//首页定位位置获取结束
-(void) createNav1{
    nav1View = [[UIView alloc] init];
    nav1View.frame = CGRectMake(0, 0, WIN_WIDTH, NAV_HEIGHT);
    nav1View.backgroundColor = [UIColor clearColor];
    
    nav1View.alpha = 0;
    UIImageView *navimg= [[UIImageView alloc]initWithFrame:navView.bounds];
    [navimg setImage:[UIImage imageNamed:@"1.3.6navRectangle"]];
    //navimg.backgroundColor = NAVBGCOLOR;
    navimg.userInteractionEnabled=YES;
    CGFloat img_H  = 20;
    CGFloat img_W  = 28;
    CGFloat img_juzuo = (44-img_H)/2;
    
    NSArray *imgAry = @[@"saoyisao",@"paycode",@"homekajuan",@"storeCar"];
    for (int i=0; i<4; i++) {
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(img_juzuo+i*55,STATUS_BAR_HEIGHT+img_juzuo,img_W,img_H)];
        [iconImg setImage:[UIImage imageNamed:imgAry[i]]];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        iconImg.userInteractionEnabled=YES;
        [navimg addSubview:iconImg];
        UIButton *iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*55,STATUS_BAR_HEIGHT, NAV_HEIGHT-STATUS_BAR_HEIGHT, NAV_HEIGHT-STATUS_BAR_HEIGHT)];
        iconBtn.tag=i;
        [iconBtn addTarget:self action:@selector(headtouch:) forControlEvents:UIControlEventTouchUpInside];
        [navimg addSubview:iconBtn];
    }
    [nav1View addSubview:navimg];
    [self.view addSubview:nav1View];
  
}

-(void)searchTouch:(UIButton *)sender{
    //    NewSearchController *vc = [[NewSearchController alloc]init];
    //    [self.delegate.navigationController pushViewController:vc animated:YES];
    UnifiedShopViewC *vc = [[UnifiedShopViewC alloc]init];
    vc.shopType=@"1";
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView==_headScrollView) {
        //        scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;
    }else{
        NSLog(@"到这里啊");
        if(CGRectGetMinY(_headScrollView.frame) > (NAV_HEIGHT +FUN_HIGHT/2) ){
            [UIView beginAnimations:nil context:nil];
            
            [UIView setAnimationDuration:0.5];
            
            CGRect newFrame = _headScrollView.frame;
            newFrame.origin.y =NAV_HEIGHT+FUN_HIGHT;
            
            _headScrollView.frame = newFrame;
            newFrame = self.scrollView.frame;
            newFrame.origin.y = CGRectGetMaxY(_headScrollView.frame);
            newFrame.size.height = WIN_HEIGHT - CGRectGetMaxY(_headScrollView.frame) - 45;
            self.scrollView.frame = newFrame;
            navView.alpha = 1;
            nav1View.alpha = 0;
            [self.view bringSubviewToFront:navView];
            
            [UIView commitAnimations];
            
            
        }else if(CGRectGetMinY(_headScrollView.frame) > NAV_HEIGHT ){
            [UIView beginAnimations:nil context:nil];
            
            [UIView setAnimationDuration:0.5];
            
            CGRect newFrame = _headScrollView.frame;
            newFrame.origin.y =NAV_HEIGHT;
            
            
            _headScrollView.frame = newFrame;
            
            newFrame = self.scrollView.frame;
            newFrame.origin.y = CGRectGetMaxY(_headScrollView.frame);
            newFrame.size.height = WIN_HEIGHT - CGRectGetMaxY(_headScrollView.frame) - 45;
            self.scrollView.frame = newFrame;
            
            nav1View.alpha = 1;
            navView.alpha = 0;
            
            [UIView commitAnimations];
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_headScrollView) {
        //        scrollView.bounces = (scrollView.contentOffset.y <= 0) ? NO : YES;
    }else{
        CGFloat scroll_Y=scrollView.contentOffset.y;
        
        //        CGFloat scroll_H=_scrollView.frame.size.height;
        //        NSLog(@"%f",scroll_Y);
        if(scroll_Y <= 0){
            NSLog(@"滚动了%f",scroll_Y);
            //处理功能区隐藏和视差
            CGRect newFrame = _headScrollView.frame;
            newFrame.origin.y =newFrame.origin.y  - scroll_Y;
            bool isTop = false;
            if(CGRectGetMinY(newFrame) >= (NAV_HEIGHT+FUN_HIGHT)){
                isTop = true;
            }else{
                _headScrollView.frame = newFrame;
            }
            //处理透明度
            if(!isTop){
                [self.view bringSubviewToFront:nav1View];
                navView.alpha = 0;
                float alpha = ((CGRectGetMinY(_headScrollView.frame) - NAV_HEIGHT)/FUN_HIGHT ) > 0 ? ((CGRectGetMinY(_headScrollView.frame) - NAV_HEIGHT)/FUN_HIGHT ) : 0;
                NSLog(@"透明值:%f",alpha);
                
                headtitleView.alpha = alpha;
                if (alpha > 0.5) {
                    navView.alpha = alpha;
                    nav1View.alpha = 0;
                } else {
                    navView.alpha = 0;
                    nav1View.alpha = 1 - alpha;
                    
                }
                
            }else{
                navView.alpha = 1;
                if(CGRectGetMinY(_headScrollView.frame) <= NAV_HEIGHT){
                    navView.alpha = 0;
                    nav1View.alpha = 1;
                }else{
                    navView.alpha = 1;
                    nav1View.alpha = 0;
                }
                
            }
            if(!isTop){
                scrollView.contentOffset = CGPointMake(0, 0);
                
                newFrame = self.scrollView.frame;
                newFrame.origin.y = CGRectGetMaxY(_headScrollView.frame);
                newFrame.size.height = WIN_HEIGHT - CGRectGetMaxY(_headScrollView.frame) - 45;
                self.scrollView.frame = newFrame;
            }
        }else{
            NSLog(@"往上拉了  %f",scroll_Y);
            [self.view bringSubviewToFront:_headScrollView];
            //处理功能区隐藏和视差
            
            CGRect newFrame = _headScrollView.frame;
            newFrame.origin.y =newFrame.origin.y  - scroll_Y;
            bool isTop = false;
            if(CGRectGetMaxY(newFrame) < NAV_HEIGHT){
                isTop = true;
            }else{
                _headScrollView.frame = newFrame;
            }
            
            
            //处理透明度
            if(!isTop){
              
                float alpha = ((CGRectGetMinY(_headScrollView.frame) - NAV_HEIGHT)/FUN_HIGHT ) > 0 ? ((CGRectGetMinY(_headScrollView.frame) - NAV_HEIGHT)/FUN_HIGHT ) : 0;
                NSLog(@"透明值:%f",alpha);
                
                headtitleView.alpha = alpha;
                if (alpha > 0.5) {
                    
                    navView.alpha = alpha;
                    nav1View.alpha = 0;
                } else {
                    
                    navView.alpha = 0;
                    nav1View.alpha = 1 - alpha;
                }
                
            }else{
            
                if(CGRectGetMinY(_headScrollView.frame) <= NAV_HEIGHT){
                    navView.alpha = 0;
                    nav1View.alpha = 1;
                    [self.view sendSubviewToBack:_headScrollView];
                }else{
                    navView.alpha = 1;
                    nav1View.alpha = 0;
                }
                
            }
            if(!isTop){
                scrollView.contentOffset = CGPointMake(0, 0);
                
                newFrame = self.scrollView.frame;
                newFrame.origin.y = CGRectGetMaxY(_headScrollView.frame);
                newFrame.size.height = WIN_HEIGHT - CGRectGetMaxY(_headScrollView.frame) - 45;
                self.scrollView.frame = newFrame;
            }
            
        }
    }
    [_homeTextF resignFirstResponder];
}

-(void)qiehuanShopping:(UIButton*)sender{
    //MalllistViewController
    //NotLoggedInController *vc = [[NotLoggedInController alloc]init];
    //vc.setInType=@"1";
    MalllistViewController *vc = [[MalllistViewController alloc]init];
    //关闭首页自动定位
    //    vc.autoLoc = ^{
    //        [self dingweiTouch:nil];
    //    };
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---请求网络---
-(void)loadData{
    int zz=[[Global sharedClient].markID intValue];
    //    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    [self displayLoading];
    if ([[Global sharedClient].isLoginPush isEqualToString:@"1"]) {
        _is_login_enter =@"1";
    }else
    {
        _is_login_enter =@"0";
    }
    NSLog(@"是否从登录页面来？%@", _is_login_enter);
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",[Global sharedClient].member_id,@"member_id",_is_login_enter,@"is_login_enter", @"ios",@"tag_code",nil];
    NSLog(@"diction = %@",diction);
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmallindex"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataDic = dic[@"data"];
            
            [Global sharedClient].building_id = [Util isNil:_dataDic[@"building_id"]];
            NSLog(@"data = %@",self.dataDic);
            // [self loadOrderListData];
            [self loadInfoData];
            
            // [self crateHeadScrollView];
        });
    }failue:^(NSDictionary *dic){
        [self removeLoading];
    }];
    
}
- (void)loadOrderListData{
    int zz=[[Global sharedClient].markID intValue];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:
                          [Global sharedClient].member_id,@"member_id",@(zz),@"mall_id",
                          nil,@"navlist_id",
                          [Global sharedClient].isoffice
                          ,@"is_office",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"membernavlist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            _orderListArr = dic[@"data"][@"nav_list"];
            [self createNavigationBtn];
            
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
    }];
}
-(void) loadInfoData{
    int zz=[[Global sharedClient].markID intValue];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(1),@"page",@(100),@"pageSize",[Global sharedClient].member_id, @"member_id",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getallconsultlist"] parameters:diction  target:self success:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            huodongDic = dic[@"data"];
            
            [self.scrollView removeFromSuperview];
            self.scrollView = nil;
            //[functionView removeFromSuperview];
            pageNum=1;
            isend1=NO;
            //[self loadOrderListData];
            //[self createNavigationBtn];
            [self createReScrollView];
            
            self.scrollView.mj_footer.hidden=NO;
            [self.scrollView.mj_footer beginRefreshing];
            [self removeLoading];
        });
    }failue:^(NSDictionary *dic){
        
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        
        //        [self.scrollView removeFromSuperview];
        // [_functionView removeFromSuperview];
        // [self createReScrollView];
        //        pageNum=1;
        //        isend1=NO;
        //
        //        self.scrollView.mj_footer.hidden=NO;
        //        [self.scrollView.mj_footer beginRefreshing];
        [self removeLoading];
    }];
}

-(void)crateHeadScrollView{
    
    CGFloat btn_W=WIN_WIDTH/4;
    CGFloat btn_H=FUN_HIGHT;
    if (headtitleView) {
        return;
    }
    headtitleView = [[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,btn_H)];
    headtitleView.backgroundColor=[UIColor clearColor];
    
    //    NSArray *imgAry = @[@"saomiaoxiaopiao",@"homebigqiandao",@"homekajuan",@"HomeARzhaoyizhao"];
    //    NSArray *titleAry = @[@"扫小票",@"身份",@"卡包",@"AR找一找"];
    NSArray *imgAry = @[@"saoyisao",@"paycode",@"homekajuan",@"storeCar"];
    // NSString *storCar = _dataDic[@"top_park"][@"name"];
    
    NSArray *titleAry = @[@"扫一扫",@"付款码",@"卡包",@"停车缴费"];
    
    CGFloat  img_juzho = (btn_W/4+M_WIDTH(4));
    CGFloat  img_W = (btn_W/2-M_WIDTH(8));
    for (int i=0; i<titleAry.count; i++) {
        
        UIView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(btn_W*i,0,btn_W,btn_H)];
        UIImageView *iconImg =[[UIImageView alloc]initWithFrame:CGRectMake(img_juzho,img_juzho-M_WIDTH(15),img_W,img_W)];
        [iconImg setImage:[UIImage imageNamed:imgAry[i]]];
        iconImg.userInteractionEnabled=YES;
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        [iconView addSubview:iconImg];
        
        UILabel *titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(iconImg.frame)+M_WIDTH(10),btn_W,M_WIDTH(20))];
        titleLab.text=titleAry[i];
        titleLab.font=COMMON_FONT;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor=[UIColor whiteColor];
        [iconView addSubview:titleLab];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btn_W*i,0,btn_W,btn_H)];
        btn.tag=i;
        [btn addTarget:self action:@selector(headtouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [headtitleView addSubview:iconView];
        [headtitleView addSubview:btn];
        
    }
    [self.view addSubview:headtitleView];
    //    [self.headScrollView addSubview:nvcView];
    //    scroll_TOP_H = scroll_TOP_H +btn_H+64;
    self.headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+FUN_HIGHT,WIN_WIDTH,0)];
    
    self.headScrollView.delegate=self;
    // self.headScrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.headScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headScrollView];
}


//顶部扫描等按钮事件
-(void)headtouch:(UIButton*)tag{
    
    NSInteger index =tag.tag;
    if (index == 0) {
        
        //        PaymentCodeController *vc= [[PaymentCodeController alloc]init];
        //        [self.delegate.navigationController pushViewController:vc animated:YES];
        ScanTypeViewController *scanTVc = [[ScanTypeViewController alloc]init];
       // [Global sharedClient].isHomePush = YES;
        [self.delegate.navigationController pushViewController:scanTVc animated:YES];
        
    }else if (index == 1) {
        NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
            NSLog(@"%@",dic);
            dispatch_async(dispatch_get_main_queue(), ^{
                ShowPayViewController *showVc = [[ShowPayViewController alloc]init];
                showVc.isBack = YES;
                [self.delegate.navigationController pushViewController:showVc animated:YES];
            });
            
        } failue:^(NSDictionary *dic) {
            NSLog(@"失败%@",dic[@"msg"]);
            NSString *isFirst =  [[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstOpenBankPay"];
            if ([Util isNull:isFirst]) {
                PaymentCodeController *payVc = [[PaymentCodeController alloc]init];
                [self.delegate.navigationController pushViewController:payVc animated:YES];
            }else
            {
                ShowPayViewController *showVc= [[ShowPayViewController alloc]init];
                showVc.isBack = YES;
                [self.delegate.navigationController pushViewController:showVc animated:YES];
            }
        }];
        
    }else if (index == 2) {
        //我的卡券
        MyVoucherViewController * myVoucherVC = [[MyVoucherViewController alloc] init];
        [self.delegate.navigationController pushViewController:myVoucherVC animated:YES];
        
    }else if (index == 3) {
        
        //        isLight=YES;
        //        MyMembershipCardView *vc= [[MyMembershipCardView alloc]init];
        //        [self.delegate.navigationController pushViewController:vc animated:YES];
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.isParking = YES;
        vc.path = _dataDic[@"top_park"][@"link_url"];
        if ([Util isNull:_dataDic[@"top_park"][@"link_url"]]) {
            
            [SVProgressHUD showErrorWithStatus:@"非常抱歉，本商场暂未开放此功能"];
            return;
        }
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
}
//扫一扫与付款功能
- (void)clickToScan:(UIButton *)sender{
    NSInteger tag = sender.tag-3000;
    if (tag==0) {
        //扫描小票
        NSLog(@"选择了拍照");
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 
                             }];
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *isDisplayStr = [userDefaults valueForKey:@"isDisplay"];
            if ([Util isNull:isDisplayStr]) {
                [self performSelector:@selector(cameraMsg) withObject:nil afterDelay:0.5];
            }
        }
    }else if (tag==1){
        NSString *str = [NSString stringWithFormat:@"1月20日-2月25日要不要进入%@，来一场精灵奇幻之旅？赢取新春大奖（参与项目详见店内信息）",[Global sharedClient].shopName];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            MalllistViewController *vc = [[MalllistViewController alloc]init];
            vc.type = 1;
            vc.getInAR = ^{
                ARShowViewController *vc = [[ARShowViewController alloc] init];
                vc.member_id = [Global sharedClient].member_id;
                vc.mall_id = [Global sharedClient].markID;
                vc.modalPresentationCapturesStatusBarAppearance = YES;
                [self.delegate.navigationController presentViewController:vc animated:YES completion:^{
                    
                }];
                
            };
            [self.delegate.navigationController pushViewController:vc animated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ARShowViewController *vc = [[ARShowViewController alloc] init];
            vc.member_id = [Global sharedClient].member_id;
            vc.mall_id = [Global sharedClient].markID;
            //        vc.preloadID = KPreLoadId;
            //        [vc preloadApp:vc.preloadID];
            //        [self.delegate.navigationController pushViewController:vc animated:YES];
            //vc.modalPresentationCapturesStatusBarAppearance = YES;
            [self.delegate.navigationController presentViewController:vc animated:YES completion:^{
                
            }];
            
        }]];
        
        NSArray *idArray = [NSArray arrayWithObjects:@"61",@"60",@"59",@"58",@"55",@"54",@"52",@"51",@"49",@"46",@"45",@"44",@"43",@"42",@"27",@"26",@"22",@"21",@"20",@"41",@"76",@"75",@"74",@"72",@"71",@"70",@"57",@"79",@"77",@"73",@"68",@"66",@"65",@"62",@"47",@"38",@"29",@"12",@"10", nil];
        
        for (int i=0; i<idArray.count; i++) {
            
            if ([Global sharedClient].markID.integerValue ==[idArray[i] intValue] ) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此商场不参与AR互动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            
        }
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else if (tag==2){
        __weak StoreDetailsController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            ScanBankPayController *scanVc  = [[ScanBankPayController alloc]init];
            //scanVc.beforeUrl = url;
            [weakSelf.delegate.navigationController pushViewController:scanVc animated:YES];
            //            scanVc.backBlock = ^(NSString *str){
            //
            //            };
            
            
        });
        
    }else {
        [_scanPopView removeFromSuperview];
        for (UIView *view in _scanPopView.subviews) {
            [view removeFromSuperview];
        }
        _scanPopView =  nil;
        
    }
}

//相机弹出提示
-(void)cameraMsg{
    
    
    // CGFloat buttom_W =M_WIDTH(240);
    CGFloat buttom_W =M_WIDTH(240);
    CGFloat buttom_H =M_WIDTH(290);//326
    cameraMsgView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    cameraMsgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    UIView *msgView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(40),M_WIDTH(100),buttom_W,buttom_H)];
    msgView.backgroundColor = UIColorFromRGB(0xebebeb);
    msgView.layer.masksToBounds=YES;
    msgView.layer.cornerRadius=10;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(11.5),buttom_W,M_WIDTH(32))];
    titleLab.text=@"注意事项";
    titleLab.textAlignment=NSTextAlignmentCenter;
    [titleLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [msgView addSubview:titleLab];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLab.frame),buttom_W,M_WIDTH(198))];
    contentScrollView.delegate=self;
    contentScrollView.scrollEnabled=YES;
    contentScrollView.contentSize=CGSizeMake(buttom_W,M_WIDTH(380));
    
    
    
    UIImageView *centerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,buttom_W,M_WIDTH(380))];
    [centerImg setImage:[UIImage imageNamed:@"matters_need_attention"]];
    [contentScrollView addSubview:centerImg];
    [msgView addSubview:contentScrollView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,buttom_H-M_WIDTH(39)-1,buttom_W,1)];
    lineView.backgroundColor=UIColorFromRGB(0x939290);
    [msgView addSubview:lineView];
    
    UIButton *laftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame),buttom_W/2,M_WIDTH(38))];
    [laftBtn setTitle:@"下次不再提示" forState:UIControlStateNormal];
    [laftBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    laftBtn.titleLabel.font=COMMON_FONT;
    laftBtn.tag=0;
    [laftBtn addTarget:self action:@selector(cameraTouch:) forControlEvents:UIControlEventTouchUpInside];
    [msgView addSubview:laftBtn];
    
    UIView *centerLine = [[UIView alloc]initWithFrame:CGRectMake(buttom_W/2-0.5,CGRectGetMaxY(lineView.frame),1,M_WIDTH(39)-1)];
    centerLine.backgroundColor=UIColorFromRGB(0x858182);
    [msgView addSubview:centerLine];
    
    UIButton *buttomBtn = [[UIButton alloc]initWithFrame:CGRectMake(buttom_W/2,CGRectGetMaxY(lineView.frame),buttom_W/2,M_WIDTH(38))];
    [buttomBtn setTitle:@"OK" forState:UIControlStateNormal];
    [buttomBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    buttomBtn.titleLabel.font=COMMON_FONT;
    buttomBtn.tag=1;
    [buttomBtn addTarget:self action:@selector(cameraTouch:) forControlEvents:UIControlEventTouchUpInside];
    [msgView addSubview:buttomBtn];
    
    [cameraMsgView addSubview:msgView];
    [[[UIApplication  sharedApplication]keyWindow]addSubview : cameraMsgView];
}

//相机弹出按钮事件
-(void)cameraTouch:(UIButton*)sender{
    [cameraMsgView removeFromSuperview];
    if (sender.tag==0) {
        //以后不再提示
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"isDisplay" forKey:@"isDisplay"];
    }
}

//显示提示
-(void) tips{
    //是否要弹出遮罩
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [userDefaults valueForKey:@"tipFisrt"];
    NSString* isSend = [userDefaults valueForKey:@"is_send"];
    if(![Util isNull:value] || [isSend intValue] != 1){
        return;
    }
    NSString* url = _dataDic[@"prompt_img_url"];
    if([Util isNull:url]){
        return;
    }
    TipDialogView *view = [TipDialogView defaultPopupView];
    view.parentVC = self;
    [view setImgUrl:url];
    //    view.frame = CGRectMake(0, 0, 300, 200);
    //    view.backgroundColor = [UIColor redColor];
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeTopBottom;
    
    [self.delegate lew_presentPopupView:view onParentBottom:NO animation:animation dismissed:^{
        NSLog(@"动画结束");
        [userDefaults setValue:@"Y" forKey:@"tipFisrt"];
        [userDefaults synchronize];
    }];
}

//导航模块视图
-(void)createNavigationBtn{
    
    //    NSArray *array =self.dataDic[@"member_nav_list"];
    //    NSMutableArray *dataary= [[NSMutableArray alloc]init];
    //
    //    if (array.count>0) {
    //        if(array.count>9){
    //          NSArray *ary= [array subarrayWithRange:NSMakeRange(0, 9)];
    //            [dataary addObjectsFromArray:ary];
    //        }else{
    //            [dataary addObjectsFromArray:array];
    //        }
    //    }
    //    NSDictionary *alldic =@{@"icon"      : @"icon_shop_1",
    //                            @"id"        : @"666",
    //                            @"link_url"  : @"",
    //                            @"name"      : @"全部",
    //                            @"other_link": @""};
    //    [dataary addObject:alldic];
    //    if (_functionView) {
    //        [self createReScrollView];
    //        return;
    //    }
    
    int num = (int)_orderListArr.count;
    bool lineH = num>5?YES:NO;
    CGFloat CELL_W = WIN_WIDTH/5;
    CGFloat CELL_H = CELL_W-M_WIDTH(8);
    CGFloat fun_H = lineH?CELL_H*2 : CELL_H;
    _functionView = [[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,fun_H+M_WIDTH(24+24))];
    _functionView.backgroundColor=[UIColor whiteColor];
    UILabel *markLabel = [[UILabel alloc]initWithFrame:CGRectMake(X_WIDTH(16),X_WIDTH(24),WIN_WIDTH-X_WIDTH(16),M_WIDTH(24))];
    markLabel.text = [NSString stringWithFormat:@"%@",[Global sharedClient].shopName];
    markLabel.font = [UIFont systemFontOfSize:X_WIDTH(32)];
    markLabel.textColor =UIColorFromRGB(0x484848);
    [_functionView addSubview:markLabel];
    
    _orderScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(markLabel.frame), _functionView.width, _functionView.height-CGRectGetMaxY(markLabel.frame))];
    _orderScrollView.contentSize = CGSizeMake(((_orderListArr.count-1)/10+1)*_functionView.width, _functionView.height-M_WIDTH(48));
    _orderScrollView.showsHorizontalScrollIndicator = NO;
    [_functionView addSubview:_orderScrollView];
    
    for (int i=0; i<num; i++) {
        int  btn_x=i%5;
        int  btn_y=i/5;
        NSDictionary *btnDic =_orderListArr[i];
        //        UIImage *btnimg = i==(num-1)?[UIImage imageNamed:@"allfangkuang"] : [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:btnDic[@"app_img_url"]]]];
        //        int navTag = [btnDic[@"id"]intValue];
        //        int tag = i==(num-1) ? 666 :navTag;
        
        UIImage *btnimg =  [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:btnDic[@"app_img_url"]]]];
        int navTag = [btnDic[@"id"]intValue];
        int tag = navTag;
        
        UIButton  *btn=[PFUIKit buttonWithFrame:CGRectMake(CELL_W * btn_x+WIN_WIDTH*(i/10),CELL_H * (btn_y%2==0?0:1), CELL_H, CELL_H) titlt:btnDic[@"name"] image:btnimg bColor:[UIColor whiteColor] tag:tag tColor:UIColorFromRGB(0x555555) font:INFO_FONT target:self acdaction:@selector(btnTouch:)];
        
        [_orderScrollView addSubview:btn];
    }
    
    //    if (lineH) {
    //        UIView *xlineView = [[UIView alloc]initWithFrame:CGRectMake(0,CELL_H+M_WIDTH(31),WIN_WIDTH,1)];
    //        xlineView.backgroundColor = COLOR_LINE;
    //        [functionView addSubview:xlineView];
    //    }
    headView_HHH = fun_H+M_WIDTH(48);
    self.headScrollView.frame = CGRectMake(0,NAV_HEIGHT+FUN_HIGHT,WIN_WIDTH,headView_HHH);
    self.headScrollView.contentSize =CGSizeMake(WIN_WIDTH,headView_HHH);
    [self.headScrollView addSubview:_functionView];
    
    //    for (int y=0; y<3; y++) {
    //        UIView *ylineView = [[UIView alloc]initWithFrame:CGRectMake((y+1)*(CELL_H-1),0,1,lineH?WIN_WIDTH/2 :WIN_WIDTH/4)];
    //        ylineView.backgroundColor = COLOR_LINE;
    //        [functionView addSubview:ylineView];
    //    }
    
    //    scroll_TOP_H = scroll_TOP_H + M_WIDTH(7) + (lineH?WIN_WIDTH/2 :WIN_WIDTH/4);
    
    //[self createReScrollView];
    // [self loadInfoData];
    
}
- (void)createReScrollView
{
//    if (self.scrollView) {
//        return;
//    }
    scroll_TOP_H=0;
    self.scrollView = [[ReScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headScrollView.frame),WIN_WIDTH,WIN_HEIGHT-CGRectGetMaxY(self.headScrollView.frame)-45)];
    
    self.scrollView.refreshScrollDelegate=self;
    self.scrollView.delegate=self;
    buttomView_HHH=WIN_HEIGHT-headView_HHH-45;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    //self.scrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.scrollView.contentSize = CGSizeMake(WIN_WIDTH,WIN_HEIGHT-headView_HHH);
    [self.view addSubview:self.scrollView];
    //[functionView bringSubviewToFront:markLabel];
    [self createInfo];
}
-(void)tableView_refresh:(NSString *)type{
    NSLog(@"刷新");
    [SVProgressHUD showWithStatus:@"页面加载中"];
    [Global sharedClient].isLoginPush=@"0";
    //[self loadInfoData];
    [self loadData];
    
}

-(void)myguanliLoadData:(NSString *)pop{
    if (![Util isNull:pop] && [pop isEqualToString:@"popMine"]) {
        NSInteger  geren=3;
        if (_indexDedegate &&[_indexDedegate respondsToSelector:@selector(setindex:)]) {
            [_indexDedegate setindex:geren];
        }
    }else{
        [Global sharedClient].isLoginPush=@"0";
        [self loadData];
    }
}


-(void)btnTouch:(UIButton*)sender{
    
    NSLog(@"%d",(int)sender.tag);
    if (sender.tag == 666) {
        MyApplicationViewController *vc =[[MyApplicationViewController alloc]init];
        vc.mDelegate=self;
        NSArray *array = [[NSArray alloc]initWithArray:_dataDic[@"member_nav_list"]];
        if (array.count>0) {
            NSMutableArray *dataary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                int idint = [dic[@"id"] intValue];
                [dataary addObject:[NSString stringWithFormat:@"%d",idint]];
            }
            vc.idStr = [dataary componentsJoinedByString:@","];
        }
        
        [self.delegate.navigationController pushViewController:vc animated:YES];
        return;
    }
    int tagint = (int)sender.tag;
    NSString * type = [NSString stringWithFormat:@"%d",tagint];
    // NSString *type= ceshiDic[sen];
    
    NSLog(@"我玩的type= %@",type);
    
    if ([type isEqualToString:@"1"]) {
        //找店
        //        FindStoreController *fvc=[[FindStoreController alloc]init];
        //        fvc.caixiID  = @"0"; //业态id
        //        fvc.yetaiStr = @"全部业态";
        //        fvc.setInType=@"1";
        //        fvc.nvcImgView=@"商户,t_shopping";
        //        [self.delegate.navigationController pushViewController:fvc animated:YES];
        
//        UnifiedShopViewC *vc = [[UnifiedShopViewC alloc]init];
//        vc.shopType=@"1";
//        [self.delegate.navigationController pushViewController:vc animated:YES];
        ShopViewController *shopVc= [[ShopViewController alloc]init];
        [self.delegate.navigationController pushViewController:shopVc animated:YES];
        
    }else if ([type isEqualToString:@"2"]) {
        //活动
        ActivityController *aVC=[[ActivityController alloc]init];
        aVC.buttomH=@"0";
        aVC.isType=@"1";
        aVC.isPush = YES;
        [self.delegate.navigationController pushViewController:aVC animated:YES];
        //GoViewController* vc = [[GoViewController alloc] init];
        //[self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"3"]) {
        //美食 w_food
        //        FoodViewController *sVC=[[FoodViewController alloc]init];
        //        sVC.nvcImgView=@"美食,t_food";
        //        sVC.setInType=@"1";
        //        [self.delegate.navigationController pushViewController:sVC animated:YES];
        UnifiedShopViewC *vc = [[UnifiedShopViewC alloc]init];
        vc.shopType=@"0";
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"5"]) {
        
    }else if ([type isEqualToString:@"7"]) {
        
        NSInteger  geren=3;
        if (_indexDedegate &&[_indexDedegate respondsToSelector:@selector(setindex:)]) {
            [_indexDedegate setindex:geren];
        }
        
    }
    else if ([type isEqualToString:@"8"]) {
        //楼层选择
        IndoorMapController  *vc=[[IndoorMapController alloc]init];
        vc.myBuildString = [Util isNil:_dataDic[@"building_id"]];
        vc.myFloorId=@"F1";
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([type isEqualToString:@"11"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = [NSString stringWithFormat:@"%@://m.ascottchina.com",[Global sharedClient].HTTP_S];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"19"]) {
        //注册
        NewRegisterController *rVC=[[NewRegisterController alloc]init];
        [self.delegate.navigationController pushViewController:rVC animated:YES];
        
    }else if ([type isEqualToString:@"20"]) {
        //积分商城
        GoodsRootController* vc = [[GoodsRootController alloc] init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"21"]) {
        //排队领号
        GoViewController* vc = [[GoViewController alloc] init];
        NSDictionary* dic = [self getAppDic:tagint];
        vc.path = [NSString stringWithFormat:@"https://%@/%@/%@",[Global sharedClient].Shopping_Mall,[Global sharedClient].markPrefix,[Util isNil:dic[@"link_url"]]];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"22"]) {
        
        //星宝贝
        CreateStarBabyViewController * cSBVC = [[CreateStarBabyViewController alloc] init];
        [self.delegate.navigationController pushViewController:cSBVC animated:YES];
        
    }else if ([type isEqualToString:@"25"]) {
        //点击签到按钮
        [SVProgressHUD showWithStatus:@"正在努力签到中"];
        int  shopID=[[Global sharedClient].markID intValue];
        NSDictionary    *diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(shopID),@"mall_id",nil];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"sign" tp:@"conventionalsign"] parameters:diction  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"签到成功"];
            });
        }failue:^(NSDictionary *dic){
        }];
        
    }else if ([type isEqualToString:@"9"]) {
        //27
        //9  PV
        //停车服务
        GoViewController* vc = [[GoViewController alloc] init];
        vc.isParking = YES;
        NSArray *parkArray = [[NSArray alloc]initWithArray:_orderListArr];
        NSLog(@"orderlsit:%@",_orderListArr);
        for (NSDictionary *dic in parkArray) {
            int idint = [dic[@"id"] intValue];
            if (idint==[type intValue]) {
                vc.path = dic[@"link_url"];
            }
        }
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"1027"]) {
        //28
        //1027  PV
        //楼层选择
        
        RTMInterfaceController * controller = [RTMInterfaceController loadController:[Global sharedClient].building_id];
        [self presentViewController:controller animated:YES completion:nil];
        //        IndoorMapController  *vc=[[IndoorMapController alloc]init];
        //        vc.myBuildString = [Util isNil:_dataDic[@"building_id"]];
        //        vc.myFloorId=@"F1";
        //        [self.delegate.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([type isEqualToString:@"1030"]) {
        //36
        //1030   PV
        //门禁
        CompanyVC  *vc=[[CompanyVC alloc]init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"1032"]) {
        //39
        //1032  PV
        //资讯
        InfoListViewController  *vc=[[InfoListViewController alloc]init];
        
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        if ([self chuliID:tagint]!=nil) {
            GoViewController* vc = [[GoViewController alloc] init];
            vc.path = [self chuliID:tagint];
            
            [self.delegate.navigationController pushViewController:vc animated:YES];
        }
    }
}

//根据应用的id返回应用对应的数据
-(NSDictionary*)getAppDic:(int)appid{
    NSArray *array = [[NSArray alloc]initWithArray:_orderListArr];
    
    for (NSDictionary *dic in array) {
        int idint = [dic[@"id"] intValue];
        if (idint==appid) {
            
            return dic;
        }
    }
    return nil;
}

//根据应用的id返回H5界面需要跳转的字段
-(NSString*)chuliID:(int)appid{
    NSArray *array = [[NSArray alloc]initWithArray:_orderListArr];
    
    for (NSDictionary *dic in array) {
        int idint = [dic[@"id"] intValue];
        if (idint==appid) {
            if([[Util isNil:dic[@"link_url"]] hasPrefix:@"http"]){
                return [Util isNil:[dic[@"link_url"] stringByReplacingOccurrencesOfString:@"http" withString:[Global sharedClient].HTTP_S]];
            }else{
                return [NSString stringWithFormat:@"%@://%@/%@/%@",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall,[Global sharedClient].markPrefix,[Util isNil:dic[@"link_url"]]];
            }
        }
    }
    return nil;
}

-(void) devNavDic{
    ceshiDic= [Util logConfigDicFromPlist:@"appid"];
}

/**
 * 创建资讯活动
 */
-(void) createInfo{
    //    if(![Util isNull:huodongDic[@"rec_consult"]]){
    //
    //        infoView = [self createHuoDongView:huodongDic[@"rec_consult"] tag:0];
    //        CGRect frame = infoView.frame;
    //        frame.origin.y = scroll_TOP_H;
    //        infoView.frame = frame;
    //        [self.scrollView addSubview:infoView];
    //        scroll_TOP_H = scroll_TOP_H +CGRectGetHeight(infoView.frame);
    //
    //    }
    [self acreateLunBoImg];
}
//咨询
-(void) onHuoDongViewTap:(UITapGestureRecognizer*) tap{
    int tag = [tap view].tag;
    NSString* url= @"";
    if(tag == 0){
        url = huodongDic[@"rec_consult"][@"link_url"];
        
    }else{
        NSArray* arr = huodongDic[@"consultlist"];
        url = arr[tag - 1 ][@"link_url"];
    }
    GoViewController *vc= [[GoViewController alloc]init];
    vc.path=url;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//创建资讯单元视图
-(UIView*) createHuoDongView:(NSDictionary*) dic tag:(NSInteger)tag
{
    CGFloat titleHieght=M_WIDTH(24);
    CGFloat infoView_H=M_WIDTH(167);
    CGFloat botomHight=M_WIDTH(24);
    UIView* infoV =  [[UIView alloc]initWithFrame:CGRectMake(0,scroll_TOP_H,WIN_WIDTH,titleHieght+infoView_H+botomHight + 10)];
    infoV.backgroundColor=[UIColor clearColor];
    
    UIView* containView =[[UIView alloc]initWithFrame:CGRectMake(0,8,WIN_WIDTH,titleHieght+infoView_H+botomHight )];
    containView.backgroundColor=[UIColor whiteColor];
    containView.tag = tag;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHuoDongViewTap:)];
    [containView addGestureRecognizer:tap];
    
    UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),0,WIN_WIDTH/2,titleHieght)];
    [self chulititleLab:titleLab text:dic[@"sub_title"]];
    //titleLab.font = DESC_FONT;
    
    [containView addSubview:titleLab];
    
    @try {
        UILabel *timeLabel= [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2,0,WIN_WIDTH/2 - M_WIDTH(14),titleHieght)];
        NSDate* time = [DateUtil dateFromstring:dic[@"create_time"] format:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        [self chulititleLab:timeLabel text:[DateUtil compareCurrentTime: time]];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = COLOR_FONT_SECOND;
        timeLabel.font = SMALL_FONT;
        [containView addSubview:timeLabel];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, titleHieght, WIN_WIDTH, infoView_H);
    [imgView setImageWithString:dic[@"img_url"]];
    [containView addSubview:imgView];
    imgView.clipsToBounds = YES;
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    UILabel *bottomLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),CGRectGetMaxY(imgView.frame),WIN_WIDTH,botomHight )];
    bottomLab.text = dic[@"title"];
    bottomLab.font = INFO_FONT;
    bottomLab.textColor = COLOR_FONT_BLACK;
    [containView addSubview:bottomLab];
    
    [infoV addSubview:containView];
    return infoV;
}

-(void) createHuoDongListView{
    if([Util isNull:huodongDic[@"consultlist"]]){
        return;
    }
    NSArray* huodongList = huodongDic[@"consultlist"];
    NSMutableArray *imgData    =[[NSMutableArray alloc]init];
    NSMutableArray *titles    =[[NSMutableArray alloc]init];
    NSMutableArray *urls    =[[NSMutableArray alloc]init];
    for (NSDictionary *dic in huodongList) {
        NSString  *img_urlStr   = [Util isNil:dic[@"img_url"]];
        NSString  *web_urlStr   = [Util isNil:dic[@"link_url"]];
        NSString  *titleStr     = [Util isNil:dic[@"title"]];
        [imgData addObject:img_urlStr];
        [urls addObject:web_urlStr];
        [titles addObject:titleStr];
    }
    
    // 咨询活动竖行展开
    //    for(int i = 0; i < huodongList.count; i++){
    //        UIView* infoV = [self createHuoDongView:huodongList[i] tag:i+1];
    //        CGRect frame = infoV.frame;
    //        frame.origin.y = scroll_TOP_H + i*frame.size.height;
    //        infoV.frame = frame;
    //        [self.scrollView addSubview:infoV];
    //        [self.scrollView setContentSize:CGSizeMake(WIN_WIDTH, CGRectGetMaxY(infoV.frame))];
    //        self.underlineLabel.frame = CGRectMake(0, infoV.bottom+5, WIN_WIDTH, 30);
    //    }
    CGFloat bannerWidth = WIN_WIDTH-M_WIDTH(42);
    CGFloat addHight=M_WIDTH(8);
    CGFloat adView_H=(WIN_WIDTH-M_WIDTH(0))/2;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, scroll_TOP_H, WIN_WIDTH, adView_H+addHight+M_WIDTH(24)+M_WIDTH(16))];
    [self.scrollView addSubview:bgView];
    // UIView *lineViewTop = [[UIView alloc]initWithFrame:CGRectMake(0,0, WIN_WIDTH, M_WIDTH(8))];
    //lineViewTop.backgroundColor=UIColorFromRGB(0xf2f2f2);
    //[bgView addSubview:lineViewTop];
    
    UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),0,WIN_WIDTH/2,M_WIDTH(24))];
    [self chulititleLab:titleLab text:@"白领课堂"];
    
    [bgView addSubview:titleLab];
    
    UIButton *moreBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn2.frame = CGRectMake(WIN_WIDTH-78, 0, 68, CGRectGetHeight(titleLab.frame));
    [moreBtn2 setTitle:@"查看全部" forState:UIControlStateNormal];
    [moreBtn2 setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    moreBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    moreBtn2.titleLabel.textAlignment =NSTextAlignmentRight;
    [moreBtn2 addTarget:self action:@selector(clickToBailing:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn2];
    UIImageView *tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-18,  M_WIDTH(9), 8, 8)];
    [tipImageView setImage:[UIImage imageNamed:@"jiantou"]];
    [bgView addSubview:tipImageView];
    
    UIScrollView *zixun = [[UIScrollView alloc]initWithFrame:CGRectMake(0, M_WIDTH(32), WIN_WIDTH,adView_H+M_WIDTH(16) )];
    zixun.bounces = YES;
    zixun.pagingEnabled = NO;
    zixun.showsHorizontalScrollIndicator = NO;
    zixun.contentSize = CGSizeMake(huodongList.count*(bannerWidth+M_WIDTH(14)), adView_H);
    [bgView addSubview:zixun];
    
    
    for (int i=0; i<huodongList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(14)+(bannerWidth+M_WIDTH(14))*i, 0, bannerWidth, adView_H)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+1;
        [imageView setImageWithString:imgData[i]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onHuoDongViewTap:)];
        [imageView addGestureRecognizer:tap];
        [zixun addSubview:imageView];
        UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14)+(bannerWidth+M_WIDTH(14))*i, CGRectGetMaxY(imageView.frame), bannerWidth, M_WIDTH(16))];
        bottomLabel.text =titles[i];
        bottomLabel.font = [UIFont systemFontOfSize:14];
        [zixun addSubview:bottomLabel];
    }
    [self.scrollView setContentSize:CGSizeMake(WIN_WIDTH, CGRectGetMaxY(bgView.frame)+30)];
    self.underlineLabel.frame = CGRectMake(0, bgView.bottom+5, WIN_WIDTH, 30);
    
    
}

/**
 * 活动轮播 */
-(void)acreateLunBoImg{
    NSArray *array=self.dataDic[@"advert_list"];
    CGFloat addHight=M_WIDTH(8);
    CGFloat adView_H=(WIN_WIDTH-M_WIDTH(0))/2;
    if(array.count>0){
        UIView *actView = [[UIView alloc]initWithFrame:CGRectMake(0,scroll_TOP_H,WIN_WIDTH,addHight+M_WIDTH(32)+adView_H)];
        actView.backgroundColor=[UIColor whiteColor];
        [self.scrollView addSubview:actView];
        
        UIView *lineViewTop = [[UIView alloc]initWithFrame:CGRectMake(0,0, WIN_WIDTH, M_WIDTH(8))];
        //lineViewTop.backgroundColor=UIColorFromRGB(0xf2f2f2);
        
        [actView addSubview:lineViewTop];
        
        UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),CGRectGetMaxY(lineViewTop.frame),WIN_WIDTH/2,M_WIDTH(24))];
        [self chulititleLab:titleLab text:@"活动推荐"];
        
        
        [actView addSubview:titleLab];
        
        //        UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,M_WIDTH(7),WIN_WIDTH,M_WIDTH(38))];
        //        [titleImg setImage:[UIImage imageNamed:@"huodongtuijian"]];
        //        [actView addSubview:titleImg];
        
        NSMutableArray *imgData    =[[NSMutableArray alloc]init];
        NSMutableArray *titles    =[[NSMutableArray alloc]init];
        _urls = [[NSMutableArray alloc]init];
        //        NSDictionary   *itmeDic;
        for (NSDictionary *dic in array) {
            NSString  *img_urlStr   = [Util isNil:dic[@"img_url"]];
            NSString  *web_urlStr   = [Util isNil:dic[@"link_url"]];
            NSString  *titleStr     = [Util isNil:dic[@"title"]];
            [imgData addObject:img_urlStr];
            [_urls addObject:web_urlStr];
            [titles addObject:titleStr];
        }
        
        UIView *imgview=[[UIView alloc]init];
        imgview.frame = CGRectMake(M_WIDTH(0),CGRectGetMaxY(titleLab.frame)+M_WIDTH(8),WIN_WIDTH-M_WIDTH(0),CGRectGetHeight(actView.frame) - CGRectGetMaxY(titleLab.frame) );
        
        
        //        // 网络加载 --- 创建带标题的图片轮播器
        //        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:imgview.bounds delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        //        cycleScrollView2.backgroundColor=[UIColor whiteColor];
        //        cycleScrollView2.titleLabelTextColor=[UIColor blackColor];
        //        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //        cycleScrollView2.titlesGroup = titles;
        //        cycleScrollView2.currentPageDotColor = APP_BTN_COLOR; // 自定义分页控件小圆标颜色
        //        cycleScrollView2.pageDotColor =COLOR_LINE;
        //        cycleScrollView2.titleLabelTextFont = INFO_FONT;
        //        [imgview addSubview:cycleScrollView2];
        //        //         --- 模拟加载延迟
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            cycleScrollView2.imageURLStringsGroup = imgData;
        //        });
        //
        //         //block监听点击方式
        //         cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        //             GoViewController *vc= [[GoViewController alloc]init];
        //             //vc.isShare=@"share";
        //             vc.path=urls[index];
        //             [self.delegate.navigationController pushViewController:vc animated:YES];
        //         };
        //
        _bannerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, imgview.width, imgview.height)];
        [imgview addSubview:_bannerScrollView];
        _bannerScrollView.showsHorizontalScrollIndicator = NO;
        CGFloat bannerWidth = WIN_WIDTH-M_WIDTH(42);
        _bannerScrollView.contentSize = CGSizeMake(imgData.count*(bannerWidth+M_WIDTH(14)), imgview.height);
        for (NSInteger i=0; i<imgData.count; i++) {
            UIButton *bannerBtn = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(14)+(bannerWidth+M_WIDTH(14))*i, 0, bannerWidth, imgview.height- M_WIDTH(21))];
            bannerBtn.tag = 2000+i;
            [bannerBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgData[i]]]] forState:UIControlStateNormal];
            [bannerBtn addTarget:self action:@selector(clickToBanner:) forControlEvents:UIControlEventTouchUpInside];
            [_bannerScrollView addSubview:bannerBtn];
            
            UILabel *bannerLabel = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14)+(bannerWidth+M_WIDTH(14))*i, imgview.height-M_WIDTH(21), bannerWidth, M_WIDTH(21))];
            bannerLabel.text = titles[i];
            bannerLabel.font = DESC_FONT;
            bannerLabel.textColor = UIColorFromRGB(0x555555);
            [_bannerScrollView addSubview:bannerLabel];
            
        }
        
        [actView addSubview:imgview];
        [self.scrollView addSubview:actView];
        scroll_TOP_H = scroll_TOP_H +CGRectGetHeight(actView.frame)+M_WIDTH(12);
        self.scrollView.contentSize = CGSizeMake(WIN_WIDTH,scroll_TOP_H);
    }else{
        scroll_TOP_H = scroll_TOP_H+M_WIDTH(12);
    }
    
    pageNum=0;
    self.integralAry = [[NSMutableArray alloc]init];
    [self crateCommodityView];
}
- (void)clickToBanner:(UIButton *)sender
{
    if ([Util isNull:_urls[sender.tag-2000]]) {
        return;
    }
    GoViewController *vc= [[GoViewController alloc]init];
    vc.path=_urls[sender.tag-2000];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
//商品推荐
-(void)crateCommodityView{
    NSArray *dataary = _dataDic[@"cash_goods_list"];
    
    CGFloat view_W = (WIN_WIDTH-M_WIDTH(31))/2;
    CGFloat view_H = M_WIDTH(81)+view_W/3*2;//
    
    //UIView *commodityView = [[UIView alloc]initWithFrame:CGRectMake(0,scroll_TOP_H,WIN_WIDTH,M_WIDTH(24) +view_H*2 +M_WIDTH(36))];
    UIView *commodityView = [[UIView alloc]initWithFrame:CGRectMake(0,scroll_TOP_H,WIN_WIDTH,M_WIDTH(34) +view_H*2 )];
    commodityView.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:commodityView];
    
    UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),0,WIN_WIDTH/2,M_WIDTH(24))];
    [self chulititleLab:titleLab text:@"商品推荐"];
    
    [commodityView addSubview:titleLab];
    
    //    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(38))];
    //    [titleImg setImage:[UIImage imageNamed:@"shangpintuijian"]];
    //    [commodityView addSubview:titleImg];
    
    for (int i=0; i<dataary.count && i<4; i++) {
        int  view_x=i%2;
        int  view_y=i/2;
        NSDictionary *dic=dataary[i];
        UIView *youlikeView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(11)+view_x*(view_W+M_WIDTH(9)),CGRectGetMaxY(titleLab.frame)+M_WIDTH(10)+view_H*view_y,view_W,view_H)];
        
        UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,youlikeView.frame.size.width,view_W/3*2)];
        [logoImg setUserInteractionEnabled:YES];
        logoImg.contentMode=UIViewContentModeScaleAspectFill;
        logoImg.clipsToBounds = YES;
        logoImg.layer.borderColor=COLOR_LINE.CGColor;
        logoImg.layer.borderWidth=1;
        [logoImg setImageWithURL:[NSURL URLWithString:dic[@"img_url"]]];
        
        UILabel *typeLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(logoImg.frame)+M_WIDTH(1),M_WIDTH(60),M_WIDTH(21))];
        typeLab.textColor=UIColorFromRGB(0x00A699);
        //typeLab.textColor = APP_BTN_COLOR;
        typeLab.textAlignment=NSTextAlignmentLeft;
        typeLab.font=SMALL_FONT;
        typeLab.text=@"现金或积分";
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(typeLab.frame),view_W, M_WIDTH(27))];
        nameLab.text=dic[@"title"];
        nameLab.font=COMMON_FONT;
        nameLab.textColor=UIColorFromRGB(0x333333);
        nameLab.textAlignment=NSTextAlignmentLeft;
        //类型
        //        UIImageView *typeImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11),CGRectGetMaxY(nameLab.frame),M_WIDTH(55),M_WIDTH(11))];
        //        [typeImg setImage:[UIImage imageNamed:@"xianjinorjifen"]];
        //        [youlikeView addSubview:typeImg];
        
        UILabel *floorLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(nameLab.frame),view_W, M_WIDTH(22))];
        floorLab.textAlignment=NSTextAlignmentLeft;
        floorLab.font=COMMON_FONT;
        floorLab.textColor=UIColorFromRGB(0x000000);
        [floorLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        floorLab.text=[NSString stringWithFormat:@"￥%@",dic[@"price"]];
        
        UIButton *youlikeBtn=[[UIButton alloc]initWithFrame:youlikeView.bounds];
        youlikeBtn.tag=i;
        [youlikeBtn addTarget:self action:@selector(youlikeTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [youlikeView addSubview:logoImg];
        [youlikeView addSubview:nameLab];
        [youlikeView addSubview:floorLab];
        [youlikeView addSubview:typeLab];
        [youlikeView addSubview:youlikeBtn];
        [commodityView addSubview:youlikeView];
    }
    
    UIButton *moreBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn2.frame = CGRectMake(WIN_WIDTH-78, 0, 68, CGRectGetHeight(titleLab.frame));
    [moreBtn2 setTitle:@"查看全部" forState:UIControlStateNormal];
    [moreBtn2 setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    moreBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    moreBtn2.titleLabel.textAlignment =NSTextAlignmentRight;
    [moreBtn2 addTarget:self action:@selector(moreTouch:) forControlEvents:UIControlEventTouchUpInside];
    [commodityView addSubview:moreBtn2];
    UIImageView *tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-18,  M_WIDTH(9), 8, 8)];
    [tipImageView setImage:[UIImage imageNamed:@"jiantou"]];
    [commodityView addSubview:tipImageView];
    
    //    UIButton *moreBtn = [[UIButton alloc]init];
    //    moreBtn.layer.borderColor=UIColorFromRGB(0x999999).CGColor;
    //    moreBtn.layer.borderWidth=1;
    //    MLabel *moreLab = [[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(7),0,10,M_WIDTH(23))];
    //    moreLab.font=DESC_FONT;
    //    moreLab.text=@"查看更多";
    //    CGRect rect1=[moreLab.text boundingRectWithSize:CGSizeMake(150,M_WIDTH(23)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:moreLab.font} context:nil];
    //    moreLab.frame=CGRectMake(M_WIDTH(7),rect1.origin.y,rect1.size.width,M_WIDTH(23));
    //    [moreBtn addSubview:moreLab];
    //
    //    UIImageView *iconImg1= [[UIImageView alloc]initWithFrame:CGRectMake(rect1.size.width+M_WIDTH(7),(M_WIDTH(23)-M_WIDTH(12))/2,M_WIDTH(10),M_WIDTH(12))];
    //    [iconImg1 setImage:[UIImage imageNamed:@"rightbiubiu"]];
    //    [iconImg1 setUserInteractionEnabled:YES];
    //    [moreBtn addSubview:iconImg1];
    //
    //    CGFloat btn_W =M_WIDTH(21)+rect1.size.width;
    //
    //    moreBtn.frame=CGRectMake((WIN_WIDTH-btn_W)/2,CGRectGetMaxY(titleLab.frame)+view_H*2,btn_W,M_WIDTH(23));
    //    [moreBtn addTarget:self action:@selector(moreTouch:) forControlEvents:UIControlEventTouchUpInside];
    //    [commodityView addSubview:moreBtn];
    //    [self.scrollView addSubview:commodityView];
    
    self.underlineLabel.frame = CGRectMake(0, commodityView.bottom, commodityView.width, 50);
    [self.scrollView addSubview:self.underlineLabel];
    
    
    scroll_TOP_H = scroll_TOP_H + CGRectGetHeight(commodityView.frame);
    self.scrollView.contentSize = CGSizeMake(WIN_WIDTH,scroll_TOP_H);
    
    [self jifenLoadDate];
}

//点击更多事件
-(void)moreTouch:(UIButton*)sender{
    GoodsRootController* vc = [[GoodsRootController alloc] init];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
- (void)clickToBailing:(UIButton *)sender
{
    InfoListViewController *infoVc = [[InfoListViewController alloc]init];
    [self.delegate.navigationController pushViewController:infoVc animated:YES];
}
-(void)youlikeTouch:(UIButton*)sender{
    NSString *datastr = _dataDic[@"cash_goods_list"][sender.tag][@"goods_detail"];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = datastr;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


-(void)youlikeNet{
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self jifenLoadDate];
    }];
    
    self.scrollView.mj_footer = footer;
    self.scrollView.mj_footer.automaticallyHidden = YES;
    [self.scrollView.mj_footer endRefreshing];
}

-(void)jifenLoadDate{
    pageNum++;
    NSString *page=[NSString stringWithFormat:@"%d",pageNum];
    int zz=[[Global sharedClient].markID intValue];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"integralgoodslist"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",page,@"page",@"10",@"pageSize",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断是否有数据
            if (isend1==NO) {
                //赋值，为了判断下次是否有数据
                isend1 = [dic[@"data"][@"isEnd"]boolValue];
                
                //成功获取所有数据
                [_integralAry addObjectsFromArray:dic[@"data"][@"integralgoodslist"]];
                if (_integralAry.count) {
                    [self createIntegralView];
                }else {
                    //                    [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                    self.scrollView.mj_footer.hidden=YES;
                    [self createHuoDongListView];
                }
                
                if (isend1) {
                    self.scrollView.mj_footer.hidden=YES;
                }
            }else{
                //                [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                self.scrollView.mj_footer.hidden=YES;
            }
            [self.scrollView.mj_footer endRefreshing];
        });
    }failue:^(NSDictionary *dic){
        [self createHuoDongListView];
        self.scrollView.mj_footer.hidden=YES;
        [self.scrollView.mj_footer endRefreshing];
    }];
}


-(void)createIntegralView{
    //只显示4个，超出显示查看更多
    [integralView removeFromSuperview];
    CGFloat scollH2 = scroll_TOP_H;
    integralView = [[UIView alloc]init];
    integralView.backgroundColor=[UIColor whiteColor];
    [self.scrollView addSubview:integralView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 8)];
    [integralView addSubview:headerView];
    //headerView.backgroundColor =  UIColorFromRGB(0xf2f2f2);
    
    UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),8,WIN_WIDTH/2,M_WIDTH(24))];
    [self chulititleLab:titleLab text:@"积分好礼"];
    
    [integralView addSubview:titleLab];
    
    //    UIImageView *titleImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(38))];
    //    [titleImg setImage:[UIImage imageNamed:@"jifenshangpin"]];
    //    [integralView addSubview:titleImg];
    
    CGFloat view_W = (WIN_WIDTH-M_WIDTH(31))/2;
    CGFloat view_H = M_WIDTH(175);
    Boolean hasMore = false;
    if(_integralAry.count > 4){
        hasMore = true;
    }
    for (int i=0; i<_integralAry.count; i++) {
        int  view_x=i%2;
        int  view_y=i/2;
        NSDictionary *dic=_integralAry[i];
        UIView *youlikeView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(11)+view_x*(view_W+M_WIDTH(9)),M_WIDTH(40)+view_H*view_y,view_W,view_H)];
        
        UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, youlikeView.frame.size.width, M_WIDTH(90))];
        [logoImg setUserInteractionEnabled:YES];
        logoImg.contentMode=UIViewContentModeScaleAspectFill;
        logoImg.clipsToBounds = YES;
        logoImg.layer.borderColor=COLOR_LINE.CGColor;
        logoImg.layer.borderWidth=1;
        [logoImg setImageWithURL:[NSURL URLWithString:dic[@"img_url"]]];
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(logoImg.frame),view_W, M_WIDTH(27))];
        nameLab.text=dic[@"title"];
        NSLog(@"nameLab.text%@",nameLab.text);
        nameLab.font=COMMON_FONT;
        nameLab.textColor=UIColorFromRGB(0x333333);
        nameLab.textAlignment=NSTextAlignmentLeft;
        //类型
        
        UILabel *nameLab2 = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(nameLab.frame),M_WIDTH(55),M_WIDTH(22))];
        nameLab2.font=SMALL_FONT;
        nameLab2.text=dic[@"mall_name"];
        NSLog(@"nameLab2.text%@",nameLab2.text);
        nameLab2.textColor=UIColorFromRGB(0xffb80e);
        nameLab2.textAlignment=NSTextAlignmentCenter;
        nameLab2.layer.masksToBounds=YES;
        nameLab2.layer.cornerRadius=nameLab2.frame.size.height/2;
        nameLab2.layer.borderColor=UIColorFromRGB(0xffb80e).CGColor;
        nameLab2.layer.borderWidth=1;
        
        CGRect rect1=[nameLab2.text boundingRectWithSize:CGSizeMake(M_WIDTH(200),M_WIDTH(22)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:nameLab2.font} context:nil];
        nameLab2.frame=CGRectMake(nameLab2.frame.origin.x,nameLab2.frame.origin.y,rect1.size.width+M_WIDTH(18),M_WIDTH(22));
        
        //        UIImageView *typeImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11),CGRectGetMaxY(nameLab.frame),rect1.size.width+15,M_WIDTH(11))];
        //        [typeImg setImage:[UIImage imageNamed:@"honebulebeijing"]];
        
        MLabel *floorLab=[[MLabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(nameLab2.frame),view_W, M_WIDTH(28))];
        floorLab.textAlignment=NSTextAlignmentLeft;
        NSString *jifen = [NSString stringWithFormat:@"%d",[dic[@"integral"] intValue]];
        floorLab.text=[NSString stringWithFormat:@"%@星积分",jifen];
        [floorLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [floorLab setAttrFont:0 end:(int)jifen.length font:COMMON_FONT];
        
        UIButton *youlikeBtn=[[UIButton alloc]initWithFrame:youlikeView.bounds];
        youlikeBtn.tag=i;
        [youlikeBtn addTarget:self action:@selector(jifenTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [youlikeView addSubview:logoImg];
        [youlikeView addSubview:nameLab];
        [youlikeView addSubview:nameLab2];
        [youlikeView addSubview:floorLab];
        [youlikeView addSubview:youlikeBtn];
        [integralView addSubview:youlikeView];
        if(i >= 3){
            break;
        }
    }
    UIButton *moreBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn2.frame = CGRectMake(WIN_WIDTH-78, CGRectGetMinY(titleLab.frame), 68, CGRectGetHeight(titleLab.frame));
    [moreBtn2 setTitle:@"查看全部" forState:UIControlStateNormal];
    
    [moreBtn2 setTitleColor:UIColorFromRGB(0x767676) forState:UIControlStateNormal];
    moreBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    moreBtn2.titleLabel.textAlignment =NSTextAlignmentRight;
    [moreBtn2 addTarget:self action:@selector(moreJfGoodsTouch:) forControlEvents:UIControlEventTouchUpInside];
    [integralView addSubview:moreBtn2];
    UIImageView *tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-18,  CGRectGetMinY(titleLab.frame)+M_WIDTH(9), 8, 8)];
    [tipImageView setImage:[UIImage imageNamed:@"jiantou"]];
    [integralView addSubview:tipImageView];
    
    int hight = M_WIDTH(34);
    int yyy = 0;
    if(hasMore ){
        yyy = 2;
        hight += view_H* 2;
        
        //        UIButton* moreBtn = [self createMoreBtn];
        //        CGRect frame = moreBtn.frame;
        //        frame.origin.x = (WIN_WIDTH-frame.size.width)/2;
        //        frame.origin.y = hight;
        //        moreBtn.frame=frame;
        //        [moreBtn addTarget:self action:@selector(moreJfGoodsTouch:) forControlEvents:UIControlEventTouchUpInside];
        //        [integralView addSubview:moreBtn];
        //        hight += CGRectGetHeight(moreBtn.frame) + 20;
    }
    else{
        yyy = ceilf(_integralAry.count/2.0);
        hight += view_H* (_integralAry.count>2?2:1) ;
        
        //        UIButton* moreBtn = [self createMoreBtn];
        //        CGRect frame = moreBtn.frame;
        //        frame.origin.x = (WIN_WIDTH-frame.size.width)/2;
        //        frame.origin.y = hight;
        //        moreBtn.frame=frame;
        //        [moreBtn addTarget:self action:@selector(moreJfGoodsTouch:) forControlEvents:UIControlEventTouchUpInside];
        //        [integralView addSubview:moreBtn];
        //        hight += CGRectGetHeight(moreBtn.frame) + 20;
    }
    
    integralView.frame = CGRectMake(0,scroll_TOP_H,WIN_WIDTH,hight);
    // scollH2 = scollH2 + M_WIDTH(38) + view_H*yyy;
    [self.scrollView addSubview:integralView];
    
    self.underlineLabel.frame = CGRectMake(0, integralView.bottom+5, integralView.width, 30);
    
    self.scrollView.contentSize = CGSizeMake(WIN_WIDTH,CGRectGetMaxY(integralView.frame));
    scroll_TOP_H = scroll_TOP_H + hight;
    [self createHuoDongListView];
}

//更多积分商品点击事件
-(void) moreJfGoodsTouch:(id) sender{
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    GoodsRootController* vc = [[GoodsRootController alloc] init];
    [self.delegate.navigationController pushViewController:vc animated:YES];
    btn.enabled = YES;
}

//新建更多按钮
-(UIButton*) createMoreBtn{
    
    UIButton *moreBtn = [[UIButton alloc]init];
    moreBtn.layer.borderColor=UIColorFromRGB(0x999999).CGColor;
    moreBtn.layer.borderWidth=1;
    
    MLabel *moreLab = [[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(7),0,10,M_WIDTH(23))];
    moreLab.font=DESC_FONT;
    moreLab.text=@"查看更多";
    CGRect rect1=[moreLab.text boundingRectWithSize:CGSizeMake(150,M_WIDTH(23)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:moreLab.font} context:nil];
    moreLab.frame=CGRectMake(M_WIDTH(7),rect1.origin.y,rect1.size.width,M_WIDTH(23));
    [moreBtn addSubview:moreLab];
    
    UIImageView *iconImg1= [[UIImageView alloc]initWithFrame:CGRectMake(rect1.size.width+M_WIDTH(7),(M_WIDTH(23)-M_WIDTH(12))/2,M_WIDTH(10),M_WIDTH(12))];
    [iconImg1 setImage:[UIImage imageNamed:@"rightbiubiu"]];
    [iconImg1 setUserInteractionEnabled:YES];
    [moreBtn addSubview:iconImg1];
    CGFloat btn_W =M_WIDTH(21)+rect1.size.width;
    moreBtn.frame=CGRectMake((WIN_WIDTH-btn_W)/2,0,btn_W,M_WIDTH(23));
    return moreBtn;
}

-(void)jifenTouch:(UIButton*)sender{
    NSString *datastr = _integralAry[sender.tag][@"integral_detail"];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = datastr;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
//对每个模块的顶部文字作处理@"积分商品"
-(void)chulititleLab:(UILabel*)lab text:(NSString*)text{
    lab.text=text;
    //[lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:X_WIDTH(22)]];
    lab.font = [UIFont systemFontOfSize:X_WIDTH(22)];
    lab.textAlignment=NSTextAlignmentLeft;
    //lab.textColor=APP_BTN_COLOR;
    lab.textColor = UIColorFromRGB(0x484848);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    //    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
    
    //[self.view bringSubviewToFront:nav1View];
    [self.view bringSubviewToFront:navView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    // 开启
    //    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //    }
    if (!isLight) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}


//----------------------------  扫描小票，上传方法  ----------------------------

-(void) updateImg{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        [self uploadImg:UIImageJPEGRepresentation(portraitImg,1.0)];
    });
}

-(void) btnSelected:(NSString*)index{
    if([index isEqualToString:@"1"]){
        return ;
    }else{
        [self updateImg];
    }
}

//以下是头像设置代码，从第三方copy
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self updateImg];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //保存图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        userImgData = UIImageJPEGRepresentation(editedImage,1.0);
    });
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void) uploadImg:(NSData*) imgData{
    
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"scanreceipt"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@"SIN001",@"location_code",[Global sharedClient].member_id,@"member_id",[Global sharedClient].markID,@"mall_id",@"1000",@"source",[self image2DataURL:portraitImg],@"receiptimg",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
        if ([dic[@"result"] integerValue]==4) {
            NSDictionary *data = [dic objectForKey:@"data"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                GoViewController *govc = [[GoViewController alloc]init];
                govc.path = data[@"url"];
                [self.delegate.navigationController pushViewController:govc animated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.3f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}
- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [Global sharedClient].isLoginPush = @"0";
    if (_functionView) {
        return;
    }
    [self loadAD];
    [self loadOrderListData];
    [self loadData];
}


@end

