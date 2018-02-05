//
//  AddressCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addressDelegate <NSObject>

-(void)setMoren:(id)morenIndex;
-(void)setbianji:(id)bianjiIndex;
-(void)setdelete:(id)deleteIndex;

@end

@interface AddressCell : UITableViewCell

@property (strong,nonatomic)UILabel     *nameLab;
@property (strong,nonatomic)UILabel     *phoneLab;
@property (strong,nonatomic)UILabel     *dizhiLab;
@property (strong,nonatomic)UIImageView *zhuangtaiImg;
@property (strong,nonatomic)UILabel     *zhuangtaiLab;
@property (assign,nonatomic)id<addressDelegate>dizhiDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index;
@end
