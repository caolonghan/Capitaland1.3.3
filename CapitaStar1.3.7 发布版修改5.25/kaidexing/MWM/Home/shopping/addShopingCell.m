//
//  addShopingCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/28.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "addShopingCell.h"
#import "Const.h"
@implementation addShopingCell


-(void) createItem:(CGFloat)view_W index:(int)index view:(UIView*) view
            logImg:(UIImageView*)logoImg typeImg:(UIImageView*)typeImg
          shopName:(UILabel*) shopName
         colorView:(UIImageView*) coloView
             index:(NSInteger) index1{
    view_W=(WIN_WIDTH-22)/2;
    
    
    view.frame = CGRectMake(M_WIDTH(8)+index*(view_W+M_WIDTH(3)), 0, view_W,view_W);
    
    view.backgroundColor=[UIColor whiteColor];
    
    logoImg.frame = CGRectMake(0, 0, view_W, view_W-M_WIDTH(32));
    logoImg.contentMode=UIViewContentModeScaleAspectFill;
    logoImg.clipsToBounds=YES;
    
    typeImg.frame = CGRectMake(view_W-M_WIDTH(28),M_WIDTH(13), M_WIDTH(18), M_WIDTH(18));
    typeImg.layer.masksToBounds=YES;
    [typeImg setUserInteractionEnabled:YES];
    typeImg.layer.cornerRadius=typeImg.frame.size.width/2;
    
    
    shopName.frame = CGRectMake(0, CGRectGetMaxY(logoImg.frame), view.frame.size.width, M_WIDTH(32));
    shopName.textAlignment=NSTextAlignmentCenter;
    shopName.font=COMMON_FONT;
    shopName.textColor=[UIColor blackColor];
    
    coloView.frame=logoImg.bounds;
    [coloView setUserInteractionEnabled:YES];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:view.bounds];
    _viewTag++;
    btn.tag=_viewTag+index1*2;
    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:logoImg];
    [view addSubview:coloView];
    [view addSubview:typeImg];
    [view addSubview:shopName];
    [view addSubview:btn];
    [self addSubview:view];
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CGFloat view_W=(WIN_WIDTH-22)/2;
    self.view1= [[UIView alloc] init];
    _logoImg1 = [[UIImageView alloc] init];
    _typeImg1 = [[UIImageView alloc] init];
    _shopName1= [[UILabel alloc] init];
    _colorView1= [[UIImageView alloc]init];
    
    [self createItem:view_W index:0 view:self.view1 logImg:self.logoImg1 typeImg:self.typeImg1 shopName:self.shopName1 colorView:_colorView1 index:index];
    
    self.view2= [[UIView alloc] init];
    _logoImg2 = [[UIImageView alloc] init];
    _typeImg2 = [[UIImageView alloc] init];
    _shopName2= [[UILabel alloc] init];
    _colorView2= [[UIImageView alloc]init];
    
    [self createItem:view_W index:1 view:self.view2 logImg:self.logoImg2 typeImg:self.typeImg2 shopName:self.shopName2 colorView:_colorView2 index:index];
    
    
    return self;
}

-(void)btnTouch:(UIButton*)sender
{
    NSString *strTag=[NSString stringWithFormat:@"%ld",sender.tag-1];
    NSLog(@"点击了第  %@  ",strTag);
    if (_addDelegate &&[_addDelegate respondsToSelector:@selector(setaddshopTouch1:)]) {
        [_addDelegate setaddshopTouch1:strTag];
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
