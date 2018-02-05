//
//  CreameVC.m
//  WXCustomCamera
//
//  Created by macvivi on 17/4/2.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "CreameVC.h"
#import "WXCamerasViewViewController.h"


@interface CreameVC ()

@end

@implementation CreameVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationBarTitleLabel.text = @"刷脸门禁";
     self.navigationBar.hidden = YES;
    
    _Creame.layer.masksToBounds = YES;
    _Creame.layer.cornerRadius = 5;
}


- (IBAction)Creame:(id)sender {
    
    WXCamerasViewViewController *vv = [[WXCamerasViewViewController alloc]init];
    [self.delegate.navigationController pushViewController:vv animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
