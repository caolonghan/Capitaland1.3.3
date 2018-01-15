//
//  UIUtil.m
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-25.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "UIUtil.h"

#define DEFAULT_MAIN_COLOR RGBCOLOR(255,126,0)
#define DEFAULT_TEXT_COLOR RGBCOLOR(207,207,207)


@implementation UIUtil


+(NSString*) structHtml:(NSString*) content{
    return [UIUtil structHtml:content scalable:NO fontsize:@"16px" bodyCss:@""];
}

+(NSString*) structHtml:(NSString*) content scalable:(BOOL) scalable fontsize:(NSString*) fontSize bodyCss:(NSString*) css{
    
    //background-color:#F8F7F5;
    NSString* template = @"<!DOCTYPE html><html><head><meta content=\"initial-scale=1.0,user-scalable=%@,maximum-scale=%@,width=device-width\" name=\"viewport\" /> <style type=\"text/css\">body {margin:0 auto;word-break:break-all;font-size:%@;line-height:1.5;color:#3E3E3E;background-color:#fff;font-family:Helvetica,STHeiti STXihei,Microsoft JhengHei,Microsoft YaHei,Tohoma,Arial;%@}  iframe{width:290px;height:auto;margin:4px 0 4px 0;}img{max-width:290px;height:auto;margin:4px 0 4px 0;}.items{height:auto;overflow:hidden;border-bottom:1px solid #E7E5E5;padding-top:5px;padding-bottom:5px;clear:both;}.item{float:left;}.item .title{display:block;font-size:16px;color:#333;}.item .date{display:block;font-size:14px;color:#999;}.nav {background-color:#E8E8E8;height:40px;line-height: 40px;margin-bottom:10px;}.nav img{float:left;margin-top:4px;width:30px;height:30px;margin-left:5px;}.nav lable{float:left;font-size:16px;color:#444;margin-left:5px;}</style></head><body>%@"
    @"</body></html>";
    return [NSString stringWithFormat:template,scalable?@"yes":@"no",scalable?@"3.0":@"1.0",fontSize,css,content];
}



/**
 * 内容也标题HTML
 */
+(NSString*) formatTitleHtml:(NSString*) title createDt:(NSString*) createDt parseNum:(NSString*) parseNum titleCss:(NSString*) titleCss{
    //border-top:1px solid #e5e6eb;
    NSString* template = @"<div style='clear:both;'><div style='text-align:left;color:#000;font-weight:bold;font-size:20px;word-wrap:break-word;%@'>%@</div><div style='text-align:left;color:#8C8C8C;font-size:11px;padding:0px 2px 6px 2px;'>%@ <img src='http://121.197.0.152/static/parsie.png' height='12' width='12' style='margin-left:10;margin-bottom:-1px;margin-right:2px;width:12px;height:12px;'/><span id='paseNum'>%@</span></div></div>";
    return [NSString stringWithFormat:template,titleCss,title,createDt,parseNum];
}

+(UIBarButtonItem*) makeBarButtonItem:(UIButton*) btn{
    if(IS_IOS_7){
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    }else{
        CGRect frame = btn.frame;
        frame.size.width = frame.size.width + 10;
        btn.frame = frame;
    }
    UIBarButtonItem* aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [aBarButtonItem setBackgroundImage:[UIImage imageNamed:@"trans.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    return aBarButtonItem;
}
+(UIBarButtonItem*) makeRightBarButtonItem:(UIButton*) btn{
    if(IS_IOS_7){
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        CGRect frame = btn.frame;
        frame.size.width = frame.size.width + 10;
        btn.frame = frame;
    }
    UIBarButtonItem* aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [aBarButtonItem setBackgroundImage:[UIImage imageNamed:@"trans.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    return aBarButtonItem;
}


+(void) removeSubView:(UIView* ) view{
    NSArray* subviews = [view subviews];
    for(int i = 0;i<[subviews count];i++){
        [[subviews objectAtIndex:i] removeFromSuperview];
    }
}

+(UITableViewCell*) findSuperCell:(UIView*) view{
    if(view == nil){
        return nil;
    }
    if([view.superview isKindOfClass:[UITableViewCell class]]){
        return (UITableViewCell*)view.superview;
    }else{
        return [UIUtil findSuperCell:view.superview];
    }
}

+(UIView*) makeBottomBar{
    
    UIView* bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_FRAME.size.height - 50, SCREEN_FRAME.size.width, 50)];
    [bottomBar setBackgroundColor:[UIColor clearColor]];
    
    
    UIView* bottomBg = [[UIView alloc] initWithFrame:CGRectMake(0, 6, bottomBar.frame.size.width, 54)];
    [bottomBar addSubview:bottomBg];
    
    UIImageView* bgImgView = [[UIImageView alloc] initWithFrame:bottomBar.bounds];
    [bottomBar addSubview:bgImgView];
    
    [bgImgView setImage:[UIImage imageNamed:@"bottom_bar_bg.png"]];
    
    return bottomBar;
}

+(UIButton*) makeBottomButton:(UIView*) bottomBar title:(NSString*) title{
    int buttonWidth = 80;
    int buttonHeight = 30;
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake((bottomBar.frame.size.width - buttonWidth)/2, ((bottomBar.frame.size.height + 6) - buttonHeight)/2, buttonWidth, buttonHeight)];
    [btn setBackgroundColor:DEFAULT_MAIN_COLOR];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    
    return btn;
}


//顶部导航菜单，比如左右切换按钮
+(NSArray*) makeNavigationBarButton:(NSArray *)titles{
    
    int space = 0;
    int buttonWidth = [[titles objectAtIndex:0] length] < 3?50:80;
    int wrapWidth = [titles count] * buttonWidth + 10 * ([titles count] - 1);
    int startX = (SCREEN_FRAME.size.width - wrapWidth)/2;
    
    NSMutableArray* buttons = [[NSMutableArray alloc] init];
    for(int i = 0;i<[titles count];i++){
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:RGBCOLOR(170,170,170) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(startX + (buttonWidth + space)*i, 0, buttonWidth , 44)];
        [btn setTag:i];
        [buttons addObject:btn];
    }
    return buttons;
}

+(CGSize) boundingRectWithSize:(CGSize) size text:(NSString*) text font:(UIFont*) font{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

+(float) deviceValue:(float) value{
    return (value* SCREEN_FRAME.size.width)/DESIGN_WIDTH;
}

@end
