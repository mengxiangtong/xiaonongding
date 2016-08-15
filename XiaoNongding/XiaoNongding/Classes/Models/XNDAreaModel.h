//
//  XNDAreaModel.h
//  XiaoNongding
//
//  Created by jion on 16/1/19.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XNDAreaModel : NSObject

@property (nonatomic, retain) NSString *area_id;
@property (nonatomic, retain) NSString *area_pid;//上级ID  没有为none
@property (nonatomic, retain) NSString *area_name;
@property (nonatomic, retain) NSString *area_sort;
@property (nonatomic, retain) NSString *first_pinyin;
@property (nonatomic, retain) NSString *is_open;
@property (nonatomic, retain) NSString *area_url;
@property (nonatomic, retain) NSString *area_ip_desc;
@property (nonatomic, assign) AreaType  area_type;


-(XNDAreaModel *)initWithDictionary:(NSDictionary *)dic;
-(NSMutableArray *)arrayWithArray:(NSArray *)arry;
@end
