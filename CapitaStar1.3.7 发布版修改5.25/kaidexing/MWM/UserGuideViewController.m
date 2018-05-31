//
//  UserGuideViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "UserGuideViewController.h"
#import "RootViewController.h"
#import "LuanchAdvViewController.h"

@interface UserGuideViewController ()<UIScrollViewDelegate>

@end

@implementation UserGuideViewController{
    @private
    NSArray* imgs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IOS_7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    imgs = @[@"newWellCom_1",@"newWellCom_2",@"newWellCom_3",@"newWellCom_4",@""];    
    _pageControl.numberOfPages = imgs.count-1;
    _pageControl.pageIndicatorTintColor = COLOR_LINE;
    _pageControl.currentPageIndicatorTintColor = APP_BTN_COLOR;
    self.scrollView.contentSize = CGSizeMake(imgs.count * SCREEN_FRAME.size.width, SCREEN_FRAME.size.height);
    self.scrollView.delegate = self;
    [self.scrollView setDelaysContentTouches:YES];

    for(int i = 0 ; i < imgs.count; i++){
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_FRAME.size.width,0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:imgs[i]];
        [_scrollView addSubview:imgView];
    }
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    [self.delegate.navigationController.navigationBar setHidden:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    //根据scrollView 的位置对page 的当前页赋值
    _pageControl.currentPage = current;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float scroll_x =scrollView.contentOffset.x;
    if (scroll_x>([UIScreen mainScreen].bounds.size.width*3)) {
        [self loadAdv];
        RootViewController* vc = [[RootViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        [self removeFromParentViewController];
        return;
    }
}

-(void) loadAdv{
    LuanchAdvViewController* vc = [[LuanchAdvViewController alloc] init];
    vc.adViewdelegate = self.navigationController;
    [self.navigationController presentViewController: vc animated:NO completion:nil];
}

@end
