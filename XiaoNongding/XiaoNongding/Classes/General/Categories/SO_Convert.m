//
//  SO_Convert.m
//  USAENet
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "SO_Convert.h"

@implementation SO_Convert

+(NSDate *)stringToDate:(NSString *)str_Date DateFormat:(NSString *)dateFormat{
    if (!str_Date) {
        return nil;
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setTimeZone:tzGMT];
    
    NSDate *date=[formatter dateFromString:str_Date];
    
    return date;
}

+(NSString *)DateToString:(NSDate *)date DateFormat:(NSString *)dateFormat{
    if(!date)return nil;
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateFormat];
    NSTimeZone *tzGMT = [NSTimeZone timeZoneWithName:@"GMT"];
    [formatter setTimeZone:tzGMT];
    
    NSString *str_date=[formatter stringFromDate:date];
    
    return str_date;
}
//颜色转Image
+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
