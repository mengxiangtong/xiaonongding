//
//  HotNews.h
//  Calender
//
//  Created by 詹世倩 on 14-10-22.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotNews : NSObject

#pragma mark 列表页面
@property (nonatomic, copy) NSString *digest;    // 标题摘要
@property (nonatomic, copy) NSString *title;     // 新闻标题
@property (nonatomic, copy) NSString *imgsrc;    // 图片地址
//@property (nonatomic, copy) NSString *replyCount;   // 跟帖个数

#pragma mark 详细页面
@property (nonatomic, copy) NSString *source;    // 新闻来源的类型
@property (nonatomic, copy) NSString *body;      // 内容
@property (nonatomic, copy) NSString *ptime;    // 更新时间
@property (nonatomic, copy) NSString *docid;


@end
