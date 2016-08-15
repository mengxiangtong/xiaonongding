//
//  AddressTableViewCell.h
//  XiaoNongding
//
//  Created by admin on 15/12/25.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell<UIAlertViewDelegate>


@property (nonatomic, retain) UILabel *lb_name;
@property (nonatomic, retain) UILabel *lb_Title;
@property (nonatomic, retain) UILabel *lb_address;
@property (nonatomic, retain) UIButton *Btn_Two;
@property (nonatomic, retain) UIButton *Btn_One;

@property (nonatomic, retain) NSDictionary *dic_item;

@end
