//
//  uploadPicViewController.m
//  kaidexing
//
//  Created by company on 2017/8/29.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "uploadPicViewController.h"
#import "UIImageView+WebCache.h"
#import "MallInfoModel.h"
#import "GoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface uploadPicViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
//    BOOL hasAuthoriz;
}
@property (strong, nonatomic)  UIImageView *imaview;
@property (strong, nonatomic) UIImageView *bgView;

@property (nonatomic, strong) AVCaptureSession* session;
/**输入设备*/
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**照片输出流*/
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**预览图层*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**判断前后摄像头的状态*/
@property (nonatomic, assign) BOOL isUsingFrontFacingCamera;



@end

@implementation uploadPicViewController

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
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:^{
//
//    }];
//
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//
//
//    [self uploadpic:image];
//}
- (void)uploadpic:(UIImage*)ima
{
    [SVProgressHUD showWithStatus:@"头像上传中"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
    
   NSString *accessUrlStr = [NSString stringWithFormat:@"%@/api/v1/upload_photo",APIDOMAIN];
    NSLog(@"域名%@",accessUrlStr);
    //NSString *accessUrlStr =@"http://cnliutao1.chinacloudapp.cn:8080/api/v1/upload_photo";
    NSDictionary *para = @{@"mobile":[Global sharedClient].phone,@"ext":@"jpg"};
    //NSDictionary *para = @{@"mobile":@"15995876379",@"ext":@"jpg"};
 
    [manager POST:accessUrlStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData  * feedbackImg =UIImageJPEGRepresentation(ima, 0.5);
        [formData appendPartWithFileData:feedbackImg name:@"file"  fileName:@"file" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        //_imaview.image = ima;
        NSLog(@"%@",responseObject);
        if (responseObject[@"path"]) {
           // NSString *path = [NSString stringWithFormat:@"http://cnliutao1.chinacloudapp.cn:8080/%@",responseObject[@"path"]];
            NSString *path = [NSString stringWithFormat:@"%@/%@",APIDOMAIN,responseObject[@"path"]];
           [_imaview setImageWithString:path];
            NSLog(@"接口为%@",path);
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            
            
            [self performSelector:@selector(next) withObject:nil afterDelay:1];
            
            
            if (self.back) {
                self.back();
            }
        }else{
            if (responseObject[@"msg"]) {
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:@"请重拍"];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请重拍"];
    }];
    
}
//13524477852 shimin19901110
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarcolor:[UIColor clearColor]];
    self.navigationBarLine.hidden = YES;
    [self redefineBackBtn:[UIImage imageNamed:@"iconBack"] :CGRectMake(10, 10, 24, 24)];
    [self initView];
    [self showCamera];
    
    
//    [self setupAddChooseImageChild];
//    [self rightbar];
//    [self img_rightTouch:nil];
}
- (void)showCamera
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                //第一次接受
                    dispatch_async(dispatch_get_main_queue(), ^{                        
                        
                        [self initAVCaptureSession];
                        [self.session startRunning];
                        
                        self.isUsingFrontFacingCamera = NO;
                        [self img_rightTouch:nil];
                        
                        [self.view bringSubviewToFront:_bgView];
                        [self.view bringSubviewToFront:self.navigationBar];
                    });
                    
                }else{
                //第一次拒绝
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.view.backgroundColor = [UIColor blackColor];
                    });
                    
                }
            }];
        }
            break;
            case AVAuthorizationStatusAuthorized:
        {
            [self initAVCaptureSession];
            
            self.isUsingFrontFacingCamera = NO;
            [self img_rightTouch:nil];
            [self.view bringSubviewToFront:_bgView];
        }
            break;
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
        {
            self.view.backgroundColor = [UIColor blackColor];
        }
            break;
        default:
            break;
    }
    
}
- (void)initView
{
    _bgView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    _bgView.image = [UIImage imageNamed:@"bg"];
    _bgView.userInteractionEnabled=YES;
    [self.view addSubview: _bgView];
    
    UILabel* tittleLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 80, WIN_WIDTH-M_WIDTH(17), 40)];
    tittleLab.font = [UIFont systemFontOfSize:32];
    tittleLab.textColor = [UIColor whiteColor];
    tittleLab.text=@"请上传照片";
    [_bgView addSubview:tittleLab];
    
    UILabel* typeTittlelab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), CGRectGetMaxY(tittleLab.frame)+20, WIN_WIDTH-M_WIDTH(17), 40)];
    typeTittlelab.textColor = [UIColor whiteColor];
    typeTittlelab.font = COMMON_FONT;
    typeTittlelab.numberOfLines = 0;
    typeTittlelab.text = @"为了方便您出入凯德办公楼，请拍摄本人面部照片";
    [_bgView addSubview:typeTittlelab];
    
    UIButton* next = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, WIN_HEIGHT-M_WIDTH(17)-40, 40, 40)];
    [next setImage:[UIImage imageNamed:@"iconArrowLeftCircle"] forState:UIControlStateNormal];
    [_bgView addSubview:next];
    [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *skip = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40-200, WIN_HEIGHT-M_WIDTH(17)-40+5, 150, 30)];
    [_bgView addSubview:skip];
    skip.titleLabel.font =DESC_FONT;
    [skip setTitle:@"跳过，以后在说" forState:UIControlStateNormal];
    [skip setTintColor:[UIColor whiteColor]];
    [skip setBackgroundColor:[UIColor clearColor]];
    skip.layer.cornerRadius = 15;
    skip.layer.borderColor =[UIColor whiteColor].CGColor;
    skip.layer.borderWidth = 1;
    [skip addTarget:self action:@selector(skipclick) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, next.y-130-20, WIN_WIDTH, 130)];
    [_bgView addSubview:view];
    UILabel *la1 = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 0, WIN_WIDTH, 20)];
    la1.font = DESC_FONT;
    la1.text = @"请拍摄正脸免冠大头照";
    la1.textColor = [UIColor whiteColor];
    [view addSubview:la1];
    UILabel *la2 = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 20, WIN_WIDTH, 20)];
    [view addSubview:la2];
    la2.font = DESC_FONT;
    la2.text = @"请勿低头、仰头、侧面或面部有遮挡";
    la2.textColor = [UIColor whiteColor];
    UILabel *la3 = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 40, WIN_WIDTH, 20)];
    [view addSubview:la3];
    la3.font = DESC_FONT;
    la3.text = @"请确保照片内只有自己的头像";
    la3.textColor = [UIColor whiteColor];
    UIButton *takephoto = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-25, 80, 50, 50)];
    [view addSubview:takephoto];
    [takephoto setImage:[UIImage imageNamed:@"iconCameraCircle"] forState:UIControlStateNormal];
    [takephoto addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat height = WIN_HEIGHT-180-M_WIDTH(17)-150-40-20;
    
    _imaview = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-height/2, typeTittlelab.bottom+10, height-20, height-20)];
    _imaview.layer.cornerRadius = 85;
    _imaview.layer.borderWidth = 3;
    _imaview.layer.borderColor = RGBCOLOR(108, 155, 164).CGColor;
    _imaview.clipsToBounds = YES;
   // [_bgView addSubview:_imaview];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
    // MARK: circlePath
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(WIN_WIDTH / 2, CGRectGetMidY(_imaview.frame)) radius:height/2 startAngle:0 endAngle:2*M_PI clockwise:NO]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [_bgView.layer setMask:shapeLayer];
    
    if (self.back) {
        [next removeFromSuperview];
        [skip removeFromSuperview];
    }
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
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
    
    //backView.backgroundColor =[UIColor redColor];
    [self.view addSubview:backView];
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0,WIN_WIDTH,WIN_HEIGHT);
    
    //backView.layer.masksToBounds = YES;
    [backView.layer addSublayer:self.previewLayer];
   // [self.view bringSubviewToFront:_bgView];
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

- (void)next
{
    if (self.locationDic) {
        
        if (_imaview.image) {
            [self getLocation:self.locationDic[@"locationCode"]];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请先上传头像"];
        }
    }else{
        
        [self.delegate.navigationController popViewControllerAnimated:YES];
    }
}
- (void)skipclick
{
    [self getLocation:self.locationDic[@"locationCode"]];
}
- (void)getLocation:(NSString*)locationCode
{
    if (!locationCode) {
        return;
    }
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmallid"] parameters:@{@"locationCode":locationCode} target:self success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        
        if ([dic[@"result"]integerValue]) {
            MallInfoModel *model = [[MallInfoModel alloc] initWithDictionary:dic[@"data"][@"mallinfo"] error:nil ];
            [self popData:model];
        }
        
        
    } failue:^(NSDictionary *dic) {
        
    }];
}
-(void)popData:(MallInfoModel*)mallInfo{
    
    [SVProgressHUD dismiss];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mall_id=mallInfo.mall_id;
    [Global sharedClient].markID        = mall_id;
    [Global sharedClient].markCookies   = mallInfo.mall_id_des;
    [Global sharedClient].markPrefix    = mallInfo.mall_url_prefix;
    [Global sharedClient].shopName      = mallInfo.mall_name;
    [userDefaults setObject:mall_id                 forKey:@"mall_id"];
    [userDefaults setObject:mallInfo.mall_name       forKey:@"mall_name"];
    [userDefaults setObject:mallInfo.mall_url_prefix forKey:@"mall_url_prefix"];
    [userDefaults setObject:mallInfo.mall_id_des   forKey:@"mall_id_des"];
    
    [Global sharedClient].pushLoadData = @"1";
    [Global sharedClient].isLoginPush = @"1";
    
    [self backToAdv];
    
    
}
- (IBAction)takePhoto:(id)sender {
    NSLog(@"点不到");
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = YES;
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self presentViewController:imagePickerController animated:YES completion:^{
//        
//    }];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus!=AVAuthorizationStatusAuthorized){
        //无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        return;
    }
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
//    if (self.flashModeOn) {//判断是否闪光灯
//        [self setFlashMode:AVCaptureFlashModeOn forDevice:[[self videoInput] device]];
//    }else{
//        [self setFlashMode:AVCaptureFlashModeOff forDevice:[[self videoInput] device]];
//    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer)
        {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
                    //    image = [self imageWithImage:image scaledToSize:CGSizeMake(660, 560)];
        
            //image =  [self setupWithImage:image imageSize:image.size];
           
            
            //上传照片摆正
            [self uploadpic:[self fixOrientation:image]];
            
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
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    else if (deviceOrientation == UIDeviceOrientationPortrait)
        result = AVCaptureVideoOrientationPortrait;
        
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        result = AVCaptureVideoOrientationPortraitUpsideDown;
//    AVCaptureOutput *outputPic
//    = [[AVCaptureStillImageOutput alloc]init];
//    AVCaptureConnection
//    * videoConnection = [outputPic connectionWithMediaType:AVMediaTypeVideo];
//    [videoConnection
//     setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    return result;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
