//
//  EditInfomationViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/15.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "EditInfomationViewController.h"

#import "MyToolbar.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VPImageCropperViewController.h"
#import "MaskMessage.h"
#import "KKDatePickerView.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface EditInfomationViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, VPImageCropperDelegate>
{
    UITableView * editTView;

    NSArray * section_0;
    NSArray * section_1;
    
    NSString * nick_name;
    NSString * username;
    NSString * sex;
    NSString * birth;
    NSString * phone_num;
    
    UIActionSheet* pickerViewPopup;
    UIAlertController* pickerViewPopupVC;
    UIDatePicker* datePicker;
    
    UITextField * sexTextField;
    UITextField * birthdayTextField;
    
    NSMutableArray * textFields;
    
    NSData* userImgData;
    BOOL choicePicker;
    UIImage *portraitImg;
    UIImageView * coverIV;
    UIView *timeView;
}
@end

@implementation EditInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"编辑信息";
    
    section_0 = @[@"头像", @"昵称"];
    section_1 = @[@"真实姓名", @"性别", @"生日", @"手机号"];
    
    textFields = [[NSMutableArray alloc] init];
    
    editTView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT) style:UITableViewStyleGrouped];
    editTView.dataSource = self;
    editTView.delegate = self;
    
    editTView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self.view addSubview:editTView];
    
    [self setKeyboardContainer:editTView];
    
    
    UIView * tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 90)];
    tableFooterView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    editTView.tableFooterView = tableFooterView;
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(16, 24, WIN_WIDTH - 16 * 2, 40);
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = APP_BTN_COLOR;
    btn.titleLabel.font = COMMON_FONT;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFooterView addSubview:btn];
}

- (void)saveAction:(UIButton *)sender {
    
    if ([Util isNull:nick_name]) {
        
        nick_name = [_section0_Data lastObject];
    }
    if ([Util isNull:username]) {
        username = _section1_Data.firstObject;
    }
    if ([Util isNull:sex]) {
        if ([_section1_Data[1] isEqualToString:@"男"]) {
            sex = @"1";
        } else if ([_section1_Data[1] isEqualToString:@"女"]) {
            sex = @"2";
        }
        if ([Util isNull:sex]) {
            [SVProgressHUD showErrorWithStatus:@"请选择您的性别"];
            return;
        }
    }
    if ([Util isNull:birth]) {
        birth = _section1_Data[2];
    }
    if ([Util isNull:phone_num]) {
        phone_num = _section1_Data.lastObject;
        
        if ([Util isNull:phone_num]) {
            [SVProgressHUD showErrorWithStatus:@"请输入您的手机号"];
            return;
        }
    }

    
    NSString * path = [Util makeRequestUrl:@"member" tp:@"upuserinfo"];

    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:phone_num, @"phone_num", sex, @"sex", nick_name, @"nick_name", username, @"username", birth, @"birth", @"1000", @"source", nil];
    
    //[SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showMsg:dic[@"data"] afterOK:^{
                [self.delegate.navigationController popViewControllerAnimated:YES];
               
            }];
        });
        
    } failue:^(NSDictionary *dic) {

    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 72;
        } else {
            
            return 50;
        }
    } else {
        
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"EditInfomationTVCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = COMMON_FONT;
        cell.textLabel.textColor = COLOR_FONT_SECOND;
        
//        UIImageView * coverIV = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 16 - 50, 8, 50, 50)];
//        coverIV.tag = 3000;
//        coverIV.layer.cornerRadius = 25;
//        coverIV.layer.masksToBounds = YES;
//        coverIV.backgroundColor = [UIColor whiteColor];
//        coverIV.hidden = YES;
//        
//        [cell addSubview:coverIV];
        
        
//        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 16 - 230, 5, 230, 40)];
//        
//        textField.font = COMMON_FONT;
//        textField.textAlignment = NSTextAlignmentRight;
//        textField.textColor = COLOR_FONT_SECOND;
//        textField.tag = 4000;
//        textField.delegate = self;
//        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
//        textField.hidden = YES;
//        
//        [cell addSubview:textField];
    }
    
    for (UIView * view in cell.subviews) {
        
        if ([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = section_0[indexPath.row];
       // cell.textLabel.textColor = [UIColor whiteColor];
        if (indexPath.row == 0) {
            
//            UIImageView * coverIV = [cell viewWithTag:3000];
//            coverIV.hidden = NO;
            coverIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIN_WIDTH - 16 - 50, 8, 50, 50)];
            coverIV.userInteractionEnabled = YES;
            coverIV.layer.cornerRadius = 25;
            coverIV.layer.masksToBounds = YES;
            [coverIV setImageWithString:[_section0_Data firstObject] placeholderImage:[UIImage imageNamed:@"user" ]];
            coverIV.contentMode = UIViewContentModeScaleAspectFill;
            coverIV.clipsToBounds = YES;
            
            [cell addSubview:coverIV];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shangChuanTouXiang:)];
            
            [coverIV addGestureRecognizer:tap];
            
        } else {
            
//            UITextField * textField = [cell viewWithTag:4000];
//            textField.hidden = NO;
            UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(WIN_WIDTH - 16 - 230, 5, 230, 40)];
            textField.font = COMMON_FONT;
            textField.textAlignment = NSTextAlignmentRight;
           // textField.textColor = [UIColor whiteColor];
            textField.tag = 4000;
            textField.delegate = self;
            [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            textField.text = [_section0_Data lastObject];
            
            [cell addSubview:textField];
            
            [textFields addObject:textField];
        }
        
    } else {
        
        
        cell.textLabel.text = section_1[indexPath.row];
        cell.textLabel.textColor = COLOR_FONT_SECOND;
        
//        UITextField * textField = [cell viewWithTag:4000];
//        textField.hidden = NO;
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(WIN_WIDTH - 16 - 230, 5, 230, 40)];
        textField.font = COMMON_FONT;
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = COLOR_FONT_SECOND;
        textField.tag = indexPath.section + indexPath.row + 4000;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        textField.text = _section1_Data[indexPath.row];
        if (indexPath.row==3) {
            textField.enabled=NO;
        }
        
        [cell addSubview:textField];
        
        [textFields addObject:textField];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 9;
    }
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 9)];
    view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.000001;
}

- (void)textFieldWithText:(UITextField *)textField {
    
    switch (textField.tag - 4000) {
        case 0:
            nick_name = textField.text;
            break;
        case 1:
            username = textField.text;
            break;
        case 2:
//            if ([textField.text isEqualToString:@"男"]) {
//                sex = @"1";
//            } else if ([textField.text isEqualToString:@"女"]) {
//                sex = @"2";
//            }
            break;
        case 3:
//            birth = textField.text;
            break;
        case 4:
            phone_num = textField.text;
            break;
        default:
            break;
    }
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    //获取可见cells
    NSArray* visibleCells = editTView.visibleCells;
    
    for (UITableViewCell *cell in visibleCells) {
        
        for(UIView* subView in  [cell subviews]){
            if([subView isKindOfClass:[UITextField class]]){
                [subView resignFirstResponder];
            }
        }
    }
    if (textField.tag == 4002) {
        sexTextField = textField;
        
        UIActionSheet* mySheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",@"女",nil];
        
        [mySheet showInView:self.view];
        mySheet.tag = 6000;
        
        return NO;
    }
    if (textField.tag == 4003) {
        
        birthdayTextField = textField;
        
        [self createTimeView];
        
        return false;
    }
    if (textField.tag == 4004) {
        [textField setKeyboardType:UIKeyboardTypePhonePad];
    }
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
}

//创建选择时间的view
-(void)createTimeView{
    
    timeView =[[UIView alloc]initWithFrame:self.view.bounds];
    timeView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    KKDatePickerView* kkTimeView=[[KKDatePickerView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-M_WIDTH(197),WIN_WIDTH,M_WIDTH(197))];
    kkTimeView.tDetegate=self;
    kkTimeView.backgroundColor=[UIColor whiteColor];
    
    [timeView addSubview:kkTimeView];
    [self.view addSubview:timeView];
}
-(void)setTime_pick:(id)time{
    [timeView removeFromSuperview];
    NSString *timestr=[NSString stringWithFormat:@"%@-%@-%@",time[0],time[1],time[2]];
    birthdayTextField.text = timestr;
    birth = timestr;
}
-(void)setdeleteView{
    [timeView removeFromSuperview];
}

-(BOOL)pickYear:(id)sender{
    
    if(IS_IOS_8){
        [pickerViewPopupVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * pickBirthday = [formatter stringFromDate:datePicker.date];
    
    birthdayTextField.text = pickBirthday;
    
    birth = pickBirthday;
    
    return  YES;
}

-(BOOL)closePicker:(id)sender
{
    if(IS_IOS_8){
        [pickerViewPopupVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    return  YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shangChuanTouXiang:(UITapGestureRecognizer *)tapGesture {
    
    if(![self isSignIn]){
        return;
    }
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:nil
                              delegate:self
                              cancelButtonTitle:@"取消"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"拍照",@"从相册选择",nil];
    
    [mySheet showInView:self.view];
    mySheet.tag = 1;
}

- (void)viewImg:(UIImage*) img{
    MaskMessage* view = [MaskMessage defaultPopupView];
    [view setParentVC:self];
    [view setTitle:@"上传图片"];
    [view setBtns:@[@"确定",@"取消"]];
    UIImageView* imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(10, 0, view.frame.size.width - 20, 400);
    imgView.image = img;
    imgView.contentMode = UIViewContentModeScaleAspectFit ;
    [view setView:imgView height:400];
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:view animation:animation dismissed:^{
        
    }];
}

-(void) btnSelected:(NSString*)index{
    if([index isEqualToString:@"1"]){
        return ;
    }else{
        [self updateImg];
    }
}

-(void) updateImg{
    
    [SVProgressHUD showWithStatus:@"数据上传中..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        [self uploadImg:UIImageJPEGRepresentation(portraitImg,1.0)];
    });
    
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //照片选择
    if(actionSheet.tag ==1){
        if(buttonIndex == 0){
            NSLog(@"选择了拍照");
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     choicePicker = false;
                                 }];
            }
            
            
        }else if(buttonIndex == 1){
            NSLog(@"选择了从相册选择");
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     choicePicker = true;
                                 }];
            }
            
        }
    }
    //性别选择
    else if(actionSheet.tag == 6000){
        
        if(buttonIndex == 0){
            NSLog(@"选择了男");
            sexTextField.text = @"男";
            sex = @"1";
            
        }else if(buttonIndex == 1){
            NSLog(@"选择了女");
            sexTextField.text = @"女";
            sex = @"2";
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//以下是头像设置代码，从第三方copy

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if(choicePicker){
            [self viewImg:portraitImg];
        }else{
            
            [self updateImg];
        }
        
        
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

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
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
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
        //        [self uploadCheck];
    });
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
/*
 member?tp=upheadimg
 form参数
 1、字段定义：
 member_id:会员ID。
 headimg:头像图片。
 source:来源。
 2、请求格式如下：
 member_id=Encrypt加密数据
 headimg:
 source=1000
 */
-(void) uploadImg:(NSData*) imgData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"upheadimg"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"1000",@"source",[self image2DataURL:portraitImg],@"headimg",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            NSLog(@"%@",dic);
            [coverIV setImage:portraitImg];
            
            NSString* imageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[[NSURL alloc] initWithString:[_section0_Data firstObject]]];
            
            [[SDImageCache sharedImageCache] removeImageForKey:imageKey fromDisk:YES];
            
        });
    }failue:^(NSDictionary *dic){
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
