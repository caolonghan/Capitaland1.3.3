//
//  SYInputViewController.m
//  ShouYi
//
//  Created by Hwang Kunee on 14-1-24.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "SYInputViewController.h"


@interface SYInputViewController ()

@end

@implementation SYInputViewController{
    @private
    UIButton* okBtn;
    UIButton* cancelBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, 280, 10);
    
    self.view.layer.cornerRadius = 3.0f;
    self.view.backgroundColor = [UIColor whiteColor];
    
    SYLabel* label = [[SYLabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 10)];
    [label setText:_desc];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [label setTextColor:DEFAULT_TEXT_COLOR];
    [self.view addSubview:label];
    [label sizeToFit];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, label.frame.origin.y + label.frame.size.height + 10, self.view.frame.size.width - 10 * 2, 40)];
    _textView.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    _textView.layer.borderWidth = 1.0f;
    
    [self.view addSubview:_textView];
    
    _textField = [[UITextFieldEx alloc] initWithFrame:CGRectMake(10, label.frame.origin.y + label.frame.size.height + 10, self.view.frame.size.width - 10 * 2, 40)];
    [_textField setPadding:YES top:0 right:10 bottom:0 left:10];
    [_textField setTextAlignment:NSTextAlignmentCenter];
    _textField.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
    _textField.layer.borderWidth = 1.0f;
    [self.view addSubview:_textField];
    
    
    okBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn.layer setCornerRadius:DEFAULT_BUTTON_RADIUS];
    [okBtn setBackgroundColor:DEFAULT_MAIN_COLOR];
    [self.view addSubview:okBtn];
    
    [okBtn addTarget:self action:@selector(okBtnOnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.layer setCornerRadius:DEFAULT_BUTTON_RADIUS];
    [cancelBtn setBackgroundColor:DEFAULT_ITEM_BG_COLOR];
    [cancelBtn setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self resize];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) setOkBtnTitle:(NSString*) btnTitle{
    [okBtn setTitle:btnTitle forState:UIControlStateNormal];
}

-(void)resize{
    CGRect frame = _textField.hidden?_textView.frame:_textField.frame;
    int space = 10;
    int buttonWidth = (self.view.frame.size.width - space * 3) / 2;
    [okBtn setFrame:CGRectMake(space, frame.origin.y + frame.size.height + 10, buttonWidth, 30)];
    [cancelBtn setFrame:CGRectMake(space + buttonWidth + space, frame.origin.y + frame.size.height + space, buttonWidth, 30)];
    
    frame = self.view.frame;
    frame.size.height = cancelBtn.frame.origin.y + cancelBtn.frame.size.height + 10;
    self.view.frame = frame;
}

-(void)okBtnOnTap:(UIButton*) sender{
    okBtn.enabled = NO;
    cancelBtn.enabled = NO;
    
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputViewReturn:)]){
        NSString* result = _textField.hidden?_textView.text:_textField.text;
        [self.delegate performSelectorOnMainThread:@selector(inputViewReturn:) withObject:result waitUntilDone:NO];
        
    }
}

-(void) enableBtn{
    dispatch_async(dispatch_get_main_queue(), ^{
        okBtn.enabled = YES;
        cancelBtn.enabled = YES;
    });
}

-(void)cancelBtn:(UIButton*) sender{
    [self enableBtn];
    [self resignFirstResponder];
    if(self.delegate && [self.delegate respondsToSelector:@selector(inputViewCancel)]){
        [self.delegate performSelectorOnMainThread:@selector(inputViewCancel) withObject:nil waitUntilDone:NO];
    }else{
        [self.delegate dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)keyboardWillShow: (NSNotification*) aNotification;
{
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^(void){
                         self.view.transform = CGAffineTransformMakeTranslation(0, -50);
                     }
                     completion:^(BOOL finished) {}];
}

- (void)keyboardWillHide: (NSNotification*) aNotification;
{
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^(void){
                         self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished) {}];
}

-(void) resignFirstResponder{
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        okBtn = nil;
        cancelBtn = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
}

@end
