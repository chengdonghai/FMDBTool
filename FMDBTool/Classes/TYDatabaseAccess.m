//
//  TYDatabaseAccess.m
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYDatabaseAccess.h"
#import "TYDatebaseQueueFactory.h"

@implementation TYDatabaseAccess

- (instancetype)initWithDatabasePath:(NSString *)dbPath andDatabaseName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        self.databaseQueue = [TYDatebaseQueueFactory sharedDatabaseQueueWithPath:dbPath withDatabaseName:dbName];
    }
    return self;
}

@end
