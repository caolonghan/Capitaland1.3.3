//
//  SYInputViewController.h
//  ShouYi
//
//  Created by Hwang Kunee on 14-1-24.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "UITextFieldEx.h"

@interface SYInputViewController : BaseViewController

@property(nonatomic,retain)id delegate;
@property(nonatomic,retain)NSString* desc;
@property(nonatomic,retain)UITextView* textView;
@property(nonatomic,retain)UITextFieldEx* textField;
@property(nonatomic)int tag;


-(void) enableBtn;
-(void) setOkBtnTitle:(NSString*) btnTitle;
-(void) resignFirstResponder;

@end
