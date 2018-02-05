//
//  SYWebViewViewController.h
//  ShouYi
//
//  Created by Hwang Kunee on 14-2-21.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "BaseViewController.h"
#import "JavaScriptAlertOfUIWebView.h"
#import "WebViewJavascriptBridge.h"

@interface SYWebViewViewController : BaseViewController
-(void)loadUrl:(NSString*) url;

@property(nonatomic,retain)NSString* webTitle;
@property(nonatomic,retain)NSString* url;
@property(nonatomic,retain)NSString* content;
@property(nonatomic,retain)UIWebView* webView;
@property(nonatomic)int donePopCount;
@property(nonatomic)BOOL needShare;
@property(nonatomic)BOOL needSizeFilt;

@end
