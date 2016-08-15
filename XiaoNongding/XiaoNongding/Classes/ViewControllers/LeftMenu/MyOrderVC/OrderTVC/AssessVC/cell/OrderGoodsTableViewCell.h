//
//  OrderTableViewCell.h
//  XiaoNongding
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderGoodsTableViewCellDelegate <NSObject>

-(void)OrderConfirmWithDic:(NSDictionary *)item;

@end

@interface OrderGoodsTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *lb_farm;
@property (nonatomic, retain) UILabel *lb_distance;
@property (nonatomic, retain) UILabel *lb_state;

@property (nonatomic, retain) UIImageView *img_Product;
@property (nonatomic, retain) UILabel *lb_Title;
@property (nonatomic, retain) UILabel *lb_Date;

@property (nonatomic, retain) UILabel *lb_Price;


@property (nonatomic, retain) NSDictionary *item_Data;//数据源

@property (nonatomic, retain) UIViewController *superVC;//父控制器

@property (nonatomic, assign) id<OrderGoodsTableViewCellDelegate> delegate;

@end
