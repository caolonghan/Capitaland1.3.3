//
//  MarketRootController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "GoodsRootController.h"
#import "MyNBTabController.h"
#import "MyNBTabButton.h"
#import "GoodsDetailViewController.h"
#import "SYWebViewViewController.h"
#import "MineViewController.h"
#import "GoViewController.h"
#import "LineUpHomeController.h"
#import "StoreDetailsController.h"
//#import "IntegralController.h"
//#import "ShopingCartController.h"
#import "GoodsCarViewController.h"

@interface GoodsRootController ()<MyNBTabBarDelegate>
{
    UISearchBar *searchBar;
    UIView *auxiliaryView;
}
@end

@implementation GoodsRootController
{

    UIView* titleView;
    UILabel* titleLabel;
    UIButton* rightButton;
    GoodsDetailViewController         *mallVc;
    GoodsCarViewController     *gwcVc;
    MineViewController     *mineViewCtrl;
    CGFloat    _tabbarHeight;
    UIView* popoverContentView;
    BOOL goBack;
    
}

@synthesize currentVC;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    
    
    if (WIN_HEIGHT==812.0f) {
        _tabbarHeight = 34.0f;
    }else
    {
        _tabbarHeight = 0;
    }
    self.tabBar=[[MyNBTabBar alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT-45-_tabbarHeight, WIN_WIDTH, 45)];
    [self.view addSubview:self.tabBar];
    self.view.backgroundColor=[UIColor whiteColor];

    
    //绑定事件
    self.view.backgroundColor = [UIColor grayColor];
    
    mallVc = [[GoodsDetailViewController alloc] init];
    mallVc.delegate = self;
    mallVc.view.tag = CURRE_SELECTED_TABBAR_2;
    
    
    gwcVc  = [[GoodsCarViewController alloc] init];
    gwcVc.delegate  =self;
    gwcVc.view.tag = CURRE_SELECTED_TABBAR_3;
    
    mineViewCtrl = [[MineViewController alloc] init];
    mineViewCtrl.delegate = self;
    
   // [_container addSubview:homeVc.view];
    
    MyNBTabButton *homeBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"goodfanhui"]];
    
    homeBtn.highlightedIcon = [UIImage imageNamed:@"goodfanhui"];
    homeBtn.viewController = nil;
    
    MyNBTabButton *mineBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"newkaidebarblack"]];
    mineBtn.highlightedIcon = [UIImage imageNamed:@"newkaidebar"];
    mineBtn.viewController = mallVc;
    
    MyNBTabButton *findBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"goodcar"]];
    findBtn.highlightedIcon = [UIImage imageNamed:@"goodcarL"];
    findBtn.viewController = gwcVc;
    
    
    MyNBTabButton *myBtn =[[MyNBTabButton alloc]initWithIcon:[UIImage imageNamed:@"goodmin"]];
    myBtn.highlightedIcon =[UIImage imageNamed:@"goodminL"];
    myBtn.viewController = mineViewCtrl;
    
    NSArray *a = [NSArray arrayWithObjects:homeBtn,mineBtn,findBtn,myBtn,nil];
    [_tabBar initWithItemsNoFrame:a];
    _tabBar.delegate = self;
    [_tabBar showIndex:1];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.delegate.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    
    if ([currentVC isKindOfClass:[GoodsDetailViewController class]]) {
       [self.navigationController setNavigationBarHidden:YES];
    }else{
    
        [self.navigationController setNavigationBarHidden:YES];
     }
    [currentVC viewWillAppear:animated];
    
    self.navigationController.navigationItem.rightBarButtonItem = nil;
    
    [self displayTitle];
    
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


-(void) displayTitle{
    //设置显示标题
    [self removeRigthBtn];
    if([currentVC isKindOfClass:[StoreDetailsController class]]){
        
    }else if([currentVC isKindOfClass:[GoodsDetailViewController class]]){
        
        self.navigationBarTitleLabel.text= @"积分商城";
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else if([currentVC isKindOfClass:[GoodsCarViewController class]]){
        
        self.navigationBarTitleLabel.text=@"购物车";
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else if([currentVC isKindOfClass:[MineViewController class]]){
        
        self.navigationBarTitleLabel.text=@"个人中心";
    }
}

-(void)afterTouchUp{
    if(goBack){
        goBack = false;
        int tag = currentVC.view.tag;
        [_tabBar showIndex:(tag - 20000)];
    }
}

-(void)switchViewController:(MyNBTabController *)viewController {
    if(viewController == nil){
        if (_goodDelegata && [_goodDelegata respondsToSelector:@selector(popToHome)]) {
            [_goodDelegata popToHome];
            [self.delegate.navigationController popViewControllerAnimated:YES];
        }else{
            [self.delegate.navigationController popViewControllerAnimated:YES];
        }
    }
    if (viewController==mallVc) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    
    if(viewController == gwcVc){
        if(![self isSignIn]){
            goBack = true;
            return;
        }
    }

    viewController.view.frame = CGRectMake(0,0,SCREEN_FRAME.size.width,SCREEN_FRAME.size.height - _tabBar.frame.size.height);
    [self.navigationController setNavigationBarHidden:YES];

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
    
    if ([currentVC isKindOfClass:[GoodsDetailViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES];
    }else{
        if([currentVC isKindOfClass:[MineViewController class]]){
            [self isSignIn];
        }
        
        [self.navigationController setNavigationBarHidden:YES];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    auxiliaryView.hidden=YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
