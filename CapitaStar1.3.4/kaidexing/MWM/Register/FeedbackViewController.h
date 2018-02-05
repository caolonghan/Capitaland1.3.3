//
//  FeedbackViewController.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UITextView *contentTV;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;   //图片验证码
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstBot;

@end
