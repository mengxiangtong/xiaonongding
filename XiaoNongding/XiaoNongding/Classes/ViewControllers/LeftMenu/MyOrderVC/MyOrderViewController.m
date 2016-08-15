//
//  MyOrderViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "MyOrderViewController.h"
#import "CustomNavigationController.h"

#import "AllOrderViewController.h"
#import "NoPayViewController.h"
#import "NoReceiveViewController.h"
#import "NoAssessViewController.h"
#import "NoCompleteViewController.h"
@interface MyOrderViewController ()< NKJPagerViewDataSource, NKJPagerViewDelegate>

@property (nonatomic, retain) UILabel *redHint;
@property (nonatomic, retain) UILabel *label;


@end

@implementation MyOrderViewController


- (void)goDismiss :(id)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
    //
}


- (UIButton *)getBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}

- (UILabel *)redHint
{
    if (!_redHint) {
        _redHint = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/4-kDeviceWidth/16, 5, 16, 16)];
        _redHint.backgroundColor = RGBACOLOR(246, 80, 63, 1);
        _redHint.text = @"2";
        _redHint.font = [UIFont systemFontOfSize:12];
        _redHint.layer.masksToBounds = YES;
        _redHint.layer.cornerRadius = 8;
        _redHint.textAlignment = NSTextAlignmentCenter;
        _redHint.textColor = [UIColor whiteColor];
        
    }
    return _redHint;
}




- (void)viewDidLoad {
    
    //设置代理
    self.dataSource = self;
    self.delegate = self;
    
    [super viewDidLoad];
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"我的订单"];
    
    //左侧添加
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
    });

    // Do any additional setup after loading the view.
}





#pragma mark - NKJPagerViewDataSource  数据源代理

- (NSUInteger)numberOfTabView
{
    return 5;
}

- (UIView *)viewPager:(NKJPagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    //1 背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/4, 44)];
    bgView.backgroundColor = kClassTabBgColor;
    
    //2 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/4, 44)];
    [bgView addSubview:label];
 
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 2015;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16.0];
    
    if (index == 0) {
        label.text = @"全部" ;
    }
    else if (index == 1) {
        label.text = @"待付款" ;
    }
    else if (index == 2) {
        label.text = @"待收货" ;
    }
    else if (index == 3) {
        label.text = @"待评价" ;
    }
    else if (index == 4) {
        label.text = @"已完成" ;
    }
    
    //3 底线
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.0, 44-3.0, kDeviceWidth/4-30.0, 3.0)];
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
    if (index == 0) {
        AllOrderViewController *vc = [[AllOrderViewController alloc] init];
        return vc;
    }
    
    else if (index == 1) {
        NoPayViewController *vc = [[NoPayViewController alloc] init];
        return vc;
    }
    
    else if (index == 2) {
        NoReceiveViewController *vc = [[NoReceiveViewController alloc] init];
        return vc;
    }
    else if (index == 3) {
        NoAssessViewController *vc = [[NoAssessViewController alloc] init];
        return vc;
    }
    else if (index == 4) {
        NoCompleteViewController *vc = [[NoCompleteViewController alloc] init];
        return vc;
    }

    AllOrderViewController *vc = [[AllOrderViewController alloc] init];
    return vc;
    
}


//滑块宽度
- (NSInteger)widthOfTabView
{
    return kDeviceWidth/4;
}

#pragma mark - NKJPagerViewDelegate  代理
//点击 滚动 都调用
- (void)viewPager:(NKJPagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs
{
    
    NSLog(@"    %lu ", index );
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         for (UIView *view in self.tabs) {
                             
                             //选中
                             if (index == view.tag) {
                                 
                                 view.alpha = 1.0;
                                 
                                 UILabel *label = (UILabel *)[view viewWithTag:2015];
                                 label.textColor = [UIColor whiteColor];
                                 
                                 [self setActiveContentIndex:index];
                                 
                                 UIImageView *imgLine = (UIImageView *)[view viewWithTag:2016];
                                 [imgLine setHidden:NO];
                             } else {
                                 //非选中
                                 UILabel *label = (UILabel *)[view viewWithTag:2015];
                                 label.textColor = RGBACOLOR(176, 176, 176, 1);
                                 
                                 
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






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
