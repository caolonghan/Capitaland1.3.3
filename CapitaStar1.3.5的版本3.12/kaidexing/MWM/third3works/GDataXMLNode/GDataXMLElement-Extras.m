//
//  GDataXMLElement-Extras.m
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-24.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "GDataXMLElement-Extras.h"

@implementation GDataXMLElement(Extras)

- (GDataXMLElement *)elementForChild:(NSString *)childName {
    NSArray *children = [self elementsForName:childName];
    if (children.count > 0) {
        GDataXMLElement *childElement = (GDataXMLElement *) [children objectAtIndex:0];
        return childElement;
    } else return nil;
}

- (NSString *)valueForChild:(NSString *)childName {
    return [[self elementForChild:childName] stringValue];
}

- (NSMutableArray*) childrenToArray{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    for(int i = 0;i<[self childCount];i++){
        GDataXMLElement* ele = (GDataXMLElement*) [self childAtIndex:i];
        if([ele childCount] == 0){
            continue;
        }
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        for(int j = 0;j<[ele childCount];j++){
            GDataXMLElement* subEle = (GDataXMLElement*)[ele childAtIndex:j];
            NSString* key = [subEle name];
            [dic setValue:[subEle stringValue] forKey:key];
        }
        [arr addObject:dic];
    }
    return arr;
}

- (NSMutableDictionary*) childrenToDic{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    for(int i = 0;i<[self childCount];i++){
        GDataXMLElement* subEle = (GDataXMLElement*)[self childAtIndex:i];
        NSString* key = [subEle name];
        [dic setValue:[subEle stringValue] forKey:key];
    }
    return dic;
}
@end