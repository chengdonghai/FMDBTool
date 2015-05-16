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

@interface TYCommonDatabaseAccess : NSObject

/**
 *  @brief  数据库操作模板，简化代码
 */
@property(nonatomic,strong) TYDatabaseAccessTemplate *databaseAccessTemplate;


/**
 *  @brief  创建数据库表
 *
 *  @param sql      sql语句
 *  @param database 数据库对象
 *
 *  @return 创建成功或失败
 */
-(BOOL)createTableWithSql:(NSString *)sql inDatabase:(FMDatabase *)database;

/**
 *  @brief  增加数据库表的列
 *
 *  @param sql      sql语句
 *  @param database 数据库对象
 *
 *  @return 增加列成功或失败
 */
-(BOOL)createTableColumnWithSql:(NSString *)sql inDatabase:(FMDatabase *)database;

/**
 *  @brief  删除数据库表
 *
 *  @param tableName 表名
 *  @param database  数据库对象
 *
 *  @return 删除成功或失败
 */
-(BOOL)deleteTableWithTableName:(NSString *)tableName inDatabase:(FMDatabase *)database;

/**
 *  @brief  删除表列
 *
 *  @param tableName  表名
 *  @param columnName 列名
 *  @param database   数据库对象
 *
 *  @return 删除成功或失败
 */
-(BOOL)deleteTableColumnWithTableName:(NSString *)tableName columnName:(NSString *)columnName inDatabase:(FMDatabase *)database;

/**
 *  @brief  表是否存在于数据库中
 *
 *  @param tableName 表名
 *  @param database  数据库
 *
 *  @return 存在或不存在
 */
-(BOOL)isTableExistWithTableName:(NSString *)tableName inDatabase:(FMDatabase *)database;

/**
 *  @brief  执行数据库更新操作
 *
 *  @param sql        sql语句
 *  @param database   数据库对象
 *  @param actionDesc 操作描述，用于打LOG
 *
 *  @return 执行成功或失败
 */
-(BOOL)executeUpdateWithSql:(NSString *)sql inDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc;

/**
 *  @brief  执行数据库更新操作
 *
 *  @param sql        sql语句
 *  @param database   数据库对象
 *
 *  @return 执行成功或失败
 */
-(BOOL)executeUpdateWithSql:(NSString *)sql inDatabase:(FMDatabase *)database;

/**
 *  @brief  执行数据查询操作，返回用户对象数组
 *
 *  @param querySQL         sql查询语句
 *  @param database         数据库对象
 *  @param actionDesc       操作描述，用于打LOG
 *  @param itemConvertBlock 用于转换FMResultSet成自定义对象的block
 *
 *  @return 自定义对象数组
 */
-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock;
/**
 *  @brief  执行数据查询操作，返回用户对象数组
 *
 *  @param querySQL         sql查询语句
 *  @param database         数据库对象
 *  @param itemConvertBlock 用于转换FMResultSet成自定义对象的block
 *
 *  @return 自定义对象数组
 */
-(NSArray *)executeQueryWithSql:(NSString *)querySQL inDatabase:(FMDatabase *)database itemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock;

@end
