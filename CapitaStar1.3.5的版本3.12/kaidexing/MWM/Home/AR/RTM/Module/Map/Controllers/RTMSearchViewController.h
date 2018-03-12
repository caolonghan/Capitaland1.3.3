//
//  RTMSearchViewController.h
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTLbs3DPOIMessageClass;

//1设置起点 2设置终点 0普通查询
typedef NS_ENUM(NSUInteger, RTMPoiSearchType) {
    RTMPoiSearchTypeNormal = 0,
    RTMPoiSearchTypeStart,
    RTMPoiSearchTypeEnd,
};

//0打点 1使用定位点导航 2使用searchReults的第一个点导航
typedef NS_ENUM(NSUInteger, RTMPoiUsingMode) {
    RTMPoiUsingModeNormal = 0,
    RTMPoiUsingModeLocation,
    RTMPoiUsingModeNavigation,
};

@interface RTMSearchViewController : UIViewController
@property (nonatomic, strong) NSString * buildingID;
@property (nonatomic, strong) NSString * floorID;

// poiMode 0打点 1使用定位点导航 2使用searchReults的第一个点导航
@property (nonatomic, strong) void (^handler)(NSArray * searchReults, RTMPoiUsingMode poiMode);

@property (nonatomic, assign) RTMPoiSearchType changeStartOrEndPoi;
@end
