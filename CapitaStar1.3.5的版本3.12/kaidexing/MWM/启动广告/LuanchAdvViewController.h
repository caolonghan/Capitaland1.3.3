//
//  LuanchAdvViewController.h
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
@protocol LuanchAdvViewDelegate <NSObject>
-(void)dismiss;
@end

@interface LuanchAdvViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *skipView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aspectImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *goUrl;
@property (strong, nonatomic) id<LuanchAdvViewDelegate> adViewdelegate ;
@end
