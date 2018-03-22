#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Const.h"

@interface UITextFieldEx : UITextField {
    
    BOOL isEnablePadding;
    float paddingLeft;
    float paddingRight;
    float paddingTop;
    float paddingBottom;
    
}

- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left;

@end