//
//  DBDeal.h
//  EAM
//
//  Created by dwolf on 16/6/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBDeal:NSObject{
    FMDatabase* db;
}
@property (nonatomic,strong)FMDatabase* db;
+ (DBDeal *)sharedClient ;

-(NSArray*) queryArea:(NSString*) pid;

@end
