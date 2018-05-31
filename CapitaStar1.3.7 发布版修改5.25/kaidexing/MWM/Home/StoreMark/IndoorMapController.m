//
//  IndoorMapController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/28.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "IndoorMapController.h"
//#import "RTLbsWebService.h"
//#import "RTLbsBuildInfo.h"
//#import "RtmapBundle.h"
//#import "RTLbsMapView.h"
//#import "RTMapLocationManager.h"
//#import <AdSupport/AdSupport.h>
//#import "RTLbsRoutePlanClass.h"
//#import "RTLbsAnnotationClass.h"
//#import "KDSearchBar.h"
//#import "RTLbsPOIMessageClass.h"
#define btn_W  M_WIDTH(32)

//http://open2.rtmap.net
static NSString *const RTLbsServerAddress =  @"https://lbsapi.rtmap.com";

//@interface IndoorMapController()<RTMapLocationManagerDelegate,UISearchBarDelegate>
@interface IndoorMapController()<UISearchBarDelegate>
{
    //RTMapLocationManager *location;
    RTLbsMapView   *mapView;              //地图对象
    NSMutableArray *navigationPointList;//
    NSMutableArray *floorInfoArray;     //楼层信息数组
    BOOL        isBuildListShow;        //建筑物列表是否展开
    
    UIButton        *floorBtn;          //楼层btn
    UIScrollView    *floorView;         //楼层View
    
    NSString *logPath;
    NSDate *startDate;
    
    BOOL  isNetLoad;//判断网络是否提示过
    BOOL  isFistrMsg;//判断我是否提示过附近没有定位点
    BOOL  isFollow;//是否跟随
    BOOL  isBluetooth;//判断蓝牙是否提示过
    NSTimer * myTimer;
    //路径规划记录点击poi
    CGPoint navPoint;
    //记录定位到的位置
    CGPoint startPoint;
    BOOL isNav;
    //KDSearchBar *homeTextF;
    NSString    *searchWords;
}

@end

@implementation IndoorMapController

-(void)viewDidLoad{
    [super viewDidLoad];
//    self.navigationBarTitleLabel.text=@"楼层导航";
//    isFistrMsg=NO;
//    isFollow=NO;
//    navigationPointList = [[NSMutableArray alloc]init];
//    floorInfoArray = [[NSMutableArray alloc]init];
//    [self createSearchBarView];
//    location = [RTMapLocationManager sharedInstance];
//    [location startUpdatingLocation];
//    location.locationFreq=5;
//    location.delegate = self;
//    [location setPersistentMotionEnable];
//
//    isBuildListShow=NO;
//    mapView.userTrackingMode= RTLbsUserTrackingModeNone;
//    [self creatMapViewBuilding:_myBuildString floorID:_myFloorId];
//    [self dingweiBtn];
//
//    if(![Util isNull:_shopName]){
//        [self performSelector:@selector(timerzz) withObject:nil afterDelay:2.0];
//    }
}

//-(void)timerzz{
//    RTLbsWebService *webService = [[RTLbsWebService alloc] init];
//    webService.delegate = self;
//    webService.serverUrl = RTLbsServerAddress;
//    BOOL isSuccess =  [webService getKeywordSearch:_shopName buildID:_myBuildString Floor:_myFloorId];
//    if (isSuccess){
//        NSLog(@"关键词检索发送成功");
//    }else{
//        NSLog(@"关键词检索发送失败");
//    }
//
//}
//
////顶部搜索商家视图
//-(void)createSearchBarView{
//
//    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(45,27,WIN_WIDTH-89,30)];
//    headView.layer.masksToBounds=YES;
//    headView.layer.cornerRadius=M_WIDTH(5);
//    homeTextF=[[KDSearchBar alloc]initWithFrame:headView.bounds];
//    headView.backgroundColor=[UIColor whiteColor];
//    homeTextF.newFrame = homeTextF.frame;
//    homeTextF.placeholder=@"请输入商户名";
//    homeTextF.delegate=self;
//    homeTextF.searchBarStyle=UISearchBarStyleMinimal;
//    homeTextF.keyboardType=UIKeyboardAppearanceDefault;
//    homeTextF.returnKeyType=UIReturnKeySearch;
//    [headView addSubview:homeTextF];
//
//    [self.navigationBar addSubview:headView];
//
//    UIButton *cancelBtn = [[UIButton alloc]init];
//    cancelBtn.frame=self.rigthBarItemView.bounds;
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font=DESC_FONT;
//    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cencalTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.rigthBarItemView addSubview:cancelBtn];
//    self.rigthBarItemView.hidden=NO;
//}
//
//-(void)cencalTouch:(UIButton *)sender{
//    [homeTextF resignFirstResponder];
//}
//
////搜索功能开始
//// 关键字搜索
//- (void) keywordSearch {
//    RTLbsWebService *webService = [[RTLbsWebService alloc] init];
//    webService.delegate = self;
//    webService.serverUrl = RTLbsServerAddress;
//    BOOL isSuccess =  [webService getKeywordSearch:searchWords buildID:_myBuildString Floor:_myFloorId];
//    if (isSuccess){
//        NSLog(@"关键词检索发送成功");
//    }else{
//        NSLog(@"关键词检索发送失败");
//    }
//    [homeTextF resignFirstResponder];
//}
//
//#pragma mark - UISearchBarDelegate
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    searchWords   = searchText;
//}
//
//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self keywordSearch];
//}
//
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [homeTextF resignFirstResponder];
//}
//
////  搜索成功后调用该方法
//#pragma mark - RTLbsWebServiceDelegate
//- (void) searchRequestFinish:(NSArray *)poiMessageArray{
//
//    if(poiMessageArray.count == 0){
//        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"没有相符的结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertV show];
//        return;
//    }
//    [RTLbsAnnotationClass removeAnnotationsInMapView:mapView];
//    NSMutableArray *annoArr = [[NSMutableArray alloc]init];
//    BOOL isSearchResult = NO;
//    for (RTLbsPOIMessageClass *poiMc in poiMessageArray){
//
//        RTLbsAnnotation *anno = [[RTLbsAnnotation alloc]init];
//        anno.title = poiMc.POI_Name;
//        anno.icon =  [UIImage imageNamed:[RtmapBundle getMyDiBiaoPath:@"icon_gcoding.png"]];
//        anno.location = poiMc.POI_point;
//        anno.annotationFloor = poiMc.POI_Floor;
//        if ([poiMc.POI_Floor isEqualToString:_myFloorId]){
//            isSearchResult = YES;
//            [annoArr addObject:anno];
//            [RTLbsAnnotationClass addAnnotation:anno floorID:_myFloorId showPopView:NO mapView:mapView];
//        }
//    }
//    if (!isSearchResult){
//        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"没有相符的结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertV show];
//    }
//}
//
//
//// 搜索失败调用该方法
//- (void) searchRequestEndWithError:(NSError *)error {
//    //    NSLog(@"%@",error);
//
//    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"搜索失败" message:[NSString stringWithFormat:@"%ld",(long)error.code] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertV show];
//}
//// 搜索功能结束
//
////选择楼层视图
//-(void)xuanzeView{
//    RTLbsWebService *webService = [[RTLbsWebService alloc] init];
//    webService.delegate = self;
//    webService.serverUrl = RTLbsServerAddress;
//
//    BOOL isSuccess = [webService getBuildFloorInfo:_myBuildString];
//    if (isSuccess){
//        NSLog(@"获取建筑物楼层发送成功");
//    }else{
//        NSLog(@"获取建筑物楼层发送失败");
//    }
//
//    floorBtn = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(15),NAV_HEIGHT+M_WIDTH(15),btn_W,btn_W)];
//    floorBtn.layer.masksToBounds=YES;
//    floorBtn.layer.cornerRadius=5;
//    floorBtn.backgroundColor=UIColorFromRGB(0x56abe4);
//    [floorBtn setTitle:_myFloorId forState:UIControlStateNormal];
//    [floorBtn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:floorBtn];
//}
//
//#pragma mark iBeacon delegate
//- (void)beaconManager:(RTMapLocationManager *)manager didUpdateToLocation:(IbeaconLocation *)newLocation withBeacons:(NSArray *) beacons{
//    NSLog(@"定位成功 (%f,%f) floor = %@\n-----------------",newLocation.location_x,newLocation.location_y,newLocation.floorID);
//    startPoint = CGPointMake(newLocation.location_x,newLocation.location_y);
//    //MARK:此处需要对定位到的建筑物和楼层做下判断，与当前地图不同时需重新加载地图
//    if(![newLocation.buildID isEqualToString:mapView.buildingID]||![newLocation.floorID isEqualToString:mapView.floor]){
//        [mapView reloadMapWithBuildingInfo:newLocation.buildID floorIndx:newLocation.floorID];
//
//        _myBuildString = newLocation.buildID;
//        _myFloorId = newLocation.floorID;
//        NSString *str=[NSString stringWithFormat:@"%@",newLocation.floorID];
//        floorBtn.frame=CGRectMake(M_WIDTH(15),NAV_HEIGHT+M_WIDTH(15),btn_W+str.length>2?M_WIDTH(10):0,btn_W);
//        [floorBtn setTitle:str forState:UIControlStateNormal];
//        [mapView removePositionMark];
//
//    }else{
//        [mapView drawLocationPoint:CGPointMake(newLocation.location_x,newLocation.location_y) locationImageName:[RtmapBundle getMyDiBiaoPath:@"icon_loc_normal.png"] flickerColor:[UIColor blueColor] flickerRadius:30];
//    }
//    if (isNav) {
//        [RTLbsRoutePlanClass mapViewNavgationStartPoint:startPoint buildingID:_myBuildString floorID:_myFloorId mapView:mapView delegate:self];
//    }
//
//}
//
//-(void)beaconManager:(RTMapLocationManager *)manager didFailLocation:(NSDictionary *)result withBeacons:(NSArray *)beacons{
//    NSLog(@"定位出错 \n result = %@",result);
//    BOOL networkState =[result[@"networkState"]boolValue];
//
//    if (isNetLoad==NO) {
//        if (!networkState) {
//            isNetLoad=YES;
//            [SVProgressHUD showErrorWithStatus:@"您的网络不是很好"];
//            return;
//        }
//    }
//
//    BOOL isbluetoothState = [result[@"bluetoothState"]boolValue];
//    if (isBluetooth==NO) {
//        if (!isbluetoothState) {
//            isBluetooth=YES;
//            [SVProgressHUD showErrorWithStatus:@"请检查蓝牙是否打开"];
//
//            return;
//        }else{
//        }
//    }
//    int beaconCount = [result[@"beaconCount"]intValue];
//    if (isFistrMsg==NO) {
//        if (beaconCount==0) {
//            isFistrMsg=YES;
//            myTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timer2) userInfo:nil repeats:NO];
//            return;
//        }
//    }
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"HH:mm:ss"];
//    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
//    NSString *loc = [NSString stringWithFormat:@"lbsId:%@\nbuildId:%@ \nfloor:%@\nx:%fy:%f\ntime:%@\nresult_type:%@\n已运行时间:%f",@"",@"",@"",0.0,0.0,dateStr,@"",0.0];
//    NSLog(@"%@",loc);
//}
//
//-(void)timer2{
//    [SVProgressHUD showErrorWithStatus:@"附近没有定位点"];
//}
//
////- (UIView *)statusBarView {
////    UIView *statusBar = nil;
////    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
////    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
////    id object = [UIApplication sharedApplication];
////    if ([object respondsToSelector:NSSelectorFromString(key)]) {
////        statusBar = [object valueForKey:key];
////    }
////    return statusBar;
////}
////地图
//
//-(void)btnTouch:(UIButton*)sender
//{
//    //56abe4  0.7
//    CGFloat  jianju_Btn=M_WIDTH(10);
//    if (isBuildListShow==NO) {
//        isBuildListShow=YES;
//        floorView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(floorBtn.frame)+jianju_Btn,btn_W*2, WIN_HEIGHT-NAV_HEIGHT-btn_W-jianju_Btn-M_WIDTH(75))];
//        int i;
//
//        for (i=0 ; i<floorInfoArray.count; i++) {
//            RTLbsFloorInfo *floorInfo = [floorInfoArray objectAtIndex:i];
//            UIButton *btn = [[UIButton alloc]init];
//            btn.layer.masksToBounds=YES;
//            btn.layer.cornerRadius=5;
//            btn.backgroundColor=UIColorFromRGB(0x56abe4);
//            NSString *str=[NSString stringWithFormat:@"%@",floorInfo.floor];
//            if (str.length>2) {
//                btn.frame=CGRectMake(M_WIDTH(15),i*(btn_W+jianju_Btn),btn_W+M_WIDTH(10),btn_W);
//            }else{
//                btn.frame=CGRectMake(M_WIDTH(15),i*(btn_W+jianju_Btn),btn_W,btn_W);
//            }
//
//            [btn setTitle:str forState:UIControlStateNormal];
//            btn.tag=i;
//            [btn addTarget:self action:@selector(xuanzeTouch:) forControlEvents:UIControlEventTouchUpInside];
//            [floorView addSubview:btn];
//        }
//        floorView.contentSize=CGSizeMake(btn_W, floorInfoArray.count * (btn_W+jianju_Btn));
//        [self.view addSubview:floorView];
//    }else{
//        isBuildListShow=NO;
//         [floorView removeFromSuperview];
//    }
//}
//
//-(void)xuanzeTouch:(UIButton*)btn
//{
//    isBuildListShow=NO;
//    [floorView removeFromSuperview];
//    RTLbsFloorInfo *floorInfo = [floorInfoArray objectAtIndex:btn.tag];
//    NSString *str=[NSString stringWithFormat:@"%@",floorInfo.floor];
//
//    if (str.length>2) {
//        floorBtn.frame=CGRectMake(M_WIDTH(15),NAV_HEIGHT+M_WIDTH(15),btn_W+M_WIDTH(10),btn_W);
//    }else{
//        floorBtn.frame=CGRectMake(M_WIDTH(15),NAV_HEIGHT+M_WIDTH(15),btn_W,btn_W);
//    }
//    [floorBtn setTitle:str forState:UIControlStateNormal];
//    _myFloorId = floorInfo.floor;
//    [mapView reloadMapWithBuildingInfo:_myBuildString floorIndx:_myFloorId mapCenterPoint:CGPointZero mapScale:0];
//}
//
////定位按钮
//-(void)dingweiBtn{
//    UIButton *dingweiBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-btn_W-M_WIDTH(21), NAV_HEIGHT+M_WIDTH(12), btn_W+M_WIDTH(3), btn_W+M_WIDTH(3))];
//    [dingweiBtn setImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
//    [dingweiBtn addTarget:self action:@selector(dingweiTouch) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:dingweiBtn];
//}
//
////右上角定位事件
//-(void)dingweiTouch{
//    if (isFollow) {
//        isFollow=NO;
//        mapView.userTrackingMode=RTLbsUserTrackingModeNone;
//    }else{
//        isFollow=YES;
//        mapView.userTrackingMode=RTLbsUserTrackingModeFollow;
//    }
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    RTLbsWebService *webService = [[RTLbsWebService alloc] init];
//    webService.delegate = self;
//    webService.serverUrl = RTLbsServerAddress;
//    BOOL isSuccess = [webService getServiceBuildListOfCity:nil];
//    if (isSuccess)
//    {
//        NSLog(@"获取建筑物列表发送成功");
//    }
//    else
//    {
//        NSLog(@"获取建筑物列表发送失败");
//    }
//}
//
//- (void) creatMapViewBuilding:(NSString*)buildInfo floorID:(NSString*)floor
//{
//    if(mapView){
//        [mapView removeFromSuperview];
//        mapView = nil;
//    }
//    mapView = [[RTLbsMapView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT) buildingID:buildInfo floorID:floor scale:1500 delegate:self];
//    mapView.serverUrl = RTLbsServerAddress;
//    mapView.doubleTap = YES;
//    mapView.panGesture = YES;
//    mapView.fingerPinch = YES;
//    mapView.rotate = YES;
//    // 地图缩放尺度
//    mapView.minZoom = 10000;
//    mapView.maxZoom = 50;
//    [self.view addSubview:mapView];
//}
//
//#pragma mark - RTLbsMapViewDelegate
//- (void) mapView:(RTLbsMapView *)rtmapView didTapOnMapPoint:(CGPoint)point poiName:(NSString*)poiName poiID:(NSString *)ID shapType:(NSInteger)type
//{
////    NSLog(@"poiName = %@,ID = %@,type = %ld",poiName,ID,(long)type);
////    [mapView getPoiDesc:ID];
//
//    navPoint = point;
//
//    RTLbsAnnotation *anno = [[RTLbsAnnotation alloc]init];
//    anno.title = poiName;
//    anno.icon =  [UIImage imageNamed:@"PinDown3Green.png"];
//    anno.location = point;
//    anno.annotationFloor = _myFloorId;
//    anno.contentOffset = CGPointMake(7, 0);
//
//    [RTLbsAnnotationClass addAnnotation:anno floorID:_myFloorId showPopView:NO mapView:mapView];
//    if (poiName){
//        [self twoPointNav];
//    }
//}
//
//- (void) twoPointNav{
//
////    if(!isNav){
////        //开始规划时，清除上次的路线
////        [RTLbsRoutePlanClass removeNavAnnotationsAndNavLineInMapView:mapView];
////        [RTLbsRoutePlanClass mapViewNavgationStartPoint:navPoint buildingID:_myBuildString floorID:_myFloorId mapView:mapView delegate:self];
////        isNav = YES;
////    }else {
////        [RTLbsRoutePlanClass mapViewNavgationEndPoint:navPoint buildingID:_myBuildString floorID:_myFloorId mapView:mapView delegate:self];
////        isNav = NO;
////    }
//
//    //开始规划时，清除上次的路线
//    [RTLbsRoutePlanClass removeNavAnnotationsAndNavLineInMapView:mapView];
//
//    [RTLbsRoutePlanClass mapViewNavgationStartPoint:startPoint buildingID:_myBuildString floorID:_myFloorId mapView:mapView delegate:self];
//    [RTLbsRoutePlanClass mapViewNavgationEndPoint:navPoint buildingID:_myBuildString floorID:_myFloorId mapView:mapView delegate:self];
//    isNav=YES;
//}
//-(void)mapViewLoadedSuccess:(RTLbsMapView *)rtmapView loadedType:(RTLbsMapLoadedSuccessType)type{
//    //MARK:为保证跨层路径规划后切换楼层路线显示正常，此处需要调用地图绘制路径方法
//    if(navigationPointList.count>0)
//    {
//        [RTLbsRoutePlanClass drawNavigationLine:navigationPointList floorId:mapView.floor isDrawOtherFloorNavigationLine:YES mapView:mapView];
//    }
//}
//
//#pragma mark - 路径规划
//- (void) navigationRequestFinish:(NSMutableArray*)navigationInfo  navigationRountInflection:(NSMutableArray*)InflectionArrays    routeStringArrays:(NSMutableArray*)routeString totalDistance:(NSString*)distance{
//
//
//    navigationPointList = navigationInfo;
//    //MARK:在地图上绘制路径规划线路
//    if(navigationInfo.count>0)
//    {
//        [RTLbsRoutePlanClass drawNavigationLine:navigationInfo floorId:mapView.floor isDrawOtherFloorNavigationLine:YES mapView:mapView];
//    }
//
//}
//-(void)navigationRequestFail:(NSString *)error
//{
//    NSLog(@"路径规划失败:%@",error);
//}
//
//
//-(void)getPoiDescSuccess:(NSData *)jsonData
//{
//
//}
//#pragma mark - RTLbsWebServiceDelegate
//
//-(void)getBuildListOfCityFinish:(NSArray *)buildList{
//    [self xuanzeView];
//}
//
//-(void)getBuildListOfCityFail:(NSString *)error{
//
//}
//-(void)getBuildFloorInfoFinish:(RTLbsBuildInfo *)buildDetail{
//
//    [floorInfoArray removeAllObjects];
//    [floorInfoArray addObjectsFromArray:buildDetail.floorArray];
////    RTLbsFloorInfo *floorInfoModel = [buildDetail.floorArray firstObject];
//
//}
//-(void)getBuildFloorInfoFail:(NSString *)error{
//
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:YES];
//    [location stopUpdatingLocation];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
