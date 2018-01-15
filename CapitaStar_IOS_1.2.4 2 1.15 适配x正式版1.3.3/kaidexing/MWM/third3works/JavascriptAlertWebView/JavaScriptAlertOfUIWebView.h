//
//  UIWebView_JavaScriptAlert.h
//  atp
//
//  Created by Hwang Kunee on 13-9-6.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWebView(JavaScriptAlertOfUIWebView)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame;

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame;

@end
