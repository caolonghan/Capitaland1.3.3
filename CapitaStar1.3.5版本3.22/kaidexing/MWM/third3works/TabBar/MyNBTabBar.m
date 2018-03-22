//
//  MyNBTabBar.m
//  NB2
//
//  Created by kohn on 13-11-16.
//  Copyright (c) 2013年 Kohn. All rights reserved.
//

#import "MyNBTabBar.h"
#import "MyNBTabButton.h"
#import "MyNBTabNotification.h"
#import "Const.h"

#define HEIGHT_MENU_VIEW ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 45 : 65)

@interface MyNBTabBar()

@property (strong) NSMutableArray *buttons;
@property (strong) NSMutableArray *buttonData;
@property (strong) NSMutableArray *statusLights;

- (void)setupButtons;
- (void)setupLights;
@end

@implementation MyNBTabBar
@synthesize buttons = _buttons, buttonData = _buttonData, statusLights = _statusLights, delegate;

- (id)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, SCREEN_FRAME.size.height - HEIGHT_MENU_VIEW, SCREEN_FRAME.size.width, 45);
        self.backgroundColor = [UIColor whiteColor];
        self.buttonData = [[NSMutableArray alloc]initWithArray:items];
        self.buttons = [[NSMutableArray alloc]init];
        
        [self setupButtons];
        [self setupLights];
        
    }
    return self;
}

- (id)initWithItemsNoFrame:(NSArray *)items {
    self = [super init];
    if (self) {
        //整个导航颜色
        self.backgroundColor = TAB_BAR_BG_COLOR;
        self.buttonData = [[NSMutableArray alloc]initWithArray:items];
        self.buttons = [[NSMutableArray alloc]init];
        
        [self setupButtons];
        [self setupLights];
        
    }
    return self;
}

-(void) setButtonsBackColor{
    for(UIButton* item in self.buttons){
//        if([Global sharedClient].isMon){
//            item.backgroundColor = BLACK_BG_COLOR;
//        }else{
//            item.backgroundColor = [UIColor whiteColor];
//        }
        
    }
}

//-(void) setBackgroundColor:(UIColor *)backgroundColor{
//    self.backgroundColor = backgroundColor;
//}

- (void)setupButtons {
    NSInteger count = 0;
    NSInteger xExtra = 0;
    NSInteger buttonSize = floor(SCREEN_FRAME.size.width / [self.buttonData count]);
    for (MyNBTabButton *info in self.buttonData) {
        NSInteger extra = 0;
        if ([self.buttonData count] % 2 == 1) {
            if ([self.buttonData count] == 5) {
                NSInteger i = (count +1) + (floor([self.buttonData count] / 2));
                if (i == [self.buttonData count]) {
                    extra = 1;
                }
            }else{
                if (count + 1 == 2) {
                    extra = 1;
                } else if (count + 1 == 3) {
                    xExtra = 1;
                }
            }
        }
        NSInteger buttonX = (count * buttonSize) +xExtra;
        
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.frame  = CGRectMake(buttonX, 1, buttonSize + extra, 44);

        
        UIImage * normalImage = [info icon];
        UIImage * highlightImage = [info highlightedIcon];
        
        UIImageView *btnImgView = [[UIImageView alloc] initWithImage:normalImage highlightedImage:highlightImage];
        btnImgView.frame = CGRectMake((buttonSize + extra-buttonSize)/2, 6, buttonSize, 45-12);
        btnImgView.contentMode = UIViewContentModeScaleAspectFit;
        btnImgView.clipsToBounds = YES;
        [tabButton addSubview:btnImgView];
        
//        [tabButton setBackgroundImage:tabButtonBackground forState:UIControlStateNormal];
//        [tabButton setBackgroundImage:hightabButtonBackground forState:UIControlStateSelected];
        
        
        //按钮的背景颜色
        //tabButton.backgroundColor = [UIColor clearColor];
        tabButton.backgroundColor = [UIColor whiteColor];
        
        [tabButton addTarget:self action:@selector(touchDownForButton:) forControlEvents:UIControlEventTouchDown];
        [tabButton addTarget:self action:@selector(touchUpForButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:tabButton];
        [self.buttons addObject:tabButton];
        count++;
    }
}

- (void)setupLights{
    NSInteger count = 0;
    NSInteger xExtra = 0;
    NSInteger buttonSize = floor(320 / [self.buttonData count]) - 1;
    for (MyNBTabButton *info in self.buttonData) {
        NSInteger extra = 0;
        if ([self.buttonData count] % 2 == 1) {
            if ([self.buttonData count] == 5) {
                NSInteger i = (count + 1) + (floor([self.buttonData count] / 2));
                if (i == [self.buttonData count]) {
                    extra = 1;
                } else if (i == [self.buttonData count]+1) {
                    xExtra = 1;
                }
            } else if ([self.buttonData count] == 3) {
                buttonSize = floor(320 / [self.buttonData count]);
            }
        } else {
            if (count + 1 == 2) {
                extra = 1;
            } else if (count + 1 == 3) {
                xExtra = 1;
            }
        }
        NSInteger buttonX = (count * buttonSize) + count + xExtra;
        [[info notificationView] updateImageView];
        [[info notificationView] setAllFrames:CGRectMake(buttonX + buttonSize+extra - 29 , 0, 24, 27)];
        
        [self addSubview:[info notificationView]];
        count++;
    }
    
}

- (void)showDefauls {
    [self touchDownForButton:[self.buttons objectAtIndex:0]];
    [self touchUpForButton:[self.buttons objectAtIndex:0]];
}
- (void)showIndex:(NSInteger) index{
    [self touchDownForButton:[self.buttons objectAtIndex:index]];
    [self touchUpForButton:[self.buttons objectAtIndex:index]];
}

- (void)touchDownForButton:(UIButton *)button{
    NSInteger i = [self.buttons indexOfObject:button];
    MyNBTabButton* btn =[self.buttonData objectAtIndex:i];
    MyNBTabController *vc = [btn viewController];
    [delegate switchViewController:vc];
    if(vc == nil ||[btn noDown]){
        return;
    }
    button.selected = YES;
    
    for (UIButton *b in self.buttons) {
        for (UIView *aView in [b subviews]) {
            if ([aView isKindOfClass:[UIImageView class]]) {
                UIImageView * imgView = (UIImageView *)aView;
                imgView.highlighted = NO;
            }
        }
    }
    for (UIView *aView in [button subviews]) {
        if ([aView isKindOfClass:[UIImageView class]]) {
            UIImageView * imgView = (UIImageView *)aView;
            imgView.highlighted = YES;
        }
    }
    
    for (UIButton * b in self.buttons) {
        b.selected = NO;
    }
    
}
- (void)touchUpForButton:(UIButton *)button {
    NSInteger i = [self.buttons indexOfObject:button];
    MyNBTabButton* btn =[self.buttonData objectAtIndex:i];
    MyNBTabController *vc = [[self.buttonData objectAtIndex:i] viewController];
    if(vc == nil || [btn noDown]){
        return;
    }
    for (UIButton *b in self.buttons) {
        for (UIView *aView in [b subviews]) {
            if ([aView isKindOfClass:[UIImageView class]]) {
                UIImageView * imgView = (UIImageView *)aView;
                imgView.highlighted = NO;
            }
        }
    }
    for (UIView *aView in [button subviews]) {
        if ([aView isKindOfClass:[UIImageView class]]) {
            UIImageView * imgView = (UIImageView *)aView;
            imgView.highlighted = YES;
        }
    }
    
    for (UIButton * b in self.buttons) {
        b.selected = NO;
    }
    button.selected = YES;
    
    if([delegate respondsToSelector:@selector(afterTouchUp)]){
        [delegate afterTouchUp];
    }
}


@end
