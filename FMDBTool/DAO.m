//
//  DAO.m
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "DAO.h"
#import "TYFMDBTool.h"
#import "CellModel.h"
#import "FMDB.h"
#define TABLE_NAME @"FIRST_TABLE"
#define CREATE_SQL [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\
'%@'        INTEGER PRIMARY KEY AUTOINCREMENT,\
'%@'        TEXT,\
'%@'        INTEGER,\
'%@'        DOUBLE\
);",TABLE_NAME,@"t_id",@"t_title",@"t_count",@"t_time"]



@implementation DAO

- (instancetype)init
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                       , NSUserDomainMask
                                                       , YES);
    if (paths.count > 0) {
        NSString *dbName = @"mydb";

       self = [super initWithDatabasePath:paths[0] andDatabaseName:dbName];
    }
    
    if (self) {
        if (![self isTableExistWithTableName:TABLE_NAME inDatabaseQueue:self.databaseQueue]) {
            [self createTable];
        }
    }
    return self;
}

-(BOOL)createTable
{
    NSString *sqlCreateTable =  CREATE_SQL;
    BOOL res = [self createTableWithSql:sqlCreateTable inDatabaseQueue:self.databaseQueue];
    return res;
}

-(void)insert:(NSString *)title count:(NSInteger)count
{
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSString *sql = [NSString stringWithFormat:@"replace INTO %@ ('%@', '%@','%@') VALUES (?, ?,?)", TABLE_NAME, @"t_title",@"t_count",@"t_time"];
    BOOL suc = [self executeUpdateUsingBlock:^BOOL (FMDatabase *db){
         return [db executeUpdate:sql,title,@(count),@(curTime)];
    } inDatabaseQueue:self.databaseQueue];
    
    NSLog(@"suc:%i",suc);
}

-(void)delete:(NSInteger)tid
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where t_id = %li", TABLE_NAME, tid];
    [self executeUpdateWithSql:sql inDatabaseQueue:self.databaseQueue];
}

-(NSArray *)queryData {
    NSString *sql = [NSString stringWithFormat:@"select * from %@", TABLE_NAME];
    
    return [self executeQueryWithSql:sql inDatabaseQueue:self.databaseQueue itemClass:[CellModel class] mappingBlock:^void(TYMappingObject *mappingObject) {
        [mappingObject setColumnName:@"t_id" mappingToPorpertyName:@"tid"];
        [mappingObject setColumnName:@"t_title" mappingToPorpertyName:@"title"];
        [mappingObject setColumnName:@"t_count" mappingToPorpertyName:@"count"];
        [mappingObject setColumnName:@"t_time" mappingToPorpertyName:@"curTime" valueBlock:^id(NSString *propertyName, id value) {
            NSTimeInterval cur = 0;
            if (value && [value respondsToSelector:@selector(doubleValue)]) {
                cur = [value doubleValue];
            }
            if (cur > 0) {
                return [NSDate dateWithTimeIntervalSince1970:cur];
            }
            return nil;
        }];
    }];
    
    
}


@end
