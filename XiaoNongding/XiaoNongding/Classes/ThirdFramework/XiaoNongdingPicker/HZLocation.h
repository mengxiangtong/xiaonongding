//
//  HZLocation.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZLocation : NSObject
@property (copy, nonatomic) NSString *adress_id;
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *countryId;
@property (copy, nonatomic) NSString *provinceId;
@property (copy, nonatomic) NSString *cityId;
@property (copy, nonatomic) NSString *areaId;

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
