//
//  TYDatabaseAccessTemplate.h
//  SurfingReader_V4.0
//
//  FMDB数据库访问模板类，封装数据库的打开和事务开启
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface TYDatabaseAccessTemplate : NSObject


/**
 *  @brief  打开数据库，并执行数据更新操作
 *
 *  @param database   数据库对象
 *  @param actionDesc 操作描述，用于打LOG
 *  @param block      执行更新操作的block
 *
 *  @return block的返回结果，成功或失败
 */
-(BOOL)openDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc withExecuteUpdateBlock:(BOOL (^)())block;

/**
 *  @brief  打开数据库，并执行数据更新操作
 *
 *  @param database 数据库对象
 *  @param block    执行更新操作的block
 *
 *  @return block的返回结果，成功或失败
 */
-(BOOL)openDatabase:(FMDatabase *)database withExecuteUpdateBlock:(BOOL(^)())block;


/**
 *  @brief  打开数据库，并执行数据查询操作，返回已转换的数组类型
 *
 *  @param database    数据库对象
 *  @param actionDesc  操作描述，用于打LOG
 *  @param block       执行查询操作的block
 *  @param resultBlock 转化结果集的block
 *
 *  @return 数据数组
 */
-(NSArray *)openDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc withExecuteQueryBlock:(FMResultSet *(^)())block andItemConvertBlock:(id(^)(FMResultSet *rs))resultBlock;

/**
 *  @brief  打开数据库，并执行数据查询操作，返回已转换的数组类型
 *
 *  @param database    数据库对象
 *  @param block       执行查询操作的block
 *  @param resultBlock 转化结果集的block
 *
 *  @return 数据数组
 */
-(NSArray *)openDatabase:(FMDatabase *)database withExecuteQueryBlock:(FMResultSet *(^)())block andItemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock;

/**
 *  @brief  打开数据库开启事务，一般用于批量操作
 *
 *  @param database   数据库对象
 *  @param actionDesc 操作描述，用于打LOG
 *  @param block      执行操作的block
 */
-(void)beginTransactionInDatabase:(FMDatabase *)database actionDesc:(NSString *)actionDesc withExecuteBlock:(void (^)())block;

/**
 *  @brief  打开数据库开启事务，一般用于批量操作
 *
 *  @param database 数据库对象
 *  @param block    执行操作的block
 */
-(void)beginTransactionInDatabase:(FMDatabase *)database withExecuteBlock:(void (^)())block;

@end
