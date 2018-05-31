//
//  RTMSearchClassifyTypeCell.m
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "RTMSearchClassifyTypeCell.h"
#import "UIColor+RTM.h"

@interface RTMSearchClassifyTypeCell()
@property (weak, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (nonatomic, strong) CALayer * leftLineLayer;
@property (nonatomic, strong) CALayer * rightLineLayer;
@end

@implementation RTMSearchClassifyTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGFloat lineWidth = CGRectGetWidth(self.frame)/2.f - 50 - 25;
    CGFloat lineY = self.typeTitleLabel.center.y - 0.5;
    
    self.leftLineLayer = [[CALayer alloc] init];
    self.leftLineLayer.frame = CGRectMake(25, lineY, lineWidth, 1);
    self.leftLineLayer.backgroundColor = [UIColor  colorForDBDBDB].CGColor;
    
    self.rightLineLayer = [[CALayer alloc] init];
    self.rightLineLayer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2.f + 50, lineY, lineWidth, 1);
    self.rightLineLayer.backgroundColor = [UIColor  colorForDBDBDB].CGColor;
    
    [self.layer addSublayer:self.leftLineLayer];
    [self.layer addSublayer:self.rightLineLayer];
}

- (void)setTypeTitle:(NSString *)typeTitle addLine:(BOOL)isAdd{
    self.typeTitleLabel.text = typeTitle;
    
    if (!isAdd) {
        self.leftLineLayer.hidden = YES;
        self.rightLineLayer.hidden = YES;
    }else{
        self.leftLineLayer.hidden = NO;
        self.rightLineLayer.hidden = NO;
    }
}
@end
