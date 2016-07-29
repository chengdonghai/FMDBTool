//
//  TYCommonDatabaseAccess.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/7.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import "TYCommonDatabaseAccess.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabase.h"

@implementation TYCommonDatabaseAccess

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.databaseAccessTemplate = [[TYDatabaseAccessTemplate alloc]init];
    }
    return self;
}

-(BOOL)createTableWithSql:(NSString *)sql inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    return [self executeUpdateWithSql:sql inDatabaseQueue:databaseQueue];
}

-(BOOL)createTableColumnWithSql:(NSString *)sql inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    return [self executeUpdateWithSql:sql inDatabaseQueue:databaseQueue];
}

- (BOOL)deleteTableWithTableName:(NSString *)tableName inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    
    return [self executeUpdateWithSql:sqlstr inDatabaseQueue:databaseQueue];
}

- (BOOL)deleteTableColumnWithTableName:(NSString *)tableName columnName:(NSString *)columnName inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    NSString *sqlstr = [NSString stringWithFormat:@"ALTER TABLE %@ DROP COLUMN %@", tableName, columnName];
    return [self executeUpdateWithSql:sqlstr inDatabaseQueue:databaseQueue];
}

- (BOOL)isTableExistWithTableName:(NSString *)tableName inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    NSString *sqlstr = @"select count(*) as 'count' from sqlite_master where type ='table' and name = ?";
    NSArray *array = [self executeQueryWithUsingBlock:^FMResultSet *(FMDatabase *database) {
       return [database executeQuery:sqlstr, tableName];
    } inDatabaseQueue:databaseQueue itemConvertBlock:^id(FMResultSet *rs) {
       NSInteger count = [rs intForColumn:@"count"];
    #ifdef DEBUG
       NSLog(@"数据表%@ %ld", tableName, (long)count);
    #endif
       return @(count);
    }];
    BOOL isExist = NO;
    if (array && array.count > 0)
    {
        NSNumber *countNumber = [array firstObject];
        if (0 == countNumber.integerValue)
        {
            isExist = NO;
        }
        else
        {
            isExist = YES;
        }
    }
    return isExist;
}

-(BOOL)executeUpdateWithSql:(NSString *)sql inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    #ifdef DEBUG
        NSLog(@"执行：SQL:%@", sql);
    #endif
    return [self executeUpdateUsingBlock:^BOOL(FMDatabase *db){
            return [db executeUpdate:sql];
        } inDatabaseQueue:databaseQueue];
    
}
-(BOOL)executeUpdateUsingBlock:(BOOL (^)(FMDatabase *database))block inDatabaseQueue:(FMDatabaseQueue *)databaseQueue
{
    return [self.databaseAccessTemplate inDatabaseQueue:databaseQueue withExecuteUpdateBlock:block];
}

-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock {
    #ifdef DEBUG
    NSLog(@"执行查询操作：SQL:%@", querySQL);
    #endif
    
    return [self executeQueryWithUsingBlock:^FMResultSet *(FMDatabase *database){
        return [database executeQuery:querySQL];
    } inDatabaseQueue:databaseQueue itemConvertBlock:itemConvertBlock];
}

-(NSArray *)executeQueryWithUsingBlock:(FMResultSet *(^)(FMDatabase *database))queryBlock inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock {
    
    return [self.databaseAccessTemplate inDatabaseQueue:databaseQueue withExecuteQueryBlock:queryBlock andItemConvertBlock:itemConvertBlock];
}

-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemClass:(Class)itemClass mappingBlock:(TYMappingBlock)mappingBlock {
    #ifdef DEBUG
   
     NSLog(@"执行查询操作：SQL:%@", querySQL);
    
    #endif
    return [self executeQueryWithUsingBlock:^FMResultSet *(FMDatabase *db){
         return [db executeQuery:querySQL];
    } inDatabaseQueue:databaseQueue itemConvertBlock:^id(FMResultSet *rs) {
        return [self convertResultSet:rs itemClass:itemClass mappingBlock:mappingBlock];
    }];
}

-(NSArray *)executeQueryWithUsingBlock:(FMResultSet *(^)(FMDatabase *database))queryBlock inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemClass:(Class)itemClass mappingBlock:(TYMappingBlock)mappingBlock {
    
    return [self.databaseAccessTemplate inDatabaseQueue:databaseQueue withExecuteQueryBlock:queryBlock andItemConvertBlock:^id(FMResultSet *rs) {
        return [self convertResultSet:rs itemClass:itemClass mappingBlock:mappingBlock];
    }];
}

-(void)executeTransactionInDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteBlock:(void (^)(FMDatabase *database))block
{
    [self.databaseAccessTemplate inTransactionInDatabaseQueue:databaseQueue withExecuteBlock:block];
}

-(id) convertResultSet:(FMResultSet *)rs itemClass:(Class)itemClass mappingBlock:(TYMappingBlock)mappingBlock{
    NSObject *item = nil;
    if (itemClass) {
        item = [[itemClass alloc]init];
    } else {
        item = [[NSObject alloc]init];
    }
    
    TYMappingObject *mappingObj = [[TYMappingObject alloc]init];
    if (mappingBlock) {
        mappingBlock(mappingObj);
    }
    [item setValuesFromFMResultSet:rs withMappingObject:mappingObj];
    return item;
}
@end
