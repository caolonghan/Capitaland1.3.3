//
//  BaseWebViewController.h
//  kaidexing
//
//  Created by dwolf on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseWebViewController : BaseViewController

@property (strong,nonatomic)  UIWebView *webView;
-(void) loadHtmlByPath:(NSString*) path;
@end
