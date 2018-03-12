//
//  PayDetailPopView.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PayDetailPopView.h"

@implementation PayDetailPopView

+(instancetype)createView{
    return [[NSBundle mainBundle]loadNibNamed:@"PayDetailPopView" owner:self options:nil][0];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
- (IBAction)payTouch:(id)sender {
    [self.delegate makeSurePay];
}
- (IBAction)chooseBankTouch:(id)sender {
    [self.delegate chooseBank];
}
- (IBAction)cancelTouch:(id)sender {
    [self.delegate cancel];
    
}

@end
