##这是一个fmdb工具库，用来简化fmdb操作：

 - **TYFMDBTool.h** 引用两个头文件，使用时引用它就行；
 - **TYDatebaseFactory** 工厂模式创建FMDatabase对象；
 - **TYDatabaseAccessTemplate** 模版模式简化fmdb操作，这里面有三种常见的模版：数据更新模版，数据查询模版，批量操作模版；
 - **TYCommonDatabaseAccess** 访问fmdb类，里面包含一个TYDatabaseAccessTemplate属性，使用时继承或者组合它就行。
 - **TYDatabaseAccess** 此类继承自TYCommonDatabaseAccess，包含一个单例的FMDatabase对象，使用时继承或者组合它就行。
 - **NSObject+TYFMResultSet** 将查询结果转换成自定义的object数组。
 - **TYMappingObject** 建立表列名和对象属性之间的映射关系，以及进行数据转换。
 
##安装方法
    pod 'FMDBTool', '~> 1.0.1'
##下面来看看怎么使用：
###一开始需要在TYCommonDatabaseAccess子类的初始化方法里创建fmdb对象，一般只需要创建一次,所以用单例模式，或者继承TYDatabaseAccess就不需要另外创建database。
```objc
      self.database = [TYDatebaseFactory sharedDatabaseWithPath:DocumentsDirectory withDatabaseName:BOOK_DB_NAME];
   
```
###查询操作
####第一种方式，传入sql，需要自己手动转换FMResultSet
```objc
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ order by updateTime",@"mytablename"];
    NSArray *bookArray = [self executeQueryWithSql:sqlString inDatabase:self.database actionDesc:@"批量查询书籍" itemConvertBlock:^id(FMResultSet *rs) {
        TYBookShelfInfo *contentInfo = [[self class] convertResultSetToBookShelfInfo:rs];
        return contentInfo;
    }];
```
####第二种方式，在block里手动执行查询并手动转换FMResultSet
```objc
  NSArray *resultArr = [self executeQueryWithUsingBlock:^FMResultSet *{
        return [self.database executeQuery:sql];
    } inDatabase:self.database itemConvertBlock:^id(FMResultSet *rs) {
        NSInteger val = [rs intForColumn:@"dfs"];
        return @(val);
    }];
```
####第三种方式自动转换查询结果为自定义对象数组,需要在block里设置映射关系，如果不设置则根据列名和对象属性名相同来进行默认映射。
```objc
[self executeQueryWithSql:sql inDatabase:self.database actionDesc:@"查询数据" itemClass:[CellModel class] mappingBlock:^void(TYMappingObject *mappingObject) {
        [mappingObject setColumnName:@"t_id" mappingToPorpertyName:@"tid"];
        [mappingObject setColumnName:@"t_title" mappingToPorpertyName:@"title"];
        [mappingObject setColumnName:@"t_count" mappingToPorpertyName:@"count"];
        [mappingObject setColumnName:@"t_time" mappingToPorpertyName:@"curTime" valueBlock:^id(NSString *propertyName, id value) {
            NSTimeInterval cur = 0;
            if (value && [value respondsToSelector:@selector(doubleValue)]) {
                cur = [value doubleValue];
            }
            if (cur > 0) {
                return [NSDate dateWithTimeIntervalSince1970:cur];
            }
            return nil;
        }];
    }];
```
###更新操作；传入更新sql、可以删除表列、更新表列、新增表列、删除行、更新行、插入行。
```objc
//actionDesc只作为日志打印出来，没有别的用处，不传也可以。
[self executeUpdateWithSql:sqlstr inDatabase:database actionDesc:@"更新"];
```
或者通过block之行更新操作
```objc
[self executeUpdateUsingBlock:^BOOL{
            return [self.database executeUpdate:sql];
        } inDatabase:self.database actionDesc:@"更新操作"];
```
###批量操作；比如批量更新数据（需要开启事务）。
```objc
NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", BOOK_TABLE_4_0, BOOK_SHELF_INDEX,@"contentId"];
 [self executeTransactionInDatabase:self.database withExecuteBlock:^{
        for (int i = 0; i < bookShelfInfos.count; i++) {
            TYBookShelfInfo*bookshelfInfo = [bookShelfInfos objectAtIndex:i];
            
            BOOL b = [self.database executeUpdate:updateSql,@(bookshelfInfo.bookshelfIndex), bookshelfInfo.contentID];
            PLog(b?@"更新顺序号成功：%@":@"更新顺序号失败：%@",updateSql);
        }
       
    }];
```

##许可证
FMDBTool使用 MIT 许可证，详情见 LICENSE 文件。


