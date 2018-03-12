//
//  DBDeal.m
//  EAM
//
//  Created by dwolf on 16/6/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "DBDeal.h"
#import "FMDatabase.h"


@implementation DBDeal{
    
}
@synthesize db = db;

+ (DBDeal *)sharedClient {
    static DBDeal *dbDeal = nil;
    static dispatch_once_t onceToken;
    NSString* dbName = @"kaidexing.sqlite";
    dispatch_once(&onceToken, ^{
        dbDeal = [[DBDeal alloc] init];
        [dbDeal copyFileDatabase];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:dbName];
        [dbDeal setDb: [FMDatabase databaseWithPath:dbPath]] ;
        if (![dbDeal.db open]) {
            NSLog(@"Could not open db.");
            return ;
        }
    });
    return dbDeal;
}

-(void) setDb:(FMDatabase*) database{
    db = database;
}


-(NSArray*) queryArea:(NSString*) pid{
    NSMutableArray* retArr = [[NSMutableArray alloc] init];

    FMResultSet *rs = [[DBDeal sharedClient].db executeQuery:[@"select id ,name,type,pid from area " stringByAppendingString:pid]];
    [self isTableOK:@"area"];
//    FMResultSet *rs = [[DBDeal sharedClient].db executeQuery:@"select id,name,type,pid from area " ];
    
    while ([rs next]) {
        
        
        
        [retArr addObject:[rs resultDictionary]];
    }
    [rs close];
    return retArr;
}

- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [[DBDeal sharedClient].db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %d", count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

-(void)copyFileDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentLibraryFolderPath = [documentsDirectory stringByAppendingPathComponent:@"kaidexing.sqlite"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) {
        NSLog(@"文件已经存在了");
        BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:documentLibraryFolderPath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }

    }else {
        
    }
    NSString *resourceSampleImagesFolderPath =[[NSBundle mainBundle]pathForResource:@"kaidexing" ofType:@"sqlite"];
    [[NSFileManager defaultManager] copyItemAtPath:resourceSampleImagesFolderPath toPath:documentLibraryFolderPath error:nil];
}

// 删除沙盒里的文件
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"pin.png"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}



@end
