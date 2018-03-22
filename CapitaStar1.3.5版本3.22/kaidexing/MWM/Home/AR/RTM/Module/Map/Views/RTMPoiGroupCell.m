//
//  RTMPoiGroupCell.m
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "RTMPoiGroupCell.h"
#import "RTLbs3DPOIMessageClass.h"

@interface RTMPoiGroupCell()
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UIButton * button;
@end
@implementation RTMPoiGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPOIInfo:(RTLbs3DPOIMessageClass *)poiInfo target:(id)target action:(SEL)selector tag:(NSInteger) tag{
    self.nameLabel.text = poiInfo.POI_Name;
    self.button.tag = tag;
    [self.button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
