//
//  AppDelegate.m
//  IOS8Frame
//
//  Created by dwolf on 14-9-17.
//  Copyright (c) 2014年 dwolf. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocialCore/UMSocialCore.h>
#import "XmlUtil.h"
#import "UserGuideViewController.h"
#import "AliManager.h"
#import "RTLbsMapManager.h"
#import "easyar3d/EasyAR3D.h"
#import "easyar3d/EasyARScene.h"
#import "SPARManager.h"
#import "CAMagicProximityKit/CAMagicProximityKit.h"
//#import "BaiduMobStat.h"
#import "LuanchAdvViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
//#import "Mixpanel/Mixpanel.h"
#import "Pingpp/Pingpp.h"
#import <Bugly/Bugly.h>
#import <easyar3d/EasyARSceneController.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

NSString *arkey = @"jrBfcp9lMhuTVrkXu9AzgDq6oYY4O9FnLD1dMmEMyJ5Ynh7m5VzF05KpMWko3l73a7rGQ5KDmMmEZFW18B5vVFMVP3PdtQ3uIVAmYzVvV03mHl3aD0rypaz5labQfyQdbf3djmJbcoEOcnRVHsqdxNOdHSehyVMmG5d3HgtKrp8mQaa9CSR2PZQzXB3h9Jpwu9x8BUxK";
RTLbsMapManager *_mapManager;
@interface AppDelegate ()<RTLbsVerifyDelegate,WXApiDelegate,CAMagicProximityManagerDelegate,JPUSHRegisterDelegate>

@end

////模拟器运行
//#if TARGET_OS_SIMULATOR
//@implementation EasyARSceneController
//@end
//@implementation EasyARScene
//- (void)setFPS:(int)fps{}
//- (void)loadJavaScript:(NSString *)uriPath{}
//- (void)loadJavaScript:(NSString *)uriPath content:(NSString *)content{}
//- (void)loadManifest:(NSString *)uriPath{}
//- (void)loadManifest:(NSString *)uriPath content:(NSString *)content{}
//- (void)preLoadTarget:(NSString *)targetDesc onLoadHandler:(void (^)(bool status)) onLoadHandler
//       onFoundHandler:(void (^)()) onFoundHandler onLostHandler:(void (^)()) onLostHandler{}
//- (void)sendMessage:(NSString *)name params:(NSArray<NSString *> *)params{}
//- (void)setMessageReceiver:(void (^)(NSString * name, NSArray<NSString *> * params))receiver{}
//+ (void)setUriTranslator:(NSString * (^)(NSString * uri))translator{}
//- (void)snapshot:(void(^)(UIImage *image))onSuccess failed:(void(^)(NSString *msg))onFailed{}
//- (void)setupCloud:(NSString *)server key:(NSString *)key secret:(NSString *)secret{}
//@end
//@implementation EasyAR3D
//+ (void) initialize:(NSString*)key{}
//@end
//#endif

@implementation AppDelegate
    
@synthesize wbtoken;
static int jpushCount = 0;

//-(void) onResp:(BaseResp*)resp
//{
//    
//}
//-(void)onReq:(BaseReq *)req
//{
//
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BOOL displayAdv = false;
    if([Util isFirstLuanch]){
        UserGuideViewController* guidVC = [[UserGuideViewController alloc] init];
        navigationController = [[UINavigationController alloc] initWithRootViewController:guidVC];
    }else{
         RootViewController* vc = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
         navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        displayAdv = true;
    }
    
    if(IS_IOS_7){
        navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    }else{
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    
    
   
    navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    
    [navigationController.navigationBar setTranslucent:YES];
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
//    navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.window setRootViewController:navigationController];
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    if(displayAdv){
        [self loadAdv];
        
        
    }
   

    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * member_id = [userDefaults valueForKey:@"member_id"];
    
    
    if (![Util isNull:member_id]) {
        [Global sharedClient].member_id = [userDefaults valueForKey:@"member_id"];
    
        [Global sharedClient].img_url = [userDefaults valueForKey:@"img_url"];
        
        [Global sharedClient].nick_name = [userDefaults valueForKey:@"nick_name"];
        
        [Global sharedClient].phone = [userDefaults valueForKey:@"phone"];
        [Global sharedClient].isoffice = [userDefaults valueForKey:@"isoffice"];
        
        [Global sharedClient].xjf_Cq_Xx = [userDefaults valueForKey:@"xjf_kq_xx"];
        [Global sharedClient].userCookies = [userDefaults valueForKey:@"userCookies"];
        [Global sharedClient].sessionId   = [userDefaults valueForKey:@"sessionId"];
        
        [Global sharedClient].markCookies =[userDefaults valueForKey:@"mall_id_des"];
        [Global sharedClient].markPrefix  =[userDefaults valueForKey:@"mall_url_prefix"];
        [Global sharedClient].shopName    =[userDefaults valueForKey:@"mall_name"];
        [Global sharedClient].markID      =[userDefaults valueForKey:@"mall_id"];
    }
    
    [self setUA];
    [self loadMagic];
   
    
    
    [EasyAR3D initialize:arkey];
    [EasyARScene setUriTranslator:^ NSString * (NSString * uri) {
        SPARManager * manager = [SPARManager sharedManager];
        return [manager getLocalPathForURL:uri];
    }];
//    JPush消息推送
    [self jpushSetup:launchOptions];
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    /* 设置微信的appKey和appSecret */ //好友
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APP_ID appSecret:WX_APPSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    //微信朋友圈
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WX_APP_ID appSecret:WX_APPSecret redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:ALI_APPKay appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    
    [self loadLocalNotif:launchOptions];
    [self loadRemoteNotif:launchOptions];
    
    [self loadData];
    //向微信注册
    [WXApi registerApp:WX_APP_ID];
    //智慧图
    _mapManager = [[RTLbsMapManager alloc]init];
    [_mapManager startVerifyLicense:@"JYRhO8qotr" delegate:self];
   
    //百度统计
//    [[BaiduMobStat defaultStat] startWithAppId:BAIDU_TONGJI_KEY];
    
    
   // [Mixpanel sharedInstanceWithToken:Mixpanel_TOKEN];
    [Pingpp setDebugMode:YES];
    
    //bugly
    [Bugly startWithAppId:@"5b9f05095b"];
    
    return YES;
}


-(void) loadAdv{
    LuanchAdvViewController* vc = [[LuanchAdvViewController alloc] init];
    vc.adViewdelegate = navigationController;
    [navigationController presentViewController: vc animated:NO completion:nil];
}
- (void)setUA{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
   NSString *newUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@"/CapitaStar2.0/%@", currentVersion]];//自定义需要拼接的字符串
    NSLog(@"newUserAgent=%@",newUserAgent);
   NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

}
- (void)loadMagic
{
    //MagicRroximityKit 用户感知第三方
    
        CAMagicConfig* config = [[CAMagicConfig alloc] initWithAppkey:MsgicAppKey  appSecret:MsgicAppSecret];
    
        config.userCode = [Global sharedClient].phone;
    
#ifdef DEBUG
    config.productionMode = NO;
#else
    config.productionMode = YES;
#endif
       // [config setupCertificate:@"kdxDevPush.p12" withPassword:@"123456"];
        //based on your decision
        config.alwaysUsingLocation = YES;
    
        [CAMagicProximityManager instance].delegate = self;
        [[CAMagicProximityManager instance] setup:config];
        [[CAMagicProximityManager instance] startMonitoring];
    
}
//获取网络数据
-(void)loadData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadcityregion"] parameters:nil  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray  *cityAry=dic[@"data"][@"citylist"];
            NSLog(@"%@",cityAry);
            [Global sharedClient].cityID=[cityAry copy];
           
        });
    }failue:^(NSDictionary *dic){
    }];
}



-(void)jpushSetup:(NSDictionary*) launchOptions{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    [JPUSHService setupWithOption:launchOptions appKey:@"305e371cb1057a295415bd8b" channel:@"" apsForProduction:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5), dispatch_get_main_queue(), ^{
        
        
        NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"member_id"];
        [JPUSHService setAlias:str completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
            NSLog(@"%@",iAlias);
        } seq:0];
    
    });
    
 //   [JPUSHService setTags:JPUSH_TAGS alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:)  object:self];
  // [JPUSHService setTags:JPUSH_TAGS alias:@"" fetchCompletionHandle:^(int iResCode,NSSet *iTags, NSString *iAlias){
  //  }];
    
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    
    if(iResCode != 0 && jpushCount < 3){
        jpushCount ++;
        //重新调用一次
        [JPUSHService setTags:JPUSH_TAGS alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:)  object:self];

        
    }else if(iResCode == 0){
        [Global sharedClient].isConnectUPushBase = YES;
    }
}

-(void) loadLocalNotif:(NSDictionary *)launchOptions{
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
    }
}
//通知跳转
-(void) loadRemoteNotif:(NSDictionary *)launchOptions{
    NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (pushInfo) {
        RootViewController *root = (RootViewController*)navigationController.topViewController;
        root.haveRemotemsg = YES;
    }
}


-(void)firstStartEvent{
    
    NSString *iKey=@"isFirstStart";
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [standardDefaults stringForKey:iKey];
    if(value == nil){
        
        [standardDefaults setValue:@"1" forKey:iKey];
        [standardDefaults synchronize];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    self.enterForeground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    RootViewController *root = (RootViewController*)navigationController.topViewController;
    // Required
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSLog(@"%@",userInfo);
    application.applicationIconBadgeNumber = (NSInteger)aps[@"badge"];
    
    if (application.applicationState == UIApplicationStateActive) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新消息" message:aps[@"alert"] preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [root.tabBar showIndex:2];
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [root presentViewController:alert animated:YES completion:^{

        }];
    }
}

//处理推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    RootViewController *root = (RootViewController*)navigationController.topViewController;
    // Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSLog(@"%@",userInfo);
    application.applicationIconBadgeNumber = (NSInteger)aps[@"badge"];
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新消息" message:aps[@"alert"] preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [root.tabBar showIndex:2];
//        }]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                    }]];
        [root presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}



#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
    
    BOOL result = [Pingpp handleOpenURL:url withCompletion:nil];
    
    if ([url.absoluteString containsString:@"wx"]) {
       result = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    if(!result){
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    
    if (!result) {
        // 其他如支付等SDK的回调
        //        if ([url.host isEqualToString:@"safepay"]) {
        //
        //            [AliManager aliMsgOpenURL:url];
        //
        //            return YES;
        //        };
        
        //result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
    
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   BOOL result = [Pingpp handleOpenURL:url withCompletion:nil];

    if ([url.absoluteString containsString:@"wx"]) {
        result = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    if(!result){
         result = [[UMSocialManager defaultManager] handleOpenURL:url];
    }
    return result;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{

    BOOL result = [Pingpp handleOpenURL:url withCompletion:nil];
    if (!result) {
        result = [[UMSocialManager defaultManager] handleOpenURL:url];
    }
   // BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if ([url.absoluteString containsString:@"wx"]) {
        result = [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];

    }
    if (!result) {
        // 其他如支付等SDK的回调
        //result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
//    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
//        NSLog(@"%@", result);
//        // 用通知实现支付成功的页面跳转
//        if ([result isEqualToString:@"success"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"enterSuccessView" object:nil];
//        }
//    }];
//return YES;
    
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
    application.applicationIconBadgeNumber =0;
}

#pragma mark - CAMagicProximityManagerDelegate
- (void)proximityManager:(CAMagicProximityManager *)proximityManager didUpdatePOIs:(NSArray *)pois
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(pois && pois.count)
        {
            UILocalNotification* notification = [[UILocalNotification alloc] init];
            if(pois.count < 2){
                return ;
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSDate *lasdTime =[defaults objectForKey:@"lastTime"];
            if (lasdTime && lasdTime.timeIntervalSinceNow > -3600) {
                return;
            }
            [defaults setObject:[NSDate date] forKey:@"lastTime"];
            [defaults synchronize];
            
            CAMagicPOI   * poi = pois[1];
            
            NSDictionary * dic = nil;
            if (poi.attachments) {
                dic = poi.attachments.firstObject;
            }
            
            if (dic && [dic.allKeys containsObject:@"message"]) {
                notification.alertBody = [dic[@"message"] stringByReplacingOccurrencesOfString:@"%place%" withString:poi.name];
            }
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.fireDate = [NSDate date];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    });
}


- (void)proximityManager:(CAMagicProximityManager *)proximityManager didFailToMonitorWithError:(NSError *)error
{
    NSLog(@"error: %@", error.localizedDescription);
}
//magic通知回调
- (void)proximityManager:(CAMagicProximityManager *)proximityManager didOpenNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo.description);
}

@end
