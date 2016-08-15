//
//  OrderDetailModule.h
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^CompleteGetDataBlock)(NSArray * allData);

@interface OrderDetailModule : NSObject

+(instancetype )shareInstance;
-(void)getOrderArrayDataWithFarmDic:(NSDictionary *)FarmItem Complete:(CompleteGetDataBlock)CompleteBlock;
-(NSMutableArray *)getOrderArrayData;
-(void)setOrderItem:(NSDictionary *)orderItem;

@end
