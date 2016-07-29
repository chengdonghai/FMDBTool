//
//  DAO.h
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYDatabaseAccess.h"

@interface DAO : TYDatabaseAccess


-(void)insert:(NSString *)title count:(NSInteger)count;

-(void)delete:(NSInteger)tid;

-(NSArray *)queryData;

@end
