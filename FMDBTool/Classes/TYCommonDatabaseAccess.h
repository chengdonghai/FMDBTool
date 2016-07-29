//
//  TYCommonDatabaseAccess.h
//  SurfingReader_V4.0
//
//  FMDB数据库访问封装类,提供基础访问方法。
//
//  Created by chengdonghai on 15/5/7.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYDatabaseAccessTemplate.h"
#import "TYMappingObject.h"
#import "NSObject+TYFMResultSet.h"

typedef void(^TYMappingBlock)(TYMappingObject *mappingObject);

@interface TYCommonDatabaseAccess : NSObject

/**
 *  @brief  数据库操作模板，简化代码
 */
@property(nonatomic,strong) TYDatabaseAccessTemplate *databaseAccessTemplate;


/**
 *  @brief  创建数据库表
 *
 *  @param sql      sql语句
 *  @param databaseQueue   数据库队列对象
 *
 *  @return 创建成功或失败
 */
-(BOOL)createTableWithSql:(NSString *)sql inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;

/**
 *  @brief  增加数据库表的列
 *
 *  @param sql      sql语句
 *  @param databaseQueue   数据库队列对象
 *
 *  @return 增加列成功或失败
 */
-(BOOL)createTableColumnWithSql:(NSString *)sql inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;

/**
 *  @brief  删除数据库表
 *
 *  @param tableName 表名
 *  @param databaseQueue   数据库队列对象
 *
 *  @return 删除成功或失败
 */
-(BOOL)deleteTableWithTableName:(NSString *)tableName inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;

/**
 *  @brief  删除表列
 *
 *  @param tableName  表名
 *  @param columnName 列名
 *  @param databaseQueue   数据库队列对象
 *
 *  @return 删除成功或失败
 */
-(BOOL)deleteTableColumnWithTableName:(NSString *)tableName columnName:(NSString *)columnName inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;

/**
 *  @brief  表是否存在于数据库中
 *
 *  @param tableName 表名
 *  @param databaseQueue   数据库队列对象
 *
 *  @return 存在或不存在
 */
-(BOOL)isTableExistWithTableName:(NSString *)tableName inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;


/**
 *  @brief  执行数据库更新操作
 *
 *  @param sql        sql语句
 *  @param databaseQueue   数据库队列对象
 *
 *  @return 执行成功或失败
 */
-(BOOL)executeUpdateWithSql:(NSString *)sql inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;


/**
 *  @brief  执行数据库更新操作
 *
 *  @param block      更新操作的block
 *  @param databaseQueue   数据库队列对象
 *  @return 执行成功或失败
 */
-(BOOL)executeUpdateUsingBlock:(BOOL (^)(FMDatabase *database))block inDatabaseQueue:(FMDatabaseQueue *)databaseQueue;

/**
 *  @brief  执行数据查询操作，返回用户对象数组
 *
 *  @param querySQL         sql查询语句
 *  @param databaseQueue   数据库队列对象
 *  @param itemConvertBlock 用于转换FMResultSet成自定义对象的block
 *
 *  @return 自定义对象数组
 */
-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock;

/**
 *  @brief  执行数据查询操作，返回用户对象数组
 *
 *  @param querySQL         sql查询语句
 *  @param databaseQueue   数据库队列对象
 *  @param itemClass        转换为自定义的元素对象的类型
 *  @param mappingBlock 用于映射block
 *
 *  @return 自定义对象数组
 */

-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemClass:(Class)itemClass mappingBlock:(TYMappingBlock)mappingBlock;


/**
 *  @brief 执行数据查询操作，返回用户对象数组
 *
 *  @param queryBlock       执行查询语句block
 *  @param databaseQueue   数据库队列对象
 *  @param itemConvertBlock 用于转换FMResultSet成自定义对象的block
 *
 *  @return 自定义对象数组
 */
-(NSArray *)executeQueryWithUsingBlock:(FMResultSet *(^)(FMDatabase *database))queryBlock inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock;

/**
 *  @brief  执行数据查询操作，返回用户对象数组
 *
 *  @param queryBlock       查询操作block
 *  @param databaseQueue   数据库队列对象
 *  @param actionDesc       操作描述，用于打LOG
 *  @param itemClass        转换为自定义的元素对象的类型
 *  @param mappingBlock     用于映射block
 *
 *  @return 自定义对象数组
 */
-(NSArray *)executeQueryWithUsingBlock:(FMResultSet *(^)(FMDatabase *database))queryBlock inDatabaseQueue:(FMDatabaseQueue *)databaseQueue itemClass:(Class)itemClass mappingBlock:(TYMappingBlock)mappingBlock;

/**
 *  @brief 执行事务操作
 *
 *  @param databaseQueue   数据库队列对象
 *  @param actionDesc 操作描述，用于打LOG
 *  @param block      操作block
 */
-(void)executeTransactionInDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteBlock:(void (^)(FMDatabase *database))block;


@end
