//
//  RealDataViewController.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
//真实资料填写
@interface RealDataViewController : BaseViewController //<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;

@property(nonatomic, copy)NSString * phone_num; //手机号
@property(nonatomic, copy)NSString * vilaCode; //验证码
@property(nonatomic, copy)NSString * pass_word; //加密之后密文
@property(nonatomic, copy)NSString * password; //加密之前原密码
@property (weak, nonatomic) IBOutlet UIButton   *wanchengBtn;

@end
