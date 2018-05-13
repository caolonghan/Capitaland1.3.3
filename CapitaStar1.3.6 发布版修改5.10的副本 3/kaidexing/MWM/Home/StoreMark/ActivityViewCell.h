//
//  ActivityViewCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/17.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewCell : UITableViewCell

@property (strong,nonatomic)UIImageView     *bigImgView;    //列表左侧显示的大图，通用的
@property (strong,nonatomic)UILabel         *huodongType;   //活动类型
@property (strong,nonatomic)UILabel         *nameLab;       //标题
@property (strong,nonatomic)UILabel         *juliLab;    //标题下面的说明
@property (strong,nonatomic)UILabel         *addressLab;    //说明下面的地址
@property (strong,nonatomic)UIImageView     *img_Down;   //表示距离的小图标

@end
