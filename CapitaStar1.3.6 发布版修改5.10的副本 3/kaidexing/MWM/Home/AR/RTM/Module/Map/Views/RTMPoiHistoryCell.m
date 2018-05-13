//
//  RTMPoiHistoryCell.m
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "RTMPoiHistoryCell.h"
#import "UIColor+RTM.h"

@interface RTMPoiHistoryCell()
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@end

@implementation RTMPoiHistoryCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = [UIColor colorForD7D9DA].CGColor;
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
@end
