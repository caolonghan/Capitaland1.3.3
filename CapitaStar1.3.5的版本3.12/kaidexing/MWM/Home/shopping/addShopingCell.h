//
//  addShopingCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/28.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addshopTouch <NSObject>
-(void)setaddshopTouch1:(id)addshopindex;

@end

@interface addShopingCell : UITableViewCell

@property (nonatomic,assign)id<addshopTouch>addDelegate;

@property (nonatomic)       NSInteger        viewTag;
@property (strong,nonatomic)UIView          *view1;
@property (strong,nonatomic)UIView          *view2;
@property (strong,nonatomic)UILabel         *shopName1;
@property (strong,nonatomic)UILabel         *shopName2;
@property (strong,nonatomic)UIImageView     *logoImg1;
@property (strong,nonatomic)UIImageView     *logoImg2;
@property (strong,nonatomic)UIImageView     *colorView1;
@property (strong,nonatomic)UIImageView     *colorView2;
@property (strong,nonatomic)UIImageView     *typeImg1;
@property (strong,nonatomic)UIImageView     *typeImg2;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index;
@end
