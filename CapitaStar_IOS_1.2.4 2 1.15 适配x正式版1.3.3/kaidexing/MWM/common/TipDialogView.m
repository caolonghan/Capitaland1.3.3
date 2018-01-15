//
//  DialogView.m
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/22.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import "TipDialogView.h"
#import "Const.h"

@implementation TipDialogView{
}

+ (instancetype)defaultPopupView {
    TipDialogView* view = [[TipDialogView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width -80, 800*(SCREEN_FRAME.size.width -80)/580)];
    view.backgroundColor = [UIColor whiteColor];
    [view.layer setCornerRadius:4.0f];
    [view setClipsToBounds:YES];
    
    UIImageView* imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = view.bounds;
    [view addSubview:imgView];
    imgView.tag = 2;
    
    UIImageView* closeImgView = [[UIImageView alloc] init];
    closeImgView.contentMode = UIViewContentModeScaleAspectFill;
    int width = 20;
    int heigh = 20;
    closeImgView.frame = CGRectMake(CGRectGetWidth(view.frame)-width -6,6, width, heigh);
    [closeImgView setImage:[UIImage imageNamed:@"close_1"]];
    [view addSubview:closeImgView];
    closeImgView.tag = 3;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(viewOnTap:)];
    [view addGestureRecognizer:gesture];
    return view;
}

-(void)setImgUrl:(NSString*) imgName{
    UIImageView* imgView = (UIImageView*)[self viewWithTag:2];
    [imgView setImageWithString:imgName];
}

-(void)viewOnTap:(UITapGestureRecognizer*) tap{
    [[tap view] setUserInteractionEnabled:NO];
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}
-(void)closeOnTap:(id) sender{
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}


@end
