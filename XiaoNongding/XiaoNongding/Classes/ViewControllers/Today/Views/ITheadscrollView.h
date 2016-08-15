//
//  ITheadscrollView.h
//  ITNews
//
//  Created by lipixu on 15/1/9.
//  Copyright (c) 2015年 Uncle Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "HomeModel.h"

@protocol ITheadscrollViewDelegate <NSObject>

@optional
- (void)didSelectedScrollView:(NSMutableArray *)scrollAllDataMutableArray;

@end


//typedef void (^SendBlock)(HomeModel *homeModel);

@interface ITheadscrollView : UIView <UIScrollViewDelegate>


//@property (nonatomic,copy) SendBlock  sendBbock;
@property (nonatomic, retain) NSMutableArray *imageName;
@property (nonatomic, retain) NSMutableArray *scrollAllDataMutableArray;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *allViewControllers;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) BOOL pageControlUsed;
@property (nonatomic, assign) id<ITheadscrollViewDelegate>delegate;
@property (nonatomic, retain) UILabel *label;


- (void)updateFrame:(CGRect)rect;

@end
