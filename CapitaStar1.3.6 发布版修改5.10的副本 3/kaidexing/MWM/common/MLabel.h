//
//  MLabel.h
//  ABAS
//
//  Created by dwolf on 16/6/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLabel : UILabel{
    int maxHeight;
    BOOL autoHeight;
}
@property int maxHeight;
@property BOOL autoHeight;
-(void) autoSize;
-(void) setAttrFont:(int) begin end:(int)length font:(UIFont*) font;
-(void) setAttrColor:(int) begin end:(int)length color:(UIColor*) color;
/**
 *  设置文字下划线
 *
 */
-(void) setUnderLine:(int) begin end:(int)length;

@end
