//
//  UIShareUMCustomView.h
//  XiaoNongding
//
//  Created by jion on 16/3/25.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIShareUMCustomViewDelegate <NSObject>
-(void)ShareAction:(int )tag;
- (void)setInfoViewFrame:(BOOL)isDown;
@end
@interface UIShareUMCustomView : UIView
@property (nonatomic, retain) UIViewController *target;
@property (nonatomic,retain) UIView *view_Bg;
@property (nonatomic, weak) id<UIShareUMCustomViewDelegate> delegate;
@end
