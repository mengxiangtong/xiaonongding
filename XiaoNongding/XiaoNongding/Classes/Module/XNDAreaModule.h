//
//  XNDAreaModule.h
//  XiaoNongding
//
//  Created by jion on 16/1/19.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNDAreaModel.h"
#import "DBManager.h"


typedef void(^XNDLoadAreaModelCompletion)(NSArray* messages,NSError* error);
typedef void(^XNDUpdateAreaModelCompletion)(BOOL success ,NSError* error);

@interface XNDAreaModule : NSObject

@property (nonatomic, retain) NSMutableArray *modelAreaArry;
@property (nonatomic, retain) NSMutableArray *modelCityArry;
@property (nonatomic, retain) NSMutableArray *modelProvinceArry;
@property (nonatomic, retain) NSMutableArray *modelCircleArry;
@property (nonatomic, retain) NSString *objId;

+ (instancetype)instance;

-(void)AddAreaWithModel:(XNDAreaModel *)model Completion:(XNDUpdateAreaModelCompletion)completion;
-(void)AddAreaWithArray:(NSArray *)arryModel Completion:(XNDUpdateAreaModelCompletion)completion;
-(void)UpdateAreaWithModel:(XNDAreaModel *)model Completion:(XNDUpdateAreaModelCompletion)completion;
-(void)LoadAllAreaWithCompletion:(XNDLoadAreaModelCompletion)completion;
-(void)LoadAllCityWithCompletion:(XNDLoadAreaModelCompletion)completion;
-(void)LoadAllProvinceWithCompletion:(XNDLoadAreaModelCompletion)completion;
-(void)LoadAllCircleWithCompletion:(XNDLoadAreaModelCompletion)completion;

-(BOOL)IsExitisWithAreaId:(int)area_id;

-(void)loadAreaList;
-(void)loadCityList:(int)pid;
-(void)loadProvinceList:(int)pid;




@end
