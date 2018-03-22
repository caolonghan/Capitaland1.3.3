//
//  WXCamerasViewViewController.m
//  WXCustomCamera
//
//  Created by wx on 16/7/8.
//  Copyright © 2016年 WX. All rights reserved.
//

#import "WXCamerasViewViewController.h"
#import "WXCameraCoverView.h"
#import "WXAVCamPreView.h"
#import "WXImageScrollView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIViewExt.h"
//#import "WXDataService.h"
#import "LognAlerView.h"
#import "MBProgressHUD.h"
#import "CompanyVC.h"
#import "MBProgressHUD+Add.h"
#import "uploadPicViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define kfont @"Helvetica"
#define kfontBold @"Helvetica-Bold"

//boundary
#define HQBoundary @"com.hq"

//换行
#define HQNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

//将字符串编码
#define HQEncode(string) [string dataUsingEncoding:NSUTF8StringEncoding]



#define ColorAlpha(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface WXCamerasViewViewController ()<UIImagePickerControllerDelegate,LognAlerViewdelegate>
/**AVCaptureSession对象来执行输入设备和输出设备之间的数据传递*/
@property (nonatomic, strong) AVCaptureSession* session;
/**输入设备*/
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**照片输出流*/
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**预览图层*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, assign) CGRect roundRect;
/**装下面button的View*/
@property (nonatomic,weak)UIView * buttonView;
/**选择照片的View*/
@property (nonatomic,weak)UIView * chooseView;
/**选择照片的Button*/
@property (nonatomic,weak)UIButton * usePhotoButton;
/**拍照按钮*/
@property (nonatomic,weak)UIButton * takePhotoButton;
/**闪光灯的按钮*/
@property (nonatomic,weak)UIButton * flashButton;
/**前后摄像头的按钮*/
@property (nonatomic,weak)UIButton * changeCameraButton;
/**显示图片的*/
@property (nonatomic,strong)WXImageScrollView * imageScrollView;
/**遮盖View*/
@property (nonatomic,strong)WXCameraCoverView * cameraCoverView;
/**保存时拍照还是相册图*/
@property (nonatomic, assign) BOOL photoFromCamera;
/**从相册选择的按钮*/
@property (nonatomic, assign) BOOL albumeButton;
/**判断前后摄像头的状态*/
@property (nonatomic, assign) BOOL isUsingFrontFacingCamera;
/**判断闪光灯的状态*/
@property (nonatomic, assign) BOOL flashModeOn;

@end

@implementation WXCamerasViewViewController{

    UIView *whview;
    UIView*view;
    NSDictionary* imgDic;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.session) {
        [self.session startRunning];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];    
    if (self.session) {
        [self.session stopRunning];
    }
}
- (void)viewDidLoad 
{
    
    [super viewDidLoad];
    
    self.navigationBarTitleLabel.text =  @"拍摄";
   
    
    self.view.backgroundColor =[UIColor whiteColor];
    [self initAVCaptureSession];
    [self setBG];
    //[self setupAddBlueBGView];
    [self setupAddCameraChild];
    [self setupAddChooseImageChild];
    [self rightbar];
    [self img_rightTouch:nil];
}
- (void)setBG
{
    uploadPicViewController *upload = [[uploadPicViewController alloc]init];
    [self.view addSubview:upload.view];
}

- (void)backBtnOnClicked:(id)sender{

    UIViewController *viewController;
    
    for (CompanyVC *tempVc in self.navigationController.viewControllers) {
        
        if ([tempVc isKindOfClass:[CompanyVC class]]) {
            
            viewController=tempVc;
            
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)rightbar{
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setTitle:@"切换" forState:UIControlStateNormal];
    [scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}



- (void)img_rightTouch:(UIButton *)btn{

    AVCaptureDevicePosition desiredPosition;
    if (self.isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }

    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }

    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;


}


/**初始化相机*/
- (void)initAVCaptureSession
{
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    backView.backgroundColor =[UIColor redColor];
    [self.view addSubview:backView];
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
    backView.layer.masksToBounds = YES;
    [backView.layer addSublayer:self.previewLayer];
}
/**添加圆圈背景View*/
-(void)setupAddBlueBGView
{
    
//    //白色头部背景
    whview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 105)];
    whview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whview];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(25,(whview.height-53)/2.0,53, 53)];
    img.image = [UIImage imageNamed:@"exclamation"];
    [whview addSubview:img];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(img.right+10, 0, SCREEN_WIDTH-img.right-10, whview.height)];
    label.text = @"请拍摄正脸免冠大头照\n请勿低头、仰头、侧脸或面部有遮挡\n请确保照片内只有自己头像";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    [whview addSubview:label];
    
    
    view= [[UIView alloc]initWithFrame:CGRectMake(0, whview.bottom, SCREEN_WIDTH,10)];
    view.backgroundColor = ColorAlpha(241, 241, 241);
    [self.view addSubview:view];
    
    UIImageView *imge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,.7*SCREEN_WIDTH+10 , .7*SCREEN_WIDTH+10)];
    imge.image = [UIImage imageNamed:@"g_round"];
    [self.view addSubview:imge];
    
    
    float scrollViewWidth = 0.7*SCREEN_WIDTH;
    float scrollViewX = (SCREEN_WIDTH - scrollViewWidth)/2;
    float scrollViewY = 0.05*SCREEN_HEIGHT;
    self.roundRect = CGRectMake(scrollViewX, scrollViewY, scrollViewWidth, scrollViewWidth);
    
    WXCameraCoverView *cameraCoverView = [[WXCameraCoverView alloc]initWithRoundFrame:self.roundRect];
    self.cameraCoverView = cameraCoverView;
    cameraCoverView.alpha = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    imge.center = cameraCoverView.center;
    imge.top = 208;
    
    
    WXImageScrollView * imageScrollView = [[WXImageScrollView alloc]initWithFrame:self.roundRect];
    imageScrollView.backgroundColor = [UIColor whiteColor];
    self.imageScrollView = imageScrollView;
    imageScrollView.hidden = YES;
    [self.view addSubview:imageScrollView];
    [self.view addSubview:cameraCoverView];
     [self.view addSubview:imge];
}
/**添加拍照时候的控件*/
-(void)setupAddCameraChild
{
    CGFloat buttonViewH = 150;
    CGRect gg = CGRectMake(0,0.7*SCREEN_WIDTH+239, SCREEN_WIDTH, buttonViewH);
    
    UIView * buttonView = [[UIView alloc]initWithFrame:gg];
    self.buttonView = buttonView;
    buttonView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:buttonView];
   
    
    //添加拍照按钮
    UIButton * takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoButton setImage:[UIImage imageNamed:@"photo_button"] forState:UIControlStateNormal];
    takePhotoButton.frame = CGRectMake((SCREEN_WIDTH -92)/2,0, 92, 92);
    [takePhotoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.takePhotoButton = takePhotoButton;
    [buttonView addSubview:takePhotoButton];
//    /**添加闪光灯按钮*/
//    UIButton * flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
//    flashButton.frame = CGRectMake(SCREEN_WIDTH/4 - 13,24.5, 26, 26);
//    [flashButton addTarget:self action:@selector(setFlashModeOnOff:) forControlEvents:UIControlEventTouchUpInside];
//    self.flashButton = flashButton;
//    [buttonView addSubview:flashButton];
//    /**添加前后摄像头切换按钮*/
//    UIButton *changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [changeCameraButton setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
//    changeCameraButton.frame = CGRectMake(SCREEN_WIDTH*3/4 - 21,18, 43, 41);
//    [changeCameraButton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
//    self.changeCameraButton = changeCameraButton;
//    [buttonView addSubview:changeCameraButton];
//    /**从相册选择*/
//    UIButton * albumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [albumeButton setBackgroundImage:[UIImage imageNamed:@"choosePhotoBtn"] forState:UIControlStateNormal];
//    [albumeButton setTitle:@"从相册选择" forState:UIControlStateNormal];
//    albumeButton.titleLabel.font =[UIFont fontWithName:kfontBold size:18];
//    [albumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    albumeButton.frame = CGRectMake((SCREEN_WIDTH - 225)/2,buttonView.frame.size.height -60, 225, 50);
//    [albumeButton addTarget:self action:@selector(showAlbume) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView addSubview:albumeButton];
}
/**添加选择图片时候的控件*/
-(void)setupAddChooseImageChild
{
//    CGFloat buttonViewH = 150;
//    UIView * chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT -150-60, SCREEN_WIDTH, buttonViewH)];
//    self.chooseView = chooseView;
//    chooseView.hidden = YES;
//    chooseView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:chooseView];
  
    
//    //添加使用照片button
//    UIButton *usePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.usePhotoButton = usePhotoButton;
//    [usePhotoButton setBackgroundImage:[UIImage imageNamed:@"usePhoto"] forState:UIControlStateNormal];
//    [usePhotoButton setTitle:@"使用照片" forState:UIControlStateNormal];
//    usePhotoButton.titleLabel.font = [UIFont fontWithName:kfontBold size:18];
////    [usePhotoButton setTitleColor:WXColorFromRGB(0x0A233C) forState:UIControlStateNormal];
//    usePhotoButton.frame = CGRectMake((SCREEN_WIDTH - 225)/2, 25, 225, 50);
//    [usePhotoButton addTarget:self action:@selector(useCrop) forControlEvents:UIControlEventTouchUpInside];
//    [chooseView addSubview:usePhotoButton];
   
    
//    //重拍的button
//    UIButton *retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [retakeButton setBackgroundImage:[UIImage imageNamed:@"signupButton"] forState:UIControlStateNormal];
//    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];
//    retakeButton.titleLabel.font = [UIFont fontWithName:kfontBold size:18];
//    [retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    retakeButton.frame = CGRectMake((SCREEN_WIDTH - 225)/2, chooseView.frame.size.height - 55, 225, 50);
//    [retakeButton addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];
//    [chooseView addSubview:retakeButton];
}




/**拍照方法*/
-(void)takePhoto:(UIButton *)button
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    if (self.flashModeOn) {//判断是否闪光灯
        [self setFlashMode:AVCaptureFlashModeOn forDevice:[[self videoInput] device]];
    }else{
        [self setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoInput] device]];
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer)
        {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            //            image = [self imageWithImage:image scaledToSize:CGSizeMake(660, 560)];
            self.photoFromCamera = YES;
            image =  [self setupWithImage:image imageSize:image.size];
            [self imageData:image];
            
            
            [self chooseViewHiddenCameraView];
            [self reladImageScrollView:image];
            NSLog(@"image:%@",image);
        }
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,imageDataSampleBuffer,kCMAttachmentMode_ShouldPropagate);
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return ;
        }
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
            
        }];
        
    }];
}






- (void)clickindex:(int)index{

    if (index==1) {
        
        //通过手机号获取用户信息
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        NSString* path = [@"http://42.159.125.221:52680/v1/api/User/phone/" stringByAppendingString:[Global sharedClient].phone];
//        [[HttpClient sharedClient] setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
        NSDictionary * params = @{};
        [HttpClient requestWithMethod:@"GET" path:path parameters:params target:self success:^(NSDictionary *dic) {
            [self updateUserInfo:dic];

        } failue:^(NSDictionary *dic) {
            [MBProgressHUD showError:@"获取用户信息异常，请稍后重试" toView:self.view];
            NSLog(@"%@",dic);
        } ];

        
        
        
        //[self.navigationController popViewControllerAnimated:YES];
        
    }else{
    
        [self retakePhoto];
    }

}

-(void) updateUserInfo:(NSDictionary*) dic{
    NSMutableDictionary* requestDic = [[NSMutableDictionary alloc] init];
    requestDic[@"id"]=dic[@"id"];
    requestDic[@"userName"]=dic[@"userName"];
    requestDic[@"gender"]=[Util isNil:dic[@"gender"]];
    requestDic[@"telephone"]=[Util isNil:dic[@"telephone"]];
    requestDic[@"password"]=[Util isNil:dic[@"password"]];
    requestDic[@"email"]=[Util isNil:dic[@"email"]];
    requestDic[@"idCard"]=[Util isNil:dic[@"idCard"]];
    requestDic[@"onboardTime"]=[Util isNil:dic[@"onboardTime"]];
    requestDic[@"birthDay"]=[Util isNil:dic[@"birthDay"]];
    requestDic[@"departureTime"]=[Util isNil:dic[@"departureTime"]];
    requestDic[@"companyId"]=[Util isNil:dic[@"company"][@"id"]];
    requestDic[@"avatar"]=[Util isNil:dic[@"avatar"]];
    requestDic[@"faceId"]=[Util isNil:dic[@"faceId"]];
    requestDic[@"userRoleIds"]=@[dic[@"userRoles"][0][@"roleId"]];
    requestDic[@"photoIds"]=@[imgDic[@"id"]];
    NSString* path = @"http://42.159.125.221:52680/v1/api/User";
    [HttpClient requestWithMethod:@"PUT" path:path parameters:requestDic target:self success:^(NSDictionary *dic) {
        NSLog(@"888888%@",dic);
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//        [[HttpClient sharedClient] setParameterEncoding:AFFormURLParameterEncoding];
//        [[HttpClient sharedClient] registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        UIViewController *viewController;
        
        for (CompanyVC *tempVc in self.navigationController.viewControllers) {
            
            if ([tempVc isKindOfClass:[CompanyVC class]]) {
                
                viewController=tempVc;
                
            }
            
        }
        [Global sharedClient].action = ACT_UPDATE_IMG;
        [self.navigationController popToViewController:viewController animated:YES];
        
    } failue:^(NSDictionary *dic) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showError:@"更新用户信息异常，请稍后重试" toView:self.view];
//        [[HttpClient sharedClient] setParameterEncoding:AFFormURLParameterEncoding];
//        [[HttpClient sharedClient] registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    } ];
}





//验证图片是否合格

- (void)imageData:(UIImage *)image{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [HttpClient requestWithMethod:@"POST" path:@"http://42.159.125.221:52680/v1/api/photo/identify" parameters:@{@"imageFiles":image,@"ext":@"jpg"} target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            
            NSLog(@"0000000000000%@",dic);
            imgDic = dic;
            LognAlerView *lognview = [[LognAlerView alloc]initWithTitle:@"面部信息上传成功" title2:@"如果失败，请点击下方按钮重新拍摄" delegate:self];
            [lognview show];
            [lognview.imgName setImage:[UIImage imageNamed:@"correct"] forState:UIControlStateNormal];
            [lognview.enter setTitle:@"我知道了" forState:UIControlStateNormal];
        });
    }failue:^(NSDictionary *dic){
        @try {
            
                
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            dispatch_sync(dispatch_get_main_queue(), ^{
            LognAlerView *lognview = [[LognAlerView alloc]initWithTitle:@"面部信息上传失败" title2:dic[@"msg"] delegate:self];
                [lognview.imgName setImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
                [lognview.enter setTitle:@"重新拍摄" forState:UIControlStateNormal];
                [lognview show];
                
//            });
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
        } @finally {
        
        }
        
        
    }];

}

- (NSString *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.3f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"%@",
            [imageData base64EncodedStringWithOptions: 0]];
    
}


- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


///**是否打开闪光灯的方法*/
//-(void)setFlashModeOnOff:(UIButton *)button
//{
//    if (self.flashModeOn) {
//        self.flashModeOn = NO;
//    }else{
//        self.flashModeOn = YES;
//    }
//}
///**前后摄像头切换的方法*/
//-(void)changeCamera:(UIButton *)button
//{
//    AVCaptureDevicePosition desiredPosition;
//    if (self.isUsingFrontFacingCamera){
//        desiredPosition = AVCaptureDevicePositionBack;
//    }else{
//        desiredPosition = AVCaptureDevicePositionFront;
//    }
//    
//    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
//        if ([d position] == desiredPosition) {
//            [self.previewLayer.session beginConfiguration];
//            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
//            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
//                [[self.previewLayer session] removeInput:oldInput];
//            }
//            [self.previewLayer.session addInput:input];
//            [self.previewLayer.session commitConfiguration];
//            break;
//        }
//    }
//    
//    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;
//}
///**从相册选择的按钮方法*/
//-(void)showAlbume
//{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = (id)self;
//    picker.allowsEditing = NO;
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:NULL];
//}
/**点击使用照片所做操作*/
//-(void)useCrop
//{
//    UIImage *scrollViewImage = [self getImageFromScrollView:self.imageScrollView];
//    WXGetViewController * imageVC = [[WXGetViewController alloc]init];
//    imageVC.getImages = scrollViewImage;
//    [self.navigationController pushViewController:imageVC animated:YES];
//}
/**重拍的按钮点击*/
-(void)retakePhoto
{
    [UIView animateWithDuration:0.38 animations:^{
        [self.view addSubview:whview];
        [self.view addSubview:view];
        self.imageScrollView.hidden = YES;
        self.cameraCoverView.alpha = 1;
        self.buttonView.hidden = NO;
        self.chooseView.hidden = YES;
//        self.chooseView.userInteractionEnabled = NO;
    }];
}
/**将照片放在scrollView上*/
-(void)reladImageScrollView:(UIImage *)chooseImage
{
    [self.imageScrollView displayImage:chooseImage];
    if (self.photoFromCamera) {
        [self.imageScrollView setContentOffsetIfPhotoFromCamera];
    }
}
#pragma mark - UIImagePickerControllerDelegate
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}
- (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}
/**拍完照后隐藏牌照View显示选择图片的View等等*/
-(void)chooseViewHiddenCameraView
{
    [UIView animateWithDuration:0.38 animations:^{
        [self.view addSubview:whview];
        [self.view addSubview:view];
        self.imageScrollView.hidden = NO;
        self.cameraCoverView.alpha = 1;
        self.buttonView.hidden = YES;
        self.chooseView.hidden = NO;
        self.chooseView.userInteractionEnabled = NO;
    }];
}
/**设置image的大小*/
-(UIImage *)setupWithImage:(UIImage *)images imageSize:(CGSize)size
{
    UIImageOrientation orientation = [images imageOrientation];
    UIImage *image = [self imageWithImage:images scaledToSize:size];
    NSData *imageData = UIImageJPEGRepresentation(image,0.6);
    image = [UIImage imageWithData:imageData];
    CGImageRef imRef = [image CGImage];
    NSInteger texWidth = CGImageGetWidth(imRef);
    NSInteger texHeight = CGImageGetHeight(imRef);
    float imageScale = 1;
    if(orientation == UIImageOrientationUp && texWidth < texHeight){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationLeft]; }
    else if((orientation == UIImageOrientationUp && texWidth > texHeight) || orientation == UIImageOrientationRight){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];		}
    else if(orientation == UIImageOrientationDown){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationDown];}
    else if(orientation == UIImageOrientationLeft){
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    }
    return image;
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
-(UIImage *)getImageFromScrollView:(UIScrollView *)theScrollView
{
    //UIGraphicsBeginImageContext(theScrollView.frame.size);
    UIGraphicsBeginImageContextWithOptions(theScrollView.frame.size, NO, [UIScreen mainScreen].scale);
    CGPoint offset=theScrollView.contentOffset;
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), -offset.x, -offset.y);
    [theScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
    self.photoFromCamera = NO;
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    image =  [self setupWithImage:image imageSize:image.size];
    [self chooseViewHiddenCameraView];
    [self reladImageScrollView:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
