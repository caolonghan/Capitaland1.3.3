//
//  Const.h
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-20.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//
/*
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif
*/

#define iPhoneOniPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[[UIDevice currentDevice] model] hasPrefix:@"iPad"])
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)


//#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IOS_7 ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]>=7)
#define IS_IOS_8 ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]>=8)
#define IS_IOS_9 ([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue]>=9)

#define SCREEN_FRAME ((IS_IOS_7)?([[UIScreen mainScreen] bounds]):([[UIScreen mainScreen] applicationFrame]))
#define WIN_WIDTH SCREEN_FRAME.size.width
#define WIN_HEIGHT SCREEN_FRAME.size.height
#define PROTOCOLURL  @"https://passport.capitaland.com.cn/registerAgreement"
#define BANKPAYPROTOCOLURL  @"http://mall.capitaland.com.cn/agreement/index.html"

//门禁接口
//#define APIDOMAIN @"http://ocrm.capitaland.com.cn:8088"
#define APIDOMAIN @"https://ocrm.capitaland.com.cn/api_proxy"
//#define APIDOMAIN @"http://cnliutao1.chinacloudapp.cn:8080"

//测试门禁参数
//#define TOKENPARAMS  @{@"email":@"www@126.com",@"password":@"admin123"}

//正式门禁参数
#define TOKENPARAMS  @{@"email":@"www@126.com",@"password":@"abc@123"}

#define WIN_WIDTH_1 [UIScreen mainScreen].bounds.size.width
#define IS_IPHONE5_LATER ((WIN_WIDTH_1 <=320 ) == YES ? YES:NO)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)


#define NAVIGATOR_BAR_RIGHT_MENU_BTN 20008
#define BLACK_COLOR RGBCOLOR(34,34,34)
#define HOME_MENU 20005
#define MASK_TAG 99998
#define DEFAULT_BG_COLOR RGBCOLOR(230,230,230)
#define DEFAULT_TEXT_COLOR RGBCOLOR(207,207,207)
#define DEFAULT_LINE_COLOR RGBCOLOR(220, 220, 220)
#define DEFAULT_MAIN_COLOR RGBCOLOR(255,126,0)
#define DEFAULT_ITEM_BG_COLOR RGBCOLOR(242,242,242)
#define NO_ALPHA_IMAGEVIEW 99999

#define DESIGN_WIDTH 320
#define DESIGN_X_WIDTH 375

#define M_WIDTH(x) [UIUtil deviceValue:x]
#define X_WIDTH(x) [UIUtil deviceXValue:x]

#define NAVIGATION_BAR_CONTENT_VIEW 87218
#define NAVIGATION_BAR_LEFT_ITEM 87219
#define NAVIGATION_BAR_CENTER_ITEM 87220
#define NAVIGATION_BAR_RIGHT_ITEM 87221
#define NAVIGATION_BAR_RIGHT_laft_ITEM 87222


//主颜色
#define COLOR_MAIN RGBCOLOR(255,126,0)
//分割线颜色
#define COLOR_LINE RGBCOLOR(227, 227, 227)

//主背景颜色
#define COLOR_MAIN_BG RGBCOLOR(255, 255, 255)

//单元内容背景颜色
#define COLOR_ITEM_BG RGBCOLOR(255, 255, 255)

//字体颜色
#define COLOR_FONT_BLACK RGBCOLOR(51,51,51)
#define COLOR_FONT_SECOND RGBCOLOR(153,153,153)
#define COLOR_FONT_THIRD RGBCOLOR(153,153,153)

//APP特有颜色
#define COLOR_RED RGBCOLOR(224,41,43)
//4CB3BA
#define APP_BTN_COLOR UIColorFromRGB(0x2ecad2)
//#define APP_NAV_COLOR UIColorFromRGB(0x2ecad2)
#define APP_NAV_COLOR UIColorFromRGB(0xffffff)

//导航中心title文字颜色
#define APP_NAV_TITLE_COLOR UIColorFromRGB(0x000000)

//导航线的颜色
#define APP_NAV_LINE_COLOR RGBCOLOR(227, 227, 227)


//第三方颜色
//TAB_BAR背景颜色
#define TAB_BAR_BG_COLOR RGBCOLOR(242,242,242)


#define DEBUG YES

#define MSG_WAIT_TICKET 60
#define CACHE_MINUTE 240
#define CACHE_MINUTE_SHORT 1

#define MSG_DISMISS_DURATION 1.2f
//#define NAV_HEIGHT (IS_IOS_7 ? 64.0f : 44.0f)
//#define STATUS_BAR_HEIGHT (IS_IOS_7 ? 20.0f : 0.0f)
#define NAV_HEIGHT (WIN_HEIGHT==812.0f ? 88.0f : 64.0f)
#define STATUS_BAR_HEIGHT (WIN_HEIGHT==812.0f ? 44.0f : 20.0f)
#define BAR_HEIGHT (WIN_HEIGHT==812.0f ? 34.0f:0.0f)

#define LEFT_VIEW_WIDTH 240.0f;
#define DEFAULT_BUTTON_RADIUS 4.0f 
#define DEFAULT_HEADIMG_RADIUS 3.0f
#define SEARCH_BAR_HEIGHT 44.0f

#define BIG_FONT  iPhone4? [UIFont systemFontOfSize:18]:iPhone5 ? [UIFont systemFontOfSize:18]:iPhone6 ? [UIFont systemFontOfSize:18]:iPhone6p ? [UIFont systemFontOfSize:18]:[UIFont systemFontOfSize:18]

#define COOL_FONT iPhone4? [UIFont systemFontOfSize:16]:iPhone5 ? [UIFont systemFontOfSize:16]:iPhone6 ? [UIFont systemFontOfSize:16]:iPhone6p ? [UIFont systemFontOfSize:16]:[UIFont systemFontOfSize:16]

#define COMMON_FONT iPhone4? [UIFont systemFontOfSize:15]:iPhone5 ? [UIFont systemFontOfSize:15]:iPhone6 ? [UIFont systemFontOfSize:15]:iPhone6p ? [UIFont systemFontOfSize:15]:[UIFont systemFontOfSize:15]

#define DESC_FONT iPhone4? [UIFont systemFontOfSize:14]:iPhone5 ? [UIFont systemFontOfSize:14]:iPhone6 ? [UIFont systemFontOfSize:14]:iPhone6p ? [UIFont systemFontOfSize:14]:[UIFont systemFontOfSize:14]

#define INFO_FONT iPhone4? [UIFont systemFontOfSize:12]:iPhone5 ? [UIFont systemFontOfSize:12]:iPhone6 ? [UIFont systemFontOfSize:12]:iPhone6p ? [UIFont systemFontOfSize:12]:[UIFont systemFontOfSize:12]

#define SMALL_FONT iPhone4? [UIFont systemFontOfSize:10]:iPhone5 ? [UIFont systemFontOfSize:10]:iPhone6 ? [UIFont systemFontOfSize:10]:iPhone6p ? [UIFont systemFontOfSize:10]:[UIFont systemFontOfSize:10]
#define NAV_FONT [UIFont systemFontOfSize:18]



#define CURRE_SELECTED_TABBAR_1 20000
#define CURRE_SELECTED_TABBAR_2 20001
#define CURRE_SELECTED_TABBAR_3 20002
#define CURRE_SELECTED_TABBAR_4 20003


#define REFRESH_METHOD @"refresh"
#define MORE_METHOD @"more"

#define BAIDU_TONGJI_KEY @""
#define UMENG_APPKEY @"58a7b3243eae2524c2002d85"
#define APP_ID @""

//#define TENCENT_APP_ID @"101026274"  222222
//#define TENCENT_APP_KEY @"bca763dafadd20caf0d1ab184516114b"

#define TENCENT_APP_ID @""
#define TENCENT_APP_KEY @""
#define QQ_LOGIN_REDIRECT_URL [[Global sharedClient] getQQBackUrl]

#define SHARESDK_KEY @""

// 把16进制的颜色转成UIColor对象
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BASE_WIDTH  1080.0


#define RELATIVE_WIDTH(w) WIN_WIDTH/BASE_WIDTH * w

//新浪KEY
#define kAppKey @"906328753"
#define SINA_SECRET @""
#define kRedirectURI [[Global sharedClient] getSinaBackUrl]


//MsgicSDK
#define MsgicAppKey @"58aba8c8a1f2dbfe9bb228a4"
#define MsgicAppSecret @"oynJJPpN4llyfK9rx_XxrtHMflJM6ZUW"

//百度key
#define BAIDUKEY @""
#define BAIDU_HOST @"https://api.map.baidu.com/telematics/v3/weather"

#define BAIDU_TONGJI_KEY @"35736ba369"

#define Mixpanel_TOKEN @"e4bf1405e329a6a5a5c1094c9c8056e5"

//微信key
#define WX_APP_ID @"wx281a422ccc3e8054"
#define WX_APPSecret @"057a73958872f0fe5462f7b9a732e105"

//友盟分享支付宝的key
#define ALI_APPKay @"2016102402310334"
//支付宝回调
#define ALI_APPBack @"aliKaidexing"

//easyAr
//c4e7955d57213d0b032d073b11074d1d35ec065cfa2482bff0484a0a28ce3afe //这个是凯德申请的secret
#define ARAppKey @"8c4bf3bc5d7c13e6c181cc33acaffef6"//这个是凯德申请的key
#define ARAppSecret @"c4e7955d57213d0b032d073b11074d1d35ec065cfa2482bff0484a0a28ce3afe" //这个是dome里面的


#define SY_BRAND_ID 14

#define JPUSH_TAGS [[Global sharedClient] getJpushTags]
//#define API_HOST      @"http://kdmallapi.companycn.net/APP_API/"

////测试环境
//#define API_HOST      @"http://kdmallapi.companycn.net/APP_API/"
//#define API_DOMAIN    @"companycn.net"
//#define Shopping_Mall @"mall.companycn.net"
//#define HTTP_VIP      @"http://vip.companycn.net/"

//pv环境
//#define API_HOST      @"http://kdmallapipv.companycn.net/APP_API/"
//#define API_DOMAIN    @"companycn.net"
//#define Shopping_Mall @"mallpv.companycn.net"
//#define HTTP_VIP      @"http://vippv.companycn.net/"
//
//

//正式https
//#define API_HOST      @"https://api.capitaland.com.cn/APP_API/"
//#define API_DOMAIN    @"capitaland.com.cn"
////积分商城，支付成功界面用到的
//#define Shopping_Mall @"mall.capitaland.com.cn"
//#define HTTP_VIP      @"https://vip.capitaland.com.cn/"

//添加取消关注中图片用到的
#define HTTP_Img      @"http://mall.capitaland.com.cn"

#define IMG_HOST @""
#define SHARE_HOST API_HOST
#define SHARE_WEB_HOST @""


#define API_RESP_OK @"1"
#define API_RESULT_OK 1
#define API_RESP_SYS_ERROR @"500"
#define API_MSG_SYS_ERROR @"好像出现了点问题，请稍后再试~"
#define API_RESP_UNLOGIN @"602"
#define API_RESP_BUSI_ERROR @"604"
#define API_RESP_NO_PAY_PWD @"605"

#define OBJ_TYPE_BRAND 10
#define OBJ_TYPE_GOODS 20
#define OBJ_TYPE_INVESTOR 30
#define OBJ_TYPE_INFO 40


#define APP_NAME @"凯德星2.0"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HttpClient.h"
#import "CacheMgr.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "SYLabel.h"
#import "SIAlertView.h"
#import "UIUtil.h"
#import "Util.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationFade.h"
#import "LewPopupViewAnimationSlide.h"
#import "LewPopupViewAnimationSpring.h"
#import "LewPopupViewAnimationDrop.h"
#import <math.h>
#import "SNObjt.h"
#import "RSA.h"
#import "DateUtil.h"
#import "MLabel.h"





#define PublicKey @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDh3neDXQW6ec/onaa84zbTf9afzWJSim7nPOmN\r\n4aP3Qkzt+6GLThorll77edl+s1scxGEgjNYHUCtO9UVPa/G+5wZuZNmWyE7XsNotwnXEizNGNq22\r\nNTftc2fPuj0FRmjrwJHTsGkNCNls1Lf3n1gvp3KGZC1N8FRNIfw2T9T1WwIDAQAB\r\n-----END PUBLIC KEY-----"
