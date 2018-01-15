//
//  BaseViewController.m
//  IJoyLife
//
//  Created by Hwang Kunee on 13-7-28.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "BaseViewController.h"
#import "Global.h"
#import "LoginViewController.h"
#import "PhoneInputViewController.h"
#import "SetInViewController.h"
#import "GoViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController{
    @private
    int jpushCount;
    BOOL homeBackBtnSelected;
    CGRect menuContainerFrame;
    CGRect keyContainerFrame;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    self.stillAnimatingTransition = YES;
    if(!_delegate){
        _delegate = self;
    }
    if (IS_IOS_7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }


    [self redefineBackBtn];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setHidesBottomBarWhenPushed:YES];
}

- (void)setNavigationBarcolor:(UIColor *)color
{
    self.navigationBar.backgroundColor = color;
}
//创建自己的导航条，隐藏系统样式
-(void)initNavigationBar{
    [self.delegate.navigationController.navigationBar setHidden:YES];
    [self.delegate.navigationController.navigationBar setTranslucent:YES];
    
    if(_navigationBar != nil){
        //return;
    }
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, NAV_HEIGHT)];
    [_navigationBar setBackgroundColor:APP_NAV_COLOR];
    _navigationBarContentView = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, _navigationBar.frame.size.width, 44)];
    
    _navigationBarContentView.tag = NAVIGATION_BAR_CONTENT_VIEW;
    [_navigationBar addSubview:_navigationBarContentView];
    
    _leftBarItemView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44,44)];
    _leftBarItemView.tag = NAVIGATION_BAR_LEFT_ITEM;
    [_navigationBarContentView addSubview:_leftBarItemView];
    
    _rigth_laft_BarItemView =[[UIView alloc]initWithFrame:CGRectMake(_navigationBarContentView.frame.size.width-88,0, 44, 44)];
    _rigth_laft_BarItemView.tag = NAVIGATION_BAR_RIGHT_laft_ITEM;
    [_navigationBarContentView addSubview:_rigth_laft_BarItemView];
    
    _rigthBarItemView =  [[UIView alloc] initWithFrame:CGRectMake(_navigationBarContentView.frame.size.width - 44, 0, 44,44)];
    _rigthBarItemView.tag = NAVIGATION_BAR_RIGHT_ITEM;
    [_navigationBarContentView addSubview:_rigthBarItemView];
    
    UIView* _centerView =  [[UIView alloc] initWithFrame:CGRectMake(44, 0, _navigationBarContentView.frame.size.width - 88,44)];
    _centerView.tag = NAVIGATION_BAR_CENTER_ITEM;
    [_navigationBarContentView addSubview:_centerView];
    
    _navigationBarLine = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBar.frame.size.height - 1, _navigationBar.frame.size.width, 1)];
    [_navigationBarLine setBackgroundColor:APP_NAV_LINE_COLOR];
    [_navigationBar addSubview:_navigationBarLine];
    
 
    
    if (![Util isNull:_nvcImgView]) {
        if ([_nvcImgView containsString:@","]) {
            NSArray *titleAry=  [_nvcImgView componentsSeparatedByString:@","];
            
            UIImageView *navBarTitleImg=[[UIImageView alloc]init];
            navBarTitleImg.contentMode=UIViewContentModeScaleAspectFit;
            CGRect rect1=[titleAry[0] boundingRectWithSize:CGSizeMake(_centerView.frame.size.width - 20,_centerView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:NAV_FONT} context:nil];
            
            CGFloat lab_laft_W=(_centerView.frame.size.width-50-rect1.size.width)/2;
            navBarTitleImg.frame=CGRectMake(lab_laft_W+5,7,44,44);
            navBarTitleImg.contentMode=UIViewContentModeScaleAspectFit;
            [navBarTitleImg setImage:[UIImage imageNamed:titleAry[1]]];
            [_centerView addSubview:navBarTitleImg];
            
            //中部标题
            _navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(navBarTitleImg.frame), 0,_centerView.frame.size.width-75-lab_laft_W, _centerView.frame.size.height)];
            [_navigationBarTitleLabel setTextAlignment:NSTextAlignmentLeft];
            [_navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
            [_navigationBarTitleLabel setTextColor:APP_NAV_TITLE_COLOR];
            _navigationBarTitleLabel.font = NAV_FONT;
            _navigationBarTitleLabel.text=titleAry[0];
            [_centerView addSubview:_navigationBarTitleLabel];
            
        }else{
            //中部标题
            _navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _centerView.frame.size.width - 20, _centerView.frame.size.height)];
            [_navigationBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
            [_navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
            [_navigationBarTitleLabel setTextColor:APP_NAV_TITLE_COLOR];
            _navigationBarTitleLabel.font = NAV_FONT;
            _navigationBarTitleLabel.text =_nvcImgView;
            [_centerView addSubview:_navigationBarTitleLabel];
        }
       
    }else{
        
        //中部标题
        _navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _centerView.frame.size.width, _centerView.frame.size.height)];
        [_navigationBarTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [_navigationBarTitleLabel setBackgroundColor:[UIColor clearColor]];
        [_navigationBarTitleLabel setTextColor:APP_NAV_TITLE_COLOR];
        _navigationBarTitleLabel.font = NAV_FONT;
        [_centerView addSubview:_navigationBarTitleLabel];

    }
    
    
    //右侧隐藏
    [_rigth_laft_BarItemView setHidden:YES];
    [_rigthBarItemView setHidden:YES];
    
    [self.view addSubview:_navigationBar];
}

-(void)redefineBackBtn:(UIImage*) image :(CGRect)rect{
    
//    if(YES){
//        //屏蔽老代码
//        return;
//    }
    UIButton* backButton;
    if ([_leftBarItemView subviews].count!=0) {
        backButton = [[_leftBarItemView subviews]firstObject];
    }else{
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    [backButton setFrame:rect];
    if(image){
        [backButton setImage:image forState:UIControlStateNormal];
    }
    [backButton addTarget:self action:@selector(backBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backItem;
    [_leftBarItemView addSubview:backButton];
//    if(IS_IOS_7){
//        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }else{
//        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
//    }
}
-(void)redefineBackBtn:(UIImage*) image
{
        if(YES){
            //屏蔽老代码
            return;
        }
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 44,44)];
    if(image){
        [backButton setImage:image forState:UIControlStateNormal];
    }
    [backButton addTarget:self action:@selector(backBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    
        if(IS_IOS_7){
            [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
            self.automaticallyAdjustsScrollViewInsets = NO;
        }else{
            [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        }
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"newback"] :CGRectMake(0, 0, 44,44)];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)performAlertMsg:(NSString*) msg{
    if([msg rangeOfString:@"NSURLErrorDomain"].location != NSNotFound){
        msg = @"网络连接失败";
    }
    if([msg isEqualToString:@"(null)"]){
        msg = @"请求异常,请稍后重试";
    }
    [SVProgressHUD showErrorWithStatus:msg duration:MSG_DISMISS_DURATION];
     
}

//加载loading
//[self loadimging:self.view cg:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-57-45)];
//[self removeloadimging:self.view.subviews];
-(void) loadimging:(UIView*) v cg:(CGRect) cg{
    
    UIActivityIndicatorView *nativeIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cg.size.width-20)/2, (cg.size.height-10)/2, 20,10 ) ];
    nativeIndicator.tag = 999;
    [nativeIndicator setColor:[UIColor grayColor]];
    [nativeIndicator startAnimating];
    [v addSubview:nativeIndicator]; 
    
}

-(void) displayMask:(UIView*) view{
    UIView* bgView = [self.view viewWithTag:MASK_TAG];
    if(bgView != nil && bgView.superview != nil){
        return;
    }
    bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.0f];
    [bgView setTag:MASK_TAG];
    [bgView setUserInteractionEnabled:YES];
    [self.view addSubview:bgView];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                            [bgView setAlpha:0.7f];
                        }completion:^(BOOL finished){
                            
                        }];
    [self.view bringSubviewToFront:view];
    
    
    UITabBarController* rootController = ((UITabBarController*)_delegate.navigationController.topViewController);
    if([rootController respondsToSelector:@selector(hideTabBar)]){
        [rootController performSelectorOnMainThread:@selector(hideTabBar) withObject:nil waitUntilDone:NO];
    }
}

//清理幕布
-(void) removeMask{
    
    UIView* bgView = [self.view viewWithTag:MASK_TAG];
    if(bgView == nil || bgView.superview == nil){
        return;
    }
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                            [bgView setAlpha:0.0f];
                        }completion:^(BOOL finished){
                            [bgView removeFromSuperview];
                        }];
    
    if(!self.hidesBottomBarWhenPushed){
        UITabBarController* rootController = ((UITabBarController*)_delegate.navigationController.topViewController);
        if([rootController respondsToSelector:@selector(showTabBar)]){
            [rootController performSelectorOnMainThread:@selector(showTabBar) withObject:nil waitUntilDone:NO];
        }
    }
}

-(void) popToViewController:(int) level{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        NSArray* viewControllers = [_delegate.navigationController viewControllers];
        if((level+1) > [viewControllers count] || level < 1){
            return;
        }
        [_delegate.navigationController popToViewController:[viewControllers objectAtIndex:[viewControllers count] - level - 1] animated:YES];
    });
}

-(void) displayLoading{
    self.isDisplayLoading = YES;
    [self loadimging:self.view cg:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
}

-(void) removeLoading{
    self.isDisplayLoading = NO;
    [self performSelectorOnMainThread:@selector(removeloadimging:) withObject:self.view.subviews waitUntilDone:NO];
    
    [SVProgressHUD dismiss];
}
-(void) removeloadimging:(NSArray *)subviews {
   
    NSInteger t=999;  
    for(id tmpView in subviews)
    { 
        if([tmpView isKindOfClass:[UIActivityIndicatorView class]])
        {
            UIActivityIndicatorView *imgView = (UIActivityIndicatorView *)tmpView;
            if( t==imgView.tag)   
            {  [imgView stopAnimating];
                [imgView removeFromSuperview];
               
                imgView=nil; 
                 
            }
        }
    }
}

- (void)backBtnOnClicked:(id)sender {
    [[[HttpClient sharedClient] operationQueue] cancelAllOperations];
    [SVProgressHUD dismiss];
    [_delegate.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidUnload{
    
    [super viewDidUnload];
    
}

-(void) showMsg:(NSString*) msg{
    if([NSThread isMainThread]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performAlertMsg:msg];
        });
        
    }else{
        [self performSelectorOnMainThread:@selector(performAlertMsg:) withObject:msg waitUntilDone:NO];
    }
}

-(void)displayError:(NSString*) msg{
    NSLog(@"error:%@",msg);
    [SVProgressHUD showErrorWithStatus:msg duration:MSG_DISMISS_DURATION];
}

-(void) showMsg:(NSString *)msg afterOK:(void (^)(void)) afterOK{
    dispatch_async(dispatch_get_main_queue(), ^{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:msg];
        [alertView addButtonWithTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  afterOK();
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [alertView show];
    });
}

-(void) confirm:(NSString*) msg okBtnTitle:(NSString*) okBtnTitle afterOK:(void (^)(void)) afterOK afterCancel:(void (^)(void)) afterCancel{
    dispatch_async(dispatch_get_main_queue(), ^{
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:msg];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  if(afterCancel){
                                      afterCancel();
                                  }
                              }];
        [alertView addButtonWithTitle:okBtnTitle != nil?okBtnTitle:@"确定"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  afterOK();
                              }];
        alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
        alertView.backgroundStyle = SIAlertViewBackgroundStyleSolid;
        [alertView show];
    });
}

-(void) confirm:(NSString*) msg afterOK:(void (^)(void)) afterOK{
    [self confirm:msg okBtnTitle:nil afterOK:afterOK afterCancel:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if(!self.keyboardContainer){
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.keyboardContainer.frame;
        
        frame.size.height = keyContainerFrame.size.height - keyboardBounds.size.height;
        
        self.keyboardContainer.frame = frame;
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if(!self.keyboardContainer){
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    NSValue *keyboardBoundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.keyboardContainer.frame;
        
        frame.size.height = keyContainerFrame.size.height - keyboardBounds.size.height;
        
        self.keyboardContainer.frame = frame;
    }];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    if(!self.keyboardContainer){
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.keyboardContainer.frame;
        
        frame.size.height = keyContainerFrame.size.height;
        self.keyboardContainer.frame = frame;
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_navigationBar];
    self.stillAnimatingTransition = YES;
    if([Global sharedClient].action){
        NSLog(@"[Global sharedClient].action = %@",[Global sharedClient].action);
    }
    if(self.keyboardContainer){
        keyContainerFrame = self.keyboardContainer.frame;
    }
    

    if(self.keyboardContainer){
        //监视键盘变化事件，界面消失后取消监视
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    //[self.delegate.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [JPUSHService cancelPreviousPerformRequestsWithTarget:self];
    
    if(self.keyboardContainer){
        //取消监视
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    }
    //退出时退出所有的请求
     NSArray *viewControllers = _delegate.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound){
        [SVProgressHUD dismiss];
        [[[HttpClient sharedClient] operationQueue] cancelAllOperations];
    }
    
    [Global sharedClient].homeBtnHidden = YES;
    
}




-(BOOL)checkLogin{
    if([Global sharedClient].token == nil || [[Global sharedClient].token isEqualToString:@""]){
        while (YES) {
                NSLog(@"checkLogin stillAnimatingTransition=%@",self.stillAnimatingTransition?@"YES":@"NO");
            if(!self.stillAnimatingTransition){
                dispatch_async(dispatch_get_main_queue(), ^{
                  
//                    [self confirm:@"请登录后再执行该操作" afterOK:^{
//                        LoginViewController* vc = [[LoginViewController alloc] init];
//                        [self presentViewController:vc animated:YES completion:^{
//                            
//                        }];
//                    }];
                    
                });
                return NO;
            }
            sleep(0.1f);
        }
        return NO;
    }
    return YES;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.stillAnimatingTransition = NO;
    NSLog(@"stillAnimatingTransition=%@",self.stillAnimatingTransition?@"YES":@"NO");
    NSString* sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:@"sessionId"];
    if(sessionId == nil){
        sessionId = [Global sharedClient].sessionId;
    }
    [[Global sharedClient] tagsAliasCallback:-1 tags:JPUSH_TAGS alias:sessionId];
    
}


-(void)toggleMenu:(int) hidden{
    UIView* menuContainer = [self.view viewWithTag:HOME_MENU] ;
    if(hidden != 0){
        if(hidden == 1 && (menuContainer == nil || menuContainer.hidden)){
            return;
        }
        if(hidden == -1 && menuContainer && !menuContainer.hidden){
            return;
        }
    }
    
    if(menuContainer && !menuContainer.hidden){
        [self removeMask];
        [UIView animateWithDuration:0.2f animations:^{
            menuContainer.alpha = 0.0f;
            menuContainer.transform = CGAffineTransformMakeScale(0.01,0.01);
        } completion:^(BOOL finished) {
            [menuContainer setHidden:YES];
        }];
        return;
    }
    if(menuContainer == nil){
        float viewWidth = 246;
        menuContainerFrame = CGRectMake(self.view.center.x - viewWidth/2, self.view.center.y - viewWidth/2, viewWidth, viewWidth);
        UIView* menuContainer = [[UIView alloc] initWithFrame:menuContainerFrame];
        [menuContainer setAutoresizesSubviews:YES];
        [self.view addSubview:menuContainer];
        
        menuContainer.tag = HOME_MENU;
        menuContainer.hidden = YES;
        
        UIView* bgView = [[UIView alloc] initWithFrame:menuContainer.bounds];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView setAlpha:0.5];
        [bgView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [bgView.layer setCornerRadius:bgView.frame.size.width/2];
        [menuContainer addSubview:bgView];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.origin.x + 4, bgView.frame.origin.y + 4, bgView.frame.size.width - 8, bgView.frame.size.width - 8)];
        [bgView setBackgroundColor:DEFAULT_MAIN_COLOR];
        [bgView setAlpha:0.72f];
        [bgView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [bgView.layer setCornerRadius:bgView.frame.size.width/2];
        [menuContainer addSubview:bgView];
        
        float centerBgWidth = 88;
        UIView* centerBg = [[UIView alloc] initWithFrame:CGRectMake((menuContainer.bounds.size.width - centerBgWidth)/2, (menuContainer.bounds.size.width - centerBgWidth)/2, centerBgWidth, centerBgWidth)];
        [centerBg setBackgroundColor:[UIColor whiteColor]];
        [centerBg.layer setCornerRadius:14.0f];
        [centerBg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [menuContainer addSubview:centerBg];
        
        UIView* inerCenterBg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, centerBgWidth - 10, centerBgWidth - 10)];
        [inerCenterBg setBackgroundColor:RGBCOLOR(76, 147, 235)];
        [inerCenterBg.layer setCornerRadius:9.0f];
        [inerCenterBg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [centerBg addSubview:inerCenterBg];
        
        
        float btnSpace = 80;
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((menuContainer.frame.size.width - 45)/2, (menuContainer.frame.size.height - 45)/2, 45, 45)];
        [btn setImage:[UIImage imageNamed:@"tab_invest_selected.png"] forState:UIControlStateNormal];
        btn.tag = 1;
        [menuContainer addSubview:btn];
        [btn addTarget:self action:@selector(subMenuOnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake((menuContainer.frame.size.width - 45)/2 - btnSpace, (menuContainer.frame.size.height - 45)/2, 45, 45)];
        [btn setImage:[UIImage imageNamed:@"tab_info_selected.png"] forState:UIControlStateNormal];
        btn.tag = 2;
        [menuContainer addSubview:btn];
        [btn addTarget:self action:@selector(subMenuOnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake((menuContainer.frame.size.width - 45)/2 + btnSpace, (menuContainer.frame.size.height - 45)/2, 45, 45)];
        [btn setImage:[UIImage imageNamed:@"tab_discover_selected.png"] forState:UIControlStateNormal];
        btn.tag = 3;
        [menuContainer addSubview:btn];
        [btn addTarget:self action:@selector(subMenuOnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake((menuContainer.frame.size.width - 45)/2, (menuContainer.frame.size.height - 45)/2 - btnSpace, 45, 45)];
        [btn setImage:[UIImage imageNamed:@"tab_mall_selected.png"] forState:UIControlStateNormal];
        btn.tag = 4;
        [menuContainer addSubview:btn];
        [btn addTarget:self action:@selector(subMenuOnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake((menuContainer.frame.size.width - 45)/2, (menuContainer.frame.size.height - 45)/2 + btnSpace, 45, 45)];
        [btn setImage:[UIImage imageNamed:@"tab_mine_selected.png"] forState:UIControlStateNormal];
        btn.tag = 5;
        [menuContainer addSubview:btn];
        [btn addTarget:self action:@selector(subMenuOnTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    menuContainer = [self.view viewWithTag:HOME_MENU];
    menuContainer.transform = CGAffineTransformMakeScale(0.01,0.01);
    menuContainer.alpha = 0.0f;
    menuContainer.hidden = NO;
    
    [self displayMask:menuContainer];
    
    UITapGestureRecognizer* homeMenuMaskOnTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homeMenuMaskOnTap:)];
    [[self.view viewWithTag:MASK_TAG] addGestureRecognizer:homeMenuMaskOnTap];
    
    [Util playSound:@"pop.wav"];
    [UIView animateWithDuration:0.4f animations:^{
        menuContainer.alpha = 1.0f;
        menuContainer.transform = CGAffineTransformMakeScale(1.1,1.1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1f animations:^{
            menuContainer.transform = CGAffineTransformMakeScale(1.0,1.0);
        } completion:^(BOOL finished) {}];
    }];
}

-(void)subMenuOnTap:(UIButton*) sender{
    if(sender.tag == 3 || sender.tag == 5){
        if(![[Global sharedClient] isLogin]){
                       return;
        }
    }
    [Global sharedClient].syncObj = [NSString stringWithFormat:@"%d",sender.tag];
    [_delegate.navigationController popToRootViewControllerAnimated:YES];
}

-(void)homeMenuMaskOnTap:(UITapGestureRecognizer*) recognizer{
    [self toggleMenu:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
    }
    //NSLog(@"didReceiveMemoryWarning:%@",self);
}


-(BOOL)isSignIn{
    if ([Util isNull:[Global sharedClient].member_id]) {
        LoginViewController *lVC=[[LoginViewController alloc]init];
//         SetInViewController *lVC=[[SetInViewController alloc]init];
        [self.delegate.navigationController pushViewController:lVC animated:YES];
        return false;
    }
    return true;
}

-(void)signInData:(NSDictionary *)dataDic password:(NSString *)pd{
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    if (pd != nil) {
//        [userDefaults setValue:pd forKey:@"passWord"];
//    }
    [JPUSHService setAlias:dataDic[@"id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:0];
    [Global sharedClient].member_id = dataDic[@"id"];
    [userDefaults setValue:dataDic[@"id"] forKey:@"member_id"];
    
    [Global sharedClient].img_url = dataDic[@"img_url"];
    [userDefaults setValue:dataDic[@"img_url"] forKey:@"img_url"];
    
    [Global sharedClient].nick_name = dataDic[@"nick_name"];
    [userDefaults setValue:dataDic[@"nick_name"] forKey:@"nick_name"];
    
    [Global sharedClient].phone = dataDic[@"phone"];
    [userDefaults setValue:dataDic[@"phone"] forKey:@"phone"];
    [Global sharedClient].isoffice = dataDic[@"is_office"];
    [userDefaults setValue:dataDic[@"is_office"] forKey:@"isoffice"];
    
    NSMutableArray * xjf_kq_xx = [[NSMutableArray alloc] init];
    [xjf_kq_xx addObject:dataDic[@"integralcount"]];
    [xjf_kq_xx addObject:dataDic[@"couponcount"]];
    [xjf_kq_xx addObject:dataDic[@"message"]];
    [Global sharedClient].sessionId  = dataDic[@"member_id_des"];
    [userDefaults setValue:dataDic[@"member_id_des"] forKey:@"sessionId"];
    [Global sharedClient].userCookies = dataDic[@"member_id_des"];
    [userDefaults setValue:dataDic[@"member_id_des"] forKey:@"userCookies"];
    
    [Global sharedClient].isSend = dataDic[@"is_send"];
    [userDefaults setValue:dataDic[@"is_send"] forKey:@"is_send"];
    
    [Global sharedClient].xjf_Cq_Xx = xjf_kq_xx;
    [userDefaults setValue:xjf_kq_xx forKey:@"xjf_kq_xx"];
    
}
//返回广告页
- (void)backToAdv
{
   
    if ([[Global sharedClient].advUrlStr rangeOfString:@"is_adv"].location!=NSNotFound&&![Util isNull:[Global sharedClient].advUrlStr]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GoViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        
    }
    else{
        [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
@end
