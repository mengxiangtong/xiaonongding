//
//  UIShareUMCustomView.m
//  XiaoNongding
//
//  Created by jion on 16/3/25.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UIShareUMCustomView.h"
@interface UIShareUMCustomView ()
@property (nonatomic,retain) UIButton *btn_back;
@property (nonatomic,retain) UIButton *view_QQ;
@property (nonatomic,retain) UIButton *view_wchat;
@property (nonatomic,retain) UIButton *view_wchatQuan;
@property (nonatomic,retain) UIButton *view_QQZone;
@property (nonatomic,retain) UIButton *view_Weibo;
@property (nonatomic,retain) UIButton *view_Nil;

@end
@implementation UIShareUMCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=kCellLineColor;
        [self addSubview:self.view_QQ];
        [self addSubview:self.view_wchat];
        [self addSubview:self.view_wchatQuan];
        [self addSubview:self.view_QQZone];
        [self addSubview:self.view_Weibo];
        [self addSubview:self.view_Nil];
    }
    return self;
}




-(void)setTarget:(UIViewController *)target{
    _target=target;
    
}
-(UIView *)view_Bg{
    if (!_view_Bg) {
        _view_Bg =[[UIView alloc]initWithFrame:_target.view.bounds];
        [_view_Bg setBackgroundColor:[UIColor blackColor]];
        _view_Bg.alpha=0.55;
        _view_Bg.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleAction:)];
        [_view_Bg addGestureRecognizer:gesture];
        [_view_Bg setHidden:YES];
        [self.target.view addSubview:_view_Bg];
        [self.target.view bringSubviewToFront:self];
    }
    return _view_Bg;
}
-(void)singleAction:(UITapGestureRecognizer *)gesture{

    if ([self.delegate respondsToSelector:@selector(setInfoViewFrame:)]) {
        [self.delegate setInfoViewFrame:YES];
    }
}

-(UIButton *)view_QQ{
    if (!_view_QQ) {
        _view_QQ=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, (self.width-2.0)/3.0, (self.width-2.0)/3.0)];
        _view_QQ.tag=1;
        [_view_QQ setBackgroundColor:[UIColor whiteColor]];
        [_view_QQ setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_QQ setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_QQ.frame.size.width-100.0)/2.0, (_view_QQ.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_qq"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"QQ好友" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -22.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_QQ addSubview:btn_icon];
        [_view_QQ addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_QQ;
}
-(UIButton *)view_wchat{
    if (!_view_wchat) {
        _view_wchat=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_QQ.frame)+1.0, 0.0, (self.width-2.0)/3.0, (self.width-2.0)/3.0)];
        _view_wchat.tag=2;
        [_view_wchat setBackgroundColor:[UIColor whiteColor]];
        [_view_wchat setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_wchat setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_wchat.frame.size.width-100.0)/2.0, (_view_wchat.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_wchat"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"微信好友" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -25.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_wchat addSubview:btn_icon];
        [_view_wchat addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_wchat;
}
-(UIButton *)view_wchatQuan{
    if (!_view_wchatQuan) {
        _view_wchatQuan=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_wchat.frame)+1.0, 0.0, (self.width-2.0)/3.0, (self.width-2.0)/3.0)];
        _view_wchatQuan.tag=3;
        [_view_wchatQuan setBackgroundColor:[UIColor whiteColor]];
        [_view_wchatQuan setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_wchatQuan setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_wchatQuan.frame.size.width-100.0)/2.0, (_view_wchatQuan.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_pengyouquan"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"朋友圈" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -22.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_wchatQuan addSubview:btn_icon];
        [_view_wchatQuan addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_wchatQuan;
}
-(UIButton *)view_QQZone{
    if (!_view_QQZone) {
        _view_QQZone=[[UIButton alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.view_wchatQuan.frame)+1.0, (self.width-2.0)/3.0, (self.width-2.0)/3.0)];
        _view_QQZone.tag=4;
        [_view_QQZone setBackgroundColor:[UIColor whiteColor]];
        [_view_QQZone setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_QQZone setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_QQZone.frame.size.width-100.0)/2.0, (_view_QQZone.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_qqzone"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"QQ空间" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -22.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_QQZone addSubview:btn_icon];
        [_view_QQZone addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_QQZone;
}
-(UIButton *)view_Weibo{
    if (!_view_Weibo) {
        _view_Weibo=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_QQZone.frame)+1.0, CGRectGetMaxY(self.view_wchatQuan.frame)+1.0, (self.width-2.0)/3.0, (self.width-2.0)/3.0)];
        _view_Weibo.tag=5;
        [_view_Weibo setBackgroundColor:[UIColor whiteColor]];
        [_view_Weibo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_Weibo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        //        [_view_Weibo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_Weibo.frame.size.width-100.0)/2.0, (_view_Weibo.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_weibo"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"新浪微博" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -25.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 35.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        //        [_view_Weibo addSubview:btn_icon];
        //        [_view_Weibo addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_Weibo;
}
-(UIButton *)view_Nil{
    if (!_view_Nil) {
        _view_Nil=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_Weibo.frame)+1.0, CGRectGetMaxY(self.view_wchatQuan.frame)+1.0, (self.width-2.0)/3.0, (self.width-2.0)/3.0)];
        [_view_Nil setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _view_Nil;
}
-(void)ShareAction:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(ShareAction:)])
    {
        //发送委托方法，方法的参数为用户的输入
        [self.delegate ShareAction:(int)sender.tag];
    }
}


@end
