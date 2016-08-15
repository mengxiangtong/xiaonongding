//
//  UIWebViewViewController.h
//  XiaoNongding
//
//  Created by jion on 16/1/22.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewViewController : UIViewController

@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, retain) NSString *idStr;
@property (nonatomic, assign) BOOL     isHiddenShareView;

-(void)initUrlAndId:(NSString *)idstr urlstr:(NSString *)urlstr;
@end
