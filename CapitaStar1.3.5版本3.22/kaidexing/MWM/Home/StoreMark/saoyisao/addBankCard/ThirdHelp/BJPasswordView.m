//
//  BJPasswordView.m
//  liyitianxiaSupper
//
//  Created by home on 2017/12/19.
//  Copyright © 2017年 home. All rights reserved.
//

#import "BJPasswordView.h"
@interface BJPasswordView()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)NSMutableArray * mArray;
@end
@implementation BJPasswordView
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.textColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        _textField.layer.borderWidth = 1;
        _mArray = [[NSMutableArray alloc]init];
        [self addSubview:_textField];
        [self drawTextField];

    }
    return self;
}
- (void)drawTextField{
    //画线和画黑点
    for(int i=0;i<6;i++){
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/6*i, 0, 1, self.frame.size.height)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_textField addSubview:line];
        
        UIView * point = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/6*i+self.frame.size.width/12-5, (self.frame.size.height-10)/2, 10, 10)];
        point.backgroundColor = [UIColor blackColor];
        point.layer.cornerRadius = 5;
        point.layer.masksToBounds = YES;
        point.hidden = YES;
        [self addSubview:point]; //加在最顶层不至于被覆盖，会看见光标
        [_mArray addObject:point];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if(range.location<6){   //小于6个字符的情况下
     UIView * view =(UIView*)_mArray[range.location];
     if(range.location==5){     //当输入最后一个字符的时候触发事件 给代理返回密码
                        NSLog(@"%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
                        [_delegate validatePass:[NSString stringWithFormat:@"%@%@",textField.text,string]];
                        }
        
    if(string.length == 0){    //删除时候 string.length==0 是删除 去掉黑点
        NSLog(@"删除键");
        view.hidden = YES;
    }
    else{      //黑点取消隐藏
        view.hidden = NO;
    }
        
    }
    else{      //否则返回NO也就是不响应输入
        return NO;
    }

    return YES;
}
@end
