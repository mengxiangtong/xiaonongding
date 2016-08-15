//
//  EditorViewController.h
//  XiaoNongding
//
//  Created by jion on 15/12/24.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorViewController : UIViewController
@property (nonatomic, assign) BOOL isProduct;
@property (nonatomic, retain) NSMutableArray *arry_data;
@property (nonatomic, retain) NSMutableArray *arry_selected;

+(instancetype )shareInstance;
@end
