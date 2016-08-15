//
//  OrderOtherTableViewCell.h
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderOtherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_Right;
@property (weak, nonatomic) IBOutlet UILabel *lb_Left;

@property (nonatomic, retain) NSDictionary *data_item;
@end
