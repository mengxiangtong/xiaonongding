//
//  CouponView.m
//  XiaoNongding
//
//  Created by jion on 16/3/18.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "CouponView.h"

@implementation CouponView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        
        UIView *view1=[[[NSBundle mainBundle ] loadNibNamed:@"CouponView" owner:nil options:nil] firstObject];
        view1.frame=(CGRect){10.0,0.0,frame.size.width-20.0,820.0};
     
        
        _lb_productName=(UILabel *)[view1 viewWithTag:1];
        _lb_Price=(UILabel *)[view1 viewWithTag:2];
        _lb_ProductTitle=(UILabel *)[view1 viewWithTag:4];
        _lb_ProductpatTime=(UILabel *)[view1 viewWithTag:5];
        _img_Product=(UIImageView*)[view1 viewWithTag:3];
        _img_QRCode=(UIImageView *)[view1 viewWithTag:6];
        _lb_ProductCode=(UILabel *)[view1 viewWithTag:7];
        _lb_OrderCode=(UILabel *)[view1 viewWithTag:8];
        _lb_OrderDate=(UILabel *)[view1 viewWithTag:9];
        _lb_OrderPhone=(UILabel *)[view1 viewWithTag:10];
        _lb_OrderNo=(UILabel *)[view1 viewWithTag:11];
        _Lb_payType=(UILabel *)[view1 viewWithTag:12];
        _lb_OrderPayTime=(UILabel *)[view1 viewWithTag:13];
        _lb_OrderPayMoney=(UILabel *)[view1 viewWithTag:14];
        _img_icons=(UIImageView *)[view1 viewWithTag:19];
        [_img_icons.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_img_icons.layer setCornerRadius:4.0];
        [_img_icons.layer setBorderWidth:2.0];
        [_img_icons.layer setMasksToBounds:YES];
        
        
        [self.scrollView addSubview:view1];
        
        [self addSubview:self.scrollView];
        [self.scrollView setContentSize:CGSizeMake(frame.size.width, 964.0)];
    }
    return self;
}
-(UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:self.bgimgView];
        [_scrollView setBounces:NO];
    }
    return _scrollView;
}
-(UIImageView *)bgimgView{
    if (!_bgimgView) {
        _bgimgView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 900.0)];
        [_bgimgView setImage:[UIImage imageNamed:@"LastMinute_TitleBar_max"]];
    }
    return _bgimgView;
}


@end
