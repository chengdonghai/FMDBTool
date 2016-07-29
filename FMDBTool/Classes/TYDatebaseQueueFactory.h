//
//  DatebaseFactory.h
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue;

@interface TYDatebaseQueueFactory : NSObject

/**
 *  @brief  获取单例数据库队列对象
 *
 *  @param path   路径
 *  @param dbName 数据库名称
 *
 *  @return FMDatabaseQueue对象
 */
+(FMDatabaseQueue *)sharedDatabaseQueueWithPath:(NSString *)path withDatabaseName:(NSString *)dbName;

/**
 *  @brief  生成一个新的数据库队列对象
 *
 *  @param path   路径
 *  @param dbName 数据库名称
 *
 *  @return FMDatabaseQueue对象
 */
+(FMDatabaseQueue *)newDatabaseQueueWithPath:(NSString *)path withDatabaseName:(NSString *)dbName;

@end
