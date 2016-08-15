//
//  RecommendViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/12.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendNewTableViewCell.h"
#import "DDCarouselFigureView.h"
#import "UINewIntoView.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) DDCarouselFigureView *view_AD;//轮播图
@property (nonatomic, retain) NSMutableArray *imgDataArray;//轮播图数据源
@property (nonatomic, retain) NSMutableArray *RecommendAllDataArray;
@property (nonatomic, retain) NSMutableArray *RecommendDataArray;
//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView;
@property (nonatomic , retain) UIView *bgView_NoData;
@end

@implementation RecommendViewController{
    int pageIndex;
}

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static RecommendViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [RecommendViewController new];
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
   
    pageIndex=1;
    self.RecommendAllDataArray=[[NSMutableArray alloc]init];
    self.RecommendDataArray=[[NSMutableArray alloc]init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-64-44) style:UITableViewStylePlain] ;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.tableView setBackgroundView:self.bgView_NoData];
    _tableView.backgroundColor = kTableViewSectionColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    self.tableView.tableHeaderView = self.view_AD;
    // 右cell 分割线长度
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
    }
    //左
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // 注册自定义cell
    [self.tableView registerClass:[RecommendNewTableViewCell class] forCellReuseIdentifier:KTodayTableViewCell];
    
    
    __weak typeof(self) weakself = self;
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex=1;
        [weakself loadRecommendData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    weakself.tableView.header.autoChangeAlpha = YES;
    
    // 上拉刷新
    weakself.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself loadRecommendData];
        
    }];
     [self.view addSubview:self.activityView];
    [self loadRecommendData];
    
    
    // Do any additional setup after loading the view.
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"  今日上新  viewWillAppear   ");
    
}

- (DDCarouselFigureView *)view_AD
{
    if (!_view_AD) {
        _view_AD=[[DDCarouselFigureView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, (kDeviceWidth-134.0)/2.0)];
        _view_AD.superVC=self;
        _view_AD.photoList=[_imgDataArray copy];
        
    }
    return _view_AD;
}
-(UIView *)bgView_NoData{
    if (!_bgView_NoData) {
        _bgView_NoData=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.tableView.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData addSubview:img];
    }
    return _bgView_NoData;
}


//加载今日精品推荐
-(void)loadRecommendData{
    [self.activityView startAnimation];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: KCommend_List_URL,pageIndex ]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block RecommendViewController *weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityView stopAnimation];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        });
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    if(dict.count>0){
                        NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                        [weakSelf.RecommendDataArray removeAllObjects];
                        
                        
                        if (pageIndex==1) {
                            weakSelf.RecommendAllDataArray =[[NSMutableArray alloc] initWithArray:arry_Msg];
                            
                            weakSelf.imgDataArray=[NSMutableArray new];

                        }else{
                            [weakSelf.RecommendAllDataArray addObjectsFromArray:arry_Msg];

                        }
                        
                        pageIndex++;
                    }
                    
                }
                
                
            }
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.imgDataArray removeAllObjects];
               
                NSMutableDictionary *dic_img2=[NSMutableDictionary new];
                [dic_img2 setObject:@"http://www.xiaonongding.com/tpl/Static/weizan/images/xnd_img/banner01.png" forKey:@"merchant_theme_image"];
                [dic_img2 setObject:@"" forKey:@"name"];
                [dic_img2 setObject:@"custem_01" forKey:@"mer_id"];
                [dic_img2 setObject:@"01" forKey:@"url"];
                [weakSelf.imgDataArray addObject:[[NSDictionary alloc]initWithDictionary:dic_img2]];
                
                NSMutableDictionary *dic_img=[NSMutableDictionary new];
                [dic_img setObject:@"http://www.xiaonongding.com/tpl/Static/weizan/images/xnd_img/banner03.png" forKey:@"merchant_theme_image"];
                [dic_img setObject:@"" forKey:@"name"];
                [dic_img setObject:@"custem_03" forKey:@"mer_id"];
                [dic_img setObject:@"03" forKey:@"url"];
                [weakSelf.imgDataArray addObject:[[NSDictionary alloc]initWithDictionary:dic_img]];
                [self.view_AD setPhotoList:weakSelf.imgDataArray];
                [self.tableView reloadData];
                
                
            });
        }else{
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
                
            });
            
        }
        
    }];
}



#pragma mark - UITableViewDataSource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (kDeviceWidth-14.0)/4.0*2.5+120.0 ;
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
    return self.RecommendAllDataArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KTodayTableViewCell forIndexPath:indexPath];
    cell.superVC=self;
    if (self.RecommendAllDataArray.count>indexPath.row) {
        
        NSDictionary *dic= self.RecommendAllDataArray[indexPath.row];
        
        NSString *str_pic=[dic  objectForKey:@"list_pic" ];
        NSURL *url=[NSURL URLWithString:str_pic];
        [cell.cellImageView sd_setImageWithURL:url placeholderImage:nil];
        
        NSString *str_name=[dic  objectForKey:@"name" ];
        NSString *str_price=[dic  objectForKey:@"price" ];
        NSString *str_sale_count=[dic  objectForKey:@"sale_count" ];
        [cell.titleLabel setText:str_name];
        [cell.xiaoliangLabel setText:[NSString stringWithFormat:@"销售:%@" ,str_sale_count ]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"¥%@", str_price ]];
        
        cell.idStr =[dic objectForKey:@"group_id"];
        cell.urlStr =[dic objectForKey:@"url"];
        
        
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
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    
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
        
        //self.navigationController.navigationBar.translucent = YES;
        view.alpha = _tableView.contentOffset.y / 200.0f;
    } else if (_tableView.contentOffset.y > 136) {
        //       self.navigationController.navigationBar.translucent = NO;
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
