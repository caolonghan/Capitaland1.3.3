//
//  ARViewController.h
//  RTMARDemo
//
//  Copyright © 2017年 智慧图. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTPOI;

typedef void(^ReturnBlock)(RTPOI * destinationPOI);

@interface RTMARViewController : UIViewController
@property (nonatomic, strong) NSString * bid;
@property (nonatomic, strong) NSString * fid;
@property (nonatomic, assign) CGPoint locationPoint;
@property (nonatomic, strong) NSString * buildingName;
@property (nonatomic, strong) RTPOI * destinationPOI;
@property (nonatomic, strong) ReturnBlock returnBlock;
@property (nonatomic, assign) BOOL isARNavigation;
@property (nonatomic, strong) NSMutableArray *routeArray;
@property (nonatomic, assign) NSInteger arFilterType;
@end
