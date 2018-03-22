//
//  BankCardView.m
//  kaidexing
//
//  Created by companycn on 2018/3/15.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BankCardView.h"
#import "UIImageView+WebCache.h"
@implementation BankCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(221, 81, 87);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self createView];
    }
    return self;
}
- (void)createView
{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    
    
    _bankNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+10, 10, 180, 21)];
    _bankNameLabel.textColor = [UIColor whiteColor];
    
    _bankNameLabel.font = [UIFont systemFontOfSize:15];
    
    _cardStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+10, CGRectGetMaxY(_bankNameLabel.frame), 180, 21)];
    _cardStyleLabel.textColor = [UIColor whiteColor];
    
    _cardStyleLabel.font = [UIFont systemFontOfSize:12];
    
    _cardNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)+10, self.frame.size.height-31, 180, 21)];
    _cardNoLabel.textColor = [UIColor whiteColor];
    _cardNoLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:_bankNameLabel];
    [self addSubview:_imageView];
    [self addSubview:_cardStyleLabel];
    [self addSubview:_cardNoLabel];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _cardNoLabel.text = [self getNewBankNumWitOldBankNum:_cardNo];
    if ([_cardStyle isEqualToString:@"01"]) {
        _cardStyleLabel.text = @"储蓄卡";
    }if ([_cardStyle isEqualToString:@"02"]) {
        _cardStyleLabel.text = @"信用卡";
    }
    _bankNameLabel.text = _bankName;
    [_imageView setImageWithURL:[NSURL URLWithString:_bankImageUrl]];
}
-(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum
{
    NSMutableString *mutableStr;
    if (bankNum.length) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        if (mutableStr.length%4==0) {
            for (int i = 0 ; i < mutableStr.length; i ++) {
                if (i>0&&i<mutableStr.length - 4) {
                    
                    [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
                }
            }
        }else{
             for (int i = 0 ; i < mutableStr.length; i ++) {
                 
                 if (i>0&&i<mutableStr.length - mutableStr.length%4) {
                      [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
                 }
                 
             }
        }
        
        NSString *text = mutableStr;
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
       
        NSRange range2 = NSMakeRange(0, 1);
       NSString *newStr = [newString stringByReplacingCharactersInRange:range2 withString:@"*"];
        return newStr;
    }
    
    return bankNum;
    
}
@end
