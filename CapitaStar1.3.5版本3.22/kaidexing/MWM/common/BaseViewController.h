//
//  BaseViewController.h
//  IJoyLife
//
//  Created by Hwang Kunee on 13-7-28.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "Util.h"
#import "UIView+category.h"
#import "SVProgressHUD.h"
#import "JPUSHService.h"
#import "SNObjt.h"

@interface BaseViewController : UIViewController{
    //主背景色
    UIColor *bodybgcolor;
    //item背景色
    UIColor *itembgcolor;
    
    //item2背景色
    UIColor *item1bgcolor;
    //标题颜色
    UIColor *titleColor;
    //内容颜色
    UIColor *descColor;
    //分割线颜色
    UIColor *lineColor;
    
    //推荐文字颜色
    UIColor *commentFontColor;;
    
    
    
    BOOL isblack;
}

@property(nonatomic)BOOL isDisplayLoading;
@property(nonatomic,retain)UIView* keyboardContainer;
@property (nonatomic) BOOL stillAnimatingTransition;
@property(nonatomic)BOOL showHomtBackBtn;

@property(nonatomic,retain)UIViewController* delegate;
@property(nonatomic,retain)UIView* navigationBar;
@property(nonatomic,retain)UIView* navigationBarContentView;
@property(nonatomic,retain)UILabel* navigationBarTitleLabel;
@property(nonatomic,retain)UIView* navigationBarLine;
@property(nonatomic,retain)UIView*  leftBarItemView;
@property(nonatomic,retain)UIView*  rigthBarItemView;
@property(nonatomic,retain)UIView*  rigth_laft_BarItemView;
@property(nonatomic,retain)NSString *nvcImgView;
@property(nonatomic,copy)NSString *advStr;

//重新定义返回按钮，支持自定义事件但是IOS7的滑动关闭效果没了
- (void)redefineBackBtn;

-(void)redefineBackBtn:(UIImage*) image :(CGRect)rect;
-(void)redefineBackBtn:(UIImage*) image;
- (void)setNavigationBarcolor:(UIColor *)color;
//返回按钮触发事件，可重写
- (void)backBtnOnClicked:(id)sender;
//展示默认的加载图示
-(void) displayLoading;

-(int) fontsize;//字体大小
-(int) isDaylight;

-(int) daylight;

//展示错误
-(void)displayError:(NSString*) msg;

//去除默认的加载图示
-(void) removeLoading;

//展示默认黑幕,view提前在幕布前
-(void) displayMask:(UIView*) view;

//清理幕布
-(void) removeMask;


//弹出消息对话框
-(void) showMsg:(NSString*) msg;

-(void) showMsg:(NSString *)msg afterOK:(void (^)(void)) afterOK;

-(void) confirm:(NSString*) msg okBtnTitle:(NSString*) okBtnTitle  afterOK:(void (^)(void)) afterOK afterCancel:(void (^)(void)) afterCancel;

-(void) confirm:(NSString*) msg afterOK:(void (^)(void)) afterOK;

-(UIView*) addNav:(NSString*) icon leftView:(UIView*) leftView rightView:(UIView*) rightView hasWeather:(BOOL) hasWeather;

-(UIView*) addNav:(NSString*) icon iconCenter:(BOOL) iconCenter leftView:(UIView*) leftView rightView:(UIView*) rightView hasWeather:(BOOL) hasWeather;

-(UIView*) addNavWithTitle:(NSString*) title leftView:(UIView*) leftView rightView:(UIView*) rightView hasWeather:(BOOL) hasWeather;

-(void) popToViewController:(int) level;

-(BOOL) checkLogin;

- (void)keyboardWillChangeFrame:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;

-(void)toggleMenu:(int) hidden;


//判断是否登录
-(BOOL)isSignIn;

//用户登录之后做的数据操作
-(void)signInData:(NSDictionary*)dataDic password:(NSString*)pd;
//返回广告
- (void)backToAdv;

@end
