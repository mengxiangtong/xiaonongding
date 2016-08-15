//
//  PayManager.h
//  XiaoNongding
//
//  Created by jion on 16/2/4.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
@interface PayManager : NSObject
-(void)LoadProductMessageWithPayType:(NSString *)payType OrderType:(NSString *)orderType orderId:(NSString *)orderId;
@end
