##这是一个fmdb工具库，用来简化fmdb操作：

 - **TYFMDBTool.h** 引用两个头文件，使用时引用它就行；
 - **TYDatebaseFactory** 工厂模式创建FMDatabase对象；
 - **TYDatabaseAccessTemplate** 模版模式简化fmdb操作，这里面有三种常见的fmdb访问模版：数据更新模版，数据查询模版，批量操作模版；
 
 - **TYCommonDatabaseAccess** 访问fmdb类，里面包含一个TYDatabaseAccessTemplate属性，使用时继承它就行。

##安装方法
    pod 'FMDBTool', '~> 0.0.5'
##下面来看看怎么使用：
###一开始需要在TYCommonDatabaseAccess子类的初始化方法里创建fmdb对象，一般只需要创建一次,所以用单例模式
```objc
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.database = [TYDatebaseFactory sharedDatabaseWithPath:DocumentsDirectory withDatabaseName:BOOK_DB_NAME];
        
    }
    return self;
}
```
###查询操作

```objc
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by updateTime",@"mytablename"];
    NSArray *bookArray = [self executeQueryWithSql:sqlString inDatabase:self.database actionDesc:@"批量查询书籍" itemConvertBlock:^id(FMResultSet *rs) {
        TYBookShelfInfo *contentInfo = [[self class] convertResultSetToBookShelfInfo:rs];
        return contentInfo;
    }];
```
####还有一种通过模版查询
```objc
 NSArray *array = [self.databaseAccessTemplate openDatabase:database withExecuteQueryBlock:^FMResultSet *{
        return [database executeQuery:sqlstr, tableName];
    } andItemConvertBlock:^id(FMResultSet *rs) {
        NSInteger count = [rs intForColumn:@"count"];
        #ifdef DEBUG
            NSLog(@"数据表%@ %ld", tableName, (long)count);
        #endif
        return @(count);
    }];
```
###更新操作；传入更新sql、可以删除表列、更新表列、新增表列、删除行、更新行、插入行。
```objc
//actionDesc只作为日志打印出来，没有别的用处，不传也可以。
[self executeUpdateWithSql:sqlstr inDatabase:database actionDesc:@"更新"];
```
或者通过模版方法操作
```objc
[self.databaseAccessTemplate openDatabase:self.database withExecuteUpdateBlock:^BOOL{
        BOOL res = [self.database executeUpdate:insertSql, catalogIdTemp, contentInfo.contentId,@(contentInfo.chapterId), contentInfo.responseString,contentInfo.remark,USER_ID];
        if (!res) {
            PLog(@"插入数据失败：%@",[contentInfo description]);
            
        }else{
            PLog(@"插入数据成功：%@",[contentInfo description]);
        }
        
        return res;
    }];
```
###批量操作；比如批量更新数据（需要开启事务）。
```objc
NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", BOOK_TABLE_4_0, BOOK_SHELF_INDEX,@"contentId"];
 [self.databaseAccessTemplate beginTransactionInDatabase:self.database withExecuteBlock:^{
        for (int i = 0; i < bookShelfInfos.count; i++) {
            TYBookShelfInfo*bookshelfInfo = [bookShelfInfos objectAtIndex:i];
            
            BOOL b = [self.database executeUpdate:updateSql,@(bookshelfInfo.bookshelfIndex), bookshelfInfo.contentID];
            PLog(b?@"更新顺序号成功：%@":@"更新顺序号失败：%@",updateSql);
        }
       
    }];
```


