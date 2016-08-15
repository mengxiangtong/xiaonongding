//
//  NSString+MD5.h
//  USAENet
//
//  Created by apple on 15/8/25.
//  Create person ： 李万浩
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString_MD5 : NSObject

+(NSString *)MD5EncryptBy16:(NSString *)str;
+(NSString *)MD5EncryptBy32:(NSString *)str;
@end
