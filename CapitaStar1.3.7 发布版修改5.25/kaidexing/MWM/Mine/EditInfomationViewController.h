//
//  EditInfomationViewController.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/15.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "KKDatePickerView.h"
@interface EditInfomationViewController : BaseViewController< UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,timeDelegate>

@property(nonatomic, retain)NSArray * section0_Data;
@property(nonatomic, retain)NSArray * section1_Data;

@end
