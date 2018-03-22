//
//  XmlUtil.h
//  iPrint
//
//  Created by dwolf on 14-3-25.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface XmlUtil : NSObject

//获取xml中单个元素并且返回String值
+(NSString*) getStringWithName: (GDataXMLElement*) doc withName:(NSString*)name;
@end
