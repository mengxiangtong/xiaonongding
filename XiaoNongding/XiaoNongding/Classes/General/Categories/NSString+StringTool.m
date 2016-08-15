//
//  NSString+StringTool.m
//  LanKe
//
//  Created by admin on 15/8/17.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "NSString+StringTool.h"

@implementation NSString (StringTool)


//    去除两端空格和回车
- (NSString *)absoluteString
{
    NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return temp;
}



@end
