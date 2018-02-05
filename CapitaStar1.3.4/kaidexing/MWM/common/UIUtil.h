//
//  UIUtil.h
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-25.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Const.h"


@interface UIUtil : NSObject

+(NSString*) structHtml:(NSString*) content;

+(NSString*) structHtml:(NSString*) content scalable:(BOOL) scalable fontsize:(NSString*) fontsize bodyCss:(NSString*) css;

+(NSString*) formatTitleHtml:(NSString*) title createDt:(NSString*) createDt parseNum:(NSString*) parseNum titleCss:(NSString*) titleCss;

+(void) removeSubView:(UIView* ) view;

+(UIBarButtonItem*) makeBarButtonItem:(UIButton*) btn;

+(UITableViewCell*) findSuperCell:(UIView*) view;

//添加底部导航VIEW
+(UIView*) makeBottomBar;
+(UIBarButtonItem*) makeRightBarButtonItem:(UIButton*) btn;
//添加标准底部按钮
+(UIButton*) makeBottomButton:(UIView*) bottomBar title:(NSString*) title;


+(NSArray*) makeNavigationBarButton:(NSArray*) titles;

+(CGSize) boundingRectWithSize:(CGSize) size text:(NSString*) text font:(UIFont*) font;

+(float) deviceValue:(float) value;

@end
