//
//  RTMPoiCell.m
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import "RTMPoiCell.h"
#import "UIColor+RTM.h"
#import "RTLbs3DPOIMessageClass.h"

@interface RTMPoiCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
@implementation RTMPoiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPOIInfo:(RTLbs3DPOIMessageClass *)poiInfo target:(id)target action:(SEL)selector tag:(NSInteger) tag keyword:(NSString *)keyword style:(NSInteger)style{
    
    NSString * name = poiInfo.POI_Name;
    
    NSMutableAttributedString * nameAttributedString = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor colorFor333333],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [nameAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorForFF5252] range:[name rangeOfString:keyword]];
    self.nameLabel.attributedText = nameAttributedString;
    self.floorLabel.text = poiInfo.POI_Floor;
    self.actionButton.tag = tag;
    [self.actionButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (style == 1) {
        [self.actionButton setTitle:@"设为起点" forState:UIControlStateNormal];
    }else if (style == 2){
        [self.actionButton setTitle:@"设为终点" forState:UIControlStateNormal];
    }else{
        [self.actionButton setTitle:@"↑ 到这里" forState:UIControlStateNormal];
    }
}
@end
