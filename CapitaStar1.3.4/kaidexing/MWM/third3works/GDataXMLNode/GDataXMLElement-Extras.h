//
//  GDataXMLElement-Extras.h
//  SurfingShare
//
//  Created by Hwang Kunee on 13-6-24.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GDataXMLElement (Extras)

- (GDataXMLElement *) elementForChild:(NSString *)childName;
- (NSString *) valueForChild:(NSString *)childName;
- (NSMutableArray*) childrenToArray;
- (NSMutableDictionary*) childrenToDic;

@end
