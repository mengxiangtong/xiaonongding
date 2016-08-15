//
//  ITheadscrollView.m
//  ITNews
//
//  Created by lipixu on 15/1/9.
//  Copyright (c) 2015年 Uncle Wang. All rights reserved.
//

#import "ITheadscrollView.h"
//#import "ScrollHomeModel.h"


@interface ITheadscrollView ()


@end

@implementation ITheadscrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       // [self addAllViews];
    }
    return self;
}

- (void)setScrollAllDataMutableArray:(NSMutableArray *)scrollAllDataMutableArray{
    if (_scrollAllDataMutableArray == scrollAllDataMutableArray) {
        return;
    }
    
    [self.scrollAllDataMutableArray removeAllObjects];
    _scrollAllDataMutableArray = scrollAllDataMutableArray;

    
    _imageName = [[NSMutableArray alloc] init];
    [self setNeedsDisplay];
    
    /*
    for (ScrollHomeModel *scrollmodel in _scrollAllDataMutableArray) {
        
        if (scrollmodel) {
            [_imageName addObject:scrollmodel];
        }
        
    }
     */
    
    _pageControl.numberOfPages = _imageName.count;
    
    [self addAllViews];
    


}

- (void)addAllViews
{
    
    //self.imageName = [NSMutableArray arrayWithObjects:@"local1", @"local2", @"local3", @"local4",@"local4", nil];
    
    self.allViewControllers = [NSMutableArray array];
    
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_imageName count]; i++) {
        [controllers addObject:[_imageName objectAtIndex:i]];
    }
    self.allViewControllers = controllers;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
    //self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * self.imageName.count, _scrollView.frame.size.height);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.autoresizesSubviews = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    [self addSubview:_scrollView];
    
    _isExpanded = NO;
    
    UITapGestureRecognizer *singleFinderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
    singleFinderTap.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:singleFinderTap];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, self.frame.size.width, 10)];
    _pageControl.numberOfPages = _imageName.count;
   // _pageControl.userInteractionEnabled = YES;
   // _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
   // _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    if (_imageName.count > 1) {
        
        [self addSubview:_pageControl];
    }

    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.bounds.size.height - 150, self.frame.size.width - 50, 70)];
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByCharWrapping;
    _label.font = [UIFont boldSystemFontOfSize:20.0f];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    
    [self loadScrollViewWithPage:0];
    
}

- (void)didTap
{/*
    if ([_delegate respondsToSelector:@selector(didSelectedScrollView:)])
    {
        [_delegate performSelector:@selector(didSelectedScrollView:)];
    }
  
  */
}


- (void)updateFrame:(CGRect)rect
{
    self.frame = rect;
    _scrollView.frame = rect;
    
    float y = self.frame.size.height + _scrollView.frame.origin.y - 10.0f;
    _pageControl.frame = CGRectMake(0, y, self.frame.size.width, 10.0f);
}



- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) {
        return;
    }
    
    if (page >= _imageName.count) {
        return;
    }
    
    
    UIImageView *controller;
    if (_allViewControllers.count) {
        controller = [_allViewControllers objectAtIndex:page];
    }
    
    
    if ([_imageName count]) {
        
        controller = [[UIImageView alloc] init];
        CGRect frame = _scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.frame = frame;
        controller.contentMode = UIViewContentModeScaleAspectFill;
        controller.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //controller.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
       
        controller.layer.masksToBounds = YES;
        controller.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:controller];
        
        
       
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setCenter:CGPointMake(controller.center.x, controller.center.y)];
        [spinner startAnimating];
        [controller addSubview:spinner];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            for (int i = 0; i < _imageName.count; i++) {
                if (page == i) {
                    
                   if (_allViewControllers.count) { // 网络判断
                        [_allViewControllers replaceObjectAtIndex:page withObject:controller];
                       
                   }
                    dispatch_async(dispatch_get_main_queue(), ^{
                     //赋值图片
                   // [controller setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_imageName objectAtIndex:i]]]];
                    /*
                    ScrollHomeModel *scrollModel = _imageName[i];
                        [controller sd_setImageWithURL:[NSURL URLWithString:scrollModel.image] placeholderImage:nil];
                        self.label.text = scrollModel.title;
                     
                     */
                    //移除指示器
                    [spinner removeFromSuperview];
                        return ;
                    });
                }
            }
        });
        
    }
    
}


#pragma mark - ScrollView Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
    _pageControl.currentPage = page + 1;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageControlUsed = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    _pageControlUsed = NO;
}



- (void)dealloc
{
//    self.delegate = nil;
//    self.scrollView = nil;
//    self.allViewControllers = nil;
//    self.pageControl = nil;
//    self.label = nil;
}

@end
