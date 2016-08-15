//
//  CouponView.h
//  XiaoNongding
//
//  Created by jion on 16/3/18.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponView : UIView
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView  *bgimgView;

//订单信息，子控件
@property (nonatomic, retain) UILabel *lb_productName;
@property (nonatomic, retain) UILabel *lb_Price;
@property (nonatomic, retain) UILabel *lb_ProductTitle;
@property (nonatomic, retain) UILabel *lb_ProductpatTime;
@property (nonatomic, retain) UIImageView *img_Product;
@property (nonatomic, retain) UIImageView *img_QRCode;
@property (nonatomic, retain) UILabel *lb_ProductCode;
@property (nonatomic, retain) UILabel *lb_OrderCode;
@property (nonatomic, retain) UILabel *lb_OrderDate;
@property (nonatomic, retain) UILabel *lb_OrderPhone;
@property (nonatomic, retain) UILabel *lb_OrderNo;
@property (nonatomic, retain) UILabel *Lb_payType;
@property (nonatomic, retain) UILabel *lb_OrderPayTime;
@property (nonatomic, retain) UILabel *lb_OrderPayMoney;
@property (nonatomic, retain) UIImageView *img_icons;


@end
