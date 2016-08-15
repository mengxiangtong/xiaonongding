//  MTTDatabaseUtil.m
//  Duoduo
//
//  Created by zuoye on 14-3-21.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//

#import "DBManager.h"

#define DB_FILE_NAME                    @"xnd.sqlite"
#define TABLE_AREAS                     @"areas"
#define TABLE_CITIS                     @"citis"
#define TABLE_PROVINCES                 @"provinces"
#define TABLE_OTHERAREAS                @"otherAreas"

#define SQL_CREATE_TABLE_AREAS          [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (area_id integer,area_ip_desc text ,area_name text,area_pid integer,area_sort integer,area_type integer,area_url text,primary key (area_id))",TABLE_AREAS]
#define SQL_CREATE_TABLE_CITIS          [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (area_id integer,area_ip_desc text ,area_name text,area_pid integer,area_sort integer,area_type integer,area_url text,primary key (area_id))",TABLE_CITIS]
#define SQL_CREATE_TABLE_PROVINCES      [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (area_id integer,area_ip_desc text ,area_name text,area_pid integer,area_sort integer,area_type integer,area_url text,primary key (area_id))",TABLE_PROVINCES]
#define SQL_CREATE_TABLE_OTHERAREAS     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (area_id integer,area_ip_desc text ,area_name text,area_pid integer,area_sort integer,area_type integer,area_url text,primary key (area_id))",TABLE_OTHERAREAS]

@implementation DBManager
{
    FMDatabase* _database;
    FMDatabaseQueue* _dataBaseQueue;
}
//+ (instancetype)instance
//{
//    static DBManager* g_databaseUtil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        g_databaseUtil = [[DBManager alloc] init];
//        [NSString stringWithFormat:@""];
//    });
//    return g_databaseUtil;
//}
-(void)reOpenNewDB
{
    
    [self openCurrentUserDB];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        //初始化数据库
        [self openCurrentUserDB];
    }
    return self;
}

- (void)openCurrentUserDB
{
    if (_database)
    {
        [_database close];
        _database = nil;
    }
    _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[DBManager dbFilePath]];
    _database = [FMDatabase databaseWithPath:[DBManager dbFilePath]];
    if (![_database open])
    {
        NSLog(@"打开数据库失败");
    }
    else
    {
        
        
        
        //创建
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            if (![_database tableExists:TABLE_AREAS])
            {
                [self createTable:SQL_CREATE_TABLE_AREAS];
            }
            if (![_database tableExists:TABLE_CITIS])
            {
                [self createTable:SQL_CREATE_TABLE_CITIS];
            }
            if (![_database tableExists:TABLE_PROVINCES]) {
                [self createTable:SQL_CREATE_TABLE_PROVINCES];
            }
            if (![_database tableExists:TABLE_OTHERAREAS]) {
                [self createTable:SQL_CREATE_TABLE_OTHERAREAS];
            }
            
            
        }];
    }
}

+(NSString *)dbFilePath
{
    NSString* directorPath = [NSString userExclusiveDirection];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //改用户的db是否存在，若不存在则创建相应的DB目录
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:directorPath isDirectory:&isDirector];
    
    if (!(isExiting && isDirector))
    {
        BOOL createDirection = [fileManager createDirectoryAtPath:directorPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection)
        {
            NSLog(@"创建DB目录失败");
        }
    }

    
    NSString *dbPath = [directorPath stringByAppendingPathComponent:[NSString stringWithFormat:@"user_%@",DB_FILE_NAME]];
    return dbPath;
}

-(BOOL)createTable:(NSString *)sql          //创建表
{
    BOOL result = NO;
    [_database setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"%@",sql];
    result = [_database executeUpdate:tempSql];
    
    return result;
}
-(BOOL)clearTable:(NSString *)tableName
{
    BOOL result = NO;
    [_database setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    result = [_database executeUpdate:tempSql];
    
    return result;
}



- (XNDAreaModel*)messageFromResult:(FMResultSet*)resultSet
{
    
    
    NSString* area_id=[NSString stringWithFormat:@"%d",[resultSet intForColumn:@"area_id"] ];
    NSString* area_ip_desc=[resultSet stringForColumn:@"area_ip_desc" ];
    NSString* area_name=[resultSet stringForColumn:@"area_name"];
    NSString* area_pid=[NSString stringWithFormat:@"%d",[resultSet intForColumn:@"area_pid"] ];
    NSString* area_sort=[NSString stringWithFormat:@"%d",[resultSet intForColumn:@"area_sort"] ];
    NSString* area_type=[NSString stringWithFormat:@"%d",[resultSet intForColumn:@"area_type"] ];
    NSString* area_url=[resultSet stringForColumn:@"area_url"];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:area_id forKey:@"area_id"];
    [dic setObject:area_ip_desc forKey:@"area_ip_desc"];
    [dic setObject:area_name forKey:@"area_name"];
    [dic setObject:area_pid forKey:@"area_pid"];
    [dic setObject:area_sort forKey:@"area_sort"];
    [dic setObject:area_type forKey:@"area_type"];
    [dic setObject:area_url forKey:@"area_url"];
    
    
    XNDAreaModel* areaModel = [[XNDAreaModel alloc] initWithDictionary:dic];
    
    //二进制数据转换
    //    NSString* infoString = [resultSet stringForColumn:@"info"];
    //    if (infoString)
    //    {
    //        NSData* infoData = [infoString dataUsingEncoding:NSUTF8StringEncoding];
    //        NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    //        NSMutableDictionary* mutalInfo = [NSMutableDictionary dictionaryWithDictionary:info];
    //        areaModel.info = mutalInfo;
    //
    //    }
    return areaModel;
}

#pragma mark Message

- (void)loadAreaArrayAllWithCompletion:(XNDLoadAreaCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([_database tableExists:TABLE_AREAS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=?",TABLE_AREAS];
            FMResultSet* result = [_database executeQuery:sqlString,@(1)];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}

- (void)loadCityArrayAllWithCompletion:(XNDLoadAreaCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([_database tableExists:TABLE_AREAS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=?",TABLE_AREAS];
            FMResultSet* result = [_database executeQuery:sqlString,@(2)];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}
- (void)loadCityArrayAllWithPid:(int)pid Completion:(XNDLoadAreaCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([_database tableExists:TABLE_AREAS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=? and area_pid=?",TABLE_AREAS];
            FMResultSet* result = [_database executeQuery:sqlString,@(2),@(pid)];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}

- (void)loadProvinceArrayAllWithPid:(int)pid Completion:(XNDLoadAreaCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([_database tableExists:TABLE_AREAS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=? and area_pid=?",TABLE_AREAS];
            FMResultSet* result = [_database executeQuery:sqlString,@(3),@(pid)];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}
- (void)loadCircleArrayAllWithPid:(int)pid Completion:(XNDLoadAreaCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        if ([_database tableExists:TABLE_AREAS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=? and area_pid=?",TABLE_AREAS];
            FMResultSet* result = [_database executeQuery:sqlString,@(4),@(pid)];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}


- (NSMutableArray *)loadAreaArrayAll
{
    FMDatabase *db=[[FMDatabase alloc]initWithPath:[DBManager dbFilePath]];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    @try {
        [db open];
        if ([db tableExists:TABLE_AREAS])
        {
            [db setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=?",TABLE_AREAS];
            FMResultSet* result = [db executeQuery:sqlString,@(1)];
            
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return array;
    }
    
    
}
- (NSMutableArray*)loadCityArrayAllWithPid:(int)pid
{
    FMDatabase *db=[[FMDatabase alloc]initWithPath:[DBManager dbFilePath]];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    @try {
        [db open];
        if ([db tableExists:TABLE_AREAS])
        {
            [db setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=? and area_pid=?",TABLE_AREAS];
            FMResultSet* result = [db executeQuery:sqlString,@(2),@(pid)];
            
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return array;
    }
    
}
- (NSMutableArray *)loadProvinceArrayAllWithPid:(int)pid
{
    FMDatabase *db=[[FMDatabase alloc]initWithPath:[DBManager dbFilePath]];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    @try {
        [db open];
        
        if ([db tableExists:TABLE_AREAS])
        {
            [db setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where area_type=? and area_pid=?",TABLE_AREAS];
            FMResultSet* result = [db executeQuery:sqlString,@(3),@(pid)];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            while ([result next])
            {
                XNDAreaModel* message = [self messageFromResult:result];
                [array addObject:message];
            }
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [db close];
        return array;
    }
}



- (void)insertAreas:(NSArray*)messages Completion:(XNDInsertAreasCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                XNDAreaModel* areaodel = (XNDAreaModel*)obj;
    
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(area_id,area_ip_desc,area_name,area_pid,area_sort,area_type,area_url) VALUES(?,?,?,?,?,?,?)",TABLE_AREAS];
                
                BOOL result = [_database executeUpdate:sql,@([areaodel.area_id intValue]),areaodel.area_ip_desc ,areaodel.area_name,@([areaodel.area_pid intValue]),@([areaodel.area_sort intValue]),@(areaodel.area_type),areaodel.area_url];
//
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
            completion(NO,@"插入数据失败");
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                completion(NO,@"插入数据失败");
            }
            else
            {
                [_database commit];
                completion(YES,nil);
            }
        }
    }];
}

- (void)deleteAreaWithAreaId:(NSString*)areaId completion:(XNDDeleteAreaCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE AREAID = ?",TABLE_AREAS ];
        BOOL result = [_database executeUpdate:sql,@([areaId intValue])];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}


- (void)updateMessageForMessage:(XNDAreaModel*)model completion:(XNDUpdateMessageCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"UPDATE %@ set area_ip_desc=?,area_name=?,area_pid=?,area_sort=?,area_type=?,area_url=? where area_id = ?",TABLE_AREAS];
        
        BOOL result = [_database executeUpdate:sql,model.area_ip_desc,model.area_name,@([model.area_pid intValue]),@([model.area_sort intValue]),@(model.area_type) ,model.area_url,@([model.area_id intValue])];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}


@end
