//
//  SearchFarmTableViewCell.h
//  XiaoNongding
//
//  Created by jion on 16/1/28.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFarmTableViewCell : UITableViewCell
@property (nonatomic, copy) NSDictionary *data_item;

+ (CGFloat)cellHeightWithContact:(NSDictionary *)note;

@end
