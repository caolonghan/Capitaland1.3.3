//
//  RTMPoiGroupCell.h
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTLbs3DPOIMessageClass;

@interface RTMPoiGroupCell : UITableViewCell
- (void)setPOIInfo:(RTLbs3DPOIMessageClass *) poiInfo target:(id) target action:(SEL) selector tag:(NSInteger) tag;
@end
