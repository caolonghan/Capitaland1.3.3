//
//  BJPasswordView.h
//  liyitianxiaSupper
//
//  Created by home on 2017/12/19.
//  Copyright © 2017年 home. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BJPasswordViewDelegate<NSObject>
- (void)validatePass:(NSString*)pass;
@end
@interface BJPasswordView : UIView
@property(nonatomic,weak) id<BJPasswordViewDelegate> delegate;
@end
