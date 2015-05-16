//
//  TYDefines.h
//  FMDBTool
//
//  Created by chengdonghai on 15/5/16.
//  Copyright (c) 2015年 天翼文化. All rights reserved.
//

#ifndef FMDBTool_TYDatebaseDefines_h
#define FMDBTool_TYDatebaseDefines_h
#ifndef PLog
#ifdef DEBUG_NO
# define PLog(fmt, ...)                         NSLog(fmt, ##__VA_ARGS__);
#else
# define PLog(...);
#endif
#endif
#endif
