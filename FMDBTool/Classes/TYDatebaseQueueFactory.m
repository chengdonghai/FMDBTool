//
//  DatebaseFactory.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import "TYDatebaseQueueFactory.h"
#import "FMDatabaseQueue.h"

@implementation TYDatebaseQueueFactory

+(FMDatabaseQueue *)sharedDatabaseQueueWithPath:(NSString *)path withDatabaseName:(NSString *)dbName
{
    static FMDatabaseQueue *databaseQueue;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *fullPath = [path stringByAppendingPathComponent:dbName];
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:fullPath];
    });
    
    if (databaseQueue == nil) {
        #ifdef DEBUG
        NSLog(@"创建数据库队列失败！path:%@, databaseName:%@",path,dbName);
        #endif
    }
    return databaseQueue;
}

+(FMDatabaseQueue *)newDatabaseQueueWithPath:(NSString *)path withDatabaseName:(NSString *)dbName
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [path stringByAppendingPathComponent:dbName];
    
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:fullPath];
    if (databaseQueue == nil) {
        #ifdef DEBUG
        NSLog(@"创建数据库队列失败！path:%@, databaseName:%@",path,dbName);
        #endif
    }
    return databaseQueue;
}

@end
