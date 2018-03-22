//
//  ScanBankPayController.m
//  kaidexing
//
//  Created by companycn on 2018/3/11.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "ScanBankPayController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import "SaoMaPayController.h"
#import "AddBankCardController.h"
#import "BankListController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanBankPayController ()< UIImagePickerControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) MMScanView *scanRectView;
@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic) CGRect scanRect;

@property (nonatomic, strong) UIButton *scanTypeQrBtn; //修改扫码类型按钮
@property (nonatomic, strong) UIButton *scanTypeBarBtn; //修改扫码类型按钮

@property (nonatomic, copy) void (^scanFinish)(NSString *, NSError *);
@property (nonatomic, assign) MMScanType scanType;
@property (nonatomic,strong)NSArray *bankListArray;
@end

@implementation ScanBankPayController
{
    NSString *appName;
    BOOL delayQRAction;
    BOOL delayBarAction;
}
- (instancetype)initWithQrType:(MMScanType)type onFinish:(void (^)(NSString *result, NSError *error))finish {
    self = [super init];
    if (self) {
        self.scanType = type;
        self.scanFinish = finish;
    }
    
    return self;
}
- (NSArray *)bankListArray
{
    if (!_bankListArray) {
        _bankListArray = [NSArray array];
    }
    return _bankListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationBar.hidden = YES;
    delayQRAction = NO;
    delayBarAction = NO;

    self.view.backgroundColor = [UIColor clearColor];
    self.session = nil;
   
   // [self initScanDevide];
    [self drawTitle];
    [self drawScanView];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ( [Global sharedClient].isHomePush != YES) {
        [self initScanDevide];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( [Global sharedClient].isHomePush == YES) {
        [self initScanDevide];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Global sharedClient].isHomePush = NO;
}
- (void)initScanDevide {
    
        //初始化摄像设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //初始化摄像输入流
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        //初始化摄像输出流
        self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
        //设置输出代理，在主线程里刷新
      //  [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.output setMetadataObjectsDelegate:self queue:dispatchQueue];
        //初始化链接对象
        self.session = [[AVCaptureSession alloc] init];
        //设置采集质量
        [self.session setSessionPreset:AVCaptureSessionPresetInputPriority];
        //将输入输出流对象添加到链接对象
        if ([self.session canAddInput:self.input]) [self.session addInput:self.input];
        if ([self.session canAddOutput:self.output]) [self.session addOutput:self.output];
        
        //设置扫码支持的编码格式【默认二维码】
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        _scanRect = CGRectFromString([self scanRectWithScale:1][0]);
        //设置扫描聚焦区域
        self.output.rectOfInterest = _scanRect;
       
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT);
        [self.view.layer insertSublayer:self.preview atIndex:0];
       
        [self.session startRunning];
        

}

- (void)initScanType{
    if (self.scanType == MMScanTypeAll) {
        _scanRect = CGRectFromString([self scanRectWithScale:1][0]);
        self.output.rectOfInterest = _scanRect;
        [self drawBottomItems];
    } else if (self.scanType == MMScanTypeQrCode) {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        self.navigationItem.title = @"二维码";
        _scanRect = CGRectFromString([self scanRectWithScale:1][0]);
        self.output.rectOfInterest = _scanRect;
        _tipTitle.text = @"将取景框对准二维码,即可自动扫描";
        
        _tipTitle.center = CGPointMake(self.view.center.x, self.view.center.y + CGSizeFromString([self scanRectWithScale:1][1]).height/2 + 25);
        
    } else if (self.scanType == MMScanTypeBarCode) {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        self.navigationItem.title = @"条码";
        
        _scanRect = CGRectFromString([self scanRectWithScale:3][0]);
        self.output.rectOfInterest = _scanRect;
        [self.scanRectView setScanType: MMScanTypeBarCode];
        _tipTitle.text = @"将取景框对准条码,即可自动扫描";
        
        _tipTitle.center = CGPointMake(self.view.center.x, self.view.center.y + CGSizeFromString([self scanRectWithScale:3][1]).height/2 + 25);
    }
}

- (NSArray *)scanRectWithScale:(NSInteger)scale {
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGFloat Left = 60 / scale;
    CGSize scanSize = CGSizeMake(self.view.frame.size.width - Left * 2, (self.view.frame.size.width - Left * 2) / scale);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    return @[NSStringFromCGRect(scanRect), NSStringFromCGSize(scanSize)];
}




//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];

    // 打开系统右滑移动返回手势
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;      // 手势有效设置为YES  无效为NO
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;    // 手势的代理设置为self
//    }
    //捕获结束
//    if (self.session) [self.session stopRunning];
//}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( (metadataObjects.count==0) )
    {
       
        return;
    }
    
    if (metadataObjects.count>0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        [self renderUrlStr:metadataObject.stringValue];
    }
}

- (void)renderUrlStr:(NSString *)url {
    
    [self loadBankInfo:url];
        //输出扫描字符串
//        if (self.scanFinish) {
//            //回调结果到页面上，也可以在此处做跳转操作,如果不想回去，直接注释下面的代码
//            if (self.navigationController &&[self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
//

//
//            }
//        }
   
}
//获取银行列表
-(void)loadBankInfo:(NSString *)urlStr
{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _bankListArray = dic[@"data"];
        [Global sharedClient].hasBankCard = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
           
            SaoMaPayController *saoVc = [[SaoMaPayController alloc]init];
            saoVc.QrImageUrl = urlStr;
            [self.navigationController pushViewController:saoVc animated:YES];
        });
        
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        NSString *result = [NSString stringWithFormat:@"%@",dic[@"result"]];
        if ([result isEqualToString:@"-1"]) {
            [self showAlertView];
            [Global sharedClient].hasBankCard = NO;
        }
        
        
    }];
}
//无绑定时弹起
- (void)showAlertView
{
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(50, (WIN_HEIGHT-180)/2, WIN_WIDTH-100, 180)];
    _alertView.layer.cornerRadius = 5;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_alertView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _alertView.width-20, 60)];
    label.numberOfLines = 2;
    label.text = @"您尚未绑定银行卡，绑定银行卡后可以向商家付款";
    label.font = [UIFont systemFontOfSize:15];
    [_alertView addSubview:label];
    
    UIButton *bankBtn = [[UIButton alloc]initWithFrame:CGRectMake(_alertView.width/2-60, 80, 120, 60)];
    [bankBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [bankBtn setTitle:@"查看支付银行" forState:UIControlStateNormal];
    [bankBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [bankBtn addTarget:self action:@selector(clickToBank:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:bankBtn];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _alertView.height-40, _alertView.width/2, 40)];
    UIButton *goBind = [[UIButton alloc]initWithFrame:CGRectMake(_alertView.width/2, _alertView.height-40, _alertView.width/2, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goBind setTitle:@"去绑卡" forState:UIControlStateNormal];
    [goBind setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(backBtn.frame), _alertView.frame.size.width,1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_alertView.frame.size.width/2, CGRectGetMinY(backBtn.frame), 1,bankBtn.frame.size.height)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_alertView addSubview:line1];
    [_alertView addSubview:line2];
    
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [goBind addTarget:self action:@selector(clickToBindCard) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:goBind];
    [_alertView addSubview:backBtn];
}
- (void)clickToBank:(UIButton *)sender{
    [self removePopView];
    BankListController *bankVc= [[BankListController alloc]init];
    [self.navigationController pushViewController:bankVc animated:YES];
}
- (void)clickToBack{
    [self removePopView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)clickToBindCard
{
    [self removePopView];
    AddBankCardController *AddVc = [[AddBankCardController alloc]init];
    AddVc.isfirstBindCard = YES;
    [self.navigationController pushViewController:AddVc animated:YES];
}
- (void)removePopView
{
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
    [_bgView removeFromSuperview];
    _bgView = nil;
}


//绘制扫描区域
- (void)drawScanView {
    _scanRectView = [[MMScanView alloc] initWithFrame:self.view.frame style:@""];
    [_scanRectView setScanType:self.scanType];
    [self.view addSubview:_scanRectView];
}

- (void)drawTitle
{
    if (!_tipTitle)
    {
        self.tipTitle = [[UILabel alloc]init];
        _tipTitle.bounds = CGRectMake(0, 0, 300, 50);
        _tipTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, self.view.center.y + self.view.frame.size.width/2 - 35);
        _tipTitle.font = [UIFont systemFontOfSize:13];
        _tipTitle.textAlignment = NSTextAlignmentCenter;
        _tipTitle.numberOfLines = 0;
        _tipTitle.text = @"将取景框对准二维码,即可自动扫描";
        _tipTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_tipTitle];
    }
    _tipTitle.layer.zPosition = 1;
    [self.view bringSubviewToFront:_tipTitle];
}

- (void)drawBottomItems
{
    if (_toolsView) {
        
        return;
    }
    
    self.toolsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-64,
                                                             CGRectGetWidth(self.view.frame), 64)];
    _toolsView.backgroundColor = [UIColor colorWithRed:0.212 green:0.208 blue:0.231 alpha:1.00];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"resource" ofType: @"bundle"]];
    
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 64);
    
    self.scanTypeQrBtn = [[UIButton alloc]init];
    _scanTypeQrBtn.frame = CGRectMake(0, 0, size.width, size.height);
    [_scanTypeQrBtn setTitle:@"二维码" forState:UIControlStateNormal];
    [_scanTypeQrBtn setTitleColor:[UIColor colorWithRed:0.165 green:0.663 blue:0.886 alpha:1.00] forState:UIControlStateSelected];
    [_scanTypeQrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanTypeQrBtn setImage:[UIImage imageNamed:@"scan_qr_normal" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_scanTypeQrBtn setImage:[UIImage imageNamed:@"scan_qr_select" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_scanTypeQrBtn setSelected:YES];
    _scanTypeQrBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    _scanTypeQrBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_scanTypeQrBtn addTarget:self action:@selector(qrBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.scanTypeBarBtn = [[UIButton alloc]init];
    _scanTypeBarBtn.frame = CGRectMake(size.width, 0, size.width, size.height);
    [_scanTypeBarBtn setTitle:@"条形码" forState:UIControlStateNormal];
    [_scanTypeBarBtn setTitleColor:[UIColor colorWithRed:0.165 green:0.663 blue:0.886 alpha:1.00] forState:UIControlStateSelected];
    [_scanTypeBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanTypeBarBtn setImage:[UIImage imageNamed:@"scan_bar_normal" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_scanTypeBarBtn setImage:[UIImage imageNamed:@"scan_bar_select" inBundle:bundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_scanTypeBarBtn setSelected:NO];
    _scanTypeBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    _scanTypeBarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_scanTypeBarBtn addTarget:self action:@selector(barBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_toolsView addSubview:_scanTypeQrBtn];
    [_toolsView addSubview:_scanTypeBarBtn];
    [self.view addSubview:_toolsView];
}

- (void)setNavItem:(MMScanType)type {
    //    if(type == MMScanTypeBarCode) {
    //        [self.navigationItem setRightBarButtonItem:nil];
    //    } else {
    //        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoto)];
    //        [self.navigationItem setRightBarButtonItem:rightItem];
    //}
}

#pragma mark -底部功能项事件
//修改扫码类型 【二维码  || 条形码】
- (void)qrBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    if (delayQRAction) return;
    
    [sender setSelected:YES];
    [_scanTypeBarBtn setSelected:NO];
    [self changeScanCodeType:MMScanTypeQrCode];
    [self setNavItem:MMScanTypeQrCode];
    delayQRAction = YES;
    [self performTaskWithTimeInterval:3.0f action:^{
        delayQRAction = NO;
    }];
    
}

- (void)barBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    if (delayBarAction) return;
    
    [sender setSelected:YES];
    [_scanTypeQrBtn setSelected:NO];
    [self.scanRectView stopAnimating];
    [self changeScanCodeType:MMScanTypeBarCode];
    [self setNavItem:MMScanTypeBarCode];
    delayBarAction = YES;
    [self performTaskWithTimeInterval:3.0f action:^{
        delayBarAction = NO;
    }];
}

#pragma mark - 修改扫码类型 【二维码  || 条形码】
- (void)changeScanCodeType:(MMScanType)type {
    [self.session stopRunning];
    __weak typeof (self)weakSelf = self;
    CGSize scanSize = CGSizeFromString([self scanRectWithScale:1][1]);
    if (type == MMScanTypeBarCode) {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        self.title = @"条码";
        _scanRect = CGRectFromString([weakSelf scanRectWithScale:3][0]);
        scanSize = CGSizeFromString([self scanRectWithScale:3][1]);
    } else {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        self.title = @"二维码";
        _scanRect = CGRectFromString([weakSelf scanRectWithScale:1][0]);
        scanSize = CGSizeFromString([self scanRectWithScale:1][1]);
    }
    
    
    //设置扫描聚焦区域
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.output.rectOfInterest = _scanRect;
        [weakSelf.scanRectView setScanType: type];
        _tipTitle.text = type == MMScanTypeQrCode ? @"将取景框对准二维码,即可自动扫描" : @"将取景框对准条码,即可自动扫描";
        [weakSelf.session startRunning];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        _tipTitle.center = CGPointMake(self.view.center.x, self.view.center.y + scanSize.height/2 + 25);
    }];
}

////打开相册
//- (void)openPhoto
//{
//    if ([self isAvailablePhoto])
//        [self openPhotoLibrary];
//    else
//    {
//        NSString *tipMessage = [NSString stringWithFormat:@"请到手机系统的\n【设置】->【隐私】->【相册】\n对%@开启相机的访问权限",appName];
//        [self showError:tipMessage andTitle:@"相册读取权限未开启"];
//    }
//}

- (void)openPhotoLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    
    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - 识别二维码
+ (void)recognizeQrCodeImage:(UIImage *)image onFinish:(void (^)(NSString *result))finish {
    [[[ScanBankPayController alloc] init] recognizeQrCodeImage:image onFinish:finish];
}

- (void)recognizeQrCodeImage:(UIImage *)image onFinish:(void (^)(NSString *result))finish {
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0 ) {
        
   //[self showError:@"只支持iOS8.0以上系统"];
        return;
    }
    
    //系统自带识别方法
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1)
    {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scanResult = feature.messageString;
        if (finish) {
            finish(scanResult);
        }
    } else {
      //  [self showError:@"图片中未识别到二维码"];
    }
}
#pragma mark - 创建二维码/条形码
+ (UIImage*)createQRImageWithString:(NSString*)content QRSize:(CGSize)size
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//引用自:http://www.jianshu.com/p/e8f7a257b612
//引用自:https://github.com/MxABC/LBXScan
+ (UIImage* )createQRImageWithString:(NSString*)content QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//TODO: 绘制条形码
+ (UIImage *)createBarCodeImageWithString:(NSString *)content barSize:(CGSize)size
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImage = filter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}


+ (UIImage* )createBarCodeImageWithString:(NSString*)content QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *barFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [barFilter setValue:stringData forKey:@"inputMessage"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",barFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

#pragma mark - 延时操作器
- (void)performTaskWithTimeInterval:(NSTimeInterval)timeInterval action:(void (^)(void))action
{
    double delayInSeconds = timeInterval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        action();
    });
}


@end
