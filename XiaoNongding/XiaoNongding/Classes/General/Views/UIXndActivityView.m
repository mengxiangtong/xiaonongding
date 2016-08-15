//
//  UIXndActivityView.m
//  XiaoNongding
//
//  Created by jion on 16/3/21.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UIXndActivityView.h"
@interface UIXndActivityView ()
@property (nonatomic, retain) UIImageView* img_activity;
@property (nonatomic, retain) UIImageView* img_bg;
@property (nonatomic, retain) NSTimer *timer;
@end
@implementation UIXndActivityView{
    int timerRepeats;
}

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
//        [self setBackgroundColor:[UIColor grayColor]];
        [self addSubview:self.img_activity];
        [self addSubview:self.img_bg];
        [self setHidden:YES ];
    }
    return self;
}
-(UIImageView *)img_activity{
    if (!_img_activity) {
        _img_activity=[[UIImageView alloc]initWithFrame:self.bounds];
        [_img_activity setImage:[UIImage imageNamed:@"椭圆圈圈.png"]];
   
    }
    return _img_activity;
    
}
-(UIImageView *)img_bg{
    if (!_img_bg) {
        _img_bg=[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, self.frame.size.width-20.0, self.frame.size.height-20.0)];
        [_img_bg setImage:[UIImage imageNamed:@"iconfont-leaf.png"]];
    }
    return _img_bg;
}

-(void)startAnimation{
    [self stopAnimation];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: 360.0 ];
    rotationAnimation.duration = 80;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1000000000000;
    
    [self.img_activity.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [self setHidden:NO];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1000.0 target:self selector:@selector(timerView) userInfo:self repeats:YES];
    timerRepeats=0;
}
-(void)stopAnimation{
    
    [self.img_activity.layer removeAllAnimations];
    [self setHidden:YES];
    
    if (_timer) {
        if (timerRepeats>0) {
            [_timer invalidate];
        }
    }
    _timer=nil;
    timerRepeats=0;
}
-(void)timerView{
    timerRepeats++;
    if (timerRepeats>=8) {
        [self stopAnimation];
    }
    
}
@end
