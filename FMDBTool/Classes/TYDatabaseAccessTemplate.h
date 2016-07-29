//
//  TYDatabaseAccessTemplate.h
//  SurfingReader_V4.0
//
//  FMDB数据库访问模板类，封装数据库的打开和事务开启
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;
@class FMResultSet;
@class FMDatabase;

@interface TYDatabaseAccessTemplate : NSObject

/**
 *  @brief  执行数据更新操作
 *
 *  @param databaseQueue 数据库队列对象
 *  @param block    执行更新操作的block
 *
 *  @return block的返回结果，成功或失败
 */
-(BOOL)inDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteUpdateBlock:(BOOL(^)(FMDatabase *database))block;


/**
 *  @brief  执行数据查询操作，返回已转换的数组类型
 *
 *  @param databaseQueue    数据库队列对象
 *  @param block       执行查询操作的block
 *  @param resultBlock 转化结果集的block
 *
 *  @return 数据数组
 */
-(NSArray *)inDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteQueryBlock:(FMResultSet *(^)(FMDatabase *database))block andItemConvertBlock:(id(^)(FMResultSet *rs))itemConvertBlock;


/**
 *  @brief  打开数据库开启事务，一般用于批量操作
 *
 *  @param databaseQueue 数据库队列对象
 *  @param block    执行操作的block
 */
-(void)inTransactionInDatabaseQueue:(FMDatabaseQueue *)databaseQueue withExecuteBlock:(void (^)(FMDatabase *database))block;

@end
