//
//  FollowCell.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol follTouch <NSObject>

-(void)setindexTouch:(id)follTouch;

@end

@interface FollowCell : UITableViewCell

@property (nonatomic,assign)id<follTouch>follDelegate;

@property (nonatomic)       NSInteger        viewTag;
@property (strong,nonatomic)UIView          *view1;
@property (strong,nonatomic)UIView          *view2;
@property (strong,nonatomic)UILabel         *shopName1;
@property (strong,nonatomic)UILabel         *shopName2;
@property (strong,nonatomic)UIImageView     *logoImg1;
@property (strong,nonatomic)UIImageView     *logoImg2;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index;
@end
