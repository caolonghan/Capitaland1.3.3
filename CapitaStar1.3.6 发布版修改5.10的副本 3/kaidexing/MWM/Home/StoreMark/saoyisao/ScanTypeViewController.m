//
//  ScanTypeViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/19.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "ScanTypeViewController.h"
#import "ScanBankPayController.h"
#import "ARShowViewController.h"
#import "PushTicketController.h"
#import "MalllistViewController.h"


@interface ScanTypeViewController ()
@property(nonatomic,strong)UIView *tipView;
@property (nonatomic,weak)UIViewController *currentVc;
@property (nonatomic,strong)ScanBankPayController *scanVc;

@property (nonatomic,strong)ARShowViewController *ARVc ;
@property (nonatomic,strong)PushTicketController *pushVc;
@property (nonatomic,strong)UIScrollView *bgScrollView;
@end

@implementation ScanTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self createHeadView];
    [self createView];
   
    [Global sharedClient].bindCardBackWhere = 3;
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)createHeadView
{
    self.navigationBarLine.backgroundColor = [UIColor clearColor];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBarContentView.backgroundColor = [UIColor clearColor];

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH/4, 0, WIN_WIDTH/2, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [self.navigationBarContentView addSubview:titleView];
    NSArray *titleArray = [NSArray arrayWithObjects:@"扫一扫",@"拍摄小票",@"AR找一找", nil];
    for (NSInteger i=0; i<titleArray.count; i++) {
        UIButton *scanBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*WIN_WIDTH/6, 0, WIN_WIDTH/6, 42)];
        scanBtn.tag = 1000+i;
      
        scanBtn.titleLabel.font = [UIFont systemFontOfSize:M_WIDTH(12)];
        [scanBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(clickToScan:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            scanBtn.selected = YES;
         
        }
        [titleView addSubview:scanBtn];
    }
    _tipView = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.height-4, WIN_WIDTH/6, 2)];
    _tipView.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:_tipView];
}


- (void)createView
{
    
    _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,-STATUS_BAR_HEIGHT, WIN_WIDTH, WIN_HEIGHT+2*STATUS_BAR_HEIGHT)];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:_bgScrollView];
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.bounces = NO;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.scrollEnabled = NO;
   _scanVc = [[ScanBankPayController alloc]init];
   [self addChildViewController:_scanVc];
    _scanVc.view.frame = CGRectMake(0, 0, WIN_WIDTH, _bgScrollView.height);
    [_bgScrollView addSubview:_scanVc.view];
   
    _bgScrollView.contentSize = CGSizeMake(WIN_WIDTH*3, WIN_HEIGHT);
}
- (void)clickToScan:(UIButton *)sender
{
    [_pushVc removeFromParentViewController];
    [_pushVc.view removeFromSuperview];
    [_ARVc removeFromParentViewController];
    [_ARVc.view removeFromSuperview];
    [_scanVc removeFromParentViewController];
    [_scanVc.view removeFromSuperview];
     self.pushVc = nil ;
    self.scanVc = nil;
    self.ARVc =nil;
    for (NSInteger i=0; i<3; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:1000+i];
        if (i==sender.tag-1000) {
           
            btn.selected = YES;
      
        }else{
             
            btn.selected = NO;
          
        }
    }
    NSInteger tag = sender.tag-1000;
    [UIView animateWithDuration:0.5 animations:^{
        _tipView.frame = CGRectMake(WIN_WIDTH/6*tag, 40, WIN_WIDTH/6, 2);
    }];
    
    _bgScrollView.contentOffset = CGPointMake(WIN_WIDTH*tag, 0);
    if (tag==0) {
        
        _scanVc = [[ScanBankPayController alloc]init];
        [self addChildViewController:_scanVc];
        _scanVc.view.frame = CGRectMake(0,STATUS_BAR_HEIGHT, WIN_WIDTH, _bgScrollView.height);
         [_bgScrollView addSubview:_scanVc.view];
        [[[UIApplication sharedApplication].keyWindow viewWithTag:1233] removeFromSuperview];
      
    }else if (tag ==1) {
        [Global sharedClient].isHomePush = NO;
         _pushVc = [[PushTicketController alloc]init];
         [self addChildViewController:_pushVc];
        _pushVc.view.frame = CGRectMake(WIN_WIDTH, STATUS_BAR_HEIGHT, WIN_WIDTH, _bgScrollView.height);
         [_bgScrollView addSubview:_pushVc.view];
       
    }else
    {
         [Global sharedClient].isHomePush = NO;
         [[[UIApplication sharedApplication].keyWindow viewWithTag:1233] removeFromSuperview];
        [self ARPopShow];
//        _ARVc = [[ARShowViewController alloc]init];
//       _ARVc.member_id = [Global sharedClient].member_id;
//       _ARVc.mall_id = [Global sharedClient].markID;
//         [self addChildViewController:_ARVc];
//         _ARVc.view.frame = CGRectMake(2*WIN_WIDTH,20, WIN_WIDTH, _bgScrollView.height);
//         [_bgScrollView addSubview:_ARVc.view];
      
    }
    
    
}
- (void)ARPopShow
{
    NSArray *idArray = [NSArray arrayWithObjects:@"61",@"60",@"59",@"58",@"55",@"54",@"52",@"51",@"49",@"46",@"45",@"44",@"43",@"42",@"27",@"26",@"22",@"21",@"20",@"41",@"76",@"75",@"74",@"72",@"71",@"70",@"57",@"79",@"77",@"73",@"68",@"66",@"65",@"62",@"47",@"38",@"29",@"12",@"10", nil];
    
    for (int i=0; i<idArray.count; i++) {
        
        if ([Global sharedClient].markID.integerValue ==[idArray[i] intValue] ) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此商场不参与AR互动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
    }
   
    NSString *str = [NSString stringWithFormat:@"1月20日-2月25日要不要进入%@，来一场精灵奇幻之旅？赢取新春大奖（参与项目详见店内信息）",[Global sharedClient].shopName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        MalllistViewController *vc = [[MalllistViewController alloc]init];
        vc.type = 1;
        vc.getInAR = ^{
            
//            ARShowViewController *vc = [[ARShowViewController alloc] init];
//            vc.member_id = [Global sharedClient].member_id;
//            vc.mall_id = [Global sharedClient].markID;
//            vc.modalPresentationCapturesStatusBarAppearance = YES;
//                        [self.navigationController presentViewController:vc animated:YES completion:^{
//
//                        }];
            
            _ARVc = [[ARShowViewController alloc]init];
            _ARVc.member_id = [Global sharedClient].member_id;
            _ARVc.mall_id = [Global sharedClient].markID;
            _ARVc.modalPresentationCapturesStatusBarAppearance = YES;
            [self addChildViewController:_ARVc];
            _ARVc.view.frame = CGRectMake(2*WIN_WIDTH,STATUS_BAR_HEIGHT, WIN_WIDTH, _bgScrollView.height);
            [_bgScrollView addSubview:_ARVc.view];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //        ARShowViewController *vc = [[ARShowViewController alloc] init];
        //        vc.member_id = [Global sharedClient].member_id;
        //        vc.mall_id = [Global sharedClient].markID;
        //        vc.preloadID = KPreLoadId;
        //        [vc preloadApp:vc.preloadID];
        //        [self.delegate.navigationController pushViewController:vc animated:YES];
        //vc.modalPresentationCapturesStatusBarAppearance = YES;
        //[self.navigationController presentViewController:vc animated:YES completion:^{
        
        //         }];
                _ARVc = [[ARShowViewController alloc]init];
               _ARVc.member_id = [Global sharedClient].member_id;
               _ARVc.mall_id = [Global sharedClient].markID;
        _ARVc.modalPresentationCapturesStatusBarAppearance = YES;
                 [self addChildViewController:_ARVc];
                 _ARVc.view.frame = CGRectMake(2*WIN_WIDTH,20, WIN_WIDTH, _bgScrollView.height);
                 [_bgScrollView addSubview:_ARVc.view];
        
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
