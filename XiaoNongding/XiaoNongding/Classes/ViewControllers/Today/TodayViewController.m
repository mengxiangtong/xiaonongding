//
//  TodayViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/12.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "TodayViewController.h"
#import "ITheadscrollView.h"
#import "TodayTableViewCell.h"
#import "UINewIntoView.h"
#import "HotNews.h"
#import "DDCarouselFigureView.h"




@interface TodayViewController ()<UITableViewDataSource, UITableViewDelegate >
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) UILabel *label;

@property (nonatomic, retain) NSMutableArray *imgDataArray;

@property (nonatomic, retain) NSMutableArray *RecommendDataArray;
@property (nonatomic, retain) NSMutableArray *RecommendAllDataArray;

@property (nonatomic,retain) DDCarouselFigureView *view_AD;//轮播图广告视图


//等待图标
@property (nonatomic, retain) UIActivityIndicatorView *activity1;
@property (nonatomic, retain) UIActivityIndicatorView *activity2;


@end

@implementation TodayViewController{
    int pageIndex;
}

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static TodayViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [TodayViewController new];
    });
    
    return _sharedManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.RecommendDataArray = [NSMutableArray array];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    pageIndex=1;
    

    self.RecommendDataArray =[[NSMutableArray alloc]init];
    self.imgDataArray =[[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-64-44) style:UITableViewStylePlain] ;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = KScrollViewBackGroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.view_AD;
    
    [self.tableView registerClass:[UINewIntoView class] forCellReuseIdentifier:KUINewIntoView];
    [self.tableView registerClass:[TodayTableViewCell class] forCellReuseIdentifier:KTodayTableViewCell];
    // 右cell 分割线长度
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {}
    //左
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    __weak typeof(self) weakself = self;
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        pageIndex=1;
        [weakself loadNewsData];
        [weakself loadRecommendData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    weakself.tableView.header.autoChangeAlpha = YES;
    
    // 上拉刷新
    weakself.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakself loadNewsData];
        
    }];
    
    
    self.activity1=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((kDeviceWidth-50.0)/2.0, 100.0, 50.0, 50.0)];
    [self.activity1 setBackgroundColor:[UIColor clearColor]];
    [self.activity1 setColor:[UIColor blackColor]];
    [self.view addSubview:self.activity1];
    [self.activity1 startAnimating];
    
    self.activity2=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((kDeviceWidth-50.0)/2.0, KDeviceHeight-200.0, 50.0, 50.0)];
    [self.activity2 setBackgroundColor:[UIColor clearColor]];
    [self.activity2 setColor:[UIColor blackColor]];
    [self.view addSubview:self.activity2];
    [self.activity2 startAnimating];
    
    [self loadNewsData];
    [self loadRecommendData];
    
    // Do any additional setup after loading the view.
}

//加载今日最新入驻
- (void)loadNewsData
{
    NSURL *url = [NSURL URLWithString:KHotNews_List_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block TodayViewController *hotTVC = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activity1 stopAnimating];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        });
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    
                    if (pageIndex==1) {
                        hotTVC.imgDataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"] ];
                    }else{
                        [hotTVC.imgDataArray addObjectsFromArray:[dict objectForKey:@"msg"]];
                    }
                
                    if (!hotTVC.imgDataArray || hotTVC.imgDataArray.count<=0) {
                        hotTVC.imgDataArray=[[NSMutableArray alloc]init];
                        
                        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                        [dic setObject:@"" forKey:@"merchant_theme_image"];
                        [dic setObject:@"name" forKey:@"name"];
                        [dic setObject:@"-1" forKey:@"mer_id"];
                        [hotTVC.imgDataArray addObject:dic];
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XNDProgressHUD showWithStatus:[dict objectForKey:@"error"] duration:1.0];
                    });
                }
                //更新页面
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateDataForUI];
                });
            }

        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];

}
//加载今日精品推荐
-(void)loadRecommendData{
    NSURL *url = [NSURL URLWithString: KHotNews_Into_URL ];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block TodayViewController *weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activity2 stopAnimating];
        });
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    if(dict.count>0){
            
                        if (pageIndex==1) {
                            weakSelf.RecommendDataArray=[[NSMutableArray alloc]init];
                            weakSelf.RecommendAllDataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"] ];
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            for (int i=0; i<arry_Msg.count; i++) {
                                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                                [dic setObject:arry_Msg[i] forKey:@"0"];
                                if (++i<arry_Msg.count) {
                                    [dic setObject:arry_Msg[i] forKey:@"1"];
                                }else
                                    [dic setObject:[NSMutableDictionary new] forKey:@"1"];
                                
                                [weakSelf.RecommendDataArray addObject:dic];
                            }
                        }else{
                            [weakSelf.RecommendAllDataArray addObjectsFromArray:[dict objectForKey:@"msg"]];
                            [weakSelf.RecommendDataArray removeAllObjects];
                            
                            for (int i=0; i<weakSelf.RecommendAllDataArray.count; i++) {
                                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                                [dic setObject:weakSelf.RecommendAllDataArray[i] forKey:@"0"];
                                if (++i<weakSelf.RecommendAllDataArray.count) {
                                    [dic setObject:weakSelf.RecommendAllDataArray[i] forKey:@"1"];
                                }else
                                    [dic setObject:[NSMutableDictionary new] forKey:@"1"];
                                
                                [weakSelf.RecommendDataArray addObject:dic];
                            }
                        }
                        
                        
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


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.4*kDeviceWidth)];
        _scrollView.contentSize = CGSizeMake(kDeviceWidth * 4, CGRectGetHeight(_scrollView.frame));
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
        
    }
    
    return _scrollView;
}


- (DDCarouselFigureView *)view_AD
{
    if (!_view_AD) {
        _view_AD=[[DDCarouselFigureView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, (kDeviceWidth-20.0)/2.0)];
        _view_AD.superVC=self;
        _view_AD.photoList=[_imgDataArray copy];

    }
    return _view_AD;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"  今日上新  viewWillAppear   ");
    
}

#pragma mark 更新页面
- (void)updateDataForUI
{
    [self.activity1 stopAnimating];
    [self.view_AD setPhotoList:[_imgDataArray copy]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return  85.0+(kDeviceWidth-40.0)/3.0;
    }
    return (kDeviceWidth -28)/2*216/325 +92 ;
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
    return self.RecommendDataArray.count+1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=nil;
    if (indexPath.row==0) {
        cell =[tableView dequeueReusableCellWithIdentifier:KUINewIntoView forIndexPath:indexPath];
        ((UINewIntoView *)cell).pList=[self.imgDataArray copy];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:KTodayTableViewCell forIndexPath:indexPath];
        if (self.RecommendDataArray.count>=indexPath.row) {
            NSDictionary *dic= self.RecommendDataArray[indexPath.row-1];
            
            NSString *str_pic=[[dic objectForKey:@"0"] objectForKey:@"list_pic" ];
            NSURL *url=[NSURL URLWithString:str_pic];
            [((TodayTableViewCell *)cell).cellImageView sd_setImageWithURL:url placeholderImage:nil];
            
            NSString *str_name=[[dic objectForKey:@"0"] objectForKey:@"name" ];
            NSString *str_price=[[dic objectForKey:@"0"] objectForKey:@"price" ];
            NSString *str_sale_count=[[dic objectForKey:@"0"] objectForKey:@"sale_count" ];
            [((TodayTableViewCell *)cell).titleLabel setText:str_name];
            [((TodayTableViewCell *)cell).xiaoliangLabel setText:[NSString stringWithFormat:@"销售:%@" ,str_sale_count ]];
            [((TodayTableViewCell *)cell).priceLabel setText:str_price];

            ((TodayTableViewCell *)cell).idStr1 =[[dic objectForKey:@"0"]  objectForKey:@"group_id"];
            ((TodayTableViewCell *)cell).urlStr1 =[[dic objectForKey:@"0"]  objectForKey:@"url"];
            
            if ([dic objectForKey:@"1"]) {
                //设置第二
                [((TodayTableViewCell *)cell).cellImageView2 sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"1"] objectForKey:@"list_pic"] ] placeholderImage:nil];
                str_name=[[dic objectForKey:@"1"] objectForKey:@"name" ];
                str_price=[[dic objectForKey:@"1"] objectForKey:@"price" ];
                str_sale_count=[[dic objectForKey:@"1"] objectForKey:@"sale_count" ];
                
                [((TodayTableViewCell *)cell).cellImageView2 setHidden:NO];
                [((TodayTableViewCell *)cell).titleLabel2 setHidden:NO];
                [((TodayTableViewCell *)cell).xiaoliangLabel2 setHidden:NO];
                [((TodayTableViewCell *)cell).priceLabel2 setHidden:NO];
                [((TodayTableViewCell *)cell).jin2 setHidden:NO];
                ((TodayTableViewCell *)cell).idStr2 =[[dic objectForKey:@"1"]  objectForKey:@"group_id"];
                ((TodayTableViewCell *)cell).urlStr2 =[[dic objectForKey:@"1"]  objectForKey:@"url"];
                if (!str_name) {
                    [((TodayTableViewCell *)cell).cellImageView2 setHidden:YES];
                    [((TodayTableViewCell *)cell).titleLabel2 setHidden:YES];
                    [((TodayTableViewCell *)cell).xiaoliangLabel2 setHidden:YES];
                    [((TodayTableViewCell *)cell).priceLabel2 setHidden:YES];
                    [((TodayTableViewCell *)cell).jin2 setHidden:YES];
                     cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                [((TodayTableViewCell *)cell).titleLabel2 setText:str_name];
                [((TodayTableViewCell *)cell).xiaoliangLabel2 setText:[NSString stringWithFormat:@"销售:%@" ,str_sale_count ]];
                [((TodayTableViewCell *)cell).priceLabel2 setText:str_price];
            }

        }else{
            [((TodayTableViewCell *)cell).cellImageView setHidden:YES];
            [((TodayTableViewCell *)cell).titleLabel setHidden:YES];
            [((TodayTableViewCell *)cell).xiaoliangLabel setHidden:YES];
            [((TodayTableViewCell *)cell).priceLabel setHidden:YES];
            
            [((TodayTableViewCell *)cell).cellImageView2 setHidden:YES];
            [((TodayTableViewCell *)cell).titleLabel2 setHidden:YES];
            [((TodayTableViewCell *)cell).xiaoliangLabel2 setHidden:YES];
            [((TodayTableViewCell *)cell).priceLabel2 setHidden:YES];
            [((TodayTableViewCell *)cell).jin2 setHidden:YES];
        }
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods
#pragma mark Table view delegate


//将要绘制cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //右边分割线间距
        //[cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        }
        
     if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        //左边分割线间距
        [cell setLayoutMargins:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
     }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_tableView deselectRowAtIndexPath:indexPath animated:NO];

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

- (void)dealloc
{
    
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
