//
//  CodePopView.h
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJPasswordView.h"
@protocol CodePopViewDelegate<NSObject>
- (void)makeSureCode:(NSString *)pass;

- (void)cancel;
@end
@interface CodePopView : UIView<BJPasswordViewDelegate>
@property (nonatomic,weak)id<CodePopViewDelegate>delegate;
@end
