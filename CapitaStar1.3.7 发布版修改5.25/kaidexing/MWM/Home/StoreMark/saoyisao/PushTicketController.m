//
//  PushTicketController.m
//  kaidexing
//
//  Created by companycn on 2018/3/19.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PushTicketController.h"
//相机
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define ORIGINAL_MAX_WIDTH 640.0f

//判断相机权限
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "GoViewController.h"

@interface PushTicketController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    //相机
    NSData* userImgData;
    UIImage *portraitImg;
    UIView  *cameraMsgView;//点开相机注意事项弹出框
}
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//输出图片
@property (nonatomic ,strong) AVCaptureStillImageOutput *imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIImageView *cameraImageView;
@property (nonatomic,strong)UIView *bgView;
@end

@implementation PushTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self cameraDistrict];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isDisplayStr = [userDefaults valueForKey:@"isDisplay"];
    if ([Util isNull:isDisplayStr]) {
        [self performSelector:@selector(cameraMsg) withObject:nil afterDelay:0.5];
    }
   
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBarLine.backgroundColor = [UIColor clearColor];
    
}

- (void)createView
{
    if (_bgView) {
        return;
    }
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    _bgView.tag = 1233;
    _bgView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView.height-80, WIN_WIDTH, 80)];
    bottomView.backgroundColor = [UIColor blackColor];
    [_bgView addSubview:bottomView];
    UIButton *photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-35, 5, 70, 70)];
    [photoBtn setImage:[UIImage imageNamed:@"takePhoto"] forState:UIControlStateNormal];
    [photoBtn addTarget: self action:@selector(photoBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/4-20, 25, 40, 30)];
    [cancleBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/4*3-35, 5, 70, 70)];
    [changeBtn setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:photoBtn];
    [bottomView addSubview:cancleBtn];
    [bottomView addSubview:changeBtn];
    UIButton *flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 40, 40)];
    [flashBtn setImage:[UIImage imageNamed:@"btn_camera_flash_off"] forState:UIControlStateNormal];
    [flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:flashBtn];
}
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        //给摄像头的切换添加翻转动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        //拿到另外一个摄像头位置
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;//动画翻转方向
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;//动画翻转方向
        }
        //生成新的输入
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
                
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bgView removeFromSuperview];
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_bgView removeFromSuperview];
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
}
- (void)openFlash:(UIButton *)sender{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.tag == 0) {
                
                sender.tag = 1;
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else{
                
                sender.tag = 0;
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }

}
- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)cameraDistrict
{
    //    AVCaptureDevicePositionBack  后置摄像头
    //    AVCaptureDevicePositionFront 前置摄像头
    self.device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    //     拿到的图像的大小可以自行设定
    //    AVCaptureSessionPreset320x240
    //    AVCaptureSessionPreset352x288
    //    AVCaptureSessionPreset640x480
    //    AVCaptureSessionPreset960x540
    //    AVCaptureSessionPreset1280x720
    //    AVCaptureSessionPreset1920x1080
    //    AVCaptureSessionPreset3840x2160
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    //输入输出设备结合
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }
    //预览层的生成
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    //设备取景开始
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        //自动闪光灯，
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡,但是好像一直都进不去
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
    
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}
//拍照拿到相应的图片
- (void)photoBtnDidClick
{
    AVCaptureConnection *conntion = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!conntion) {
        NSLog(@"拍照失败!");
        return;
    }
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:conntion completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == nil) {
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        [self.session stopRunning];
        
        [self updateImg:self.image];
    //[self.view addSubview:self.cameraImageView];
    }];
     
     
}

#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//- (void)pushTicket{
//    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
//        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
//        if ([self isFrontCameraAvailable]) {
//            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//        }
//        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
//        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
//        controller.mediaTypes = mediaTypes;
//        controller.delegate = self;
//        [self presentViewController:controller
//                           animated:YES
//                         completion:^(void){
//
//                         }];
//        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *isDisplayStr = [userDefaults valueForKey:@"isDisplay"];
//        if ([Util isNull:isDisplayStr]) {
//            [self performSelector:@selector(cameraMsg) withObject:nil afterDelay:0.5];
//        }
//    }
//}
//相机弹出提示
-(void)cameraMsg{
    
    
    // CGFloat buttom_W =M_WIDTH(240);
    CGFloat buttom_W =M_WIDTH(240);
    CGFloat buttom_H =M_WIDTH(290);//326
    cameraMsgView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    cameraMsgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    UIView *msgView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(40),M_WIDTH(100),buttom_W,buttom_H)];
    msgView.backgroundColor = UIColorFromRGB(0xebebeb);
    msgView.layer.masksToBounds=YES;
    msgView.layer.cornerRadius=10;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,M_WIDTH(11.5),buttom_W,M_WIDTH(32))];
    titleLab.text=@"注意事项";
    titleLab.textAlignment=NSTextAlignmentCenter;
    [titleLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [msgView addSubview:titleLab];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLab.frame),buttom_W,M_WIDTH(198))];
    contentScrollView.delegate=self;
    contentScrollView.scrollEnabled=YES;
    contentScrollView.contentSize=CGSizeMake(buttom_W,M_WIDTH(380));
    
    
    
    UIImageView *centerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,buttom_W,M_WIDTH(380))];
    [centerImg setImage:[UIImage imageNamed:@"matters_need_attention"]];
    [contentScrollView addSubview:centerImg];
    [msgView addSubview:contentScrollView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,buttom_H-M_WIDTH(39)-1,buttom_W,1)];
    lineView.backgroundColor=UIColorFromRGB(0x939290);
    [msgView addSubview:lineView];
    
    UIButton *laftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView.frame),buttom_W/2,M_WIDTH(38))];
    [laftBtn setTitle:@"下次不再提示" forState:UIControlStateNormal];
    [laftBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    laftBtn.titleLabel.font=COMMON_FONT;
    laftBtn.tag=0;
    [laftBtn addTarget:self action:@selector(cameraTouch:) forControlEvents:UIControlEventTouchUpInside];
    [msgView addSubview:laftBtn];
    
    UIView *centerLine = [[UIView alloc]initWithFrame:CGRectMake(buttom_W/2-0.5,CGRectGetMaxY(lineView.frame),1,M_WIDTH(39)-1)];
    centerLine.backgroundColor=UIColorFromRGB(0x858182);
    [msgView addSubview:centerLine];
    
    UIButton *buttomBtn = [[UIButton alloc]initWithFrame:CGRectMake(buttom_W/2,CGRectGetMaxY(lineView.frame),buttom_W/2,M_WIDTH(38))];
    [buttomBtn setTitle:@"OK" forState:UIControlStateNormal];
    [buttomBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    buttomBtn.titleLabel.font=COMMON_FONT;
    buttomBtn.tag=1;
    [buttomBtn addTarget:self action:@selector(cameraTouch:) forControlEvents:UIControlEventTouchUpInside];
    [msgView addSubview:buttomBtn];
    
    [cameraMsgView addSubview:msgView];
    [[[UIApplication  sharedApplication]keyWindow]addSubview : cameraMsgView];
}

//相机弹出按钮事件
-(void)cameraTouch:(UIButton*)sender{
    [cameraMsgView removeFromSuperview];
    if (sender.tag==0) {
        //以后不再提示
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"isDisplay" forKey:@"isDisplay"];
    }
}


//------------扫小票方法-----------------------------
-(void) updateImg:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self uploadImg:UIImageJPEGRepresentation([self imageByScalingToMaxSize:image],1.0)];
    });
}

//-(void) btnSelected:(NSString*)index{
//    if([index isEqualToString:@"1"]){
//        return ;
//    }else{
//        [self updateImg];
//    }
//}
//
////以下是头像设置代码，从第三方copy
//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [picker dismissViewControllerAnimated:YES completion:^() {
//        portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        [self updateImg];
//    }];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [picker dismissViewControllerAnimated:YES completion:^(){
//    }];
//}
//
//#pragma mark - UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//
//}
//
//#pragma mark camera utility
//- (BOOL) isCameraAvailable{
//    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//}
//
//- (BOOL) isRearCameraAvailable{
//    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
//}
//
//- (BOOL) isFrontCameraAvailable {
//    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
//}
//
//- (BOOL) doesCameraSupportTakingPhotos {
//    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
//}
//
//- (BOOL) isPhotoLibraryAvailable{
//    return [UIImagePickerController isSourceTypeAvailable:
//            UIImagePickerControllerSourceTypePhotoLibrary];
//}
//- (BOOL) canUserPickVideosFromPhotoLibrary{
//    return [self
//            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//}
//- (BOOL) canUserPickPhotosFromPhotoLibrary{
//    return [self
//            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//}
//
//- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
//    __block BOOL result = NO;
//    if ([paramMediaType length] == 0) {
//        return NO;
//    }
//    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
//    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
//        NSString *mediaType = (NSString *)obj;
//        if ([mediaType isEqualToString:paramMediaType]){
//            result = YES;
//            *stop= YES;
//        }
//    }];
//    return result;
//}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //保存图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        userImgData = UIImageJPEGRepresentation(editedImage,1.0);
    });
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void) uploadImg:(NSData*) imgData{
    
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"scanreceipt"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@"SIN001",@"location_code",[Global sharedClient].member_id,@"member_id",[Global sharedClient].markID,@"mall_id",@"1000",@"source",[self image2DataURL:self.image],@"receiptimg",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
        if ([dic[@"result"] integerValue]==4) {
            NSDictionary *data = [dic objectForKey:@"data"];
            [_bgView removeFromSuperview];
            _bgView = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                GoViewController *govc = [[GoViewController alloc]init];
                govc.path = data[@"url"];
                [self.navigationController pushViewController:govc animated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
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
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
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


@end
