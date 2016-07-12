//
//  TYMappingObject.h
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^ValueBlock)(NSString* propertyName,id value);
@interface TYMapedItem : NSObject
@property(nonatomic,copy) NSString *columnName;
@property(nonatomic,copy) ValueBlock valBlock;
@end

@interface TYMappingObject : NSObject

-(void)setColumnName:(NSString *)columnName mappingToPorpertyName:(NSString *)propertyName;

-(void)setColumnName:(NSString *)columnName mappingToPorpertyName:(NSString *)propertyName valueBlock:(ValueBlock)valBlock;

-(void)setValueBlock:(ValueBlock)valBlock forPropertyName:(NSString *)propertyName;

-(TYMapedItem *)getMapedItemByPropertyName:(NSString *)propertyName;

-(void)setColumnNames:(NSArray *)columnNames mappingToPorpertyNames:(NSArray *)propertyNames;


-(void)setColumnNamesMappingToPorpertyNamesWithDictionary:(NSDictionary *)dict;


@end
