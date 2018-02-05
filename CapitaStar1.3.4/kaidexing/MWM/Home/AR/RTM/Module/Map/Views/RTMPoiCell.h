//
//  RTMPoiCell.h
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTLbs3DPOIMessageClass;

@interface RTMPoiCell : UITableViewCell
- (void)setPOIInfo:(RTLbs3DPOIMessageClass *) poiInfo target:(id) target action:(SEL) selector tag:(NSInteger) tag keyword:(NSString *) keyword style:(NSInteger) style;
@end
