//
//  ShopeDetailViewController.h
//  kaidexing
//
//  Created by dwolf on 16/5/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "ImageScrollView.h"

@interface ShopeDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *advView;
@property (weak, nonatomic) IBOutlet UIImageView *tmImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *collectView;
@property (weak, nonatomic) IBOutlet UIImageView *collectImgView;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sayYesImg;
@property (weak, nonatomic) IBOutlet UILabel *sayYesLabel;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *locView;
@property (weak, nonatomic) IBOutlet UILabel *locLabel;
@property (weak, nonatomic) IBOutlet UIView *dingzView;
@property (weak, nonatomic) IBOutlet UIView *pzView;
@property (weak, nonatomic) IBOutlet UITableView *huoDongTabelView;
@property (weak, nonatomic) IBOutlet UIView *shopeInrView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *dpView;
@property (weak, nonatomic) IBOutlet UICollectionView *dpCololectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hdHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dpHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopIntroHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shop2hdConst;

@end
