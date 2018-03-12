//
//  MarketRootController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MarketRootController.h"
#import "MyNBTabController.h"
#import "MyNBTabButton.h"
#import "ActivityController.h"
#import "SYWebViewViewController.h"
#import "StoreDetailsController.h"
#import "IntegralController.h"
#import "MineViewController.h"
#import "GoViewController.h"
#import "LineUpHomeController.h"
#import "GoodsRootController.h"


@interface MarketRootController ()<MyNBTabBarDelegate>
{
    UISearchBar *searchBar;
    UIView *auxiliaryView;
}
@end

@implementation MarketRootController{

    UIView* titleView;
    UILabel* titleLabel;
    UIButton* rightButton;
    StoreDetailsController *homeVc;
    ActivityController     *mineVc;
    GoodsRootController     *intVC;
    MineViewController     *mineViewCtrl;
    BOOL                   off_on;//点击发现
    
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
    
    off_on=NO;
    self.tabBar=[[MyNBTabBar alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT-45, WIN_WIDTH, 45)];
    [self.view addSubview:self.tabBar];
    self.view.backgroundColor=[UIColor whiteColor];
    self.popover = [DXPopover new];
    
    //绑定事件
    self.view.backgroundColor = [UIColor grayColor];
    homeVc = [[StoreDetailsController alloc] init];
    homeVc.indexDedegate=self;
    homeVc.delegate = self;
    
    mineVc = [[ActivityController alloc] init];
    mineVc.nvcImgView=@"活动,t_gift";
    mineVc.buttomH=@"1";
    mineVc.isType=@"1";
    mineVc.delegate = self;
    
    intVC = [[GoodsRootController alloc] init];
    intVC.delegate = self;
    
    mineViewCtrl = [[MineViewController alloc] init];
    mineViewCtrl.delegate = self;
    
    currentVC = homeVc;
    
    MyNBTabButton *homeBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"itme1"]];
    
    homeBtn.highlightedIcon = [UIImage imageNamed:@"itme1_r"];
    
    homeBtn.viewController = homeVc;
    
    
    MyNBTabButton *mineBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"item2"]];
    mineBtn.highlightedIcon = [UIImage imageNamed:@"item2_r"];
    mineBtn.viewController = mineVc;
    
    
    MyNBTabButton *findBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"item3"]];
    findBtn.highlightedIcon = [UIImage imageNamed:@"item3_r"];
    findBtn.viewController = nil;
    
    MyNBTabButton *intBtn = [[MyNBTabButton alloc] initWithIcon:[UIImage imageNamed:@"item4"]];
    intBtn.highlightedIcon = [UIImage imageNamed:@"item4_r"];
    intBtn.viewController  = intVC;
    intBtn.noDown = true;
    
    MyNBTabButton *myBtn =[[MyNBTabButton alloc]initWithIcon:[UIImage imageNamed:@"grey_mine"]];
    myBtn.highlightedIcon =[UIImage imageNamed:@"red_mine"];
    myBtn.viewController = mineViewCtrl;
    
    NSArray *a = [NSArray arrayWithObjects:homeBtn,mineBtn,findBtn,intBtn,myBtn,nil];
    [_tabBar initWithItemsNoFrame:a];
    _tabBar.delegate = self;
    [_tabBar showIndex:0];
    
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [currentVC viewWillAppear:animated];
    self.navigationController.navigationItem.rightBarButtonItem = nil;
    [self displayTitle];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [currentVC viewDidAppear:animated];
    if ([currentVC isKindOfClass:[homeVc class]]) {
        NSLog(@"homeVC");
    }
}


-(void) removeRigthBtn{
    [rightButton removeFromSuperview];
    rightButton = nil;
    self.navigationItem.rightBarButtonItem = nil;
}


-(void) displayTitle{
    //设置显示标题
   // [self removeRigthBtn];
    if([currentVC isKindOfClass:[StoreDetailsController class]]){
        self.navigationBarTitleLabel.text=@" ";
        return;
        
    }else if([currentVC isKindOfClass:[ActivityController class]]){
        
        
        
    }else if([currentVC isKindOfClass:[IntegralController class]]){
        
        self.navigationBarTitleLabel.text=@"积分商城";
    }else if([currentVC isKindOfClass:[MineViewController class]]){
        
        self.navigationBarTitleLabel.text=@"个人中心";
    }
}

-(void)bidTypeChangeOnTap:(UIButton*) sender{
    
    [self.popover dismiss];
}

-(void)switchViewController:(MyNBTabController *)viewController {
    
    
    if(viewController ==nil)
    {
        if (off_on==NO) {
            off_on=YES;
            [self initAuxiliary];
            
        }else {
            off_on=NO;
            [auxiliaryView removeFromSuperview];
        }
        return;
    }
    [auxiliaryView removeFromSuperview];
    
    if([viewController isKindOfClass:[GoodsRootController class]]){
        self.delegate.navigationController.navigationBarHidden = YES;
        GoodsRootController* vc = [[GoodsRootController alloc] init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        return;
    }

        viewController.view.frame = CGRectMake(0,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - _tabBar.frame.size.height);
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
    
    if ([currentVC isKindOfClass:[StoreDetailsController class]]) {
        self.delegate.navigationController.navigationBarHidden = YES;
        [self redefineBackBtn:nil];
        
    }else{
        self.delegate.navigationController.navigationBarHidden = YES;
        if([currentVC isKindOfClass:[MineViewController class]]){
            [self isSignIn];
        }
        
        [self redefineBackBtn];
    }
    
}

-(void)initAuxiliary{
    auxiliaryView=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-51.5, SCREEN_FRAME.size.height-286,103,241.5)];
    auxiliaryView.backgroundColor=[UIColor clearColor];
    
    UIImageView *beijingImg=[[UIImageView alloc]initWithFrame:auxiliaryView.bounds];
    [beijingImg setImage:[UIImage imageNamed:@"juxing-1"]];
    [beijingImg setUserInteractionEnabled:YES];
    
    NSArray *array=[[NSArray alloc]init];
    array=[Global sharedClient].findAry;
    NSMutableArray *titleAry=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        NSString *titleStr=[Util isNil:dic[@"name"]];
        [titleAry addObject:titleStr];
    }
    for (int i=0; i<5; i++) {
        UIButton *auxiliaryBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,15+45*i,auxiliaryView.frame.size.width, 29)];
        [auxiliaryBtn setTitle:titleAry[i] forState:UIControlStateNormal];
        auxiliaryBtn.tag=i;
        [auxiliaryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [auxiliaryBtn setTitle:titleAry[i] forState:UIControlStateNormal];
        auxiliaryBtn.titleLabel.font=COMMON_FONT;
        [auxiliaryBtn addTarget:self action:@selector(auxiliaryTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i<4) {
            UIView *lineView_x=[[UIView alloc]initWithFrame:CGRectMake(6,38,auxiliaryBtn.frame.size.width-12,1)];
            lineView_x.backgroundColor=COLOR_LINE;
            [auxiliaryBtn addSubview:lineView_x];
        }
        [beijingImg addSubview:auxiliaryBtn];
    }
    
    [auxiliaryView addSubview:beijingImg];
    [self.view addSubview:auxiliaryView];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    auxiliaryView.hidden=YES;
}
 

-(void)auxiliaryTouch:(UIButton*)sender
{
    NSArray *array=[[NSArray alloc]init];
    array=[Global sharedClient].findAry;
    NSMutableArray *titleAry=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        NSString *titleStr=[Util isNil:dic[@"link_url"]];
        [titleAry addObject:titleStr];
    }
    if (sender.tag==0) {
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = titleAry[0];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag==1) {
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = titleAry[1];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag==2) {
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = titleAry[2];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag==3) {
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = titleAry[3];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag==4) {
        
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = titleAry[4];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }
    
    [auxiliaryView removeFromSuperview];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [currentVC viewWillDisappear:YES];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [currentVC viewDidDisappear:YES];
    
}


@end
