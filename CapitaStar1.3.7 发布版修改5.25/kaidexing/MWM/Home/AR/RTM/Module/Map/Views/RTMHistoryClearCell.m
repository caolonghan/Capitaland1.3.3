//
//  RTMHistoryClearCell.m
//  CapitaLand
//
//  Created by 赵晨洪 on 2017/10/20.
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "RTMHistoryClearCell.h"
@interface RTMHistoryClearCell()
@property (nonatomic, weak) IBOutlet UIButton * clearButton;
@end
@implementation RTMHistoryClearCell

- (void)bindTarget:(id)target action:(SEL)selector{
    [self.clearButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}
@end
