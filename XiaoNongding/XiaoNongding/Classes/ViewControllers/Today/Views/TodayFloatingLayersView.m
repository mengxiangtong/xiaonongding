//
//  TodayFloatingLayersView.m
//  XiaoNongding
//
//  Created by jion on 16/3/22.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "TodayFloatingLayersView.h"
#import "UIWebViewViewController.h"
#import "MyCollectionVC.h"
@interface TodayFloatingLayersView()
@property (nonatomic, retain) UIViewController * superVC;
@end
@implementation TodayFloatingLayersView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTarget:(UIViewController*)supervc Frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.superVC=supervc;
        [self setBackgroundColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0]];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];
        [self setAlpha:0.8];
        [self initwithPage];
    }
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0]];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];
        [self setAlpha:0.8];
        [self initwithPage];
    }
    return self;
}
-(void)initwithPage{
    self.btn_care=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, self.width/2.0-1.0, self.height)];
    [self.btn_care setImage:[UIImage imageNamed:@"bottombar_collect.png"] forState:UIControlStateNormal];
    [self.btn_care setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [self.btn_care setBackgroundImage:[SO_Convert createImageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
    [self.btn_care setImageEdgeInsets:UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0)];
    [self.btn_care addTarget:self action:@selector(btn_careAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn_shopCar=[[UIButton alloc]initWithFrame:CGRectMake(self.width/2.0+0.5, 0.0, self.width/2.0-1.0, self.height)];
    [self.btn_shopCar setImage:[UIImage imageNamed:@"bottom_shopcar.png"] forState:UIControlStateNormal];
    [self.btn_shopCar setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [self.btn_shopCar setBackgroundImage:[SO_Convert createImageWithColor:[UIColor blackColor]] forState:UIControlStateHighlighted];
    [self.btn_shopCar setImageEdgeInsets:UIEdgeInsetsMake(8.0, 15.0, 8.0, 15.0)];
    [self.btn_shopCar addTarget:self action:@selector(btn_shopCarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lb_line=[[UIView alloc]initWithFrame:CGRectMake(self.width/2.0-0.5, 8.0, 1.0, self.height-16.0)];
    [lb_line setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
    
    [self addSubview:self.btn_care];
    [self addSubview:self.btn_shopCar];
    [self addSubview:lb_line];
    
}

-(void)btn_shopCarAction:(UIButton *)sender{
    UIWebViewViewController *webview=[[UIWebViewViewController alloc]init];
    [webview setUrlStr:@""];
    [_superVC.navigationController pushViewController:webview animated:YES];
}
-(void)btn_careAction:(UIButton *)sender{
    MyCollectionVC *careVC=[[MyCollectionVC alloc] init];
    
    [_superVC presentViewController:[[UINavigationController alloc]initWithRootViewController:careVC] animated:YES completion:nil];
}


@end
