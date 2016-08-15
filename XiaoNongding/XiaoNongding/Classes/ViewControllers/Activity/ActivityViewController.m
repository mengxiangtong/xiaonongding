//
//  ActivityViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/12.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "ActivityViewController.h"
#import "MJRefresh.h"
#import "ActivityTableViewCell.h"
#import "UIWebViewViewController.h"
#import "NewLoginViewController.h"
#import "ActivityContentViewController.h"
#import "CycleScrollView.h"

#define arryguan @[@{@"name":@"采摘",@"pinyin":@"picking",@"image":@"组_12.png",@"type":@"50"},@{@"name":@"钓鱼",@"pinyin":@"fishing",@"image":@"组_13.png",@"type":@"49"},@{@"name":@"烧烤",@"pinyin":@"barbecue",@"image":@"组_14.png",@"type":@"51"},@{@"name":@"种菜",@"pinyin":@"Vegetables",@"image":@"组_16.png",@"type":@"54"},@{@"name":@"农家宴",@"pinyin":@"farm feast",@"image":@"组_17.png",@"type":@"55"},@{@"name":@"更多" ,@"pinyin":@"more",@"image":@"组_18.png",@"type":@""}]

@interface ActivityViewController ()< UITableViewDataSource, UITableViewDelegate  >


@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *ActivityDataArray;
//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView;

@property (nonatomic, retain) UIButton *view_zone1;

@property (nonatomic , retain) CycleScrollView *mainScorllView;

@end

@implementation ActivityViewController{
    int pageIndexA;
    NSMutableArray* viewsArray;
    NSMutableArray* Array;
}

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static ActivityViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ActivityViewController new];
    });
    
    return _sharedManager;
}
-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndexA=1;
    NSLog(@" 活动  viewDidLoad   ");
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-64-44) style:UITableViewStylePlain] ;
    _tableView.showsVerticalScrollIndicator = NO;
    //UITableViewStyleGrouped  UITableViewStylePlain
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = KScrollViewBackGroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_tableView setTableHeaderView:[self tableHeadView]];
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ActivityTableViewCell class] forCellReuseIdentifier:KActivityTableViewCell];
    
    
    __weak typeof(self) weakself = self;
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        pageIndexA=1;
        [weakself loadActivityData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    weakself.tableView.header.autoChangeAlpha = YES;
    
    // 上拉刷新
    weakself.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadActivityData];
        
    }];
    
    [self.view addSubview:self.activityView];
    [self.activityView startAnimation];
    
    
    // 注册自定义cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"activecelll"];

    // Do any additional setup after loading the view.
}
-(UIView *)tableHeadView{
    UIView *viewbg=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth-0.0, 335.0)];
    [viewbg setBackgroundColor:KScrollViewBackGroundColor];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 130.0)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:@"http://www.xiaonongding.com/tpl/Static/weizan/images/xnd_img/banner01.png" ] placeholderImage:[UIImage  imageNamed:@"1.jpg"]];
    [viewbg addSubview:imgView];
    
    _view_zone1=[[UIButton alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(imgView.frame), kDeviceWidth, 40.0)];
    [_view_zone1 setBackgroundColor:[UIColor whiteColor]];
    [viewbg addSubview:_view_zone1];
    
    UILabel *lb_new=[[UILabel alloc]initWithFrame:CGRectMake(10.0, 10.0, 40.0, 20.0)];
    [lb_new setBackgroundColor:[UIColor colorWithRed:234.0/255.0 green:13.0/255.0 blue:10.0/255.0 alpha:1.0]];
    [lb_new setText:@"最新"];
    [lb_new setTextAlignment:NSTextAlignmentCenter];
    [lb_new setTextColor:[UIColor whiteColor]];
    [lb_new setFont: [UIFont systemFontOfSize:13.0]];
    [lb_new.layer setCornerRadius:5.0];
    [lb_new.layer setMasksToBounds:YES];
    [_view_zone1 addSubview:lb_new];
  
    [self loadNewActivitydata];
    
    UILabel *lb_more=[[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-50.0, 10.0, 50.0, 20.0)];
    [lb_more setText:@"更多>"];
    [lb_more setTextColor:[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0]];
    [lb_more setFont: [UIFont systemFontOfSize:15.0]];
    lb_more.userInteractionEnabled=YES;
    [lb_more addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ScrollViewScrollToBottom:)]];
    [_view_zone1 addSubview:lb_more];
    
    
    /**
     * 又一个
     */
    UIView *view_zone2=[[UIView alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(_view_zone1.frame)+10.0, kDeviceWidth, 125.0)];
    [view_zone2 setBackgroundColor:[UIColor whiteColor]];
    float jiange=(kDeviceWidth-(100.0*3.0))/4.0;
    float y=15.0;
    int indexs=0;
    
    
    for (int j=0; j<2; j++) {
        if (j==1) y=75.0;
        
        for (int i=0; i<3; i++) {
            float x=i*100.0+(i+1)*jiange;
            UIImageView *imgAvatar1=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, 35.0, 35.0)];
            imgAvatar1.backgroundColor=KScrollViewBackGroundColor;
            [imgAvatar1 setImage:[UIImage imageNamed:[arryguan [indexs] objectForKey:@"image"]]];
            [imgAvatar1.layer setMasksToBounds:YES];
            [imgAvatar1.layer setCornerRadius:17.5];
            [imgAvatar1 setUserInteractionEnabled:YES];
            [imgAvatar1 setTag:indexs];
            [view_zone2 addSubview:imgAvatar1];
            UILabel *lb_name1=[[UILabel alloc]initWithFrame:CGRectMake(x+45.0, y+4.0, 50, 16)];
            [lb_name1 setText:[arryguan [indexs] objectForKey:@"name"]];
            [lb_name1 setFont: [UIFont boldSystemFontOfSize:15.0]];
            [lb_name1 setUserInteractionEnabled:YES];
            [lb_name1 setTag:indexs];
            [view_zone2 addSubview:lb_name1];
            
            UILabel *lb_name2=[[UILabel alloc]initWithFrame:CGRectMake(x+46.0, y+22.0, 70, 15)];
            [lb_name2 setText:[arryguan [indexs] objectForKey:@"pinyin"]];
            [lb_name2 setFont: [UIFont systemFontOfSize:12.0]];
            [lb_name2 setTextColor:kCellLineColor];
            [lb_name2 setUserInteractionEnabled:YES];
            [lb_name2 setTag:indexs];
            [view_zone2 addSubview:lb_name2];
            indexs++;
            
            [imgAvatar1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single_Action:)]];
            [lb_name1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single_Action:)]];
            [lb_name2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single_Action:)]];
        }
    }
    
    
    
    [viewbg addSubview:view_zone2];
    
    
    UILabel *lb_tuijian=[[UILabel alloc]initWithFrame:CGRectMake((kDeviceWidth-60.0)/2.0, CGRectGetMaxY(view_zone2.frame), 60.0, 30.0)];
    [lb_tuijian setTextColor:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1.0]];
    [lb_tuijian setText:@"推荐活动"];
    [lb_tuijian setFont:[UIFont systemFontOfSize:15.0]];
    [viewbg addSubview:lb_tuijian];
    
    UIView *viewLineLeft=[[UIView alloc]initWithFrame:CGRectMake(10.0, CGRectGetMaxY(view_zone2.frame)+15.0, (kDeviceWidth-lb_tuijian.width)/2.0-20.0, 1.0)];
    [viewLineLeft setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
    
    UIView *viewLineRight=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lb_tuijian.frame)+10.0, CGRectGetMaxY(view_zone2.frame)+15.0, (kDeviceWidth-lb_tuijian.width)/2.0-20.0, 1.0)];
    [viewLineRight setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
    
    [viewbg addSubview:viewLineLeft];
    [viewbg addSubview:viewLineRight];
    
    
    
    
    return viewbg;
}
-(void)single_Action:(UITapGestureRecognizer *)gest{
    
    NSString *str_type=[arryguan[[gest view].tag] objectForKey:@"type" ];
    NSString *str_title=[arryguan[[gest view].tag] objectForKey:@"name" ];
    if (str_type) {
        [[ActivityContentViewController shareInstance] setStr_type:str_type];
        [[ActivityContentViewController shareInstance] setStr_Title:[NSString stringWithFormat:@"活动列表－%@",str_title ]];
        [self.navigationController pushViewController: [ActivityContentViewController shareInstance] animated:YES ];
    }
    

}
-(void)LabelSingleAction:(UITapGestureRecognizer *)gest{

    NSDictionary* item= Array[gest.view.tag];
    if (item) {
        NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
        NSString *latitude=[dicInfo objectForKey:@"latitude"];
        NSString *longitude=[dicInfo objectForKey:@"longitude"];
        
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            NewLoginViewController *vc = [NewLoginViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            return;
        }
        NSString *uid=[dic_userInfo objectForKey:@"uid"];
        NSString *token=[dic_userInfo objectForKey:@"token"];
        NSString *url=[item objectForKey:@"url"];
        url=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",url,latitude,longitude,uid,token];
        
        UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
        [webview initUrlAndId:nil urlstr:url];
        
        [[ActivityViewController shareInstance].navigationController pushViewController:webview animated:YES];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@" 活动  viewWillAppear   ");
    [self.activityView startAnimation];
    [self loadNewActivitydata];
      pageIndexA=1;
    [self loadActivityData];
}

//加载活动
-(void)loadActivityData{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: KActivity_List_URL,pageIndexA ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block ActivityViewController *weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            [self.activityView stopAnimation];
        });
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    if(dict.count>0){
                        if (pageIndexA==1) {
                            weakSelf.ActivityDataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                        }else{
                            [weakSelf.ActivityDataArray addObjectsFromArray:[dict objectForKey:@"msg"]];
                        }
                        pageIndexA++;
                    }
                    
                }
                
                //更新页面
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                    
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];
}
//加载最新活动
-(void)loadNewActivitydata{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: KActivity_getNewestActivity_URL ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block ActivityViewController *weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.header endRefreshing];
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.activityView stopAnimation];
        });
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                
                if (status==1) {
                    if(dict.count>0){
                        if (pageIndexA==1) {
                           Array=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                        }
                      
                    }
                }
                
                //更新页面
                dispatch_async(dispatch_get_main_queue(), ^{
                    viewsArray=nil;
                    viewsArray=[[NSMutableArray alloc]init];
                    for (int i=0; i<Array.count; i++) {
                        UILabel *lb_content=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth-105.0, 20.0)];
                        [lb_content setText:[Array[i] objectForKey:@"product_name" ]];
                        [lb_content setFont: [UIFont systemFontOfSize:14.0]];
                        lb_content.tag=i;
                        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LabelSingleAction:)];
                        [lb_content addGestureRecognizer:singleTap];
                         [viewsArray addObject:lb_content];
                    }
                    if (!self.mainScorllView) {
                         weakSelf.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(55.0, 10.0, kDeviceWidth-105.0, 20.0) animationDuration:3.0];
                        [ _view_zone1 addSubview:self.mainScorllView];
                    }
                    
                    weakSelf.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                        return [viewsArray objectAtIndex:pageIndex];
                    };
                    weakSelf.mainScorllView.totalPagesCount = ^NSInteger(void){
                        return Array.count;
                    };
                    
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];
}
#pragma mark - UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float imgWidth=(kDeviceWidth-20)/7.0*4.0;
    float imgHeight=imgWidth/4.0*2.8;
    return  imgHeight+10.0 ;
}
//Header 高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    return v;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.ActivityDataArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KActivityTableViewCell forIndexPath:indexPath];
    if (indexPath.row<self.ActivityDataArray.count) {
        NSDictionary* item= self.ActivityDataArray[indexPath.row];
        [cell setItem_Activity:[item copy]];
    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* item= self.ActivityDataArray[indexPath.row];
    if (item) {
        NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
        NSString *latitude=[dicInfo objectForKey:@"latitude"];
        NSString *longitude=[dicInfo objectForKey:@"longitude"];
        
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            NewLoginViewController *vc = [NewLoginViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            return;
        }
        NSString *uid=[dic_userInfo objectForKey:@"uid"];
        NSString *token=[dic_userInfo objectForKey:@"token"];
        NSString *url=[item objectForKey:@"url"];
        url=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",url,latitude,longitude,uid,token];
        
        UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
        [webview initUrlAndId:nil urlstr:url];
        
        [[ActivityViewController shareInstance].navigationController pushViewController:webview animated:YES];
    }

}

#pragma mark -
-(void)ScrollViewScrollToBottom:(UITapGestureRecognizer *)Gesture{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - 实现改变导航栏的颜色等功能

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    UIView *view = self.navigationController.navigationBar.subviews[0];
    
    if (_tableView.contentOffset.y <= 0) {
        self.navigationController.navigationBar.translucent = YES;
        view.alpha = 0;
    } else if (_tableView.contentOffset.y > 0 && _tableView.contentOffset.y <= 136) {
        
        view.alpha = _tableView.contentOffset.y / 200.0f;
    } else if (_tableView.contentOffset.y > 136) {
        
        view.alpha = 1;
    }
    
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
