//
//  CardInfoView.h
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol carInfoViewDelegate<NSObject>
- (void)known;
@end
@interface CardInfoView : UIView

@property (nonatomic,weak)id<carInfoViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
@end
