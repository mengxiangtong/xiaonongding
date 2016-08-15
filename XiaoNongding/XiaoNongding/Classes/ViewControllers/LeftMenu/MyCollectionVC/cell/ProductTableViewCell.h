//
//  ProductTableViewCell.h
//  XiaoNongding
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductTableViewCellDelegate <NSObject>

-(void)selectedCell:(BOOL)isSelected item:(NSDictionary*)item;

@end

@interface ProductTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *img_Product;
@property (nonatomic, retain) UILabel *lb_Title;
@property (nonatomic, retain) UILabel *lb_Price;
@property (nonatomic, retain) UILabel *lb_OldPrice;
@property (nonatomic, retain) UIButton *btn_select;//选择框

@property (nonatomic, retain) NSDictionary *data_item;
@property (nonatomic, retain) NSString *str_isEditor;// 是否编辑
@property (nonatomic, assign) BOOL isChecked;// 是否选中

@property (nonatomic,assign) id<ProductTableViewCellDelegate> delegate;

@end
