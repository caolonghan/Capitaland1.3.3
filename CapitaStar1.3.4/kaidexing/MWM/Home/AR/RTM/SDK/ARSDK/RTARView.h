//
//  RTARView.h
//  RTMARDemo
//
//  Copyright © 2017年 智慧图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTMapLocationManager.h"

@class RTPOI;

@protocol RTARViewDelegate;
//AR 类型
typedef NS_ENUM(NSUInteger, RTARType) {
    RTARTypeNormal,    //  一般类型，即查看当前楼层指定范围(radius)内POI
    RTARTypeNavigation,//  导航类型，到达指定POI
    RTARTypeSightseeingNavigation,//观光导航
};

//雷达位置
typedef NS_ENUM(NSUInteger, RTARRadarPosition) {
    RTARRadarPositionRightTop,                // 右上方
    RTARRadarPositionRightBottom,             // 右下方
    RTARRadarPositionLeftTop,                 // 左上方
    RTARRadarPositionLeftBottom,              // 左下方
};

@interface RTARView : UIView
@property (nonatomic, assign, readonly) RTARType type;
@property (nonatomic, assign) BOOL isARNavigation;
@property (nonatomic, weak) id<RTARViewDelegate>delegate;

//展示半径，即展示半径内的所有POI 默认15
@property (nonatomic, assign) CGFloat radius;

//雷达位置，默认右上
@property (nonatomic, assign) RTARRadarPosition radarPosition;

//当前展示的建筑物 与 楼层
@property (nonatomic, strong, readonly) NSString * currentFloorID;
@property (nonatomic, strong, readonly) NSString * currentBuildingID;

@property (nonatomic, strong) NSString * currentBuildingName;



//观光路线数组
@property (nonatomic, strong) NSMutableArray *sightseeingRouteArray;

//滤镜类型
@property (nonatomic, assign) NSInteger filterType;

- (instancetype)initWithBuildingID:(NSString *) buildingID floorID:(NSString *) floorID;

/**
 导航

 @param destinationPOI 目的地POI
 */
- (void)navigateToPOI:(RTPOI *) destinationPOI;




//AR 开始 结束
- (void)start;
- (void)stop;

@end

@interface RTARView (NavigationConfig)

//触碰距离 默认8米，即离目标点8米以内，就算到达目的地
@property (nonatomic, assign) CGFloat distance;

@property (nonatomic, assign) CGPoint locationPoint;

//偏移距离，默认4（单位：米）
@property (nonatomic, assign) CGFloat deflectionDistance;

//偏移时间，默认6（单位：秒）
@property (nonatomic, assign) NSUInteger deflectionTime;

@end

@protocol RTARViewDelegate <NSObject>

@optional
//AR 成功开始，若要调用导航方法，请在此回调之后
- (void)didStartedOfARView:(RTARView *) aRView;

//ar 结束时调用，导航中返回返回时会返回目的地，一般模式destinationPOI为nil
- (void)rTARView:(RTARView *) aRView didDisappearType:(RTARType) type destinationPOI:(RTPOI *) destinationPOI;

- (void)userTouchPoiDetails:(RTPOI*)poi;

@end
