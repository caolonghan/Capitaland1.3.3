//
//  inputInfoViewController.h
//  kaidexing
//
//  Created by company on 2017/8/28.
//  Copyright © 2017年 dwolf. All rights reserved.
//
typedef enum {
    phoneNum=0,
    verificationCode,
    PWD,
 //   NAME,
    carNum
} type;
#import "BaseViewController.h"

@interface inputInfoViewController : BaseViewController

@property(strong,nonatomic)NSString *phonenum;
@property(strong,nonatomic)NSString *vilaCode;

@property(assign,nonatomic)type type;
@property(assign,nonatomic)type nextType;


@property(assign,nonatomic)BOOL isForgetpwd;

@end
