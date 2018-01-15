//
//  ViewController.m
//  Foodspotting
//
//  Created by jetson  on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MyNBTabController.h"
#import "MyNBTabButton.h"
#import "MineViewController.h"
#import "SYWebViewViewController.h"
#import "GoodsRootController.h"
#import "IntegralController.h"
#import "StoreDetailsController.h"
#import "MyMsgWebController.h"

#import "LuanchAdvViewController.h"

@interface RootViewController ()<MyNBTabBarDelegate,rootIndex,goodsRootDelegate>
{
     UISearchBar *searchBar;
}
@end

@implementation RootViewController{
    UIView *hiddbackView;//
    UIView* titleView;
    UILabel* titleLabel;
    UIButton* rightButton;
    GoodsRootController *intVC;
    MineViewController* mineVc;
    StoreDetailsController *homeVc;
    MyMsgWebController     *msgVC;
    UIView* popoverContentView;
    
    UIView *locationCueView;//提示框
    NSDictionary *locDic;//定位返回的商场数据
}

@synthesize currentVC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.popover = [DXPopover new];
    if (WIN_HEIGHT==812.0f) {
        _tabbarHeight.constant = 34.0f;
    }else
    {
        _tabbarHeight.constant = 0;
    }
    
    //绑定事件
    self.view.backgroundColor = [UIColor grayColor];
    homeVc = [[StoreDetailsController alloc] init];
    homeVc.delegate = self;
    homeVc.indexDedegate=self;
    
    mineVc = [[MineViewController alloc] init];
    mineVc.delegate = self;

    currentVC = homeVc;

    [_container addSubview:homeVc.view];

    intVC = [[GoodsRootController alloc] init];
    intVC.goodDelegata=self;
    intVC.delegate = self;
    
    msgVC =[[MyMsgWebController alloc]init];
    msgVC.delegate=self;
    msgVC.path =[NSString stringWithFormat:@"%@TitleNav/userMessageList",[Global sharedClient].HTTP_VIP];
    
    MyNBTabButton *homeBtn  = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"newHomebarblack"]];
    homeBtn.highlightedIcon = [UIImage imageNamed:@"newHomebar"];
    homeBtn.viewController  = homeVc;
    
    MyNBTabButton *intBtn   = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"newkaidebarblack"]];
    intBtn.highlightedIcon  = [UIImage imageNamed:@"newkaidebar"];
    intBtn.viewController   = intVC;
    intBtn.noDown = true;
    
    MyNBTabButton *msgBtn   = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"newMsgbarblack"]];
    msgBtn.highlightedIcon  = [UIImage imageNamed:@"newMsgbar"];
    msgBtn.viewController   = msgVC;
    
    MyNBTabButton *mineBtn  = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"newMinebarblack"]];
    mineBtn.highlightedIcon = [UIImage imageNamed:@"newMinebar"];
    mineBtn.viewController  = mineVc;
    
    NSArray *arr = [NSArray arrayWithObjects:homeBtn,intBtn,msgBtn,mineBtn,nil];
    [_tabBar initWithItemsNoFrame:arr];
    _tabBar.delegate = self;
    
    if (self.haveRemotemsg) {
        [_tabBar showIndex:3];
    }else{
        [_tabBar showIndex:0];
    }
}

-(void) viewWillAppear:(BOOL)animated{
   [super viewWillAppear:YES];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //先加载广告
//    if(![Global sharedClient].showAdv){
//        [self loadAdv];
//    }else{
        [self display];
//    }

    
}

-(void) display{
    
    if(![self isSignIn]){
        return;
    }
    [self displayTitle];
    
    [currentVC viewWillAppear:YES];
    if (![Util isNull:[Global sharedClient].pushLoadData] && [[Global sharedClient].pushLoadData isEqualToString:@"1"] ) {
        [_tabBar showIndex:0];
        [currentVC viewWillAppear:YES];
        NSLog(@"%@",[Global sharedClient].pushLoadData);
    }else{
        NSLog(@"asdasd");
    }
}


-(void) dismiss{
//    [self display];
}


//凯德星商场返回在主界面
-(void)popToHome{
    [_tabBar showIndex:0];
}



-(void)setindex:(NSInteger)index{
    [_tabBar showIndex:index];
    NSLog(@"%d",index);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [currentVC viewDidAppear:animated];
}


-(void) removeRigthBtn{
    [rightButton removeFromSuperview];
    rightButton = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
//右侧搜索
-(void) addRightBtn{
}
-(void) rightBtnOnTap:(id) sender{
//    SearchViewController *saVC=[[SearchViewController alloc]init];
//    [self.navigationController pushViewController:saVC animated:YES];
    
}

//定位提示框
-(void)createLocationPrompt:(NSDictionary *)dic type:(NSString *)typeStr{
    locDic = dic;
    //定位到的商场就是用户当前的商场
    [locationCueView removeFromSuperview];
    locationCueView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    locationCueView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    CGFloat buttom_W =M_WIDTH(232);
    
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(232))/2,M_WIDTH(215),buttom_W,M_WIDTH(139))];
    buttomView.backgroundColor = [UIColor whiteColor];
    buttomView.layer.masksToBounds=YES;
    buttomView.layer.cornerRadius=10;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(32),buttom_W,M_WIDTH(20))];
    int tagType;
    if ([typeStr isEqualToString:@"0"]) {
        titleLab.text=@"您已进入距当前位置最近的商场";
        tagType=0;
    }else{
        titleLab.text=@"您已在距当前位置最近的商场";
        tagType=1;
    }
    
    titleLab.font=DESC_FONT;
    titleLab.textAlignment=NSTextAlignmentCenter;
    [buttomView addSubview:titleLab];
    
    UILabel *mallNameLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLab.frame),buttom_W,M_WIDTH(25))];
    mallNameLab.text=dic[@"mall_name"];
    [mallNameLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    mallNameLab.textAlignment=NSTextAlignmentCenter;
    [buttomView addSubview:mallNameLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(100),buttom_W,1)];
    lineView.backgroundColor=UIColorFromRGB(0x999999);
    [buttomView addSubview:lineView];
    
    UIButton *buttomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,M_WIDTH(101),buttom_W,M_WIDTH(38))];
    [buttomBtn setTitle:@"OK" forState:UIControlStateNormal];
    [buttomBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    buttomBtn.titleLabel.font=COMMON_FONT;
    buttomBtn.tag=tagType;
    [buttomBtn addTarget:self action:@selector(locationTouch:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:buttomBtn];
    
    [locationCueView addSubview:buttomView];
    [self.view addSubview:locationCueView];
    
    
}
//弹出框Ok点击事件
-(void)locationTouch:(UIButton*)sender{
    if (sender.tag==0) {
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *mall_id=[locDic valueForKey:@"mall_id"];
        [Global sharedClient].markID        = mall_id;
        [Global sharedClient].markCookies   = locDic[@"mall_id_des"];
        [Global sharedClient].markPrefix    = locDic[@"mall_url_prefix"];
        [Global sharedClient].shopName      = locDic[@"mall_name"];
        [userDefaults setObject:mall_id                    forKey:@"mall_id"];
        [userDefaults setObject:locDic[@"mall_name"]       forKey:@"mall_name"];
        [userDefaults setObject:locDic[@"mall_url_prefix"] forKey:@"mall_url_prefix"];
        [userDefaults setObject:locDic[@"mall_id_des"]     forKey:@"mall_id_des"];
        [locationCueView removeFromSuperview];
        [homeVc loadAD];
        [homeVc loadData];
    }else{
        [locationCueView removeFromSuperview];
    }
}




-(void) displayTitle{
    //设置显示标题

    if([currentVC isKindOfClass:[StoreDetailsController class]]){
        [self addRightBtn];
        self.navigationBarTitleLabel.text=@"";
        [titleView removeFromSuperview];
        self.navigationBar.hidden = YES;
        [hiddbackView removeFromSuperview];
    }else if([currentVC isKindOfClass:[IntegralController class]]){
        
        self.navigationBarTitleLabel.text=@"积分商城";
    }else if([currentVC isKindOfClass:[MineViewController class]]){
        [self addRightBtn];
       
        self.navigationBarTitleLabel.text= @"个人中心";
    }
}




-(void)bidTypeChangeOnTap:(UIButton*) sender{
    [self.popover dismiss];
}

-(void)switchViewController:(MyNBTabController *)viewController {
    
    if (viewController ==mineVc) {
        mineVc.typeStr=@"1";
    }
//    if (viewController == intVC) {
//        [Global sharedClient].markCookies=@"";
//    }

    if(viewController == intVC || viewController == msgVC){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    if([viewController isKindOfClass:[GoodsRootController class]]){
        self.delegate.navigationController.navigationBarHidden = YES;
        GoodsRootController* vc = [[GoodsRootController alloc] init];
        vc.goodDelegata=self;
        [self.delegate.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if([viewController isKindOfClass:[MineViewController class]]){
        [self redefineBackBtn:nil];
        viewController.view.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - _tabBar.frame.size.height);
        
        //[mineVc getUserInfo];
    }else if (viewController == intVC) {  
        viewController.view.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height);
    }else{
        viewController.view.frame = CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height  - _tabBar.frame.size.height);
    }
    
    [currentVC.view removeFromSuperview ];
    [self.view insertSubview:viewController.view belowSubview:_tabBar];
    
    if (currentVC == viewController) {
        [viewController.tabBarButton addNotification:[NSDictionary dictionary]];
    }else{
        
        [currentVC.tabBarButton clearNotifications];
        
        [viewController.tabBarButton addNotification:[NSDictionary dictionary]];
        currentVC = viewController;
    }
    currentVC.delegate = self;
    [self displayTitle];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
