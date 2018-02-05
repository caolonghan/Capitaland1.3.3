//
//  Global.h
//  iJoymain
//
//  Created by Hwang Kunee on 13-8-26.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#define ACT_MYINVEST_REFLESH @"ACT_MYINVEST_REFLESH"
#define ACT_LOGIN @"ACT_LOGIN"
#define ACT_NATION @"ACT_NATION"
#define ACT_MON @"ACT_MON";
#define ACT_LEFT_MENU @"ACT_LEFT_MENU"
#define ACT_RIGHT_MENU @"ACT_RIGHT_MENU"
#define ACT_SELECT_GOODS @"ACT_SELECT_GOODS"
#define ACT_SELECT_FRIENDS @"ACT_SELECT_FRIENDS"
#define ACT_SINA_WEIBO_LOGIN @"ACT_SINA_WEIBO_LOGIN"
#define ACT_BANK @"ACT_BANK"
#define ACT_REFLESH_AGREESALE @"ACT_REFLESH_AGREESALE" //交易市场刷新，清理缓存
#define ACT_REFLESH_COMMENT @"ACT_REFLESH_COMMENT"//刷新评论
#define ACT_REFLESH_MSG @"ACT_REFLESH_MSG" //刷新消息
#define ACT_REFLESH_GOODS @"ACT_REFLESH_GOODS" //刷新商品
#define ACT_REG @"ACT_REG" //刷新投资圈
#define ACT_SAVE_DATE @"ACT_SAVE_DATE" //大模块跳转
#define ACT_OPEN_WEBVIEW @"ACT_OPEN_WEBVIEW"
#define ACT_SELECT_ADDR @"ACT_SELECT_ADDR"
#define ACT_SELECT_AREA @"ACT_SELECT_AREA"
#define ACT_SELECT_CASH @"ACT_SELECT_CASH"

#define ACT_SELECT_YW_MAIN @"ACT_SELECT_YW_MAIN"

#define ACT_SELECT_YW_OTHER @"ACT_SELECT_YW_OTHER"

#define ACT_SELECT_YW_SUB_AREA @"ACT_SELECT_YW_SUB_AREA"

#define ACT_SELECT_YW_AREA @"ACT_SELECT_YW_AREA"

#define ACT_SELECT_YW_ACCT @"ACT_SELECT_YW_ACCT"

#define ACT_COMMIT_INFO @"ACT_COMMIT_INFO"

#define ACT_CHOICE_SUB_ACCT @"ACT_CHOICE_SUB_ACCT"
#define ACT_UPDATE_IMG @"ACT_UPDATE_IMG"



#import <Foundation/Foundation.h>

@interface Global : NSObject{
    
}
//[[NSSet alloc] initWithObjects:@"hhk",nil]

@property(nonatomic,retain )NSString* api_host;
@property(nonatomic,retain)NSString* API_DOMAIN;
@property(nonatomic,retain)NSString* Shopping_Mall;
@property(nonatomic,retain)NSString* HTTP_VIP;
@property(nonatomic,retain)NSString* HTTP_S;

@property(nonatomic,retain)NSMutableDictionary* user;
@property(nonatomic,retain)NSMutableDictionary* config;
@property(nonatomic,copy)NSString* sessionId;
@property(nonatomic,copy)NSString* userId;
@property(nonatomic,copy)NSString* deptcode;
@property(nonatomic,copy)NSString* markID;
@property(nonatomic,copy)NSArray  *cityID;
@property(nonatomic,copy)NSString  *isFouce;
@property(nonatomic,copy)NSString  *homeImg;
@property(nonatomic,copy)NSString  *shopName;
@property(nonatomic,copy)NSArray   *findAry;
@property(nonatomic,retain)NSString* action;
@property(nonatomic,retain)NSObject* syncObj;
@property(nonatomic,retain)NSString* cityTag;
@property(nonatomic,retain)NSString* sinaUrl;
@property(nonatomic,retain)NSString* qqUrl;
@property(nonatomic,retain)NSString* token;
@property(nonatomic,retain)NSString* isoffice;
@property(nonatomic)int jpushCount;
@property(nonatomic)int pushUserCount;
@property(nonatomic)BOOL homeBtnHidden;
@property(nonatomic)BOOL login;
//是否需要提示领券
@property(nonatomic)NSString* isSend;
@property(nonatomic, copy)NSString * pushLoadData;//返回刷新跳转  0 是不做操作 1是返回商场首页刷新
@property(nonatomic,copy)NSString *isLoginPush;
@property(nonatomic, copy)NSString * member_id;
@property(nonatomic, copy)NSString * img_url;
@property(nonatomic, copy)NSString * nick_name;
@property(nonatomic, copy)NSString * phone;
@property(nonatomic, copy)NSArray * xjf_Cq_Xx; //星积分，卡券，消息个数数组
@property(nonatomic, copy)NSString *building_id;//商场建筑id

//是否关闭刷新
@property(nonatomic)BOOL is_EndRefresh;//关闭顶部和底部刷新
@property(nonatomic)BOOL is_EndheadRefresh;//关闭顶部刷新
@property(nonatomic)BOOL is_EndFooderRefresh;//关闭底部刷新

@property(nonatomic)BOOL openQQ;
//是否已经展示过广告
@property(nonatomic)BOOL showAdv;

@property(nonatomic,copy)NSString* markPrefix;
@property(nonatomic,copy)NSString* markCookies;
@property(nonatomic,copy)NSString* userCookies;

@property(nonatomic)BOOL isConnectJPush;
//UPush 基础连接成功
@property(nonatomic)BOOL isConnectUPushBase;
//UPush 用户标识连接成功
@property(nonatomic)BOOL isConnectUPushUser;
//广告URL
@property (nonatomic,copy)NSString *advUrlStr;

- (BOOL) isLogin;

+ (Global *)sharedClient ;

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias;

- (NSSet*)getJpushTags;

-(NSString*) getSinaBackUrl;

-(NSString*) getQQBackUrl;

- (NSString*)getUpushUserTags;

@end
