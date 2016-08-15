//
//  DEMOHomeViewController.h
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NKJPagerViewController.h"


@interface HomeViewController :NKJPagerViewController
+(instancetype )shareInstance;
-(void)setPageSelectedIndex:(int)index;
@end
