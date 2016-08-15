//
//  SearchResultViewController.h
//  XiaoNongding
//
//  Created by jion on 16/1/27.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SearchOrderComPreTopType   = 1<<0,//综合排序
    SearchOrderSalesNumTopType = 1<<2,//销量
    SearchOrderFansNumTopType  = 1<<3,//关注数
    SearchOrderPriceTopType    = 1<<4,//价格
    SearchOrderDistanceTopType = 1<<5,//距离
    SearchOrderComPreBottomType   = 1<<6,//综合排序
    SearchOrderSalesNumBottomType = 1<<7,//销量
    SearchOrderFansNumBottomType  = 1<<8,//关注数
    SearchOrderPriceBottomType    = 1<<9,//价格
    SearchOrderDistanceBottomType = 1<<10,//距离
} SearchOrderType;

@interface SearchResultViewController : UIViewController



@property (nonatomic, retain) NSString *keyWord;

@end
