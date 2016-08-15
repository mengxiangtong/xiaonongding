//
//  WelcomeViewController.m
//  USAENet
//
//  Created by join on 15/11/23.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "WelcomeViewController.h"

#import "REFrostedViewController.h"
#import "CustomNavigationController.h"
#import "HomeViewController.h"
#import "LeftMenuViewController.h"

@interface WelcomeViewController ()
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UIView *view_Bg1;
@property (nonatomic,retain) UIView *view_Bg2;
@property (nonatomic,retain) UIView *view_Bg3;
@property (nonatomic,retain) UIView *view_Bg4;
@property (nonatomic,retain) UIView *view_Bg5;

@property (nonatomic,retain) UIImageView *img_1;
@property (nonatomic,retain) UIImageView *img_2;
@property (nonatomic,retain) UIImageView *img_3;
@property (nonatomic,retain) UIImageView *img_4;
@property (nonatomic,retain) UIImageView *img_5;

@property (nonatomic, retain) UIButton *btn_goHome;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    
    NSLog(@"WelcomeViewController  viewDidLoad ");
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self initWithPage];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWithPage{
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrollView];
    
    
    _img_1=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
    _img_2=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0.0, kDeviceWidth, KDeviceHeight)];
    _img_3=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*2.0, 0.0, kDeviceWidth,KDeviceHeight)];
    _img_4=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*3.0, 0.0, kDeviceWidth,KDeviceHeight)];
    _img_5=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth*4.0, 0.0, kDeviceWidth,KDeviceHeight)];
    
    
    [_img_1 setImage:[UIImage imageNamed:@"welcome_01.png"]];
    [_img_2 setImage:[UIImage imageNamed:@"welcome_02.png"]];
    [_img_3 setImage:[UIImage imageNamed:@"welcome_03.png"]];
    [_img_4 setImage:[UIImage imageNamed:@"welcome_04.png"]];
    [_img_5 setImage:[UIImage imageNamed:@"welcome_05.png"]];
    [_scrollView addSubview:_img_1];
    [_scrollView addSubview:_img_2];
    [_scrollView addSubview:_img_3];
    [_scrollView addSubview:_img_4];
    [_scrollView addSubview:_img_5];
    float widthVal=(kDeviceWidth-100.0)*(320.0/kDeviceWidth);
    NSLog(@"============%f",KDeviceHeight);
    float yVal=KDeviceHeight-(130.0*KDeviceHeight/480.0);
    _btn_goHome=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth*4.0+(kDeviceWidth-widthVal)/2.0, yVal, widthVal, 40.0)];
    [_btn_goHome setBackgroundImage:[UIImage imageNamed:@"welcome_btn2.png"] forState:UIControlStateNormal];
    
    [_btn_goHome addTarget:self action:@selector(btn_Start:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_btn_goHome];
    
    
    _scrollView.contentSize=CGSizeMake(kDeviceWidth*5.0, KDeviceHeight);
    
}

#pragma mark - 开始程序
-(void)btn_Start:(UIButton *)swender{
    CustomNavigationController *navigationController = [[CustomNavigationController alloc] initWithRootViewController:[HomeViewController shareInstance]];
    
    
    LeftMenuViewController *menuController = [[LeftMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    //
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;//模糊风格
    
    
    
    // Make it a root controller
    //
    kAPPALL.window.rootViewController = frostedViewController;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KIsFirst];
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
