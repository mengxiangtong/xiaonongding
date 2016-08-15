//
//  RankTableViewCell.h
//  ITNews
//
//  Created by Unlce Wang on 15/1/12.
//  Copyright (c) 2015年 Uncle Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NewsListModel.h"
//#import "AnimationModel.h"
//#import "FunModel.h"
@interface RecommendTableViewCell : UITableViewCell
@property (nonatomic, retain) NSString *idStr1;
@property (nonatomic, retain) NSString *urlStr1;
@property (nonatomic, retain) UIImageView *cellImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *xiaoliangLabel ;
@property (nonatomic, retain) UILabel *priceLabel;

@property (nonatomic, retain) NSString *idStr2;
@property (nonatomic, retain) NSString *urlStr2;
@property (nonatomic, retain) UIImageView *cellImageView2;
@property (nonatomic, retain) UILabel *titleLabel2;
@property (nonatomic, retain) UILabel *xiaoliangLabel2 ;
@property (nonatomic, retain) UILabel *priceLabel2;
@property (nonatomic, retain) UILabel *jin2;


@property (nonatomic, retain) UIViewController *superVC;

@end
