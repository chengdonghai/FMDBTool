//
//  NSObject+TYFMResultSet.m
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "NSObject+TYFMResultSet.h"
#import "FMResultSet.h"
#import <objc/runtime.h>
@implementation NSObject (TYFMResultSet)

- (void)setValuesFromFMResultSet:(FMResultSet *)rs withMappingObject:(TYMappingObject *)mappingObject
{
    unsigned int propertysCount;
    objc_property_t *propertys = class_copyPropertyList(self.class, &propertysCount);
    NSString *propertyName = nil;
    
    
    for (int i = 0; i < propertysCount; i++) {
        propertyName = [[NSString alloc]initWithCString:property_getName(propertys[i]) encoding:NSUTF8StringEncoding];
        TYMapedItem *mapedItem = [self getTYMapedItemByPorpertyName:propertyName mappingObject:mappingObject];
        id obj = nil;
        if (mapedItem && mapedItem.columnName) {
            obj = [rs objectForColumnName:mapedItem.columnName];
            if (mapedItem.valBlock) {
               obj = mapedItem.valBlock(propertyName,obj);
            }
        }
        
        if (obj && propertyName && ![obj isKindOfClass:[NSNull class]]) {
            [self setValue:obj forKey:propertyName];
        }
        
        
    }
    free(propertys);
}

- (void)setValuesFromFMResultSet:(FMResultSet *)rs
{
    [self setValuesFromFMResultSet:rs withMappingObject:nil];
}

/**
 *  @brief 根据映射由属性名得到表列名
 *
 *  @param proName 属性名
 *
 *  @return 返回TYMapedItem
 */
-(TYMapedItem *)getTYMapedItemByPorpertyName:(NSString *)proName mappingObject:(TYMappingObject* )mapping
{
    if (proName == nil || [proName isEqualToString:@""] || [proName isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if (mapping) {
        TYMapedItem *mapedItem = [mapping getMapedItemByPropertyName:proName];
        if (mapedItem) {
            return mapedItem;
        }
    }
    return nil;
}
@end
