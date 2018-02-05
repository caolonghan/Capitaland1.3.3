//
//  ChoiceMarketController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/11/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ChoiceMarketController.h"

@interface ChoiceMarketController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIScrollView  *laftScrollView;
@property (strong,nonatomic)UIScrollView  *rightScrollView;

@end

@implementation ChoiceMarketController{
    UIButton *seBtn;
    int       indexTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self createLaftView];
    
}

-(void)createLaftView{
    _laftScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,M_WIDTH(85),WIN_HEIGHT)];
    _laftScrollView.delegate=self;
    _laftScrollView.backgroundColor=[UIColor clearColor];
    
    indexTag=0;
    for (int i=0; i<6; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,i*M_WIDTH(48),M_WIDTH(85),M_WIDTH(48))];
        btn.layer.borderColor=COLOR_LINE.CGColor;
        btn.layer.borderWidth=0.5;
        [btn setTitle:@"华东区" forState:UIControlStateNormal];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xf15152) forState:UIControlStateSelected];
        btn.titleLabel.font=DESC_FONT;
        btn.tag=i;
        if (i==0) {
            btn.selected=YES;
            seBtn=btn;
        }
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.laftScrollView addSubview:btn];
    }
    
    [self.view addSubview:_laftScrollView];    
}




-(void)btnAction:(UIButton*)sender{
    if (seBtn != nil) {
        seBtn.selected = NO;
        seBtn.backgroundColor=[UIColor whiteColor];
        seBtn.layer.borderColor=COLOR_LINE.CGColor;
        [seBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    sender.backgroundColor=[UIColor clearColor];
    sender.layer.borderColor=[UIColor clearColor].CGColor;
    [sender setTitleColor:UIColorFromRGB(0xf15152) forState:UIControlStateNormal];

    sender.enabled=YES;
    seBtn=sender;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
