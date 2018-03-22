//
//  RTMMapViewController.m
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import "RTMMapViewController.h"
#import "RTMInterfaceController.h"
#import "RTMSearchViewController.h"
#import "RTMARViewController.h"

#import "RTLbsMapView.h"
#import "RTMFloorPickerView.h"

#import "RTLbs3DWebService.h"
#import "RTMapLocationManager.h"
#import "RTLbs3DNavigationInfo.h"
#import "RTLbs3DPOIMessageClass.h"

#import "RTPOI.h"
#import "UIColor+RTM.h"
#import "Masonry.h"
#import "RTMapProgressHUD.h"

#import "RTMARRequest.h"
#import <CoreBluetooth/CBCentralManager.h>

static NSString * const defaultBuildingID = @"862200050030300012";
static NSString * const defaultFloorID = @"F1";
static NSString * const defaultMapServerURL = @"http://lbsapi.rtmap.com";
static float const defaultMapScale = 500;

@interface RTMMapViewController ()<RTLbsMapViewDelegate,RTLbs3DWebServiceDelegate,RTMapLocationManagerDelegate,RTMFloorPickerDelegate,RTMFloorPickerDataSource>
{
    int count;
    NSInteger filterType;
    CGPoint locationPoint;
    
}

@property (nonatomic, strong) NSDictionary * navigationDestinationPOI;
@property (nonatomic, assign) BOOL isFirstLoadMap;
//地图信息查询服务
@property (nonatomic, strong) RTLbs3DWebService * mapService;
//定位服务
@property (nonatomic, strong) RTMapLocationManager * locationManager;
@property (nonatomic, assign) BOOL firstLocation;
/*
 定位使用
 */
//当前建筑物ID
@property (nonatomic, strong) NSString * currentBuildingID;
//定位点
@property (nonatomic, strong) IbeaconLocation * location;
@property (nonatomic, strong) CBCentralManager * centralManager;
/*暂存数据*/

//楼层
@property (nonatomic, strong) NSArray * floorsArr;

//导航信息，楼层切换后绘图使用
@property (nonatomic, strong) NSArray * navigationsArr;

//导航信息
@property (nonatomic, strong) RTLbs3DAnnotation * startAnnotation;
@property (nonatomic, strong) RTLbs3DAnnotation * endAnnotation;
@property (nonatomic, assign) NSInteger otherAnnotationCount;

//导航起始点为定位点
@property (nonatomic, assign) BOOL isLocation;

//导航选点
@property (nonatomic, strong) NSDictionary * tempPOI;
@property (nonatomic, strong) NSDictionary * startPOI;
@property (nonatomic, strong) NSDictionary * endPOI;

@property (nonatomic, assign) BOOL showAR;
@property (nonatomic, strong) NSMutableArray *routesArray;


/*
 子视图
 */
@property (weak, nonatomic) IBOutlet UIView *searchView;
//地图view
@property (nonatomic, strong) RTLbsMapView * mapView;
//当前楼层
@property (weak, nonatomic) IBOutlet UILabel *currentFloorLabel;
//楼层选择器
@property (nonatomic, strong) RTMFloorPickerView * floorPickerView;
//顶部选点
@property (weak, nonatomic) IBOutlet UILabel *topBoardStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *topBoardEndLabel;
@property (weak, nonatomic) IBOutlet UIView *topBoardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBoardTopConstraint;
@property (nonatomic, strong) CALayer * topBoardViewPartingLineLayer;

//底部选点
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomViewPOILabel;

//定位按钮
@property (weak, nonatomic) IBOutlet UIButton *positionButton;
//取消导航按钮
@property (weak, nonatomic) IBOutlet UIButton * cancelNavigationButton;

//ar导航按钮
@property (weak, nonatomic) IBOutlet UIButton * arNavigationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * arNavigationButtonConstraint;
@property (weak, nonatomic) IBOutlet UIButton *arButton;
@property (weak, nonatomic) IBOutlet UIButton *routeBtn;

//底部选点view的bottom与self.view底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopConstraint;

//底部选点view与定位按钮的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *positionButtonBottomConstraint;

@property (nonatomic, assign) CGFloat arButtonHeight;
@property (nonatomic, assign) CGFloat bottomViewHeight;

@end

@implementation RTMMapViewController
#pragma mark - 重写属性getter方法，成员变量初始化放入getter方法中
- (RTLbsMapView *)mapView{
    if (!_mapView) {
        
        NSString * floorID = self.navigationDestinationPOI[@"floorID"];
        
        _mapView = [[RTLbsMapView alloc] initWithFrame:self.view.bounds building:self.currentBuildingID floor:floorID.length?floorID:defaultFloorID serverUrl:defaultMapServerURL scale:defaultMapScale delegate:self];
        _mapView.navStartImage = [UIImage imageNamed:@"startPOI"];
        _mapView.navEndImage = [UIImage imageNamed:@"endPOI"];
    }
    return _mapView;
}
- (RTLbs3DWebService *)mapService{
    if (!_mapService) {
        _mapService = [[RTLbs3DWebService alloc] init];
        _mapService.delegate = self;
        _mapService.serverUrl = defaultMapServerURL;
    }
    return _mapService;
}
- (RTMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[RTMapLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (RTMFloorPickerView *)floorPickerView{
    if (!_floorPickerView) {
        _floorPickerView = [RTMFloorPickerView loadFloorPickerView];
        _floorPickerView.frame = self.view.bounds;
        _floorPickerView.delegate = self;
        _floorPickerView.dataSource = self;
    }
    return _floorPickerView;
}
- (CBCentralManager *)centralManager{
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:nil queue:dispatch_get_main_queue()];
    }
    return _centralManager;
}

- (NSMutableArray*)routesArray{
    if(!_routesArray){
        _routesArray = [[NSMutableArray alloc] init];
    }
    return _routesArray;
}
#pragma mark - setter
- (void)setShowAR:(BOOL)showAR{
    _showAR = showAR;
    if (_showAR) {
        [self openARInterface];
    }else{
        [self closeARInterface];
    }
}
#pragma mark - controller 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLoadMap = YES;
    self.firstLocation = NO;
    // Do any additional setup after loading the view.
    
    if ([self.navigationController isKindOfClass:[RTMInterfaceController class]]) {
        RTMInterfaceController * controller = (RTMInterfaceController *)self.navigationController;
        
        if (controller.destinationPOI) {
            NSString * buildingID = controller.destinationPOI[@"buildingID"];
            self.navigationDestinationPOI = controller.destinationPOI;
            self.currentBuildingID = buildingID.length?buildingID:defaultBuildingID;
        }else{
            self.currentBuildingID = controller.defaultBuildingID.length?controller.defaultBuildingID:defaultBuildingID;
        }
    }else{
        self.currentBuildingID = defaultBuildingID;
    }
    
    if ([self.currentBuildingID isEqualToString:defaultBuildingID]) {
        self.showAR = YES;
    }else{
        self.showAR = NO;
    }
    
    [self.mapService getBuildFloorInfo:self.currentBuildingID];
    self.otherAnnotationCount = 0;
    
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    if (!self.navigationDestinationPOI) {
        self.mapView.userTrackingMode = RLUserTrackingModeFollow;
    }
    [self.view addSubview:self.floorPickerView];
    
    self.topBoardViewPartingLineLayer = [[CALayer alloc] init];
    self.topBoardViewPartingLineLayer.backgroundColor = [UIColor colorForEEEEEE].CGColor;
    [self.topBoardStartLabel.layer addSublayer:self.topBoardViewPartingLineLayer];
    
    self.searchView.layer.shadowColor = [UIColor colorForEEEEEE].CGColor;
    self.searchView.layer.shadowOpacity = 1.f;
    self.searchView.layer.shadowRadius = 3;
    self.searchView.layer.shadowOffset = CGSizeMake(0, 2);
    
    //修改返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self sendAppOpenRequest];
    [self getfestivalInfo];//获取节日信息
}

- (void)viewDidLayoutSubviews{
    self.arButtonHeight = CGRectGetHeight(self.arNavigationButton.frame);
    self.bottomViewHeight = CGRectGetHeight(self.bottomView.frame);
    
    self.searchView.layer.cornerRadius = CGRectGetHeight(self.searchView.frame)/2.f;
    self.searchView.layer.masksToBounds = YES;
    
    self.topBoardViewPartingLineLayer.frame = CGRectMake(0, CGRectGetHeight(self.topBoardStartLabel.frame), CGRectGetWidth(self.topBoardStartLabel.frame), 1);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

#pragma mark - 业务处理
- (void)setNavigationPOI:(NSDictionary *) poi startOrEnd:(BOOL) startOrEnd mapCenter:(BOOL) mapCenter{
    
    CGPoint point = [poi[@"point"] CGPointValue];
    NSString * floor = poi[@"floorID"];
    NSString * name = poi[@"name"];
    RTLbs3DAnnotation * annotation = nil;
    
    if (self.otherAnnotationCount) {
        self.otherAnnotationCount = 0;
        [self.mapView removeAnnotations];
    }
    
    if (startOrEnd) {
        if (self.startAnnotation) {
            [self.mapView removeAnnotationWith:self.startAnnotation];
            self.startAnnotation = nil;
        }
        
        if (floor.length) {
            annotation = [[RTLbs3DAnnotation alloc] initWithMapPoint:point annoTitle:@"" annoId:@"startPOI" iconImage:[UIImage imageNamed:@"startPOI"] floorID:floor];
            
            self.startAnnotation = annotation;
            
            self.topBoardStartLabel.text = name;
            self.topBoardStartLabel.textColor = [UIColor colorFor333333];
            self.startPOI = poi;
        }else{
            self.topBoardStartLabel.text = @"请选择起点位置";
            self.topBoardStartLabel.textColor = [UIColor colorForEEEEEE];
            self.startPOI = nil;
        }
    }else{
        if (self.endAnnotation) {
            [self.mapView removeAnnotationWith:self.endAnnotation];
            self.endAnnotation = nil;
        }
        
        if (floor.length) {
            annotation = [[RTLbs3DAnnotation alloc] initWithMapPoint:point annoTitle:nil annoId:@"endPOI" iconImage:[UIImage imageNamed:@"endPOI"] floorID:floor];
            self.endAnnotation = annotation;
            
            self.topBoardEndLabel.text = name;
            self.topBoardEndLabel.textColor = [UIColor colorFor333333];
            self.endPOI = poi;
        }else{
            self.topBoardEndLabel.textColor = [UIColor colorForEEEEEE];
            self.topBoardEndLabel.text = @"请选择终点位置";
            self.endPOI = nil;
        }
    }
    
    if (annotation) {
        [self.mapView addAnnotation:annotation isShowPopView:NO setMapCenter:mapCenter];
    }
    
    if (self.startPOI && self.endPOI) {
        [RTMapProgressHUD show];
        
        [self.mapView mapViewNavgationStartPoint:[self.startPOI[@"point"] CGPointValue]  buildingID:self.startPOI[@"buildingID"] floorID:self.startPOI[@"floorID"] delegate:self];
        
        [self.mapView mapViewNavgationEndPoint:[self.endPOI[@"point"] CGPointValue] buildingID:self.endPOI[@"buildingID"] floorID:self.endPOI[@"floorID"] delegate:self];
        
        [self sendAppNavigationRouteRequest];
    }else if((self.startPOI || self.endPOI) && self.navigationsArr.count){
        if (self.navigationsArr.count) {
            self.navigationsArr = nil;
            [self.mapView removeNavAnnotationsAndNavLine];
        }
    }
}
- (void)openARInterface{
    self.arButton.hidden = NO;
    self.routeBtn.hidden = NO;
}
- (void)closeARInterface{
    self.arButton.hidden = YES;
    self.routeBtn.hidden = YES;
}

- (NSString *)getCurrentTime{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)getIdfv{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
- (void)sendAppOpenRequest{
    NSDictionary * param = @{@"userid":[self getIdfv],
                             @"burying_Point_key":@"app_open",
                             @"build_id":defaultBuildingID,
                             @"time":[self getCurrentTime]};
    NSData * data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    [self postData:data];
}
- (void)sendAppOpenLocationRequest{
    NSDictionary * param = @{@"userid":[self getIdfv],
                             @"burying_Point_key":@"app_openlocation",
                             @"build_id":self.location.buildID,
                             @"time":[self getCurrentTime],
                             @"floor":self.location.floorID,
                             @"x":[NSString stringWithFormat:@"%f",self.location.location_x],
                             @"y":[NSString stringWithFormat:@"%f",self.location.location_y]
                             };
    NSData * data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    [self postData:data];
}
- (void)sendAppNavigationRouteRequest{
    NSDictionary * param = @{@"userid":[self getIdfv],
                             @"burying_Point_key":@"app_navigation_route",
                             @"build_id":self.startPOI[@"buildingID"],
                             @"time":[self getCurrentTime],
                             @"start_floor":self.startPOI[@"floorID"],
                             @"start_x":[NSString stringWithFormat:@"%f",[self.startPOI[@"point"] CGPointValue].x],
                             @"start_y":[NSString stringWithFormat:@"%f",[self.startPOI[@"point"] CGPointValue].y],
                             @"end_floor":self.endPOI[@"floorID"],
                             @"end_x":[NSString stringWithFormat:@"%f",[self.endPOI[@"point"] CGPointValue].x],
                             @"end_y":[NSString stringWithFormat:@"%f",[self.endPOI[@"point"] CGPointValue].y]
                             };
    NSData * data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    [self postData:data];
}

- (void)postData:(NSData *) data{
    [RTMARRequest POSTWithData:data AndRequestPolicy:RequestBuryingPoint AndBlock:^(id result, NSError *error) {
        
    }];
}

// 用户点击了观光浏览按钮
- (IBAction)touchARSightseeingBtn:(id)sender {
    NSLog(@"用户点击了观光浏览按钮");
    if(self.routesArray.count<=0){
        [RTMapProgressHUD showWithStatus:@"正在获取观光路线" maskType:RTMapProgressHUDMaskTypeNone];
        [self getNaviateRoute];
    }else {
        RTMARViewController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMARViewController"];
        controller.bid = self.location.buildID;
        controller.fid = self.location.floorID;
        controller.arFilterType = filterType;
        controller.routeArray = self.routesArray;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 获取观光路线和滤镜效果样式 
- (void)getNaviateRoute {
    if (!self.location) {
        [RTMapProgressHUD showErrorWithStatus:@"未获取到定位信息无法开启AR导航" duration:1.5];
        return;
    }
    
    NSDictionary *param = @{@"key":@"JYRhO8qotr",@"buildid":self.currentBuildingID,@"floor":self.location.floorID,@"x":@(self.location.location_x),@"y":@(self.location.location_y)};
    [RTMARRequest POSTWithParameters:param AndRequestPolicy:RequestNavigationRoute AndBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [RTMapProgressHUD dismiss];
            if(result){
                NSInteger code = [[[result objectForKey:@"result"] objectForKey:@"error_code"] integerValue];
                if(code == 0){
                    filterType = [[result objectForKey:@"holiday"] integerValue];
                    self.routesArray = [result objectForKey:@"pointlist"];
                    
                    if (self.routesArray.count > 0) {
                        [self touchARSightseeingBtn:nil];
                    }
                }
            }
        });
    }];
}

// 获取节日信息
- (void)getfestivalInfo {
    NSDictionary *param = @{@"key":@"JYRhO8qotr",@"buildid":self.currentBuildingID};
    [RTMARRequest POSTWithParameters:param AndRequestPolicy:RequestNavigationRoute AndBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [RTMapProgressHUD dismiss];
            if(result){
                NSInteger code = [[[result objectForKey:@"result"] objectForKey:@"error_code"] integerValue];
                if(code == 0){
                    filterType = [[result objectForKey:@"holiday"] integerValue];
                }
            }
        });
    }];
}



#pragma mark - 按钮action
//底部选点view 弹框按钮
- (IBAction)bottomViewPopButtonAction:(UIButton *)sender {
    [self bottomViewHide];
}

//底部选点view 起点选定按钮
- (IBAction)bottomViewStartButtonAction:(UIButton *)sender {
    [self topBoardViewShow];
    [self setNavigationPOI:self.tempPOI startOrEnd:YES mapCenter:YES];
}

//底部选点view 起点终点按钮
- (IBAction)bottomViewEndButtonAction:(UIButton *)sender {
    [self topBoardViewShow];

    [self setNavigationPOI:self.tempPOI startOrEnd:NO mapCenter:YES];
}

//唤起楼层选择器
- (IBAction)floorButtonAction:(UIButton *)sender{
    [self.floorPickerView show];
}

//定位按钮
- (IBAction)positionButtonAction:(UIButton *) sender{
    self.mapView.userTrackingMode = RLUserTrackingModeFollow;
    if (self.centralManager.state == CBCentralManagerStatePoweredOff) {
        [RTMapProgressHUD showErrorWithStatus:@"需要蓝牙设备支持，请打开蓝牙" duration:1.5];
    }
}

//地图文字 图标 切换
- (IBAction)openAR:(UIButton *) sender{
    if (!self.location) {
        [RTMapProgressHUD showErrorWithStatus:@"未获取到定位信息无法开启AR导航" duration:1.5];
        return;
    }
    RTPOI * destinationPOI = nil;
    
    if (self.navigationsArr.count && self.arNavigationButton==sender) {
        
        if (![self.startPOI[@"name"] isEqualToString:@"我的位置"]) {
            [RTMapProgressHUD showErrorWithStatus:@"请把起点设成我的位置，开始AR导航" duration:1.5];
            return;
        }
        
        destinationPOI = [[RTPOI alloc] init];
        destinationPOI.point = [[self.endPOI valueForKey:@"point"] CGPointValue];
        destinationPOI.buildingID = self.endPOI[@"buildingID"];
        destinationPOI.floorID = self.endPOI[@"floorID"];
    }
    
    RTMARViewController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMARViewController"];
    controller.bid = self.location.buildID;
    controller.fid = self.location.floorID;
    controller.arFilterType = filterType;
    controller.isARNavigation = self.arNavigationButton==sender;
    controller.destinationPOI = destinationPOI;
    controller.returnBlock = ^(RTPOI * destinationPOI){
        if (destinationPOI) {
            if ([destinationPOI.buildingID isEqualToString:self.mapView.build]) {
                [self topBoardViewShow];
                
                if ([self.location.buildID isEqualToString:destinationPOI.buildingID]) {
                    [self setNavigationPOI:@{@"name":@"我的位置",@"point":[NSValue valueWithCGPoint:CGPointMake(self.location.location_x, self.location.location_y)],@"floorID":self.location.floorID,@"buildingID":self.location.buildID} startOrEnd:YES mapCenter:NO];

                }
                
                [self setNavigationPOI:@{@"name":destinationPOI.name,@"point":[NSValue valueWithCGPoint:destinationPOI.point],@"floorID":destinationPOI.floorID,@"buildingID":destinationPOI.buildingID} startOrEnd:NO mapCenter:NO];
            }
        }else{
            [self topBoardViewHide];
            [self updateViewForNormalMode];
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)stopNavigationButtonAction:(UIButton *)sender {
    [self updateViewForNormalMode];
}

- (IBAction)searchAction:(UITapGestureRecognizer *)sender {
    RTMSearchViewController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMSearchViewController"];
    __block NSString * buildingID = self.mapView.build;
    controller.buildingID = buildingID;
    controller.floorID = self.mapView.floor;
    controller.handler = ^(NSArray *searchReults, RTMPoiUsingMode poiMode) {
        if ([self.mapView.build isEqualToString:buildingID]) {
            if (poiMode == 0) {
                [self.mapView removeAnnotations];
                self.otherAnnotationCount = searchReults.count;
                int i = 0;
                for (RTLbs3DPOIMessageClass * poi in searchReults) {
                    RTLbs3DAnnotation * annotation = [[RTLbs3DAnnotation alloc] initWithMapPoint:poi.POI_point annoTitle:nil annoId:poi.POI_ID iconImage:[UIImage imageNamed:@"annotation"] floorID:poi.POI_Floor];
                    [self.mapView addAnnotation:annotation isShowPopView:NO setMapCenter:i==0];
                    i++;
                }
            }else{
                if (searchReults.count) {
                    RTLbs3DPOIMessageClass * poi = searchReults.firstObject;
                    NSDictionary * temp = @{@"point":[NSValue valueWithCGPoint:poi.POI_point],@"name":poi.POI_Name,@"floorID":poi.POI_Floor,@"buildingID":self.mapView.build};
                    [self topBoardViewShow];
                    
                    [self setNavigationPOI:temp startOrEnd:NO mapCenter:self.startPOI == nil];
                }
            }
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)backButtonAction:(UIButton *) sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//顶部选点控件action
- (IBAction)exchangeNavigationPointAction:(UIButton *)sender {
    NSDictionary * startTemp = self.startPOI;
    NSDictionary * endTemp = self.endPOI;
    
    self.startPOI = nil;
    self.endPOI = nil;
    
    [self setNavigationPOI:endTemp startOrEnd:YES mapCenter:NO];
    [self setNavigationPOI:startTemp startOrEnd:NO mapCenter:NO];
}
- (IBAction)changeStartAction:(UITapGestureRecognizer *)sender {
    RTMSearchViewController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMSearchViewController"];
    __block NSString * buildingID = self.mapView.build;
    controller.changeStartOrEndPoi = 1;
    controller.buildingID = buildingID;
    controller.floorID = self.mapView.floor;
    controller.handler = ^(NSArray *searchReults, RTMPoiUsingMode poiMode) {
        if (poiMode == 1) {
            if (self.location && [self.location.buildID isEqualToString:self.mapView.build]) {
                [self setNavigationPOI:@{@"name":@"我的位置",@"point":[NSValue valueWithCGPoint:CGPointMake(self.location.location_x, self.location.location_y)],@"floorID":self.location.floorID,@"buildingID":self.location.buildID} startOrEnd:YES mapCenter:NO];
            }
        }else if(poiMode == 2){
            if ([self.mapView.build isEqualToString:buildingID]) {
                if (searchReults.count) {
                    RTLbs3DPOIMessageClass * poi = searchReults.firstObject;
                    
                    [self setNavigationPOI:@{@"name":poi.POI_Name,@"point":[NSValue valueWithCGPoint:poi.POI_point],@"floorID":poi.POI_Floor,@"buildingID":self.mapView.build} startOrEnd:YES mapCenter:self.endPOI == nil];
                }
            }
        }
    };
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)changeEndAction:(UITapGestureRecognizer *)sender {
    RTMSearchViewController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMSearchViewController"];
    __block NSString * buildingID = self.mapView.build;
    controller.changeStartOrEndPoi = 2;
    controller.buildingID = buildingID;
    controller.floorID = self.mapView.floor;
    controller.handler = ^(NSArray *searchReults, RTMPoiUsingMode poiMode) {
        if (poiMode == 1) {
            if (self.location && [self.location.buildID isEqualToString:self.mapView.build]) {
                [self setNavigationPOI:@{@"name":@"我的位置",@"point":[NSValue valueWithCGPoint:CGPointMake(self.location.location_x, self.location.location_y)],@"floorID":self.location.floorID,@"buildingID":self.location.buildID} startOrEnd:NO mapCenter:NO];
            }
        }else if(poiMode == 2){
            if ([self.mapView.build isEqualToString:buildingID]) {
                if (searchReults.count) {
                    RTLbs3DPOIMessageClass * poi = searchReults.firstObject;
                    
                    [self setNavigationPOI:@{@"name":poi.POI_Name,@"point":[NSValue valueWithCGPoint:poi.POI_point],@"floorID":poi.POI_Floor,@"buildingID":self.mapView.build} startOrEnd:NO mapCenter:self.startPOI == nil];
                }
            }
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)cancelNavigationAction:(UIButton *) sender{
    [self topBoardViewHide];
    [self updateViewForNormalMode];
}
#pragma mark - 动画
/*
 底部选点view 显示与隐藏
 */
- (void)bottomViewShow{
    if (!self.bottomView.hidden) {
        return;
    }
    self.bottomView.hidden = NO;
    if (self.arNavigationButton.hidden) {
        self.bottomViewTopConstraint.constant = 0;
        self.positionButtonBottomConstraint.constant = 20 + self.bottomViewHeight;
    }else{
        self.bottomViewTopConstraint.constant = -self.arButtonHeight;
        self.positionButtonBottomConstraint.constant = 20 + self.bottomViewHeight + self.arButtonHeight;
    }
    
    
    [UIView animateWithDuration:0.24 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)bottomViewHide{
    if (self.bottomView.hidden) {
        return;
    }
    self.bottomViewTopConstraint.constant = self.bottomViewHeight;
    
    if (self.arNavigationButton.hidden) {
        self.positionButtonBottomConstraint.constant = 20;
    }else{
        self.positionButtonBottomConstraint.constant = 20 + self.arButtonHeight;
    }
    
    [UIView animateWithDuration:0.24 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bottomView.hidden = YES;
    }];
}

- (void)updateViewForNavigationMode{
    self.tempPOI = nil;
    self.startAnnotation = nil;
    self.endAnnotation = nil;
    self.searchView.hidden = YES;
    [self bottomViewHide];
    
    if (self.showAR) {
        self.arNavigationButton.hidden = NO;
        self.arNavigationButtonConstraint.constant = 0;
        self.positionButtonBottomConstraint.constant = 15 + self.arButtonHeight;
        [self.view layoutIfNeeded];
    }
}

- (void)updateViewForNormalMode{
    [self.mapView removeAnnotations];
    [self.mapView removeNavAnnotationsAndNavLine];
    [self bottomViewHide];
    self.searchView.hidden = NO;
    self.arNavigationButton.hidden = YES;
    self.arNavigationButtonConstraint.constant = -self.arButtonHeight;
    self.positionButtonBottomConstraint.constant = 20;
    [self.view layoutIfNeeded];
    
    self.topBoardStartLabel.text = @"请选择起点位置";
    self.topBoardStartLabel.textColor = [UIColor colorForEEEEEE];
    self.startPOI = nil;
    self.startAnnotation = nil;
    self.otherAnnotationCount = 0;
    
    self.topBoardEndLabel.text = @"请选择终点位置";
    self.topBoardEndLabel.textColor = [UIColor colorForEEEEEE];
    self.endPOI = nil;
    self.endAnnotation = nil;
}

/*
 顶部选点View动画
 */
- (void)topBoardViewShow{
    if (!self.topBoardView.hidden) {
        return;
    }
    self.cancelNavigationButton.hidden = NO;
    self.topBoardView.hidden = NO;
    self.topBoardTopConstraint.constant = 0;
    
    if (!self.startPOI && self.location && [self.location.buildID isEqualToString:self.mapView.build]) {
        [self setNavigationPOI:@{@"name":@"我的位置",@"point":[NSValue valueWithCGPoint:CGPointMake(self.location.location_x, self.location.location_y)],@"floorID":self.location.floorID,@"buildingID":self.location.buildID} startOrEnd:YES mapCenter:NO];
    }
    
    [UIView animateWithDuration:0.24 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)topBoardViewHide{
    if (self.topBoardView.hidden) {
        return;
    }
    self.cancelNavigationButton.hidden = YES;
    self.topBoardTopConstraint.constant = -CGRectGetHeight(self.topBoardView.frame);
    
    [UIView animateWithDuration:0.24 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.topBoardView.hidden = YES;
    }];
}

#pragma mark - 地图代理
- (void)mapViewLoadedSuccess:(RTLbsMapView *)rtmapView{
    [RTMapProgressHUD dismiss];
    
    if ([rtmapView.build isEqualToString:self.currentBuildingID]) {
        if (![self.currentFloorLabel.text isEqualToString:rtmapView.floor]) {
            for (int i = 0; i < self.floorsArr.count; i++) {
                NSString * floorID = [self.floorsArr[i] valueForKey:@"floor"];
                if ([floorID isEqualToString:rtmapView.floor]) {
                    [self.floorPickerView scrollToRow:i];
                    break;
                }
            }
           
            self.currentFloorLabel.text = rtmapView.floor;
            
        }
        
        if (self.navigationsArr.count) {
            [self.mapView drawNavigationLine:self.navigationsArr floorId:self.mapView.floor];
             self.mapView.navigationMode = RTLbsRoutePlanningModeNavigation;
        }
    }else{
        self.currentBuildingID = rtmapView.build;
        [self.mapService getBuildFloorInfo:self.currentBuildingID];
        if (self.navigationsArr.count) {
            [self updateViewForNormalMode];
        }
    }
    
    [self.mapView setMapViewPitchAngleOffset:50];
    
    if (self.isFirstLoadMap) {
        self.isFirstLoadMap = NO;
        if (self.navigationDestinationPOI) {
            NSString * name = self.navigationDestinationPOI[@"name"];
            if (name.length) {
                NSArray * pois = [rtmapView getMapViewAllPoiMessage];
                for (RTLbs3DPOIMessageClass * poi in pois) {
                    if ([poi.POI_Name isEqualToString:name]) {
                        self.otherAnnotationCount = 1;
                        RTLbs3DAnnotation * annotation = [[RTLbs3DAnnotation alloc] initWithMapPoint:poi.POI_point annoTitle:nil annoId:poi.POI_ID iconImage:[UIImage imageNamed:@"annotation"] floorID:poi.POI_Floor];
                        [self.mapView addAnnotation:annotation isShowPopView:NO setMapCenter:YES];
                        
                        break;
                    }
                }
            }
        }
    }
    
//    IbeaconLocation *ibeacon = [[IbeaconLocation alloc] init];
//    [self beaconManager:nil didUpdateToLocation:ibeacon withBeacons:nil];
//    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self beaconManager:nil didUpdateToLocation:nil withBeacons:nil];
//    }];
}

-(void)mapViewLoadedFaile:(RTLbsMapView *)rtmapView{
    [RTMapProgressHUD dismissWithError:@"地图加载失败"];
}

//地图点击
- (void)mapViewDidTapOnMapPoint:(CGPoint)point poiName:(NSString *)poiName poiID:(NSString *)ID shapType:(NSInteger)type{
    NSLog(@"用户点击了地图： %f %f",point.x,point.y);
    
    if (poiName.length) {
        [self showBottomViewWithMapPoint:point poiName:poiName];
    }else{
        [self bottomViewHide];
    }
}


//显示地图View
- (void) showBottomViewWithMapPoint:(CGPoint)point poiName:(NSString*)name {
    self.tempPOI = @{@"point":[NSValue valueWithCGPoint:point],@"name":name,@"floorID":self.mapView.floor,@"buildingID":self.mapView.build};
    self.bottomViewPOILabel.text = name;
    [self bottomViewShow];
}

- (void)navigationRequestFinish:(NSMutableArray *)navigationInfo navigationRountInflection:(NSMutableArray *)InflectionArrays routeStringArrays:(NSMutableArray *)routeString poiIndexArray:(NSMutableArray *)poiIndexArray totalDistance:(NSString *)distance{
    [RTMapProgressHUD dismiss];
    
    if(navigationInfo.count<2){
        return;
    }
    
    [self.mapView removeNavAnnotationsAndNavLine];
    self.otherAnnotationCount = 0;
    self.navigationsArr = navigationInfo;
    RTLbs3DNavigationInfo * firstNavigation = InflectionArrays.firstObject;
     NSLog(@"navigationRequestFinish:%@ %@",firstNavigation.navFloor,self.mapView.floor);
    
    if ([self.mapView.floor isEqualToString:firstNavigation.navFloor]) {
       
        [self.mapView drawNavigationLine:self.navigationsArr floorId:self.mapView.floor];
         self.mapView.navigationMode = RTLbsRoutePlanningModeNavigation;
        

    }else{
        NSLog(@"需要切换的楼层 ：%@",firstNavigation.navFloor);
        [self.mapView reloadMapWithBuilding:self.mapView.build andFloor:firstNavigation.navFloor];
    }
    [self updateViewForNavigationMode];
}

- (void)navigationRequestFail:(NSString *)error{
    [RTMapProgressHUD dismissWithError:@"获取导航数据失败"];
}

// 用户操作地图的回调
- (void) mapViewWithUserActionMap:(RTLbsMapView*)rtmapView {
    self.mapView.userTrackingMode =RLUserTrackingModeNone;
}

#pragma mark - 定位代理
//定位成功
- (void)beaconManager:(RTMapLocationManager *)manager
  didUpdateToLocation:(IbeaconLocation *)newLocation
          withBeacons:(NSArray *) beacons{
//    newLocation.buildID    = @"862200050030300012";
//    newLocation.floorID    = @"B1";
//    newLocation.location_x = 325;
//    newLocation.location_y = 252;

    NSLog(@"地图上面的定位点 （%f,%f）",newLocation.location_x,newLocation.location_y);
   
    if ([self.mapView.build isEqualToString:newLocation.buildID]) {
        self.location = newLocation;
        BOOL locationInCurrentFloor = [newLocation.buildID isEqualToString:self.mapView.build] && [newLocation.floorID isEqualToString:self.mapView.floor];
        
        [self.mapView drawMobilePositioningPoint:CGPointMake(newLocation.location_x, newLocation.location_y) AndBuild:newLocation.buildID AndFloor:newLocation.floorID locationImageName:@"location"];
        
        if (self.mapView.userTrackingMode != RLUserTrackingModeNone && locationInCurrentFloor) {
            self.mapView.userTrackingMode = RLUserTrackingModeNone;
        }
        
        if (!self.firstLocation) {
            self.firstLocation = YES;
            
            [self sendAppOpenLocationRequest];
        }
    }
}

//定位失败
-(void)beaconManager:( RTMapLocationManager *)manager didFailLocation:(NSDictionary *)result withBeacons:(NSArray *) beacons{
    self.location = nil;
}

#pragma mark - 地图信息查询代理
//获取建筑物楼层信息
- (void)getFloorInfoFinish:(NSDictionary *)floorInfo{
    self.title = floorInfo[@"name_chn"];
    self.floorsArr = floorInfo[@"floorinfo"];
    [self.floorPickerView reloadData];
}

-(void) getFloorInfoFail:(NSString *)error{
    
}
#pragma mark - 楼层选择器代理
- (NSInteger)numberOfRowsInFloorPickerView:(RTMFloorPickerView *)floorPickerView{
    return self.floorsArr.count;
}

- (NSDictionary *)floorPickerView:(RTMFloorPickerView *)floorPickerView floorInfoForRow:(NSInteger)row{
    return self.floorsArr[row];
}


- (void)floorPickerView:(RTMFloorPickerView *)floorPickerView didSelectRow:(NSInteger)row{
    NSDictionary * floorInfo = self.floorsArr[row];
    
    [RTMapProgressHUD show];
    [self.mapView reloadMapWithBuilding:self.currentBuildingID andFloor:floorInfo[@"floor"]];
}
@end
