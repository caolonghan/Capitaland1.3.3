//
//  DialogView.h
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/22.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TipDialogView : UIView

@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic, weak)UIViewController *openVC;


+ (instancetype)defaultPopupView;
-(void)setImgUrl:(NSString*) imgName;


@end
