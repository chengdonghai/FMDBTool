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

#define TABLE_NAME @"FIRST_TABLE"
#define CREATE_SQL [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(\
'%@'        INTEGER PRIMARY KEY AUTOINCREMENT,\
'%@'        TEXT,\
'%@'        INTEGER,\
'%@'        DOUBLE\
);",TABLE_NAME,@"t_id",@"t_title",@"t_count",@"t_time"]


@interface DAO()
@property(nonatomic,strong) FMDatabase *database;
@end


@implementation DAO

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                           , NSUserDomainMask
                                                           , YES);
        if (paths.count > 0) {
            NSString *dbName = @"mydb";
            self.database = [TYDatebaseFactory sharedDatabaseWithPath:paths[0] withDatabaseName:dbName];
            if (![self isTableExistWithTableName:TABLE_NAME inDatabase:self.database]) {
                [self createTable];
            }
        }
        
    }
    return self;
}

-(BOOL)createTable
{
    NSString *sqlCreateTable =  CREATE_SQL;
    BOOL res = [self createTableWithSql:sqlCreateTable inDatabase:self.database];
    return res;
}

-(void)insert:(NSString *)title count:(NSInteger)count
{
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSString *sql = [NSString stringWithFormat:@"replace INTO %@ ('%@', '%@','%@') VALUES (?, ?,?)", TABLE_NAME, @"t_title",@"t_count",@"t_time"];
    BOOL suc = [self executeUpdateUsingBlock:^BOOL{
        return [self.database executeUpdate:sql,title,@(count),@(curTime)];
    } inDatabase:self.database actionDesc:@"插入数据"];
    
    NSLog(@"suc:%i",suc);
}

-(void)delete:(NSInteger)tid
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where t_id = %li", TABLE_NAME, tid];
    [self executeUpdateWithSql:sql inDatabase:self.database actionDesc:@"删除数据"];
}

-(NSArray *)queryData {
    NSString *sql = [NSString stringWithFormat:@"select * from %@", TABLE_NAME];
    
    return [self executeQueryWithSql:sql inDatabase:self.database actionDesc:@"查询数据" itemClass:[CellModel class] mappingBlock:^void(TYMappingObject *mappingObject) {
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
