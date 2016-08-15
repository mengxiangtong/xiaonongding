//
//  MTTDatabaseUtil.h
//  Duoduo
//
//  Created by zuoye on 14-3-21.
//  Copyright (c) 2015年 MoguIM All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "XNDAreaModel.h"

typedef void(^XNDLoadAreaCompletion)(NSArray* messages,NSError* error);
typedef void(^XNDInsertAreasCompletion)(BOOL success,NSString* error);
typedef void(^XNDAreaCompletion)(NSInteger count);
typedef void(^XNDDeleteAreaCompletion)(BOOL success);
typedef void(^XNDGetAreaCompletion)(XNDAreaModel* area,NSError* error);
typedef void(^XNDUpdateMessageCompletion)(BOOL result);

@interface DBManager : NSObject
@property(retain)NSString *recentsession;

//在数据库上的操作
@property (nonatomic,readonly)dispatch_queue_t databaseMessageQueue;


//+ (instancetype)instance;

- (void)openCurrentUserDB;

- (void)loadAreaArrayAllWithCompletion:(XNDLoadAreaCompletion)completion;
- (void)loadCityArrayAllWithCompletion:(XNDLoadAreaCompletion)completion;
- (void)loadProvinceArrayAllWithCompletion:(XNDLoadAreaCompletion)completion;
- (void)loadCircleArrayAllWithCompletion:(XNDLoadAreaCompletion)completion;

- (void)loadCityArrayAllWithPid:(int)pid Completion:(XNDLoadAreaCompletion)completion;
- (void)loadProvinceArrayAllWithPid:(int)pid Completion:(XNDLoadAreaCompletion)completion;
- (void)loadCircleArrayAllWithPid:(int)pid Completion:(XNDLoadAreaCompletion)completion;

- (NSMutableArray *)loadAreaArrayAll;
- (NSMutableArray*)loadCityArrayAllWithPid:(int)pid;
- (NSMutableArray *)loadProvinceArrayAllWithPid:(int)pid;


- (void)insertAreas:(NSArray*)messages Completion:(XNDInsertAreasCompletion)completion;
- (void)updateMessageForMessage:(XNDAreaModel*)model completion:(XNDUpdateMessageCompletion)completion;
- (void)deleteAreaWithAreaId:(NSString*)areaId completion:(XNDDeleteAreaCompletion)completion;

@end




