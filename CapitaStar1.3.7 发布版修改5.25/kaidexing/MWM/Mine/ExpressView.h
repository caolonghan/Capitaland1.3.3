//
//  ExpressView.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/22.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol expressViewTouch <NSObject>

-(void)setTouch:(id)exTouch;

@end


@interface ExpressView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,nonatomic)NSString       *titleStr;

@property (strong,nonatomic)NSString       *typeStr;

@property (strong,nonatomic)NSArray        *dataAry;

@property (strong,nonatomic)NSArray        *idArray;

@property (strong,nonatomic)UIPickerView   *pickerView1;

@property (assign,nonatomic)id<expressViewTouch>exDelegate;

@end
