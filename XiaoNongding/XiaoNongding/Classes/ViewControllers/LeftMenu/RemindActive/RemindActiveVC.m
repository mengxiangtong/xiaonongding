//
//  RemindActiveVC.m
//  XiaoNongding
//
//  Created by admin on 15/12/22.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "RemindActiveVC.h"

#import "PartInViewController.h"
#import "OverdueViewController.h"
#import "NewLoginViewController.h"

@interface RemindActiveVC ()< NKJPagerViewDataSource, NKJPagerViewDelegate>

@property (nonatomic, retain) UILabel * redHint;


@end

@implementation RemindActiveVC


+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static RemindActiveVC *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [RemindActiveVC new];
    });
    
    return _sharedManager;
}


- (UILabel *)redHint
{
    if (!_redHint) {
        _redHint = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2 -kDeviceWidth/10, 5, 16, 16)];
        _redHint.backgroundColor = RGBACOLOR(246, 80, 63, 1);
        _redHint.text = @"22";
        _redHint.font = [UIFont systemFontOfSize:12];
        _redHint.layer.masksToBounds = YES;
        _redHint.layer.cornerRadius = 8;
        _redHint.textAlignment = NSTextAlignmentCenter;
        _redHint.textColor = [UIColor whiteColor];
        
        CGFloat hintWith = [_redHint.text
                            boundingRectWithSize:CGSizeMake(40, 16)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}
                            context:nil
                            ].size.width ;
        
        _redHint.frame = CGRectMake(kDeviceWidth/2 -kDeviceWidth/10, 5, 8 + hintWith, 16);
        
    }
    return _redHint;
}


- (void)goDismiss :(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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



- (void)viewDidLoad {
    
    //设置代理
    self.dataSource = self;
    self.delegate = self;
    
    [super viewDidLoad];
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"活动提醒"];
    
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBarHidden = NO;

}


#pragma mark - NKJPagerViewDataSource  数据源代理

- (NSUInteger)numberOfTabView
{
    return 2;
}

- (UIView *)viewPager:(NKJPagerViewController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    //1 背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 44)];
    bgView.backgroundColor = kClassTabBgColor;
    
    //2 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 44)];
    [bgView addSubview:label];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 2015;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
    if (index == 0) {
        label.text = @" 参与的活动" ;
        label.frame = CGRectMake(20, 0, kDeviceWidth/2-20, 44);
        
     
    }
    if (index == 1) {
        label.text = @"已过期活动 " ;
        label.frame = CGRectMake(0, 0, kDeviceWidth/2-20, 44);
    }
    
    return bgView;
}

- (UIViewController *)viewPager:(NKJPagerViewController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{

    if (index == 0) {
        PartInViewController *vc = [PartInViewController shareInstance];
        return vc;
    }
    
    if (index == 1) {
        OverdueViewController *vc = [OverdueViewController shareInstance];
        return vc;
    }
    
    PartInViewController *vc = [PartInViewController shareInstance];
    return vc;
    
}


//滑块宽度
- (NSInteger)widthOfTabView
{
    return kDeviceWidth/2;
}

#pragma mark - NKJPagerViewDelegate  代理
//点击 滚动 都调用
- (void)viewPager:(NKJPagerViewController *)viewPager didSwitchAtIndex:(NSInteger)index withTabs:(NSArray *)tabs
{
    NSLog(@"    %d ", index );
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         for (UIView *view in self.tabs) {
                             
                             UILabel *label = (UILabel *)[view viewWithTag:2015];

                             if (index == view.tag) {
                                 //选中
                                 label.textColor = [UIColor whiteColor];
                                
                                 
                             } else {
                                 //非选中
                                label.textColor = RGBACOLOR(176, 176, 176, 1);
                               
                                 
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
