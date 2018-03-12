//
//  MyCollectionTableViewCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionTableViewCell : UITableViewCell
//我的收藏-----cell1
@property (strong,nonatomic)UIImageView     *bigImgView;    //列表左侧显示的大图，通用的
@property (strong,nonatomic)UILabel         *nameLab;       //标题
@property (strong,nonatomic)UILabel         *explainLab;    //标题下面的说明
@property (strong,nonatomic)UIImageView     *img_Down1;
@property (strong,nonatomic)UILabel         *addressLab;    //地址

//最近星积分----cell2
@property (strong,nonatomic)UILabel         *jifenLab;//星积分的数量
@property (strong,nonatomic)UILabel         *riqiLab;//日期
@property (strong,nonatomic)UILabel         *zhuangtaiLab;//积分状态

@property(nonatomic, retain)NSDictionary * dataDic;

@end
