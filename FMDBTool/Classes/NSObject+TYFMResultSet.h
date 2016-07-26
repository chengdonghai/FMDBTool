//
//  NSObject+TYFMResultSet.h
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TYMappingObject.h"
@class FMResultSet;

@interface NSObject (TYFMResultSet)

/**
 *  @brief 将FMResultSet对象里的值设置到当前对象的属性中
 *
 *  @param rs FMResultSet对象
 *  @param mappingBlock 字段与属性名词之间的映射对象
 */
- (void)setValuesFromFMResultSet:(FMResultSet *)rs withMappingObject:(TYMappingObject *)mappingObject;

/**
 *  @brief 将FMResultSet对象里的值设置到当前对象的属性中
 *
 *  @param rs FMResultSet对象
 */
- (void)setValuesFromFMResultSet:(FMResultSet *)rs;
@end
