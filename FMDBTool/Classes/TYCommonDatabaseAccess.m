//
//  TYCommonDatabaseAccess.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/7.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import "TYCommonDatabaseAccess.h"

@implementation TYCommonDatabaseAccess

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.databaseAccessTemplate = [[TYDatabaseAccessTemplate alloc]init];
    }
    return self;
}


-(BOOL)createTableWithSql:(NSString *)sql inDatabase:(FMDatabase *)database
{
    return [self executeUpdateWithSql:sql inDatabase:database actionDesc:@"创建数据表"];
}

-(BOOL)createTableColumnWithSql:(NSString *)sql inDatabase:(FMDatabase *)database
{
    return [self executeUpdateWithSql:sql inDatabase:database actionDesc:@"创建表列"];
}

- (BOOL)deleteTableWithTableName:(NSString *)tableName inDatabase:(FMDatabase *)database
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    
    return [self executeUpdateWithSql:sqlstr inDatabase:database actionDesc:@"删除表"];
}

- (BOOL)deleteTableColumnWithTableName:(NSString *)tableName columnName:(NSString *)columnName inDatabase:(FMDatabase *)database
{
    NSString *sqlstr = [NSString stringWithFormat:@"ALTER TABLE %@ DROP COLUMN %@", tableName, columnName];
    return [self executeUpdateWithSql:sqlstr inDatabase:database actionDesc:@"删除列"];
}

- (BOOL)isTableExistWithTableName:(NSString *)tableName inDatabase:(FMDatabase *)database
{
    NSString *sqlstr = @"select count(*) as 'count' from sqlite_master where type ='table' and name = ?";
    
    NSArray *array = [self.databaseAccessTemplate openDatabase:database withExecuteQueryBlock:^FMResultSet *{
        return [database executeQuery:sqlstr, tableName];
    } andItemConvertBlock:^id(FMResultSet *rs) {
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

-(BOOL)executeUpdateWithSql:(NSString *)sql inDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc
{
    #ifdef DEBUG
    if (actionDesc == nil) {
        
        NSLog(@"执行更新操作：SQL:%@", sql);
        
    } else {
        NSLog(@"执行%@：SQL:%@",actionDesc, sql);
    }
    #endif
    return [self.databaseAccessTemplate openDatabase:database actionDesc:actionDesc withExecuteUpdateBlock:^BOOL{
        return [database executeUpdate:sql];
    }];
}

-(BOOL)executeUpdateWithSql:(NSString *)sql inDatabase:(FMDatabase *)database
{
    return [self executeUpdateWithSql:sql inDatabase:database actionDesc:nil];
}

-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock {
    #ifdef DEBUG
    if(actionDesc) {
       NSLog(@"执行%@：SQL:%@",actionDesc, querySQL);
    } else {
       NSLog(@"执行查询操作：SQL:%@", querySQL);
    }
    #endif
    return [self.databaseAccessTemplate openDatabase:database actionDesc:actionDesc withExecuteQueryBlock:^FMResultSet *{
        return [database executeQuery:querySQL];
    } andItemConvertBlock:itemConvertBlock];
}

-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabase:(FMDatabase *)database itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock {
    return [self executeQueryWithSql:querySQL inDatabase:database actionDesc:nil itemConvertBlock:itemConvertBlock];
}
@end
