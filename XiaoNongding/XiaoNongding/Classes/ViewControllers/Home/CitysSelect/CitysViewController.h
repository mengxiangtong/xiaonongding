//
//  CitysViewController.h
//  XiaoNongding
//
//  Created by admin on 15/12/18.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^B_block)(NSString *);


@interface CitysViewController : UIViewController


@property (nonatomic, copy) B_block sendCityBlock;

@property (nonatomic, retain)  NSString *currentCityString;


@end
