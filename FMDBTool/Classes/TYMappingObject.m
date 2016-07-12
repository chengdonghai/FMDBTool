//
//  TYMappingObject.m
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYMappingObject.h"
@implementation TYMapedItem
@end
@interface TYMappingObject()

@property(nonatomic,strong) NSMutableDictionary *mappingDict;
@end
@implementation TYMappingObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mappingDict = [NSMutableDictionary dictionary];
    }
    return self;
}



-(void)setColumnName:(NSString *)columnName mappingToPorpertyName:(NSString *)propertyName
{
    [self setObject:columnName propertyName:propertyName valueBlock:nil];
}
-(void)setColumnName:(NSString *)columnName mappingToPorpertyName:(NSString *)propertyName valueBlock:(ValueBlock)valBlock
{
    [self setObject:columnName propertyName:propertyName valueBlock:valBlock];
}

-(void)setValueBlock:(ValueBlock)valBlock forPropertyName:(NSString *)propertyName{
    [self setObject:propertyName propertyName:propertyName valueBlock:valBlock];
}

-(TYMapedItem *)getMapedItemByPropertyName:(NSString *)propertyName
{
    if (propertyName) {
        TYMapedItem *mapedItem = [self.mappingDict objectForKey:propertyName];
        return mapedItem;
    }
    return nil;
}

-(void)setColumnNames:(NSArray *)columnNames mappingToPorpertyNames:(NSArray *)propertyNames
{
    NSString *propertyName = nil;
    NSString *columnName = nil;
    for (int i = 0; i < [propertyNames count]; i++) {
        propertyName = propertyNames[i];
        if (propertyName && ![propertyName isEqualToString:@""] && ![propertyName isKindOfClass:[NSNull class]]) {
            if ([columnNames count] > i) {
                columnName = columnNames[i];
                [self setColumnName:columnName mappingToPorpertyName:propertyName];
            }
            
        }
    }
}

-(void)setColumnNamesMappingToPorpertyNamesWithDictionary:(NSDictionary *)dict
{
    [self.mappingDict setValuesForKeysWithDictionary:dict];
}

-(void)setObject:(NSString *)columnName propertyName:(NSString *)propertyName valueBlock:(ValueBlock)valBlock
{
    if (propertyName && columnName) {
        TYMapedItem *mapedItem = [TYMapedItem new];
        mapedItem.columnName = columnName;
        mapedItem.valBlock = valBlock;
        
        [self.mappingDict setObject:mapedItem forKey:propertyName];
    }
}
@end
