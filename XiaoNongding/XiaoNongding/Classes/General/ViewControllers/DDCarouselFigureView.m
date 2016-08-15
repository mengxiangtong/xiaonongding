//
//  DDCarouselFigureView.m
//  Demo_simple
//
//  Created by jion on 15/11/4.
//  Copyright © 2015年 rain. All rights reserved.
//

#import "DDCarouselFigureView.h"
#import "UIWebViewViewController.h"
#import "TodayViewController.h"
#import "HomeViewController.h"
#import "NewLoginViewController.h"

#define KOUNT 6
@interface DDCarouselFigureView()<UIScrollViewDelegate>

@property (nonatomic,weak) UIImageView *currentImageView;   // 当前imageView
@property (nonatomic,weak) UIImageView *nextImageView;      // 下一个imageView
@property (nonatomic,weak) UIImageView *preImageView;       //上一个imageView
@property (nonatomic,assign) BOOL isDragging;               //是否正在拖动
@property (nonatomic,retain)NSTimer *timer;                 //设置动画

@end
@implementation DDCarouselFigureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initWithPage];
    }
    return self;
}
-(void)initWithPage{
    UIScrollView *scrollView =[[UIScrollView alloc] init];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    scrollView.frame = CGRectMake(0, 0, width, height);
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    [self.scrollView setContentSize:CGSizeMake(width * _number, height)];
    //  设置隐藏横向条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //  设置自动分页
    self.scrollView.pagingEnabled = YES;
    //  设置代理
    self.scrollView.delegate = self;
    //  设置当前点
    self.scrollView.contentOffset = CGPointMake(width, 0);
    //  设置是否有边界
    self.scrollView.bounces = NO;
    //  初始化当前视图

    //  设置时钟动画 定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(update:) userInfo:nil repeats:YES];
    //  将定时器添加到主线程
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)update:(NSTimer *)timer{
    //定时移动
    
    if (_isDragging == YES) {
        return ;
    }
    CGPoint offSet = self.scrollView.contentOffset;
  
    
    if (offSet.x >= self.frame.size.width *(_photoList.count-1)) {
        offSet.x = -self.frame.size.width;
        //[self.scrollView setContentOffset:offSet animated:YES];
    }
    if (offSet.x<=0) {
        offSet.x+=self.frame.size.width;
    }else
        offSet.x +=self.frame.size.width;
    [self.scrollView setContentOffset:offSet animated:YES];
    
}
-(void)setPhotoList:(NSArray *)photoList{
    _photoList=photoList;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for (int i=0; i<_photoList.count; i++) {
        UIImageView *currentImageView =[[UIImageView alloc] init];
        currentImageView.tag=i;
        currentImageView.frame = CGRectMake(width*i, 0, width, height);
        currentImageView.userInteractionEnabled=YES;
  
        NSString *imageName =  [_photoList[i] objectForKey:@"merchant_theme_image"];
        if (imageName) {
            
            [currentImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@""]];
            
        }
        
        UITapGestureRecognizer *SinglePress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewADClicked:)];
        SinglePress.numberOfTapsRequired=1;
        [currentImageView addGestureRecognizer:SinglePress];
        
        
        [self.scrollView setContentSize:CGSizeMake(width * (i+1), height)];
        [_scrollView addSubview:currentImageView];
        
    }
    
}
#pragma mark - 点击广告跳转
-(void)viewADClicked:(UIGestureRecognizer *)gesture{
    //点击广告跳转
    UIImageView *currentImageView=(UIImageView *)gesture.view;

    NSString *url=[_photoList[currentImageView.tag] objectForKey:@"url"];
    if ([url  isEqualToString:@"01"]|[url isEqualToString:@"03"]) {
        [[HomeViewController shareInstance] setPageSelectedIndex:2];
        return;
    }
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.superVC presentViewController:nc animated:YES completion:nil];
        return;
    }
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    
    url=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",url,latitude,longitude,uid,token];
    UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
    [webview initUrlAndId:nil urlstr:url];
    [self.superVC.navigationController pushViewController:webview animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isDragging = YES;
}
//  停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isDragging = NO;

}




@end
