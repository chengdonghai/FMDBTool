//
//  DatebaseFactory.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import "TYDatebaseFactory.h"

@implementation TYDatebaseFactory

+(FMDatabase *)sharedDatabaseWithPath:(NSString *)path withDatabaseName:(NSString *)dbName
{
    static FMDatabase *database;
    if (database == nil) {
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *fullPath = [path stringByAppendingPathComponent:dbName];
        database = [FMDatabase databaseWithPath:fullPath];
    }
    if (database == nil) {
        #ifdef DEBUG
        NSLog(@"创建数据库失败！path:%@, databaseName:%@",path,dbName);
        #endif
    }
    return database;
}

+(FMDatabase *)newDatabaseWithPath:(NSString *)path withDatabaseName:(NSString *)dbName
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [path stringByAppendingPathComponent:dbName];
    
    FMDatabase * database = [FMDatabase databaseWithPath:fullPath];
    if (database == nil) {
        #ifdef DEBUG
        NSLog(@"创建数据库失败！path:%@, databaseName:%@",path,dbName);
        #endif
    }
    return database;
}

@end
