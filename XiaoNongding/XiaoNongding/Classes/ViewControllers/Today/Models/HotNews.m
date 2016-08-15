//
//  HotNews.m
//  Calender
//
//  Created by 詹世倩 on 14-10-22.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "HotNews.h"

@implementation HotNews

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    self.digest = nil;
    self.imgsrc = nil;
    self.title = nil;
    self.source = nil;
    self.body = nil;
    //self.replyCount = nil;
    self.docid = nil;
    
}
@end
