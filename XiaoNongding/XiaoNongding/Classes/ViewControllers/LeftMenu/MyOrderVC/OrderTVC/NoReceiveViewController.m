//
//  AllOrderViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "NoReceiveViewController.h"
#import "OrderTableViewCell.h"
#import "NewLoginViewController.h"
#import "OrderDetailViewController.h"
#import "OrderCouponDetailViewController.h"

@interface NoReceiveViewController ()<UITableViewDataSource, UITableViewDelegate,OrderTableViewCellDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic , retain) UIView *bgView_NoData;
@property (nonatomic,retain) NSMutableArray *arry_AllOrder;

@property (nonatomic, retain) UIXndActivityView *activityView;

@end

@implementation NoReceiveViewController{
    int pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex=1;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-64-44) style:UITableViewStylePlain] ;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView setBackgroundView:self.bgView_NoData];
    [self.view addSubview:_tableView];
    
    // 注册自定义cell
    [self.tableView registerClass:[OrderTableViewCell class] forCellReuseIdentifier:KOrderTableViewCell];
    
    __weak typeof(self) weakself = self;
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        pageIndex=1;
//        [self.activityView startAnimation];
        [weakself loadOrderData];
        
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    weakself.tableView.header.autoChangeAlpha = YES;
    
    // 上拉刷新
    weakself.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{

        [weakself loadOrderData];
        
    }];
    

    [self.view addSubview:self.activityView];

    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pageIndex=1;
    [self loadOrderData];
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

//加载今日精品推荐
-(void)loadOrderData{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KOrder_List_URL,@"2",pageIndex,uid,token ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block NoReceiveViewController *weakSelf = self;
    
    
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
                    if(pageIndex==1){
                        weakSelf.arry_AllOrder=[[NSMutableArray alloc]initWithArray: [dict objectForKey:@"msg"]];
                    }else{
                        [weakSelf.arry_AllOrder addObjectsFromArray:[dict objectForKey:@"msg"]];
                    }
                    pageIndex++;
                    
                }
                
                //更新页面
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.tableView reloadData];
                  
                });
            }
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
    return  210 ;
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
    return self.arry_AllOrder.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KOrderTableViewCell forIndexPath:indexPath];
    cell.superVC=self;
    cell.delegate=self;
    NSDictionary *item=self.arry_AllOrder[indexPath.row];
    [cell setItem_Data:item];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate Methods
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //查看订单详情
    if([[self.arry_AllOrder[indexPath.row]  objectForKey:@"name"] isEqualToString:@"2"] &&[[self.arry_AllOrder[indexPath.row] objectForKey:@"tuan_type"] isEqualToString:@"2"]){
        
        [[OrderDetailViewController shareInstance] setOrderData:self.arry_AllOrder[indexPath.row]];
        [self.navigationController pushViewController:[OrderDetailViewController shareInstance] animated:YES];
    }else{
        
        OrderCouponDetailViewController *couponVC=[[OrderCouponDetailViewController alloc]init];
        [couponVC setItemData:self.arry_AllOrder[indexPath.row]];
        [self.navigationController pushViewController:couponVC animated:YES];
    }
}

-(void)OrderConfirmWithDic:(NSDictionary *)item{
    
    if (item) {
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            return;
        }
        [self.activityView startAnimation];
        NSString *uid=[dic_userInfo objectForKey:@"uid"];
        NSString *token=[dic_userInfo objectForKey:@"token"];
        NSString *orderId=[item objectForKey:@"order_id"];
        NSString *orderType=[[item objectForKey:@"name"] isEqualToString:@"1"]?@"2":@"1";
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KOrderConfirmURL,orderType,orderId,uid,token ] ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
        request.timeoutInterval=KHTTPTimeoutInterval;
        [request setHTTPMethod:@"GET"];
        
        __block NoReceiveViewController *weakSelf = self;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.activityView stopAnimation];
            });
            if (!connectionError) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (dict) {
                    int status=[[dict objectForKey:@"status"] intValue];
                    if (status==1) {
                        //更新页面
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self loadOrderData ];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [XNDProgressHUD showWithStatus:@"确认收货失败，请重试" duration:1.0];
                            
                        });
                    }
                    
                    
                }
            }else{
                //更新页面
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
                  
                });
                
            }
            
        }];
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
