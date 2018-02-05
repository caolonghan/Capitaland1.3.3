//
//  ARShowViewController.m
//  sightpDemo
//
//  Created by YangTengJiao on 16/9/22.
//  Copyright ¬© 2016Âπ?YangTengJiao. All rights reserved.
//

#import "ARShowViewController.h"
#import "DownLoadAnimationView.h"
#import "SPARManager.h"
#import "SPARPackage.h"
#import "SPARApp.h"
#import "easyar3d/EasyARScene.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ARWebViewController.h"
#import "ScanLineView.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIViewController+HUD.h"
#import "sys/utsname.h"

#define  KEY_USERNAME_PASSWORD @"kidEstate.getUUID"

#define kUrl @"https://copapi.easyar.cn"
#define ARScene (EasyARScene *)self.view

NSString* CloudKey = @"b5d3cc3abe3fafb6301ceae47a9548e5566a8cc0442899d1a3930fb9405b6c6b";
NSString* CloudUrl = @"di36.easyar.com:8080";
NSString* CloudSecret = @"5f5cb639b392e2ca545ebb77562a424e10e6b652ba3ec277ca658b93cac901ddad57da0e5609df6ef04f2035b5d276b819082cbe9e95f8041d78627e415fbb78";

@interface ARShowViewController ()
@property (strong, nonatomic)DownLoadAnimationView *loadAnimationView;

@property (strong, nonatomic)ScanLineView *scanLineView;

@property (strong, nonatomic)NSString *manifestURL;

@property (nonatomic, strong)Reachability *conn;
@property (nonatomic, strong)NSString *errorStr;

@property (nonatomic, strong)NSMutableArray *preloadedIdArray;
@property (nonatomic, strong)NSString *preLoadingId;

@property (nonatomic, strong)NSString *showId;
@property (nonatomic, strong)NSString *cameraType;

@property (nonatomic, strong)NSMutableArray *arcloudArray;
@property (nonatomic, strong)NSString* loadingArId;

@property (nonatomic, strong)NSString* lastestArid;
@property (nonatomic, assign)BOOL couldOpen;

@property (nonatomic, strong)NSString* elveID;

@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIImageView *btn_continue;
@property (nonatomic, assign) BOOL isShowContent;

@property (nonatomic, strong) UIImageView *hintImageView;
@property (nonatomic, strong) UIImageView *knowImageView;

@property(nonatomic, strong) UIImageView *btn_back;
@property(nonatomic, strong) UIImageView *btn_reset;
@property(nonatomic, strong) UIImageView *btn_change;
@property(nonatomic, strong) UIImageView *btn_takePhoto;
@property(nonatomic, strong) UIImageView *screenImageView;
@property(nonatomic, strong) UIImageView *btn_close;
@property(nonatomic, strong) UIImageView *btn_savePhoto;
@property(nonatomic, strong) UIImageView *hudImageView;

@property(nonatomic, assign) int takePhotoTimes;

@end

@implementation ARShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[EasyARScene alloc] initWithFrame:self.view.bounds];
    [self creatView];
	[ARScene setupCloud:CloudUrl key:CloudKey secret:CloudSecret];
    [self loadScene:@"scene"];
    self.couldOpen = YES;
    self.elveID = @"1";
    self.takePhotoTimes = 0;
    self.isShowContent = YES;
    
    __weak ARShowViewController *myself = self;
    [ARScene setMessageReceiver:^(NSString *name, NSArray<NSString *> *params) {
        [myself messageReceiverWith:name parms:params];
    }];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    int intTime = [[NSNumber numberWithDouble:time] intValue];
    NSString* timeStr = [NSString stringWithFormat:@"%d", intTime];
    
    int nonce = arc4random() % 1000000;
    NSString* nonceStr = [NSString stringWithFormat:@"%d", nonce];
    
    NSString* str = [NSString stringWithFormat:@"%d^%d^getSpirit", intTime, nonce];
    NSString* md5Str = [self md5:str];
    NSMutableString* sn = [[NSMutableString alloc] initWithString:md5Str];
    [sn insertString:@"Companycn" atIndex:10];
    NSString* snMD5 = [self md5:sn];
    
    NSLog(@"%@", snMD5);
    
    __weak ARShowViewController* weak_self = self;
    NSString* url = [NSString stringWithFormat:@"http://api.capitaland.com.cn/api/ar_spirit_activity?tp=getSpirit&mall_id=%@&member_id=%@&timestamp=%@&nonce=%@&sn=%@", self.mall_id, self.member_id, timeStr, nonceStr, snMD5];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary* dic = (NSDictionary *)responseObject;
        
        NSNumber* result = [dic objectForKey:@"result"];
        if ([result longValue] == 1) {
            NSString* elveName = [dic objectForKey:@"data"];
            if ([elveName isEqualToString:@"光精灵"]) {
                weak_self.elveID = @"1";
            }else if ([elveName isEqualToString:@"和平精灵"]) {
                weak_self.elveID = @"2";
            }else if ([elveName isEqualToString:@"花精灵"]) {
                weak_self.elveID = @"3";
            }else if ([elveName isEqualToString:@"树精灵"]) {
                weak_self.elveID = @"4";
            }else if ([elveName isEqualToString:@"雨精灵"]) {
                weak_self.elveID = @"5";
            }else if ([elveName isEqualToString:@"空气精灵"]) {
                weak_self.elveID = @"6";
            }
            
        }else {
           weak_self.elveID = @"1";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        self.elveID = @"1";
    }];
    
    NSString* uuid = [self getUUID];
    NSLog(@"%@", uuid);
}
- (void)dealloc {
    NSLog(@"dealloc");
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    if (!self.couldOpen) {
        self.couldOpen = !self.couldOpen;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.conn stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)networkStateChange {
    [self loadAgainWithNetwork];
}
- (void)becomeActive {
    [self loadAgainWithNetwork];
}
- (void)loadAgainWithNetwork {
    NSLog(@"loadAgainWithNetwork");
    if (self.errorStr) {
        NSLog(@"loadAgainWithNetwork error have");
        if ([self.errorStr isEqualToString:@"loadARID"]) {
            if (self.loadingArId.length > 0) {
                [self loadARID:self.loadingArId];
            }
        } else if ([self.errorStr isEqualToString:@"preloadApp"]) {

        } else {
            [self loadResourcesFile:self.errorStr];
        }
    }
}
- (void)creatView {
    self.preloadedIdArray = [[NSMutableArray alloc] init];
    
    self.scanLineView = [[ScanLineView alloc] initWithFrame:self.view.bounds];
    [self.scanLineView.backButton removeFromSuperview];
    [self.view addSubview:self.scanLineView];
    [self.scanLineView showScanLineView];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.loadAnimationView = [[DownLoadAnimationView alloc]  initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.loadAnimationView.center = self.view.center;
    [self.view addSubview:self.loadAnimationView];
    self.loadAnimationView.hidden = YES;
    
    UIImage* changeImage = [UIImage imageNamed:@"AR_change"];
    self.btn_change = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - changeImage.size.width - 20, 40, changeImage.size.width, changeImage.size.height)];
    self.btn_change.image = changeImage;
    UITapGestureRecognizer* changeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCameraAction)];
    self.btn_change.userInteractionEnabled = YES;
    [self.btn_change addGestureRecognizer:changeTap];
    [self.view addSubview:self.btn_change];
    
    UIImage* resetImage = [UIImage imageNamed:@"AR_reset"];
    self.btn_reset = [[UIImageView alloc] initWithFrame:CGRectMake(self.btn_change.frame.origin.x - resetImage.size.width - 20, 40, resetImage.size.width, resetImage.size.height)];
    self.btn_reset.image = resetImage;
    UITapGestureRecognizer* resetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetAction)];
    self.btn_reset.userInteractionEnabled = YES;
    [self.btn_reset addGestureRecognizer:resetTap];
//    [self.view addSubview:self.btn_reset];
    
    UIImage* takePhotoImage = [UIImage imageNamed:@"AR_takePhoto"];
    self.btn_takePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - takePhotoImage.size.width / 2, self.view.frame.size.height - takePhotoImage.size.height - 60, takePhotoImage.size.width, takePhotoImage.size.height)];
    self.btn_takePhoto.image = takePhotoImage;
    UITapGestureRecognizer* takePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotoAction)];
    self.btn_takePhoto.userInteractionEnabled = YES;
    [self.btn_takePhoto addGestureRecognizer:takePhotoTap];
    [self.view addSubview:self.btn_takePhoto];
    
    UIImage* backImage = [UIImage imageNamed:@"AR_back"];
    self.btn_back = [[UIImageView alloc] initWithImage:backImage];
    self.btn_back.image = backImage;
    self.btn_back.center = CGPointMake(30, self.btn_change.center.y);
    UITapGestureRecognizer* backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    self.btn_back.userInteractionEnabled = YES;
    [self.btn_back addGestureRecognizer:backTap];
    [self.view addSubview:self.btn_back];
    
    self.screenImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.screenImageView];
    self.btn_close = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AR_cancle"]];
    self.btn_close.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height - 80);
    UITapGestureRecognizer* closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    self.btn_close.userInteractionEnabled = YES;
    [self.btn_close addGestureRecognizer:closeTap];
    [self.view addSubview:self.btn_close];
    self.btn_savePhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AR_save"]];
    self.btn_savePhoto.center = CGPointMake(self.view.frame.size.width * 3 / 4, self.view.frame.size.height - 80);
    UITapGestureRecognizer* savePhotoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(savePhoto)];
    self.btn_savePhoto.userInteractionEnabled = YES;
    [self.btn_savePhoto addGestureRecognizer:savePhotoTap];
    [self.view addSubview:self.btn_savePhoto];
    self.btn_close.hidden = YES;
    self.btn_savePhoto.hidden = YES;
    
    CGRect saveBtnRect = self.btn_savePhoto.frame;
    UIImage* hudImage = [UIImage imageNamed:@"AR_hud"];
    self.hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(saveBtnRect.origin.x + saveBtnRect.size.width / 4 - hudImage.size.width, saveBtnRect.origin.y - hudImage.size.height - 5, hudImage.size.width, hudImage.size.height)];
    self.hudImageView.image = hudImage;
    [self.view addSubview:self.hudImageView];
    self.hudImageView.hidden = YES;

    self.screenImageView.hidden = YES;
    self.btn_reset.hidden = YES;
    self.btn_change.hidden = YES;
    self.btn_takePhoto.hidden = YES;
    
    self.BGView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.BGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.contentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AR_contentHUD"]];
    self.contentImageView.center = self.view.center;
    self.contentImageView.userInteractionEnabled = YES;
    [self.BGView addSubview:self.contentImageView];
    CGRect contentImageRect = self.contentImageView.frame;
    UIImage* continueImage = [UIImage imageNamed:@"AR_continue"];
    self.btn_continue = [[UIImageView alloc] initWithFrame:CGRectMake(contentImageRect.size.width * 2 / 5, contentImageRect.size.height - continueImage.size.height - 10, continueImage.size.width, continueImage.size.height)];
    self.btn_continue.image = continueImage;
    UITapGestureRecognizer* continueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continueToTakePhoto)];
    self.btn_continue.userInteractionEnabled = YES;
    [self.btn_continue addGestureRecognizer:continueTap];
    [self.contentImageView addSubview:self.btn_continue];
    [self.view addSubview:self.BGView];
    
    
    self.hintImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AR_hint"]];
    self.hintImageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height  * 0.45);;
    [self.BGView addSubview:self.hintImageView];
    UIImage* knowImage = [UIImage imageNamed:@"AR_know"];
    self.knowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - knowImage.size.width / 2, self.hintImageView.frame.origin.y + self.hintImageView.frame.size.height + knowImage.size.height, knowImage.size.width, knowImage.size.height)];
    self.knowImageView.image = knowImage;
    UITapGestureRecognizer* knowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(know)];
    self.knowImageView.userInteractionEnabled = YES;
    [self.knowImageView addGestureRecognizer:knowTap];
    [self.BGView addSubview:self.knowImageView];
    
    self.BGView.hidden = YES;
    self.contentImageView.hidden = YES;
    self.btn_continue.hidden = YES;
    self.hintImageView.hidden = YES;
    self.knowImageView.hidden = YES;
    
    self.manifestURL = nil;
}
- (void)messageReceiverWith:(NSString *)name parms:(NSArray *)array {
    
    __weak ARShowViewController* weak_self = self;
    if ([name isEqualToString:@"request:JsNativeBinding.AnimationEnd"]) {
        NSLog(@"response:JsNativeBinding.AnimationEnd %@",array);
        
        if (weak_self.isShowContent) {
            weak_self.BGView.hidden = NO;
            weak_self.contentImageView.hidden = NO;
            weak_self.btn_continue.hidden = NO;
            
            [ARScene sendMessage:@"request:NativeJsBinding.ShowTopUI" params:@[]];
        }else {
            weak_self.isShowContent = !weak_self.isShowContent;
        }
        
    } else if ([name isEqualToString:@"response:JsNativeBinding.getCameraDeviceType"]) {
        NSLog(@"response:JsNativeBinding.getCameraDeviceType %@",array);
        weak_self.cameraType = array[0];
    } else if ([name isEqualToString:@"request:JsNativeBinding.targetLost"]) {
        NSLog(@"response:JsNativeBinding.targetLost %@",array);
        [weak_self JSMeaasgeTargetLost:array];
    } else if ([name isEqualToString:@"request:JsNativeBinding.targetFound"]) {
        NSLog(@"response:JsNativeBinding.targetFound %@",array);
        [weak_self JSMeaasgeTargetFound:array];
    } else if ([name isEqualToString:@"request:JsNativeBinding.showNativeButton"]) {
        NSLog(@"request:JsNativeBinding.showNativeButton %@",array);
        [weak_self JSMeaasgeShowNativeButtonWithName:array[0]];
    } else if ([name isEqualToString:@"request:JsNativeBinding.closeNativeButton"]) {
        NSLog(@"request:JsNativeBinding.closeNativeButton %@",array);
        [weak_self JSMeaasgeHiddenNativeButtonWithName:array[0]];
    } else if ([name isEqualToString:@"request:JsNativeBinding.GameStart"]) {
        
        [ARScene sendMessage:@"request:NativeJsBinding.GetPicture" params:@[ weak_self.elveID ]];
        
    }else if ([name isEqualToString:@"request:JsNativeBinding.getMetaData"]) {
        [weak_self JSMeaasgeGetMetaData:array[0]];
    }else if ([name isEqualToString:@"request:JsNativeBinding.FinishLoading"]) {
        weak_self.loadAnimationView.hidden = YES;
        
        weak_self.BGView.hidden = NO;
        weak_self.hintImageView.hidden = NO;
        weak_self.knowImageView.hidden = NO;
        
        [ARScene sendMessage:@"request:NativeJsBinding.ShowTopUI" params:@[]];
        
        weak_self.btn_reset.hidden = NO;
        weak_self.btn_change.hidden = NO;
        weak_self.btn_takePhoto.hidden = NO;
        
        [ARScene sendMessage:@"request:NativeJsBinding.showARWithTrack" params:@[]];
    }else {
        NSLog(@"name error %@",name);
    }
}

/**
 *  32位md5加密算法
 *
 *  @param str 传入要加密的字符串
 *
 *  @return NSString
 */
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}
#pragma mark - JS Message Use
- (void)JSMeaasgeOpenWebView:(NSString *)url {
    
    if (self.couldOpen) {
        ARWebViewController* arwebVC = [ARWebViewController new];
        
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        int intTime = [[NSNumber numberWithDouble:time] intValue];
        NSString* timeStr = [NSString stringWithFormat:@"%d", intTime];
        
        int nonce = arc4random() % 1000000;
        NSString* nonceStr = [NSString stringWithFormat:@"%d", nonce];
        
        NSString* str = [NSString stringWithFormat:@"%d^%d^getMemberLuckdraw", intTime, nonce];
        NSString* md5Str = [self md5:str];
        NSMutableString* sn = [[NSMutableString alloc] initWithString:md5Str];
        [sn insertString:@"Companycn" atIndex:10];
        NSString* snMD5 = [self md5:sn];
        
        NSLog(@"%@", snMD5);
        
        NSString* Url = [NSString stringWithFormat:@"http://mall.companycn.net/SpriteActivity/index?tp=getMemberLuckdraw&mall_id=11&member_id=6016&timestamp=%@&nonce=%@&sn=%@", timeStr, nonceStr, snMD5];
        arwebVC.url = Url;
        UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:arwebVC];
        [self presentViewController:navi animated:YES completion:nil];
        self.couldOpen = !self.couldOpen;
    }

}
- (void)JSMeaasgeTargetLost:(NSArray *)array {
    if (self.preLoadingId) {
        return;
    }
    [self showUntracking];
    [ARScene sendMessage:@"request:NativeJsBinding.showARWithIMU" params:@[]];
}
- (void)JSMeaasgeTargetFound:(NSArray *)array {
    if (self.preLoadingId) {
        return;
    }
    if ([self.showId isEqualToString:array[0]]) {
        [self showFinding];
        return;
    }
    [self showFinding];
    self.showId = array[0];
//    [ARScene sendMessage:@"request:NativeJsBinding.hideAR" params:@[]];
//    [ARScene sendMessage:@"request:NativeJsBinding.showARWithTrack" params:@[]];
}
- (void)JSMeaasgeShowNativeButtonWithName:(NSString *)name {
    if ([name isEqualToString:@"takePhoto"]) {
//        self.tackePictureButton.hidden = NO;
    } else if ([name isEqualToString:@"changeCamera"]) {
//        self.changeCameraButton.hidden = NO;
    } else if ([name isEqualToString:@"reset"]) {
//        self.resetButton.hidden = NO;
    } else {
        NSLog(@"JSMeaasgeShowNativeButtonWithName error %@",name);
    }
}
- (void)JSMeaasgeHiddenNativeButtonWithName:(NSString *)name {
    if ([name isEqualToString:@"takePhoto"]) {
//        self.tackePictureButton.hidden = YES;
    } else if ([name isEqualToString:@"changeCamera"]) {
//        self.changeCameraButton.hidden = YES;
    } else if ([name isEqualToString:@"reset"]) {
//        self.resetButton.hidden = YES;
    } else {
        NSLog(@"JSMeaasgeHiddenNativeButtonWithName error %@",name);
    }
}
- (void)JSMeaasgeGetMetaData:(NSString *)data {
    NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSString *meta = [[dict[@"images"] firstObject] objectForKey:@"meta"];
    NSData *metaData = [[NSData alloc] initWithBase64EncodedString:meta options:0];
    NSString *m = [[NSString alloc] initWithData:metaData encoding:NSUTF8StringEncoding];
    
    NSData *json = [m dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableContainers error:nil];
    
    NSString *arId =d[@"loadUuid"];
    
    if (self.lastestArid.length >0) {
        if (![self.lastestArid isEqualToString:arId]) {
//            [ARScene sendMessage:@"request:NativeJsBinding.StartScan" params:@[ @"false" ]];
        }else {
//            [ARScene sendMessage:@"request:NativeJsBinding.StartScan" params:@[ @"true" ]];
        }
    }
    
    if (!self.arcloudArray) {
        self.arcloudArray = [[NSMutableArray alloc] init];
    }
    for (NSString *str in self.arcloudArray) {
        if ([str isEqualToString:arId]) {
            return;
        }
    }

    if (self.loadingArId.length > 0) {
        return;
    }else {
        self.loadingArId = arId;
        [self loadARID:arId];
        [self.arcloudArray addObject:arId];
    }
    
}

#pragma mark - showUI type
- (void)showUntracking {
    NSLog(@"AR View type showUntracking");
    [self.scanLineView hiddenScanLineView];
//    self.closeButton.hidden = NO;
//    self.btn_center.hidden = NO;
}
- (void)showFinding {
    NSLog(@"AR View type showFinding");
    [self.scanLineView hiddenScanLineView];
//    self.closeButton.hidden = YES;
//    self.btn_center.hidden = YES;
}
- (void)showLoast {
    NSLog(@"AR View type showLoast");
    [self.scanLineView showScanLineView];
//    self.closeButton.hidden = YES;
//    self.btn_center.hidden = YES;
//    self.changeCameraButton.hidden = YES;
//    self.resetButton.hidden = YES;
//    self.tackePictureButton.hidden = YES;
}

#pragma mark - ButtonActive
- (void) backAction {
    
    NSString* uuid = [self getUUID];
    
    NSString* url = [NSString stringWithFormat:@"https://www.shichen.club/rest/count/add?targetId=%@&takePhotoTimes=%d", uuid, self.takePhotoTimes];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
    
    NSLog(@"scanLineViewBackButton");
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)continueToTakePhoto {
    
    self.BGView.hidden = YES;
    self.contentImageView.hidden = YES;
    self.btn_continue.hidden = YES;
    [ARScene sendMessage:@"request:NativeJsBinding.HideTopUI" params:@[]];
}

- (void)know {
    
    self.BGView.hidden = YES;
    self.hintImageView.hidden = YES;
    self.knowImageView.hidden = YES;
    
    [ARScene sendMessage:@"request:NativeJsBinding.HideTopUI" params:@[]];
}

- (void)closeButton:(UIButton *)button {
    NSLog(@"closeButton");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeCameraAction {
    NSLog(@"changeCameraButton");
    [ARScene sendMessage:@"request:NativeJsBinding.changeCameraDeviceType" params:@[]];
    [ARScene sendMessage:@"request:NativeJsBinding.getCameraDeviceType" params:@[]];
    [self resetAction];
}

- (void)resetAction {
    NSLog(@"resetButton");
    [ARScene sendMessage:@"request:NativeJsBinding.resetContent" params:@[]];
}

- (void) setCenter {
    EasyARScene* scene = (EasyARScene*)self.view;
    [scene sendMessage:@"request:NativeJsBinding.JuZhong" params:@[]];
}

- (void)takePhotoAction {
    NSLog(@"tackePictureButton");
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"]) {
        
        UIImage* image = [self customSnapShot];
        self.takePhotoTimes++;
        self.screenImageView.hidden = NO;
        self.screenImageView.image = image;
        self.btn_close.hidden = NO;
        self.btn_savePhoto.hidden = NO;
        self.hudImageView.hidden = NO;
        
        
        [ARScene sendMessage:@"request:NativeJsBinding.ShowTopUI" params:@[]];
        
    }else {
        __weak ARShowViewController* weak_self = self;
        [ARScene snapshot:^(UIImage *image) {
            
            weak_self.takePhotoTimes++;
            weak_self.screenImageView.hidden = NO;
            weak_self.screenImageView.image = image;
            weak_self.btn_close.hidden = NO;
            weak_self.btn_savePhoto.hidden = NO;
            weak_self.hudImageView.hidden = NO;
            
            [ARScene sendMessage:@"request:NativeJsBinding.ShowTopUI" params:@[]];
            
        } failed:^(NSString *msg) {
            NSLog(@"msg %@",msg);
        }];
    }
    
    self.isShowContent = NO;
}

- (UIImage *)customSnapShot {

    self.btn_back.hidden = YES;
    self.btn_reset.hidden = YES;
    self.btn_change.hidden = YES;
    self.btn_takePhoto.hidden = YES;
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.btn_back.hidden = NO;
    self.btn_reset.hidden = NO;
    self.btn_change.hidden = NO;
    self.btn_takePhoto.hidden = NO;
    
    return image;
}

- (void) close {
    
    self.isShowContent = YES;
    self.screenImageView.image = nil;
    self.screenImageView.hidden = YES;
    self.btn_close.hidden = YES;
    self.btn_savePhoto.hidden = YES;
    self.hudImageView.hidden = YES;
    [ARScene sendMessage:@"request:NativeJsBinding.HideTopUI" params:@[]];
}

- (void) savePhoto {
    UIImage* image = self.screenImageView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    [ARScene sendMessage:@"request:NativeJsBinding.HideTopUI" params:@[]];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"save to System photo album error %@",error);
        
        [self showHint:@"保存到相册失败"];
        
    } else {
        NSLog(@"save to System photo album Success");
        
        [self showHint:@"成功保存到相册"];
     
        if (self.couldOpen) {
            self.screenImageView.hidden = YES;
            self.screenImageView.image = nil;
            self.btn_close.hidden = YES;
            self.btn_savePhoto.hidden = YES;
            self.hudImageView.hidden = YES;
            ARWebViewController* arwebVC = [ARWebViewController new];
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            int intTime = [[NSNumber numberWithDouble:time] intValue];
            NSString* timeStr = [NSString stringWithFormat:@"%d", intTime];
            int nonce = arc4random() % 1000000;
            NSString* nonceStr = [NSString stringWithFormat:@"%d", nonce];
            NSString* str = [NSString stringWithFormat:@"%d^%d^getMemberLuckdraw", intTime, nonce];
            NSString* md5Str = [self md5:str];
            NSMutableString* sn = [[NSMutableString alloc] initWithString:md5Str];
            [sn insertString:@"Companycn" atIndex:10];
            NSString* snMD5 = [self md5:sn];
            NSLog(@"%@", snMD5);
            NSString* Url = [NSString stringWithFormat:@"http://mall.capitaland.com.cn/SpriteActivity/index?tp=getMemberLuckdraw&mall_id=%@&member_id=%@&timestamp=%@&nonce=%@&sn=%@", self.mall_id, self.member_id, timeStr, nonceStr, snMD5];
            arwebVC.url = Url;
            UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:arwebVC];
            [self presentViewController:navi animated:YES completion:nil];
            self.couldOpen = !self.couldOpen;
            
        }
    }
        
}
#pragma mark - preloadApp loadScene loadManifest loadARID
- (void)loadScene:(NSString*)path{
    NSString * fName = [[NSBundle mainBundle] pathForResource:path ofType:@"js"];
    if (ARScene != nil) {
        [ARScene loadJavaScript:path content:[NSString stringWithContentsOfFile:fName encoding:NSUTF8StringEncoding error:nil]];
    }
}
- (void)loadARID:(NSString*)arid{
    [self.scanLineView hiddenScanLine];
    SPARManager *sparMan = [SPARManager sharedManager];
    [sparMan setServerAddress:kUrl];
    [sparMan setServerAccessTokens:ARAppKey secret:ARAppSecret];
    
    __weak ARShowViewController * myself = self;
    [sparMan loadApp:arid completionHandler:^(SPARApp *app, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Error: %@", error);
                myself.errorStr = @"loadARID";
                myself.loadAnimationView.hidden = YES;
            } else {
                myself.errorStr = nil;
                myself.lastestArid = self.loadingArId;
//                myself.loadingArId = nil;
                NSString* manifestURL = [app.package getManifestURL];
                NSLog(@"%@", manifestURL);
                [(EasyARScene*)myself.view loadManifest:manifestURL];
            }
        });
    } progressHandler:^(NSString *taskName, float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            myself.errorStr = @"loadARID";
            NSLog(@"%@: %.2f%%", taskName, progress * 100);
            [myself showProgressWith:taskName Progress:progress];
        });
    }];
}
- (void)loadResourcesFile:(NSString*)targetDesc{
    if (targetDesc == nil)
        return;
    if (self.preLoadingId) {
        return;
    }
    self.preLoadingId = [self getUidWithtargetDesc:targetDesc];
//    [self.scanLineView hiddenScanLine];
    self.showId = nil;
    [ARScene sendMessage:@"request:NativeJsBinding.hideAR" params:@[]];
    __weak ARShowViewController *myself = self;
    SPARManager *sparMan = [SPARManager sharedManager];
    SPARApp *app = [sparMan getAppByTargetDesc:targetDesc];
    [app deployPackage:NO completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [myself.scanLineView showScanLine];
            myself.preLoadingId = nil;
            if (error) {
                NSLog(@"Error: %@", error);
                myself.errorStr = targetDesc;
                myself.loadAnimationView.hidden = YES;
                return;
            }
            myself.errorStr = nil;
            [(EasyARScene*)myself.view loadManifest:[app.package getManifestURL]];
            [myself.preloadedIdArray addObject:[myself getUidWithtargetDesc:targetDesc]];
        });
    } progressHandler:^(NSString *taskName, float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@: %.2f%%", taskName, progress * 100);
            [myself showProgressWith:taskName Progress:progress];
        });
    }];
}
- (void)showProgressWith:(NSString *)taskName Progress:(float)progress {
    if ([taskName isEqualToString:@"Download"]) {
        [self.scanLineView hiddenScanLine];
        self.loadAnimationView.hidden = NO;
        self.loadAnimationView.centerLabel.text = [NSString stringWithFormat:@"loading\n%.2f%%",progress*100];
    }
    if (progress >= 1) {

        self.loadAnimationView.centerLabel.text = [NSString stringWithFormat:@"loading"];

    }
}
- (void)preloadApp:(NSString *)preloadID {
    SPARManager *sparMan = [SPARManager sharedManager];
    [sparMan setServerAddress:kUrl];
    [sparMan setServerAccessTokens:ARAppKey secret:ARAppSecret];
    __weak ARShowViewController *myself = self;
    [sparMan preloadApps:preloadID completionHandler:^(NSArray *apps, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Error: %@", error);
                myself.errorStr = @"preloadApp";
                return;
            }
            myself.errorStr = nil;
            for (SPARApp *app in apps) {
                NSString *targetURL = [app getTargetURL];
                NSLog(@"targetURL: %@", targetURL);
                NSString *targetDesc = [app getTargetDesc];
                NSLog(@"targetDesc: %@", targetDesc);
                
                [(EasyARScene*)myself.view preLoadTarget:targetDesc onLoadHandler:^(bool status) {
                    if (!status)
                        NSLog(@"fail to load preload target into tracker");
                    else
                        NSLog(@"loaded preload target into tracker");
                } onFoundHandler:^() {
                    NSLog(@"target found");
                    [myself preloadFind:targetDesc];
                } onLostHandler:^() {
                    NSLog(@"target lost");
                    [myself preloadLoast:targetDesc];
                }];
            }
        });
    } progressHandler:^(NSString *taskName, float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@: %.2f%%", taskName, progress * 100);
        });
    }];
}

- (void)preloadFind:(NSString *)targetDesc {
    NSLog(@"preloadFind");
    if (self.preLoadingId == nil && ![self.preloadedIdArray containsObject:[self getUidWithtargetDesc:targetDesc]]) {
        NSLog(@"preloadFind loadManifest");
        [self loadResourcesFile:targetDesc];
    }
}

- (NSString *)getUidWithtargetDesc:(NSString *)targetDesc {
    NSLog(@"getUidWithtargetDesc");
    NSData *jsonData = [targetDesc dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *imageArray = dict[@"images"];
    for (NSDictionary *imageDict in imageArray) {
        return imageDict[@"uid"];
    }
    return nil;
}
- (void)preloadLoast:(NSString *)targetDesc {
    NSLog(@"preloadLoast");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark statisticsMethod
- (NSString *)getUUID {
    
    NSString * strUUID = (NSString *)[self load:KEY_USERNAME_PASSWORD];
    
    // 首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [self save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}

- (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

- (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


- (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}



@end
