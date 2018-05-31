//
//  DownLoadAnimationView.h
//  sightpDemo
//
//  Created by YangTengJiao on 16/9/14.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadAnimationView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *scrollImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)startScrollAnimation;

@end
