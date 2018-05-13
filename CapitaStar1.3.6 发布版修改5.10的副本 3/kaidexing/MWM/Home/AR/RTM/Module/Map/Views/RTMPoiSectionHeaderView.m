//
//  RTMPoiSectionHeaderView.m
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "RTMPoiSectionHeaderView.h"
@interface RTMPoiSectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel * floorLabel;
@end

@implementation RTMPoiSectionHeaderView
+ (instancetype)loadView{
    return [[NSBundle mainBundle] loadNibNamed:@"RTMPoiSectionHeaderView" owner:self options:nil].firstObject;
}
- (void)setFloor:(NSString *)floor{
    self.floorLabel.text = floor;
}
@end
