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
        #ifdef DEBUG
        NSLog(@"数据库不存在，访问数据库失败！");
        #endif
        return NO;
    }
    BOOL success = NO;
    @synchronized(database) {
        if ([database open]) {
            if (block) {
                success = block();
                block = nil;
            }
            #ifdef DEBUG
            if (success) {
                if (actionDesc) {
                    NSLog(@"%@",[NSString stringWithFormat:@"%@ 成功", actionDesc]);
                }
                
            } else {
                if (actionDesc) {
                    NSLog(@"%@",[NSString stringWithFormat:@"%@ 失败", actionDesc]);
                }
                
            }
            #endif
            [database close];
        } else {
            #ifdef DEBUG
            NSLog(@"打开数据库失败!");
            #endif
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
                    #ifdef DEBUG
                    if (actionDesc) {
                        NSLog(@"%@ 成功:%@",actionDesc,returnObjItem);
                    } else {
                        NSLog(@"获取数据成功:%@",returnObjItem);
                    }
                    #endif
                    [returnArr addObject:returnObjItem];
                }
            }
            itemConvertBlock = nil;
            [database close];
        } else {
            #ifdef DEBUG
            NSLog(@"打开数据库失败!");
            #endif
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
        #ifdef DEBUG
        NSLog(@"数据库不存在，访问数据库失败！");
        #endif
        return;
    }
    @synchronized(database) {
        if ([database open]) {
            [database beginTransaction];
            @try {
                if (block) {
                    block();
                    block = nil;
                    #ifdef DEBUG
                    if (actionDesc) {
                        NSLog(@"%@",actionDesc);
                    }
                    #endif
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
            #ifdef DEBUG
            NSLog(@"打开数据库失败!");
            #endif
        }
    }
    
}

-(void)beginTransactionInDatabase:(FMDatabase *)database withExecuteBlock:(void (^)())block
{
    [self beginTransactionInDatabase:database actionDesc:nil withExecuteBlock:block];
}


@end
