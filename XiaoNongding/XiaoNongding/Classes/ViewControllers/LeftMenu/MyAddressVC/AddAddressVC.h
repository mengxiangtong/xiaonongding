//
//  AddAddressVC.h
//  XiaoNongding
//
//  Created by admin on 15/12/24.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressVC : UIViewController

@property (nonatomic, retain) NSDictionary *dic_item;


+(instancetype )shareInstance;
-(void)clearAllData;
-(void)setAllDataWithDic:(NSDictionary *)dic;
@end
