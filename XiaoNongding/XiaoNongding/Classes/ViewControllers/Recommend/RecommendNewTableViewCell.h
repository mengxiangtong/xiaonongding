//
//  RecommendNewTableViewCell.h
//  XiaoNongding
//
//  Created by jion on 16/3/9.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendNewTableViewCell : UITableViewCell
@property (nonatomic, retain) NSString *idStr;
@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, retain) UIImageView *cellImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *xiaoliangLabel ;
@property (nonatomic, retain) UILabel *priceLabel;


@property (nonatomic, retain) UIViewController *superVC;
@end
