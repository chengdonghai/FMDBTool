//
//  DatebaseFactory.h
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 15/5/8.
//  Copyright (c) 2015年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface TYDatebaseFactory : NSObject

/**
 *  @brief  获取单例数据库对象
 *
 *  @param path   路径
 *  @param dbName 数据库名称
 *
 *  @return FMDatabase对象
 */
+(FMDatabase *)sharedDatabaseWithPath:(NSString *)path withDatabaseName:(NSString *)dbName;

/**
 *  @brief  生成一个新的数据库对象
 *
 *  @param path   路径
 *  @param dbName 数据库名称
 *
 *  @return FMDatabase对象
 */
+(FMDatabase *)newDatabaseWithPath:(NSString *)path withDatabaseName:(NSString *)dbName;

@end
