//
//  PhoneInputViewController.h
//  kaidexing
//
//  Created by dwolf on 2017/4/22.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface PhoneInputViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *phoeTF;
@property (weak, nonatomic) IBOutlet UIButton *netBtn;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *wxImgView;
@property (weak, nonatomic) IBOutlet UIView *regView;
@property (weak, nonatomic) IBOutlet MLabel *regLabel;
- (IBAction)onNext:(id)sender;
- (IBAction)getCode:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property int type;
@property (strong, nonatomic)  NSString *phone;
@property (strong, nonatomic)  NSString *code;
@property (strong, nonatomic)  NSString *name;
@property BOOL isReg;


@end
