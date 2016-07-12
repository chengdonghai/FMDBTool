//
//  CellModel.h
//  FMDBTool
//
//  Created by chengdonghai on 16/7/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellModel : NSObject
@property(nonatomic) NSInteger tid;
@property(nonatomic,copy) NSString *title;
@property(nonatomic) NSInteger count;
@property(nonatomic,strong) NSDate * curTime;

@end
