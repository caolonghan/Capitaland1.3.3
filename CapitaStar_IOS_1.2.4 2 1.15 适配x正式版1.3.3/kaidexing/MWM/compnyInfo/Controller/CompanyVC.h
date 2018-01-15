//
//  CompanyVC.h
//  WXCustomCamera
//
//  Created by macvivi on 17/4/2.
//  Copyright © 2017年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CompanyVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerVIew;
@property (strong, nonatomic) IBOutlet UIView *footVIew;
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UIButton *enter_btn;

@end
