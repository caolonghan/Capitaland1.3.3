//
//  ScanViewController.h
//  kaidexing
//
//  Created by dwolf on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface ScanViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)onScanTouch:(id)sender;

@end
