//
//  TYDatabaseAccess.h
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYCommonDatabaseAccess.h"

@interface TYDatabaseAccess : TYCommonDatabaseAccess


@property(nonatomic,strong) FMDatabaseQueue *databaseQueue;

- (instancetype)initWithDatabasePath:(NSString *)dbPath andDatabaseName:(NSString *)dbName;

@end
