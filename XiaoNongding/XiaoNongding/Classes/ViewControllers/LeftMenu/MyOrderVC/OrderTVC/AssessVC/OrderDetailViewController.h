//
//  OrderDetailViewController.h
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

@property (nonatomic, retain) NSDictionary *orderData;

+(instancetype )shareInstance;
@end
