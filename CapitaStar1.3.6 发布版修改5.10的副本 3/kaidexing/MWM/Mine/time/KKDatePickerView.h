//
//  KKDatePickerView.h
//  PickerView
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDatePickerViewModel.h"

@protocol timeDelegate <NSObject>

-(void)setTime_pick:(id)time;
-(void)setdeleteView;

@end

@interface KKDatePickerView : UIView

@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong)KKDatePickerViewModel *model ;
@property (assign,nonatomic)id<timeDelegate>tDetegate;
-(instancetype)initWithFrame:(CGRect)frame;
@end
