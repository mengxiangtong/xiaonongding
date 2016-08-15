//
//  ActivityContentViewController.h
//  XiaoNongding
//
//  Created by jion on 16/3/9.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    ActivityOrderComPreTopType      = 1<<0,//综合排序
    ActivityOrderSalesNumTopType    = 1<<1,//销量
    ActivityOrderFansNumTopType     = 1<<2,//关注数
    ActivityOrderPriceTopType       = 1<<3,//价格
    ActivityOrderDistanceTopType    = 1<<4,//距离
    ActivityOrderComPreBottomType   = 1<<5,//综合排序
    ActivityOrderSalesNumBottomType = 1<<6,//销量
    ActivityOrderFansNumBottomType  = 1<<7,//关注数
    ActivityOrderPriceBottomType    = 1<<8,//价格
    ActivityOrderDistanceBottomType = 1<<9,//距离
} ActivityOrderType;
@interface ActivityContentViewController : UIViewController
@property (nonatomic, retain) NSString *str_type;//活动类型
@property (nonatomic, retain) NSString *str_Title;// 标题
+(instancetype )shareInstance;

-(void)refreshData;
@end
