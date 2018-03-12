//
//  FollowCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FollowCell.h"
#import "Const.h"

@implementation FollowCell




-(void) createItem:(CGFloat)view_W index:(int)index view:(UIView*) view
               logImg:(UIImageView*)logoImg
             shopName:(UILabel*) shopName
                index:(NSInteger) index1{
    
    view.frame = CGRectMake(8+index*(WIN_WIDTH/2-5), 0, view_W,view_W);
    view.backgroundColor=[UIColor whiteColor];
    logoImg.frame = view.bounds;
    logoImg.contentMode=UIViewContentModeScaleAspectFill;
    logoImg.clipsToBounds=YES;

    shopName.frame = CGRectMake(0, CGRectGetMaxY(view.frame)-M_WIDTH(36), view.frame.size.width, M_WIDTH(36));
    shopName.textAlignment=NSTextAlignmentCenter;
    shopName.font=COMMON_FONT;
    shopName.textColor=[UIColor blackColor];
    
    UIView  *colorview=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame)-M_WIDTH(36), view.frame.size.width, M_WIDTH(36))];
    colorview.backgroundColor=[UIColor whiteColor];
    colorview.alpha=0.5;

    UIButton *btn=[[UIButton alloc]initWithFrame:view.bounds];
    _viewTag++;
    btn.tag=_viewTag+index1*2;
    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:logoImg];
    [view addSubview:colorview];
    [view addSubview:shopName];
    [view addSubview:btn];
    [self addSubview:view];

}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.view1= [[UIView alloc] init];
    _logoImg1 = [[UIImageView alloc] init];
    _shopName1= [[UILabel alloc] init];
    CGFloat  view_W=(WIN_WIDTH-22)/2;
    [self createItem:view_W index:0 view:self.view1 logImg:self.logoImg1 shopName:self.shopName1 index:index];
    
    self.view2= [[UIView alloc] init];
    _logoImg2 = [[UIImageView alloc] init];
    _shopName2= [[UILabel alloc] init];
    
    [self createItem:view_W index:1 view:self.view2 logImg:self.logoImg2 shopName:self.shopName2 index:index];
    
    
    return self;
}

-(void)btnTouch:(UIButton*)sender
{
    NSString *strTag=[NSString stringWithFormat:@"%ld",sender.tag];
    if (_follDelegate &&[_follDelegate respondsToSelector:@selector(setindexTouch:)]) {
        [_follDelegate setindexTouch:strTag];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
