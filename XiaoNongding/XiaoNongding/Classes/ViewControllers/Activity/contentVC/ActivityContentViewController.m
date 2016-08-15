//
//  ActivityContentViewController.m
//  XiaoNongding
//
//  Created by jion on 16/3/9.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "ActivityContentViewController.h"
#import "MJRefresh.h"
#import "ActivityTableViewCell.h"
#import "UIWebViewViewController.h"
#import "NewLoginViewController.h"

@interface ActivityContentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView               *tableView;
@property (nonatomic, retain) UIView                    *headView;
@property (nonatomic, retain) UIXndActivityView *activityView;
@property (nonatomic, retain) UIView                    *bgView_NoData;

@property (nonatomic, retain) NSMutableArray            *ActivityDataArray;

@property (nonatomic, assign) ActivityOrderType orderType;
@property (nonatomic, assign) ActivityOrderType orderComPreType;
@property (nonatomic, assign) ActivityOrderType orderSalesNumType;
@property (nonatomic, assign) ActivityOrderType orderPriceType;
@property (nonatomic, assign) ActivityOrderType orderDistanceType;

@end

@implementation ActivityContentViewController{
    int pageIndex;
}
+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static ActivityContentViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ActivityContentViewController new];
    });
    
    return _sharedManager;
}

- (UIButton *)getBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    
    
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.activityView];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:_str_Title];
    [self.ActivityDataArray removeAllObjects];
    [self.tableView reloadData];
    [self refreshData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)goDismiss :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma 懒加载
- (UITableView *)tableView
{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight-65.0) style:UITableViewStylePlain] ;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        [_tableView registerClass:[ActivityTableViewCell class] forCellReuseIdentifier:KActivityTableViewCell];
        [_tableView setBackgroundView:self.bgView_NoData];
        
        __weak typeof(self) weakself = self;
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex=1;
//            [self.activityView startAnimation];
            [weakself loadActivityData];
        }];
        
        weakself.tableView.header.autoChangeAlpha = YES;
        weakself.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{[weakself loadActivityData];}];
        
    }
    return _tableView;
}
-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
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
-(void)refreshData{
    pageIndex=1;
    
    [self loadActivityData];
}
//加载活动
-(void)loadActivityData{
    
    
    [self.activityView startAnimation];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: KActivity_getTypeActivity_URL,_str_type,pageIndex ]];
    if([_str_type isEqualToString:@""]){
        url = [NSURL URLWithString:[NSString stringWithFormat: KActivity_getOtherTypeActivity_URL,pageIndex ]];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block ActivityContentViewController *weakSelf = self;
    
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
                        if (pageIndex==1) {
                            weakSelf.ActivityDataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                        }else{
                            [weakSelf.ActivityDataArray addObjectsFromArray:[dict objectForKey:@"msg"]];
                        }
                        pageIndex++;
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

#pragma mark - ###监听 代理###
#pragma mark UITableViewDataSource 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.tableView]){
        return self.ActivityDataArray.count;
    }else{
        return self.ActivityDataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float imgWidth=(kDeviceWidth-20)/7.0*4.0;
    float imgHeight=imgWidth/4.0*2.8;
    return imgHeight+10.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40.0;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KActivityTableViewCell forIndexPath:indexPath];
    if (indexPath.row<self.ActivityDataArray.count) {
        NSDictionary* item= self.ActivityDataArray[indexPath.row];
        [cell setItem_Activity:[item copy]];
    }
    return cell;
}


#pragma mark tableView代理  行选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        [self.navigationController pushViewController:webview animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        if (!_headView) {
            int edgeinsets=7.0;

            _headView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 40.0)];
            [_headView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
            //综合
            UIButton *btn_compre=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth/4.0, 40.0)];
            [btn_compre  setTitle:@"综合" forState:UIControlStateNormal];
            [btn_compre.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            [btn_compre setTitleColor:KSearchCheckedColor forState:UIControlStateNormal];
            [btn_compre setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            [btn_compre setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/edgeinsets, 0.0, 0.0)];
            [btn_compre setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
            [btn_compre addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn_compre setTag:1001];
            //销量
            UIButton *btn_salesNum=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0, 0.0, kDeviceWidth/4.0, 40.0)];
            [btn_salesNum  setTitle:@"人数" forState:UIControlStateNormal];
            [btn_salesNum.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            [btn_salesNum setTitleColor:kCellLineColor forState:UIControlStateNormal];
            [btn_salesNum setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
            [btn_salesNum setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/edgeinsets, 0.0, 0.0)];
            [btn_salesNum setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
            [btn_salesNum addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn_salesNum setTag:1002];
            //价格
            UIButton *btn_price=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0*2.0, 0.0, kDeviceWidth/4.0, 40.0)];
            [btn_price  setTitle:@"价格" forState:UIControlStateNormal];
            [btn_price.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            [btn_price setTitleColor:kCellLineColor forState:UIControlStateNormal];
            [btn_price setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
            [btn_price setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/edgeinsets, 0.0, 0.0)];
            [btn_price setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
            [btn_price addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn_price setTag:1003];
            //距离
            UIButton *btn_distance=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0*3.0, 0.0, kDeviceWidth/4.0, 40.0)];
            [btn_distance  setTitle:@"日期" forState:UIControlStateNormal];
            [btn_distance.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
            [btn_distance setTitleColor:kCellLineColor forState:UIControlStateNormal];
            [btn_distance setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
            [btn_distance setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/edgeinsets, 0.0, 0.0)];
            [btn_distance setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
            [btn_distance addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn_distance setTag:1004];
            
            [_headView addSubview:btn_compre];
            [_headView addSubview:btn_salesNum];
            [_headView addSubview:btn_price];
            [_headView addSubview:btn_distance];
            self.orderComPreType=ActivityOrderComPreBottomType;
            self.orderSalesNumType=ActivityOrderSalesNumBottomType;
            self.orderPriceType=ActivityOrderPriceTopType;
            self.orderDistanceType=ActivityOrderDistanceTopType;
        }
        
        return _headView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)btn_OrderAction:(UIButton *)sender{
    for (UIView *v in _headView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)v;
            [btn setTitleColor:kCellLineColor forState:UIControlStateNormal];
            switch (btn.tag) {
                case 1001:
                    if(self.orderComPreType==ActivityOrderComPreTopType)
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    else
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    break;
                case 1002:
                    if(self.orderSalesNumType==ActivityOrderSalesNumTopType)
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    else
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    break;
                case 1003:
                    if(self.orderPriceType==ActivityOrderPriceTopType )
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    else
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    break;
                case 1004:
                    if(self.orderDistanceType==ActivityOrderDistanceTopType)
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    else
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }

        }
    }
    [sender setTitleColor:KSearchCheckedColor forState:UIControlStateNormal];
    
    switch (sender.tag) {
        case 1001:
            if(self.orderComPreType==ActivityOrderComPreTopType){
                self.orderType=ActivityOrderComPreBottomType;
                self.orderComPreType=ActivityOrderComPreBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortend_time = [[NSSortDescriptor alloc] initWithKey:@"end_time" ascending:YES];
                NSSortDescriptor *sortprice = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:NO];
                NSSortDescriptor *sortpart_count = [[NSSortDescriptor alloc] initWithKey:@"part_count" ascending:YES];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortpart_count]];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObjects:sortpart_count,sortend_time,sortprice,nil]];
                [self.tableView reloadData];
               
            }
            else{
                self.orderType=ActivityOrderComPreTopType;
                self.orderComPreType=ActivityOrderComPreTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortend_time = [[NSSortDescriptor alloc] initWithKey:@"end_time" ascending:NO];
                NSSortDescriptor *sortprice = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
                NSSortDescriptor *sortpart_count = [[NSSortDescriptor alloc] initWithKey:@"part_count" ascending:NO];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortpart_count]];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObjects:sortpart_count,sortend_time,sortprice,nil]];
                [self.tableView reloadData];
              
            }
            break;
        case 1002:
            if(self.orderSalesNumType==ActivityOrderSalesNumTopType){
                self.orderType=ActivityOrderSalesNumBottomType;
                self.orderSalesNumType=ActivityOrderSalesNumBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortpart_count = [[NSSortDescriptor alloc] initWithKey:@"part_count" ascending:NO];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortpart_count]];
                [self.tableView reloadData];
            }
            else {
                
                self.orderType=ActivityOrderSalesNumTopType;
                self.orderSalesNumType=ActivityOrderSalesNumTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortpart_count = [[NSSortDescriptor alloc] initWithKey:@"part_count" ascending:YES];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortpart_count]];
                [self.tableView reloadData];
            }
            break;
        case 1003:
            if(self.orderPriceType==ActivityOrderPriceTopType ){
                self.orderType=ActivityOrderPriceBottomType;
                self.orderPriceType=ActivityOrderPriceBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortprice = [[NSSortDescriptor alloc] initWithKey:@"money" ascending:NO];

                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortprice]];
                [self.tableView reloadData];
                
            }
            else {
                self.orderType=ActivityOrderPriceTopType;
                self.orderPriceType=ActivityOrderPriceTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortprice = [[NSSortDescriptor alloc] initWithKey:@"money" ascending:YES];
                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortprice]];

                [self.tableView reloadData];
            }
            break;
        case 1004:
            if(self.orderDistanceType==ActivityOrderDistanceTopType){
                self.orderType=ActivityOrderDistanceBottomType;
                self.orderDistanceType=ActivityOrderDistanceBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortend_time = [[NSSortDescriptor alloc] initWithKey:@"end_time" ascending:NO];

                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortend_time]];

                [self.tableView reloadData];
            }
            else {
                self.orderType=ActivityOrderDistanceTopType;
                self.orderDistanceType=ActivityOrderDistanceTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
                //排序
                NSSortDescriptor *sortend_time = [[NSSortDescriptor alloc] initWithKey:@"end_time" ascending:YES];

                [self.ActivityDataArray sortUsingDescriptors:[NSArray arrayWithObject:sortend_time]];

                [self.tableView reloadData];
            }
            break;
        default:
            break;
    }
    
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
