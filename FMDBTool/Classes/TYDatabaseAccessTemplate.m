//
//  TYDatabaseAccessTemplate.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import "TYDatabaseAccessTemplate.h"
#import "FMDB.h"

@implementation TYDatabaseAccessTemplate


-(BOOL)inDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteUpdateBlock:(BOOL (^)(FMDatabase *database))block
{
    if (!databaseQueue) {
        #ifdef DEBUG
        NSLog(@"数据库队列不存在，访问数据库失败！");
        #endif
        return NO;
    }
    __block BOOL success = NO;

    [databaseQueue inDatabase:^(FMDatabase *db) {
        if (block) {
            success = block(db);
        }
        #ifdef DEBUG
        if (success) {
            NSLog(@"执行更新成功");
        } else {
            NSLog(@"执行更新失败");
        }
        #endif
    }];
    return success;
}


-(NSArray *)inDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteQueryBlock:(FMResultSet *(^)(FMDatabase *database))block andItemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock
{
    
    if (!databaseQueue) {
        #ifdef DEBUG
        NSLog(@"数据库队列不存在，访问数据库失败！");
        #endif
        return nil;
    }
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    
    [databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        if (block) {
            rs = block(db);
        }
        
        while (rs.next) {
            id returnObjItem = nil;
            if (itemConvertBlock) {
                returnObjItem = itemConvertBlock(rs);
            }
            
            if (returnObjItem) {
            #ifdef DEBUG
                NSLog(@"获取数据成功:%@",returnObjItem);
            #endif
                [returnArr addObject:returnObjItem];
            }
        }
        [rs close];
    }];
    return returnArr;
}

-(void)inTransactionInDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteBlock:(void (^)(FMDatabase *database))block
{
    if (!databaseQueue) {
        #ifdef DEBUG
        NSLog(@"数据库队列不存在，访问数据库失败！");
        #endif
        return;
    }
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        @try {
            if (block) {
                block(db);
            }
        }
        @catch (NSException *exception) {
            *rollback = YES;
        }
        @finally {
            
        }

    }];
}


@end
