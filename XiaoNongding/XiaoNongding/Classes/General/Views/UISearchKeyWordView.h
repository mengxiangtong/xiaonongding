//
//  UISearchKeyWordView.h
//  XiaoNongding
//
//  Created by jion on 16/1/27.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UISearchKeyWordViewDelegate<NSObject>
-(void)UISearchKeyWordViewClicked:(NSDictionary *)item;
@end

@interface UISearchKeyWordView : UIView
@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic,assign) id<UISearchKeyWordViewDelegate> delegate;
@end
