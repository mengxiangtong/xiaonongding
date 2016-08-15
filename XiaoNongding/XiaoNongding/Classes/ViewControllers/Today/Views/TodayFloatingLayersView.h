//
//  TodayFloatingLayersView.h
//  XiaoNongding
//
//  Created by jion on 16/3/22.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayFloatingLayersView : UIView
@property (nonatomic, retain) UIButton *btn_care;
@property (nonatomic,retain) UIButton *btn_shopCar;

- (instancetype)initWithTarget:(UIViewController*)supervc Frame:(CGRect)frame;

@end
