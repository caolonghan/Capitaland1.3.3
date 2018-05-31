#import "UITextFieldEx.h"

@implementation UITextFieldEx


-(id)initWithFrame:(CGRect) frame{
    if(frame.size.height == 0){
        frame.size.height = 41;
    }
    self = [super initWithFrame:frame];
    if(self){
        [self setPadding:YES top:7 right:3 bottom:3 left:4];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = DEFAULT_LINE_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
        [self setBorderStyle:UITextBorderStyleNone];
    }
    return self;
}
- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left {
    isEnablePadding = enable;
    paddingTop = top;
    paddingRight = right;
    paddingBottom = bottom;
    paddingLeft = left;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (isEnablePadding) {
        return CGRectMake(bounds.origin.x + paddingLeft,
                          bounds.origin.y + paddingTop,
                          bounds.size.width - paddingRight, bounds.size.height - paddingBottom);
    } else {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end