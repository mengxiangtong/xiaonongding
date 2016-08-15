//
//  DDCarouselFigureView.h
//  Demo_simple
//
//  Created by jion on 15/11/4.
//  Copyright © 2015年 rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCarouselFigureView : UIView

@property (nonatomic,weak) UIScrollView *scrollView;

@property (assign,nonatomic) NSInteger number;
@property (retain,nonatomic) NSArray *photoList;

@property (retain, nonatomic) UIViewController *superVC;

@end
