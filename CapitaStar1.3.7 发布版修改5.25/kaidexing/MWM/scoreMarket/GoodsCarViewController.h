//
//  GoodsDetailViewController.h
//  kaidexing
//
//  Created by dwolf on 16/5/13.
//  Copyright (c) 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "MyNBTabController.h"

@interface GoodsCarViewController : MyNBTabController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* path;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end
