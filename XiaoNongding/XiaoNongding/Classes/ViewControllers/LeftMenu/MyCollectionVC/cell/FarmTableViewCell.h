//
//  FarmTableViewCell.h
//  XiaoNongding
//
//  Created by jion on 15/12/24.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FarmTableViewCellDelegate <NSObject>

-(void)selectedFarmCell:(BOOL)isSelected item:(NSDictionary*)item;

@end

@interface FarmTableViewCell : UITableViewCell
@property (nonatomic, retain) UIImageView *img_Product;     //农场图片
@property (nonatomic, retain) UILabel *lb_Title;            //农场名称
@property (nonatomic, retain) UILabel *lb_Score;            //评分
@property (nonatomic, retain) UILabel *lb_Attention;        // 关注 键: 值
@property (nonatomic, retain) UILabel *lb_Distance;         // 关注 键: 值
@property (nonatomic, retain) UIImageView *img_Score1;      //评分 1
@property (nonatomic, retain) UIImageView *img_Score2;      //评分 2
@property (nonatomic, retain) UIImageView *img_Score3;      //评分 3
@property (nonatomic, retain) UIImageView *img_Score4;      //评分 4
@property (nonatomic, retain) UIImageView *img_Score5;      //评分 5
@property (nonatomic, retain) UIButton *btn_select;//选择框


@property (nonatomic, retain) NSDictionary *data_item;
@property (nonatomic, retain) NSString *str_isEditor;// 是否编辑
@property (nonatomic, assign) BOOL isChecked;// 是否选中

@property (nonatomic,assign) id<FarmTableViewCellDelegate> delegate;

@end
