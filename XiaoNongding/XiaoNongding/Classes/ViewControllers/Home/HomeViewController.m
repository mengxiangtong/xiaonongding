//
//  DEMOHomeViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "HomeViewController.h"

#import "NKJPagerViewController.h"

#import "CustomNavigationController.h"
#import "TodayWebViewController.h"
#import "TodayViewController.h"
#import "FarmNewViewController.h"
#import "ActivityViewController.h"
#import "RecommendViewController.h"

#import "CitysViewController.h"
#import "SearchViewController.h"

#import "TodayFloatingLayersView.h"

#define kSlider_W  kDeviceWidth/4

#define kTopView_H  110



@interface HomeViewController ()< NKJPagerViewDataSource, NKJPagerViewDelegate>
{
    
    int index_Selected;//当前选中板块下标
    
    UIImageView *imageV;
}
@property (nonatomic, retain) TodayFloatingLayersView *floatView;

@property (retain, nonatomic) NSArray *catesArray;


@property (retain, nonatomic) UILabel *titleL;
@property (retain, nonatomic)  UIView * titleV;
@property (retain, nonatomic) UIImageView *imageOpenV ;
//@property (retain, nonatomic)  UILabel *cityLabel;

@end

@implementation HomeViewController

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static HomeViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [HomeViewController new];
    });
    
    return _sharedManager;
}
- (NSArray *)catesArray
{
    if (!_catesArray) {
        _catesArray = @[@"今日上新",@"精品推荐",@"农场推荐",@"最新活动"];
    }
    
    return _catesArray;
}




- (void)setDefaultNavigationView
{
    
    self.titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    // 标题
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 80, 30)];
    self.titleL.textColor = [UIColor whiteColor];
    self.titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.font = [UIFont boldSystemFontOfSize:18];
    self.titleL.text =@"今日上新";
    [self.titleV addSubview:_titleL];

    //城市
    kAPPALL.cityLabel = [[UILabel alloc] init];
    kAPPALL.cityLabel.text = @"青岛";
    kAPPALL.cityLabel.font= [UIFont systemFontOfSize:12];

    kAPPALL.cityLabel.textColor = [UIColor whiteColor];
    //自适应宽度
    CGFloat cityWith = [kAPPALL.cityLabel.text
                        boundingRectWithSize:CGSizeMake(200, 30)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                        context:nil
                        ].size.width ;
    
    kAPPALL.cityLabel.frame = CGRectMake( CGRectGetMaxX(_titleL.frame), 0, cityWith, 30) ;
    [self.titleV addSubview:kAPPALL.cityLabel];
    
    self.imageOpenV = [[UIImageView alloc] initWithFrame:CGRectMake( CGRectGetMaxX(kAPPALL.cityLabel.frame)+3, 7, 16, 16)];
    
    self.imageOpenV.image = [UIImage imageNamed:@"icon_open_large_disable.png"];
    [self.titleV addSubview:self.imageOpenV];
    
    //
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame =CGRectMake( CGRectGetMaxX(_titleL.frame), 0, 60, 30);
    [locationBtn addTarget:self action:@selector(selectCityAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleV addSubview:locationBtn];
    
    self.navigationItem.titleView = self.titleV;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"topbar_menu_normal.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(CustomNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goSearch)];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    
    
    
    
    

    
}
-(TodayFloatingLayersView*)floatView{
    if (!_floatView) {
        _floatView=[[TodayFloatingLayersView alloc]initWithTarget:self Frame:CGRectMake(10.0, KDeviceHeight-45.0-64.0, 100.0, 35.0)];
    }
    return _floatView;
}

- (void)goSearch
{
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}



#pragma mark - 城市选择
- (void)selectCityAction
{

    CitysViewController *vc = [[CitysViewController alloc] init];
    vc.currentCityString = kAPPALL.cityLabel.text;

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];

    [self presentViewController:nc animated:YES completion:^{  }];
    
    
    //2， (给下一级 属性赋值) block 赋值 即 block的实现
    vc.sendCityBlock = ^(NSString *str){
        kAPPALL.cityLabel.text = str;
        CGFloat cityWith = [kAPPALL.cityLabel.text
                            boundingRectWithSize:CGSizeMake(60, 30)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                            context:nil
                            ].size.width ;
        
        kAPPALL.cityLabel.frame = CGRectMake( CGRectGetMaxX(_titleL.frame), 0, cityWith, 30) ;
        self.imageOpenV.frame = CGRectMake(CGRectGetMaxX(kAPPALL.cityLabel.frame)+3, 7, 16, 16);
    };
}

- (void)viewDidLoad
{
    //设置代理
    self.dataSource = self;
    self.delegate = self;

    [super viewDidLoad];

    
    
    [self setDefaultNavigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
   // [self defaultSetUp];
    
    [self.view addSubview:self.floatView];
    [self.view bringSubviewToFront:_floatView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}


#pragma mark - NKJPagerViewDataSource  数据源代理

- (NSUInteger)numberOfTabView
{
    return self.catesArray.count;
}

- (UIView *)viewPager:(NKJPagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    //1 背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSlider_W, 44)];
    bgView.backgroundColor = kClassTabBgColor;
    if (index == 3) {
        CGFloat x = kDeviceWidth/4-34-10;
        if (kDeviceWidth < 321) {
            x = kDeviceWidth/4-34 -2;
        }
        UIImageView *newV = [[UIImageView alloc] initWithFrame:CGRectMake( x, 3, 34, 17)];
        newV.image = [UIImage imageNamed:@"new.png"];
        [bgView addSubview:newV];
    }
    //2 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSlider_W, 44)];
    label.backgroundColor = [UIColor clearColor];

    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    
    label.text = _catesArray[index] ;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 2015;
    label.textColor = [UIColor grayColor];
    [bgView addSubview:label];
    
    //3 底线
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 44-3.0, kSlider_W-30.0, 3.0)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    imageView.image = [SO_Convert createImageWithColor:[UIColor colorWithRed:70.0/255.0 green:193.0/255.0 blue:152.0/255.0 alpha:1.5]];
    imageView.tag = 2016;
    [imageView setHidden:YES];
    [bgView addSubview:imageView];
    
    return bgView;
}

- (UIViewController *)viewPager:(NKJPagerViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    index_Selected=0;
    
//    TodayViewController *vc = [TodayViewController shareInstance];
TodayWebViewController *vc = [[TodayWebViewController alloc]init];
    if (index == 1) {
        RecommendViewController *vc = [RecommendViewController shareInstance];
        return vc;
    }
    if (index == 2) {
        
//        FarmViewController *vc = [FarmViewController shareInstance];
        FarmNewViewController *vc=[[FarmNewViewController alloc]init];
        return vc;
    }
    if (index == 3) {
        ActivityViewController *vc = [ActivityViewController shareInstance];
        return vc;
    }

    return vc;
    
}


//滑块宽度
- (NSInteger)widthOfTabView
{
    return kSlider_W;
}

#pragma mark - NKJPagerViewDelegate  代理
//点击 滚动 都调用
- (void)viewPager:(NKJPagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs
{
    self.titleL.text = _catesArray[index];
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         for (UIView *view in self.tabs) {
                             
                             //选中
                             if (index == view.tag) {
                                 
                                 view.alpha = 1.0;
                                 
                                 UILabel *label = (UILabel *)[view viewWithTag:2015];
                                 label.textColor = [UIColor whiteColor];
                                 label.font = [UIFont systemFontOfSize:16.0];
                                 
                                 UIImageView *imgLine = (UIImageView *)[view viewWithTag:2016];
                                 [imgLine setHidden:NO];
                             } else {
                                 //非选中
                                 
                                 UILabel *label = (UILabel *)[view viewWithTag:2015];
                                 label.textColor = RGBACOLOR(176, 176, 176, 1);
                                
                                 label.font = [UIFont systemFontOfSize:15.0];
                                 UIImageView *imgLine = (UIImageView *)[view viewWithTag:2016];
                                 [imgLine setHidden:YES];
                             }
                         }
                     }
                     completion:^(BOOL finished){}
     ];
}


- (void)viewPagerDidAddContentView
{
        NSLog(@" 代理 viewPagerDidAddContentView   ");
    
}
-(void)setPageSelectedIndex:(int)index{
    [self upodateDefaultSetUp:index];
}


@end
