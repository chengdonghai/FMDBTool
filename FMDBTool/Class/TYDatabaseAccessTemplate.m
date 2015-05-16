//
//  TYDatabaseAccessTemplate.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import "TYDatabaseAccessTemplate.h"

@implementation TYDatabaseAccessTemplate


-(BOOL)openDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc withExecuteUpdateBlock:(BOOL (^)())block
{
    if (!database) {
        PLog(@"数据库不存在，访问数据库失败！");
        return NO;
    }
    BOOL success = NO;
    @synchronized(database) {
        if ([database open]) {
            if (block) {
                success = block();
                block = nil;
            }
            if (success) {
                if (actionDesc) {
                    NSString *log = [NSString stringWithFormat:@"%@ 成功", actionDesc];
                    PLog(@"%@",log);
                }
                
            } else {
                if (actionDesc) {
                    NSString *log = [NSString stringWithFormat:@"%@ 失败", actionDesc];
                    PLog(@"%@",log);
                }
                
            }
            [database close];
        } else {
            PLog(@"打开数据库失败!");
        }
    }
    
    return success;
}

-(BOOL)openDatabase:(FMDatabase *)database withExecuteUpdateBlock:(BOOL(^)())block
{
    return [self openDatabase:database actionDesc:nil withExecuteUpdateBlock:block];
}

-(NSArray *)openDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc withExecuteQueryBlock:(FMResultSet *(^)())block andItemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock
{
    NSMutableArray *returnArr = [[NSMutableArray alloc]init];
    
    @synchronized(database) {
        if ([database open]) {
            
            FMResultSet *rs = nil;
            if (block) {
                rs = block();
                block = nil;
            }

            while (rs.next) {
                id returnObjItem = nil;
                if (itemConvertBlock) {
                    returnObjItem = itemConvertBlock(rs);
                }
               
                if (returnObjItem) {
                    if (actionDesc) {
                        PLog(@"%@ 成功:%@",actionDesc,returnObjItem);
                    } else {
                        PLog(@"获取数据成功:%@",returnObjItem);
                    }
                    
                    [returnArr addObject:returnObjItem];
                }
            }
            itemConvertBlock = nil;
            [database close];
        } else {
            PLog(@"打开数据库失败!");
        }
    }
    
    
    return returnArr;
}

-(NSArray *)openDatabase:(FMDatabase *)database withExecuteQueryBlock:(FMResultSet *(^)())block andItemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock
{
    return [self openDatabase:database actionDesc:nil withExecuteQueryBlock:block andItemConvertBlock:itemConvertBlock];
}

-(void)beginTransactionInDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc withExecuteBlock:(void (^)())block
{
    if (!database) {
        PLog(@"数据库不存在，访问数据库失败！");
        return;
    }
    @synchronized(database) {
        if ([database open]) {
            [database beginTransaction];
            @try {
                if (block) {
                    block();
                    block = nil;
                    if (actionDesc) {
                        PLog(@"%@",actionDesc);
                    }
                }
                
                [database commit];
            }
            @catch (NSException *exception) {
                [database rollback];
            }
            @finally {
                
            }
            [database close];
        } else {
            PLog(@"打开数据库失败!");
        }
    }
    
}

-(void)beginTransactionInDatabase:(FMDatabase *)database withExecuteBlock:(void (^)())block
{
    [self beginTransactionInDatabase:database actionDesc:nil withExecuteBlock:block];
}


@end
