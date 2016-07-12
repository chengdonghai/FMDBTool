//
//  TYDatabaseAccess.m
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYDatabaseAccess.h"
#import "TYDatebaseFactory.h"

@implementation TYDatabaseAccess

- (instancetype)initWithDatabasePath:(NSString *)dbPath andDatabaseName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        self.database = [TYDatebaseFactory sharedDatabaseWithPath:dbPath withDatabaseName:dbName];
    }
    return self;
}
@end
