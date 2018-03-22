//
//  AliManager.h
//  meirile
//
//  Created by 朱巩拓 on 16/9/1.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlimsgDelegata <NSObject>

-(void)setAliMsg:(id)vul;

@end

@interface AliManager : NSObject

@property (assign,nonatomic)id<AlimsgDelegata>aiDelegate;

+(instancetype)aliMsgOpenURL:(NSURL *)url;
@end
