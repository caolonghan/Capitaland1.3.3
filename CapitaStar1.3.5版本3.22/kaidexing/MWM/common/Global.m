//
//  Global.m
//  iJoymain
//
//  Created by Hwang Kunee on 13-8-26.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "Global.h"
#import "JPUSHService.h"
#import "Const.h"

@implementation Global{
}

@synthesize user = _user,action = _action,syncObj = _syncObj,sessionId = _sessionId,findAry=_findAry,isFouce=_isFouce,shopName=_shopName, markID=_markID,homeImg=_homeImg,markPrefix= _markPrefix ,userId = _userId,cityID=_cityID,deptcode=_deptcode ,openQQ = _openQQ,cityTag = _cityTag , sinaUrl = _sinaUrl , qqUrl=_qqUrl, token=_token, login = _login, member_id = _member_id, img_url = _img_url, nick_name = _nick_name, xjf_Cq_Xx = _xjf_Cq_Xx , phone=_phone,markCookies=_markCookies,userCookies=_userCookies,pushLoadData = _pushLoadData,building_id=_building_id,isoffice=_isoffice,isSend=_isSend;

+ (Global *)sharedClient {
    static Global *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Global alloc] init];
        _sharedClient.isConnectJPush = NO;
        _sharedClient.jpushCount = 0;
        
        NSDictionary* dic = [Util logInitConfig];
        _sharedClient.API_DOMAIN = dic[@"API_DOMAIN"];
        _sharedClient.api_host = dic[@"API_HOST"];
        _sharedClient.Shopping_Mall = dic[@"Shopping_Mall"];
        _sharedClient.HTTP_VIP = dic[@"HTTP_VIP"];
        _sharedClient.HTTP_S = dic[@"HTTP_S"];
    });
    return _sharedClient;
}

- (BOOL) isLogin{
    return _sessionId != nil && ![_sessionId isEqualToString:@""];
}

- (NSSet*)getJpushTags{
    
//    if(_cityTag == nil){    
//        NSString *iKey=@"cityTag";
//        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
//        [Global sharedClient].cityTag = [standardDefaults valueForKey:iKey];
//    }
//    if(_cityTag == nil || [_cityTag isEqualToString:@""]){
//        _cityTag = @"notag";
//    }
//    return [[NSSet alloc] initWithObjects:@"public", _cityTag,nil];
   return [[NSSet alloc] initWithObjects:@"public",[Global sharedClient].sessionId,nil];
    
    
}

- (NSString*)getUpushUserTags{
    return  [Global sharedClient].sessionId;
}

-(NSString*) getSinaBackUrl{
    if(_sinaUrl == nil){
        NSString *iKey=@"weiboDomain";
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        [Global sharedClient].sinaUrl = [standardDefaults valueForKey:iKey];
    }
    if(_sinaUrl == nil){
        [Global sharedClient].sinaUrl = @"https://www.sina.com";
    }
    NSLog(@"新浪回调地址%@\n", [Global sharedClient].sinaUrl);
    return [Global sharedClient].sinaUrl;
    
}

-(NSString*) getQQBackUrl{
    if(_qqUrl == nil){
        NSString *iKey=@"qqDomain";
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        [Global sharedClient].qqUrl = [standardDefaults valueForKey:iKey];
    }
    if(_qqUrl == nil){
        [Global sharedClient].qqUrl = @"";
    }
    NSLog(@"QQ回调地址%@\n", [Global sharedClient].qqUrl);
    return [Global sharedClient].qqUrl;
    
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if([Global sharedClient].isConnectJPush){
        return;
    }

    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if(tags == nil){
        tags = JPUSH_TAGS;
    }

    if(iResCode != 0){
        if(_jpushCount < 3){
            _jpushCount++;
            [JPUSHService setTags:tags alias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:)  object:self];
        }else{
            _jpushCount = 0;
        }
    }else{
        [Global sharedClient].isConnectJPush = YES;
        _jpushCount = 0;
    }
}


@end
