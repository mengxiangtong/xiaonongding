//
//  UINewIntoTableViewCell.h
//  XiaoNongding
//
//  Created by jion on 16/1/11.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCarouselFigureView.h"
@interface UINewIntoView : UITableViewCell

@property (nonatomic,retain) UIImageView *img1;
@property (nonatomic,retain) UIImageView *img2;
@property (nonatomic,retain) UIImageView *img3;

@property (nonatomic, retain) NSArray *pList;
@property (nonatomic,retain) DDCarouselFigureView *caro;
@end
