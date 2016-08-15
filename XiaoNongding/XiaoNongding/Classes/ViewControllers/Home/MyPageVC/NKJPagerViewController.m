//
//  MIPagerViewController.m
//  NKJPagerViewController
//
//  Created by nakajijapan on 11/28/14.
//  Copyright (c) 2015 net.nakajijapan. All rights reserved.
//

#import "NKJPagerViewController.h"

#define kTabViewTag 18
#define kContentViewTag 24

#define kTabsViewBackgroundColor [UIColor colorWithRed:234.0 / 255.0 green:234.0 / 255.0 blue:234.0 / 255.0 alpha:0.75]
#define kContentViewBackgroundColor [UIColor colorWithRed:248.0 / 255.0 green:248.0 / 255.0 blue:248.0 / 255.0 alpha:0.75]

@interface NKJPagerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property CGFloat leftTabIndex;
@property NSInteger tabCount;

@property UIPageViewController *pageViewController;
@property (getter=isAnimatingToTab, assign) BOOL animatingToTab;
@property CGPoint movingOffset;

@end

@implementation NKJPagerViewController

#pragma mark - Initialize

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

#pragma mark - init 的默认初始化
- (void)defaultSettings
{
    //下面 平滑页面  VC
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self addChildViewController:self.pageViewController];

    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

    
    //--------------------- 设置 tabbar 位置
    self.heightOfTabView = 44.0;
    self.yPositionOfTabView = 0.0;
    self.view.backgroundColor = kClassTabBgColor;
    
    self.animatingToTab = NO;
}



#pragma mark - viewdidload 的 默认加载
- (void)defaultSetUp
{
    // Empty tabs and contents
    for (UIView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    self.tabsView.contentSize = CGSizeZero;

    [self.tabs removeAllObjects];
    [self.contents removeAllObjects];

    // Initializes
    self.tabCount = [self.dataSource numberOfTabView];
    self.leftTabIndex = 2;
    self.tabs = [NSMutableArray array];
    self.contents = [NSMutableArray array];

    // Add tabsView in Superview
    if (!self.tabsView) {

        self.tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.yPositionOfTabView, kDeviceWidth, self.heightOfTabView)];
        self.tabsView.userInteractionEnabled = YES;
        self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabsView.backgroundColor = kClassTabBgColor;
        self.tabsView.scrollsToTop = NO;
        self.tabsView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
        self.tabsView.showsVerticalScrollIndicator = NO;
        self.tabsView.tag = kTabViewTag;
        self.tabsView.bounces = NO;
        self.tabsView.scrollEnabled = YES;//可以滚动

        [self.view insertSubview:self.tabsView atIndex:0];

        //向左滑动。 （快速滑动）
        UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.tabsView addGestureRecognizer:leftSwipeGestureRecognizer];

        //向右滑动。
        UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.tabsView addGestureRecognizer:rightSwipeGestureRecognizer];
    }

    //计算 分类总宽度
    NSInteger contentSizeWidth = 0;
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        
        if (self.tabs.count >= self.tabCount) {
            continue;
        }

        //代理调用
        UIView *tabView = [self.dataSource viewPager:self viewForTabAtIndex:i];
        tabView.tag = i;
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = [self.dataSource widthOfTabView ];
        tabView.frame = frame;
        tabView.userInteractionEnabled = YES;
        
      
        
        
        [self.tabsView addSubview:tabView];
        [self.tabs addObject:tabView];
       
        contentSizeWidth += CGRectGetWidth(tabView.frame);
        
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];

        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // 调用代理  添加控制器数组
        [self.contents addObject:[self.dataSource viewPager:self contentViewControllerForTabAtIndex:i]];
    }
    //顶部 滚动 的宽高   // 4. 设置内容视图大小
    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, self.heightOfTabView);


    
    //添加容器视图。 下部分视图 ————————————————————————————————————————————————————————————————————————————————
    // Add contentView in Superview
    self.contentView = [self.view viewWithTag:kContentViewTag];
    if (!self.contentView) {

        // Populate pageViewController.view in contentView
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        //self.contentView.backgroundColor = kContentViewBackgroundColor;
        //背景色 黄色
        self.contentView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0];

        self.contentView.bounds = self.view.bounds;
        self.contentView.tag = kContentViewTag;
        [self.view insertSubview:self.contentView atIndex:0];

        // constraints
        if ([self.delegate respondsToSelector:@selector(viewPagerDidAddContentView)]) {
            
            [self.delegate viewPagerDidAddContentView];
            
        } else {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = @{ @"contentView" : self.contentView };
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
            //自动布局 垂直
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:nil views:views]];
        }
    }

    //初始化索引0
    [self selectTabAtIndex:0];

    //调用代理   tab 点击事件代理
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
    }
}
- (void)upodateDefaultSetUp:(int)index
{
    
    [self selectTabAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
        [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
    }
}

- (void)viewWillLayoutSubviews
{
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0]];
    
    //默认加载
    [self defaultSetUp];
    
    //注册通知 分类点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotifacation:) name:@"changeSelected" object:nil];
    
    NSLog(@" NKJPagerViewController  viewDidLoad  ");
    
    //注册通知 上划
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUp:) name:@"changeUp" object:nil];

    //注册通知 下划
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDown:) name:@"changeDown" object:nil];
}



- (void)changeUp:(NSNotification *)not
{
      NSLog(@"接收到 通知----");

    self.navigationController.navigationBarHidden = YES;
   [UIView animateWithDuration:0.5 animations:^{
       self.tabsView.frame = CGRectMake(0, 20, kDeviceWidth, self.heightOfTabView);

   } completion:^(BOOL finished) {
       
   }];

    
}

- (void)changeDown:(NSNotification *)not
{
    NSLog(@"   下滑 通知     +++++++   ----");
    self.navigationController.navigationBarHidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tabsView.frame = CGRectMake(0, 0, kDeviceWidth, self.heightOfTabView);
    } completion:^(BOOL finished) {
        
    }];

   // self.tabsView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

#pragma mark - 处理通知
- (void)handleNotifacation:(NSNotification *)notica
{
    NSString *str = [notica object];
    NSInteger tag = [str intValue];
    //NSLog(@"-- %lu",(long)tag);
    
    [self handleNotifacationTapGesture:tag];
}

#pragma mark - 根据通知的值 来切换
- (void)handleNotifacationTapGesture:(NSInteger) tag
{
    NSLog(@"根据通知的值 来切换-- %lu",(long)tag);
    
    [self trasitionTabViewWithView:[self tabViewAtIndex:tag]];
    [self selectTabAtIndex:tag];
    
    
}

#pragma mark - Gesture  顶部 滚动 点击
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    [self trasitionTabViewWithView:sender.view];
    [self selectTabAtIndex:sender.view.tag];
}

#pragma mark - 滚动顶部 tabbar
//滚动tab
- (void)trasitionTabViewWithView:(UIView *)view
{
    self.animatingToTab = YES;

    CGFloat buttonSize = [self.dataSource widthOfTabView];
    CGFloat sizeSpace = ([[UIScreen mainScreen] bounds].size.width - buttonSize) / 10;
    NSLog(@"%f",view.frame.origin.x-buttonSize);
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.width - buttonSize);
    
    [UIView animateWithDuration:0.1 animations:^{
        if(self.tabCount>4 && (view.frame.origin.x-buttonSize) >= ([[UIScreen mainScreen] bounds].size.width - buttonSize*2.0)){
            //                             self.tabsView.contentOffset = CGPointMake(buttonSize*(view.tag-(self.tabCount>=4?3:1)) , 0);
            self.tabsView.contentOffset = CGPointMake(buttonSize*(self.tabCount-4), 0);
        }else{
            self.tabsView.contentOffset = CGPointMake(0, 0);
        }
    }completion:^(BOOL finished) {
          //调用代理
        if ([self.delegate respondsToSelector:@selector(viewPager:didSwitchAtIndex:withTabs:)]) {
            [self.delegate viewPager:self didSwitchAtIndex:self.activeContentIndex withTabs:self.tabs];
        }
        self.animatingToTab = NO;
    }];
    
}

// 快速滑动scrollview
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)sender
{
//  
//    //判断方向
//    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {//向左
//        UIView *activeTabView = [self tabViewAtIndex:3];
//        [self trasitionTabViewWithView:activeTabView];
//        [self selectTabAtIndex:activeTabView.tag];
//
//    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
//        UIView *activeTabView = [self tabViewAtIndex:1];
//        [self trasitionTabViewWithView:activeTabView];
//        [self selectTabAtIndex:activeTabView.tag];
//        [self scrollWithDirection:0.1];
//        
//    }
    
}

#pragma mark - UIPageViewControllerDataSource

#pragma mark   返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    //拿到当前 VC 的索引
    NSUInteger index = [self indexForViewController:viewController];
    index++;

    if (index == [self.contents count]) {
        index = 0;
        return nil;
    }

    return [self viewControllerAtIndex:index];
}

#pragma mark  返回上一个ViewController对象xc
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexForViewController:viewController];

    if (index == 0) {
        index = [self.contents count] - 1;
        return nil;
    } else {
        index--;
    }

    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
         didFinishAnimating:(BOOL)finished
    previousViewControllers:(NSArray *)previousViewControllers
        transitionCompleted:(BOOL)completed
{
    UIViewController *viewController = self.pageViewController.viewControllers[0];

    // Select tab
    NSUInteger index = [self indexForViewController:viewController];
    for (UIView *view in self.tabsView.subviews) {
        if (view.tag == index) {
            [self trasitionTabViewWithView:view];
        }
    }

    _activeContentIndex = index;
}




#pragma mark - UIScrollViewDelegate

#pragma mark - 将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    
}


#pragma mark  滚动结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

#pragma mark - 将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{    
    
}






#pragma mark - Private Methods

- (void)setActiveContentIndex:(NSInteger)activeContentIndex
{

    NSLog(@"  设置 内容 VC  %lu ",  activeContentIndex);
    
    UIViewController *viewController = [self viewControllerAtIndex:activeContentIndex];

    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }

    if (activeContentIndex == self.activeContentIndex) {

        [self.pageViewController setViewControllers:@[ viewController ]
                                          direction:UIPageViewControllerNavigationDirectionForward//从左往右
                                           animated:NO
                                         completion:^(BOOL completed){// none
                                         }];

    } else { // 点击 非当前的tab

        NSInteger direction = 0; //默认从左往右
        if (activeContentIndex == self.contents.count - 1 && self.activeContentIndex == 0) { // 点 最后
           // direction = UIPageViewControllerNavigationDirectionReverse;  // 从右往左
            direction = UIPageViewControllerNavigationDirectionForward;//从左往右

        } else if (activeContentIndex == 0 && self.activeContentIndex == self.contents.count - 1) {//点第一个
            // direction = UIPageViewControllerNavigationDirectionForward;//从左往右
            direction = UIPageViewControllerNavigationDirectionReverse;  // 从右往左

        } else if (activeContentIndex < self.activeContentIndex) { // dian  左
            direction = UIPageViewControllerNavigationDirectionReverse;// 从右往左
        } else {
            direction = UIPageViewControllerNavigationDirectionForward;//从左往右
        }

        // 切换
        [self.pageViewController setViewControllers:@[ viewController ]
                                          direction:direction
                                           animated:YES
                                         completion:^(BOOL completed){// none
                                         }];
    }

    _activeContentIndex = activeContentIndex;
}

#pragma mark - 设置索引
- (void)selectTabAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return;
    }

    [self setActiveContentIndex:index];
}

#pragma mark - 根据索引 返回 滑块
- (UIView *)tabViewAtIndex:(NSUInteger)index
{
    return [self.tabs objectAtIndex:index];
}



- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= self.tabCount) {
        return nil;
    }

    return [self.contents objectAtIndex:index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController
{
    return [self.contents indexOfObject:viewController];
}

- (void)scrollWithDirection:(NSInteger)direction
{
    CGFloat buttonSize = [self.dataSource widthOfTabView];

    if (direction == 0) {
        UIView *firstView = [self.tabs objectAtIndex:0];
        [self.tabs removeObjectAtIndex:0];
        [self.tabs addObject:firstView];
    } else {
        UIView *lastView = [self.tabs lastObject];
        [self.tabs removeLastObject];
        [self.tabs insertObject:lastView atIndex:0];
    }

    NSUInteger index = 0;
    NSUInteger contentSizeWidth = 0;
    for (UIView *pageView in self.tabs) {

        CGRect frame = pageView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = buttonSize;
        pageView.frame = frame;

        contentSizeWidth += buttonSize;

        ++index;
    }

    if (direction == 0) {
        self.tabsView.contentOffset = CGPointMake(self.tabsView.contentOffset.x - buttonSize, 0);
    } else {
        self.tabsView.contentOffset = CGPointMake(self.tabsView.contentOffset.x + buttonSize, 0);
    }
}





- (void)scrollViewDidEndDirection:(NSNumber *)direction
{
    [self scrollWithDirection:[direction integerValue]];
}


@end
