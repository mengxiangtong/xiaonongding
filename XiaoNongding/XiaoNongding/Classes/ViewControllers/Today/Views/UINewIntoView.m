//
//  UINewIntoTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/1/11.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UINewIntoView.h"
#import "UIWebViewViewController.h"
#import "TodayViewController.h"
#import "NewLoginViewController.h"


@implementation UINewIntoView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addAllViews];
    }
    return self;
}


#pragma mark - 添加所有视图元素
- (void)addAllViews
{
    
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 50.0)];
    [imgview setImage:[UIImage imageNamed:@"label01"]];
    
    [self.contentView addSubview:imgview];
    
    _img1=[[UIImageView alloc]initWithFrame:CGRectMake(10.0, 50.0, (kDeviceWidth-40.0)/3.0, (kDeviceWidth-40.0)/3.0-20.0)];
    [_img1 sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@""]];
    [self.img1 setUserInteractionEnabled:YES];
    [self.contentView addSubview:_img1];
    
    
    _img2=[[UIImageView alloc]initWithFrame:CGRectMake(20.0+(kDeviceWidth-40.0)/3.0, 50.0, (kDeviceWidth-40.0)/3.0, (kDeviceWidth-40.0)/3.0-20.0)];
    [_img2 sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@""]];
    [self.img2 setUserInteractionEnabled:YES];
    [self.contentView addSubview:_img2];
    
    _img3=[[UIImageView alloc]initWithFrame:CGRectMake(30.0+(kDeviceWidth-40.0)/3.0*2.0, 50.0, (kDeviceWidth-40.0)/3.0, (kDeviceWidth-40.0)/3.0-20.0)];
    [_img3 sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@""]];
    [self.img3 setUserInteractionEnabled:YES];
    [self.contentView addSubview:_img3];
    
    UIImageView *imgview3=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 50.0+(kDeviceWidth-40.0)/3.0, kDeviceWidth, 35.0)];
    [imgview3 setImage:[UIImage imageNamed:@"label_jingpin"]];
    [self.contentView addSubview:imgview3];
    
    
    UITapGestureRecognizer *tapRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    UITapGestureRecognizer *tapRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    UITapGestureRecognizer *tapRecognizer3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    
    [self.img1 addGestureRecognizer:tapRecognizer1];
    [self.img2 addGestureRecognizer:tapRecognizer2];
    [self.img3 addGestureRecognizer:tapRecognizer3];
    
}
-(void)setPList:(NSArray *)pList{
    _pList=pList;
    [_caro setPhotoList:pList];

    if (_pList &&_pList.count>0) {

        if (_pList.count>0) {
            NSURL *url=[NSURL URLWithString:[_pList[0] objectForKey:@"merchant_theme_image"]];
            [_img1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        if (_pList.count>1) {
            NSURL *url=[NSURL URLWithString:[_pList[1] objectForKey:@"merchant_theme_image"]];
            [_img2 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        if (_pList.count>2) {
            NSURL *url=[NSURL URLWithString:[_pList[2] objectForKey:@"merchant_theme_image"]];
            [_img3 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        }
        
    }
}


-(void)tapRecognizer_Action:(UIGestureRecognizer *)recognizer{
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
//        NewLoginViewController *vc = [NewLoginViewController shareInstance];
//        [[TodayViewController shareInstance].navigationController pushViewController:vc animated:YES];
        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[TodayViewController shareInstance] presentViewController:nc animated:YES completion:nil];
        return;
    }
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    
    if (self.pList && self.pList.count>0) {
        NSString *url=nil;
        if ([recognizer.view  isEqual:self.img1]) {
            url=[_pList[0] objectForKey:@"url"];
        }else if([recognizer.view isEqual:self.img2]){
            url=[_pList[1] objectForKey:@"url"];
        }else if([recognizer.view isEqual:self.img3]){
            url=[_pList[2] objectForKey:@"url"];
        }
        url=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",url,latitude,longitude,uid,token];
        
        UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
        [webview initUrlAndId:nil urlstr:url];
        [[TodayViewController shareInstance].navigationController pushViewController:webview animated:YES];
        
    }
    
}


@end
