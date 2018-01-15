//
//  RegisterTHView.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegisterViewController;

@interface RegisterTHView : UIView  <UITextFieldDelegate>
{
    NSTimer *countDownTimer;
    NSInteger secondsCountDown;
}
@property (weak, nonatomic, null_unspecified) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic, null_unspecified) IBOutlet UITextField *figureVCTF; //图形验证码
@property (weak, nonatomic) IBOutlet UILabel * _Nullable xieyiLab;

@property (weak, nonatomic, null_unspecified) IBOutlet UITextField *msgVCTF;  //短信验证码

@property (weak, nonatomic, null_unspecified) IBOutlet UITextField *setPswdTF;

@property (weak, nonatomic, null_unspecified) IBOutlet UITextField *confirmPwTF;

@property(nonnull, strong)RegisterViewController * viewController;

@property (weak, nonatomic) IBOutlet UIButton * _Nullable getBtn;

@property (strong,nonatomic)NSString      * _Nullable typestr;

@end











