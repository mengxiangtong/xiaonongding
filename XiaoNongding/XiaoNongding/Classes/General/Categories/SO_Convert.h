//
//  SO_Convert.h
//  USAENet
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SO_Convert : NSObject

//NSString 转 NSDate
+(NSDate *)stringToDate:(NSString *)str_Date DateFormat:(NSString *)dateFormat;
//NSDate 转 NSString
+(NSString *)DateToString:(NSDate *)date DateFormat:(NSString *)dateFormat;
//UIColor转Image
+(UIImage*) createImageWithColor:(UIColor*) color;
@end
