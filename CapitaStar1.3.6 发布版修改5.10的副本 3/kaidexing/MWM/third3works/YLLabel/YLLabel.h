//
//  YLLabel.h
//  YLLabelDemo
//
//  Created by Eric Yuan on 12-11-8.
//  Copyright (c) 2012年 YuanLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLLabel : UIView
{
    NSMutableAttributedString* _string;
    UIFont* _font;
    UIColor* _textColor;
    int _numberOfLines;
}

@property (nonatomic, strong)NSMutableAttributedString* string;
@property (nonatomic, strong)UIFont* font;
@property (nonatomic, strong)UIColor* textColor;
@property (nonatomic)int numberOfLines;

- (void)setText:(NSString*)text;

- (void)sizeToFit;
@end
