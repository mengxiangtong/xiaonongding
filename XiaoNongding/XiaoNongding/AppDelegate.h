//
//  AppDelegate.h
//  XiaoNongding
//
//  Created by admin on 15/12/10.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

@interface AppDelegate : UIViewController <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;


@property (retain, nonatomic) NSDictionary *setDic;

@property (retain, nonatomic)  UILabel * cityLabel;
//@property (retain, nonatomic) NSString * cityStr;

//获取当前位置
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *location;

@end

