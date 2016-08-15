//
//  OverActiveTableViewCell.h
//  XiaoNongding
//
//  Created by jion on 16/1/29.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverActiveTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *lb_farm;
@property (nonatomic, retain) UILabel *lb_distance;
@property (nonatomic, retain) UILabel *lb_state;

@property (nonatomic, retain) UIImageView *img_Product;
@property (nonatomic, retain) UILabel *lb_Title;
@property (nonatomic, retain) UILabel *lb_Date;

@property (nonatomic, retain) UILabel *lb_Price;

@property (nonatomic, retain) UIButton *Btn_Two;
@property (nonatomic, retain) UIButton *Btn_One;

@property (nonatomic, retain) NSDictionary *dic_Item;

@end
