//
//  ApplicationCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/22.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *stateBtnImg;
@property (weak, nonatomic) IBOutlet UIImageView *functionImg;
@property (weak, nonatomic) IBOutlet UILabel *functionLab;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;

// 1我的应用中显示  2所有应用中已添加 0所用应用中未添加
-(void)canEdit:(BOOL)ishidden;


@end
