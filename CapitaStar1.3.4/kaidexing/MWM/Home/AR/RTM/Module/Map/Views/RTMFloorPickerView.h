//
//  RTMFloorPickerView.h
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTMFloorPickerDataSource;
@protocol RTMFloorPickerDelegate;

@interface RTMFloorPickerView : UIView
@property (nonatomic, weak) id<RTMFloorPickerDataSource>dataSource;
@property (nonatomic, weak) id<RTMFloorPickerDelegate>delegate;

+ (id)loadFloorPickerView;

- (void)reloadData;
- (void)show;
- (void)hide;
- (void)scrollToRow:(NSInteger)row;
@end

@protocol RTMFloorPickerDataSource <NSObject>
- (NSInteger)numberOfRowsInFloorPickerView:(RTMFloorPickerView *)floorPickerView;

- (NSDictionary *)floorPickerView:(RTMFloorPickerView *)floorPickerView floorInfoForRow:(NSInteger)row;
@end

@protocol RTMFloorPickerDelegate <NSObject>
@optional
- (void)floorPickerView:(RTMFloorPickerView *)floorPickerView didSelectRow:(NSInteger)row;
@end
