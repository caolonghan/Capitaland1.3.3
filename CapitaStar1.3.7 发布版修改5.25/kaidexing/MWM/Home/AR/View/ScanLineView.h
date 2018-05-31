//
//  ScanLineView.h
//  sightpDemo
//
//  Created by YangTengJiao on 2016/10/26.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScanLineView : UIView

@property (strong, nonatomic)UIButton *backButton;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showScanLine;
- (void)hiddenScanLine;
- (void)hiddenScanLineView;
- (void)showScanLineView;

@end
