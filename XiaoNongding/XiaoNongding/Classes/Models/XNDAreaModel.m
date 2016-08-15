//
//  XNDAreaModel.m
//  XiaoNongding
//
//  Created by jion on 16/1/19.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "XNDAreaModel.h"

@implementation XNDAreaModel

-(XNDAreaModel *)initWithDictionary:(NSDictionary *)dic{

    XNDAreaModel *model=[[XNDAreaModel alloc]init];
    if (dic) {
        model.area_id=[dic objectForKey:@"area_id"];
        model.area_ip_desc=[dic objectForKey:@"area_ip_desc"];
        model.area_name=[dic objectForKey:@"area_name"];
        model.area_pid=[dic objectForKey:@"area_pid"];
        model.area_sort=[dic objectForKey:@"area_sort"];
        model.area_type=(AreaType)[[dic objectForKey:@"area_type"] integerValue];
        model.area_url=[dic objectForKey:@"area_url"];

    }else{
        model.area_id=nil;
        model.area_ip_desc=nil;
        model.area_name=nil;
        model.area_pid=nil;
        model.area_sort=nil;
        model.area_type=AreaTypeNone;
        model.area_url=nil;
    }
    return model;
}

-(NSMutableArray *)arrayWithArray:(NSArray *)arry{
    NSMutableArray *mutableArry=[[NSMutableArray alloc] init];
    if (arry) {
        for (NSDictionary *obj in arry) {
            [mutableArry addObject:[self initWithDictionary:obj ]];
        }
    }
    return mutableArry;
}
@end
