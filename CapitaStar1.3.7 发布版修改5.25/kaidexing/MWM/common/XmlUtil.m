//
//  XmlUtil.m
//  iPrint
//
//  Created by dwolf on 14-3-25.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "XmlUtil.h"

@implementation XmlUtil

+(NSString*) getStringWithName: (GDataXMLElement*) doc withName:(NSString*)name{

    NSArray* eleArray = [doc nodesForXPath:name error:nil];
    if(eleArray.count > 0){
        return [[eleArray objectAtIndex:0] stringValue];
    }else{
        return nil;
    }
    
}

@end
