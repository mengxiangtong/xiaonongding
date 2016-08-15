//
//  MyCollectionVC.m
//  XiaoNongding
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "SearchResultViewController.h"
#import "RecommendNewTableViewCell.h"
#import "SearchFarmTableViewCell.h"
#import "UIWebViewViewController.h"

@interface SearchResultViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate>
//控件类
@property (nonatomic, retain)  UISearchBar *searchBar;
//@property (nonatomic, retain)  UIView *topView_Product;
@property (nonatomic, retain)  UIScrollView *scrollView;
@property (nonatomic, retain)  UITableView *productTableView;
@property (nonatomic, retain)  UITableView *farmTableview;
@property (nonatomic, retain)  UISegmentedControl *segmentControl;

//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView1;
@property (nonatomic, retain) UIXndActivityView *activityView2;
//数据类
@property (nonatomic, retain) NSMutableArray *arry_Product;
@property (nonatomic, retain) NSMutableArray *arry_Farm;


@property (nonatomic, assign) SearchOrderType orderType_farm;
@property (nonatomic, assign) SearchOrderType orderType_Product;

@property (nonatomic, retain) UIView         *bgView_NoData;
@property (nonatomic, retain) UIView         *bgView_NoData2;

@end

@implementation SearchResultViewController{
    int pageIndex_product;
    int pageIndex_fram;
    int senderFarmTag;
    bool isrequest;
    UIView *headView_farm;
    UIView *headView_product;
}



#pragma mark - ###界面###

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex_fram=1;
    pageIndex_product=1;
    senderFarmTag=101;
    isrequest=YES;
    self.orderType_farm=SearchOrderComPreTopType;
    self.orderType_Product=SearchOrderComPreTopType;
    
    self.navigationItem.titleView = self.segmentControl ;
    //左侧
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    //标题
    [self.view addSubview:self.searchBar];
    [self.scrollView addSubview:self.productTableView];
    [self.scrollView addSubview:self.farmTableview];
    [self.view addSubview:self.scrollView];
    
    
    [self.view addSubview:self.activityView1];
    [self.view addSubview:self.activityView2];

    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    
}

-(void)setKeyWord:(NSString *)keyWord{
    _keyWord=keyWord;
    pageIndex_product=0;
    pageIndex_fram=0;
    [self.searchBar setText:keyWord];
    [self loadProductData];
    [self loadFarmData];
    
}
#pragma mark 懒加载
-(UIXndActivityView *)activityView2{
    if (!_activityView2) {
        
        _activityView2 = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView2;
}
-(UIXndActivityView *)activityView1{
    if (!_activityView1) {
        
        _activityView1= [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView1;
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
- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"农场", @"商品"]];
        
        CGFloat h = kDeviceWidth*30/400;
        if (kDeviceWidth < 350) {
            h += 5;
        }
        _segmentControl.frame =CGRectMake(0, 0, kDeviceWidth*15/40, h);
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.tintColor = [UIColor whiteColor];
        //修改字体的默认颜色与选中颜色
        NSDictionary *dicSelect = [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(38, 189, 118, 1),NSForegroundColorAttributeName,
                                   [UIFont fontWithName:@"Helvetica" size:16.f],NSFontAttributeName ,nil];
        [_segmentControl setTitleTextAttributes:dicSelect forState:UIControlStateSelected];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,
                             [UIFont fontWithName:@"Helvetica" size:15.f],NSFontAttributeName ,nil];
        
        [_segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
        
        [_segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentControl;
}
-(void)segmentControlAction:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex==0) {
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0)];
    }else{
        [self.scrollView setContentOffset:CGPointMake(kDeviceWidth, 0.0)];
    }
}
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 40.0)];
        _searchBar.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
        _searchBar.barTintColor=[UIColor colorWithWhite:0.95 alpha:1.0];
        _searchBar.showsCancelButton=NO;
        _searchBar.delegate=self;
        _searchBar.placeholder=@"搜索农场或商品名称";
        _searchBar.barStyle=UIBarStyleDefault;
    }
    return _searchBar;
}
-(UIView *)bgView_NoData{
    if (!_bgView_NoData) {
        _bgView_NoData=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.productTableView.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData addSubview:img];
    }
    return _bgView_NoData;
}
-(UIView *)bgView_NoData2{
    if (!_bgView_NoData2) {
        _bgView_NoData2=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData2 setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.farmTableview.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData2 addSubview:img];
    }
    return _bgView_NoData2;
}
#pragma mark 搜索框的代理方法
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];

    [self loadFarmData];
    [self loadProductData];
}

- (UITableView *)productTableView
{
    
    if (!_productTableView) {
        _productTableView = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0.0, kDeviceWidth, self.scrollView.height) style:UITableViewStylePlain] ;
        _productTableView.showsVerticalScrollIndicator = NO;
        _productTableView.dataSource = self;
        _productTableView.delegate = self;
        _productTableView.backgroundColor = [UIColor whiteColor];
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        [_productTableView registerClass:[RecommendNewTableViewCell class] forCellReuseIdentifier:KTodayTableViewCell];
        [_productTableView setBackgroundView:self.bgView_NoData];
        
        __weak typeof(self) weakself = self;
        self.productTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex_product=1;
            
            [weakself loadProductData];
        }];
        
        weakself.productTableView.header.autoChangeAlpha = YES;
        weakself.productTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{[weakself loadProductData];}];
        
    }
    return _productTableView;
}
- (UITableView *)farmTableview
{
    
    if (!_farmTableview) {
        _farmTableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, self.scrollView.height) style:UITableViewStylePlain] ;
        _farmTableview.showsVerticalScrollIndicator = NO;
        _farmTableview.dataSource = self;
        _farmTableview.delegate = self;
        _farmTableview.backgroundColor = [UIColor whiteColor   ];
        _farmTableview.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        [_farmTableview registerClass:[SearchFarmTableViewCell class] forCellReuseIdentifier:KSearchFarmTableViewCell];
        _farmTableview.rowHeight=150.0;
        [_farmTableview setBackgroundView:self.bgView_NoData2];
        
        
        __weak typeof(self) weakself = self;
        self.farmTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex_fram=1;
            [weakself loadFarmData];
            
            
        }];
        weakself.farmTableview.header.autoChangeAlpha = YES;
        weakself.farmTableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            [weakself loadFarmData];
            
        }];
        
    }
    return _farmTableview;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 40.0, kDeviceWidth, KDeviceHeight-104.0)];
        [_scrollView setBackgroundColor:KScrollViewBackGroundColor];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsVerticalScrollIndicator:YES];
        [_scrollView setDelegate:self ];
        [_scrollView setContentSize:CGSizeMake(kDeviceWidth*2.0, KDeviceHeight-104.0)];
    }
    return _scrollView;
}

//加载产品列表
-(void)loadProductData{
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    NSString *uid;
    NSString *token;
    if (dic_userInfo) {
        uid=[dic_userInfo objectForKey:@"uid"];
        token=[dic_userInfo objectForKey:@"token"];
    }
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    
    NSString *orderStr=@"";
    switch (self.orderType_Product) {
        case SearchOrderComPreTopType:
            orderStr=@"&price=1&distance=1&sale_count=2";
            break;
        case SearchOrderSalesNumTopType:
            orderStr=@"&price=&distance=&sale_count=1";
            break;
        case SearchOrderPriceTopType:
            orderStr=@"&price=1&distance=&sale_count=";
            break;
        case SearchOrderDistanceTopType:
            orderStr=@"&price=&distance=1&sale_count=";
            break;
        case SearchOrderComPreBottomType:
            orderStr=@"&price=1&distance=1&sale_count=1";
            break;
        case SearchOrderSalesNumBottomType:
            orderStr=@"&sale_count=2&price=&distance=";
            break;
        case SearchOrderPriceBottomType:
            orderStr=@"&sale_count=&price=2&distance=";
            break;
        case SearchOrderDistanceBottomType:
            orderStr=@"&sale_count=&price=&distance=2";
            break;
        default:
            orderStr=@"&price=1&distance=1&sale_count=2";
            break;
    }
    
    NSURL *url = [NSURL URLWithString: [[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat: KSearch_SearchGoods_URL,_keyWord,latitude,longitude,pageIndex_product,uid,token ] ,orderStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block SearchResultViewController *weakSelf = self;
    
    [self.activityView1 startAnimation];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityView1 stopAnimation];
            [self.productTableView.header endRefreshing];
            [self.productTableView.footer endRefreshing];
        });
        
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    if(dict.count>0){
                        
                        if (pageIndex_product==1) {
                            
                            NSMutableArray *arry_msg=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"] ];
                            
                               weakSelf.arry_Product=[[NSMutableArray alloc]initWithArray:arry_msg];
                            
                        }else{
                            NSMutableArray *arry_msg=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"] ];
                          
                                [weakSelf.arry_Product addObjectsFromArray:arry_msg];
                            
                        }
                        
                    }
                    pageIndex_product++;
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:[dict objectForKey:@"error"] duration:1.0];
                });
            }
            
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.productTableView reloadData];
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];
}

//加载默认农场列表
-(void)loadFarmData{
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    NSString *uid;
    NSString *token;
    if (dic_userInfo) {
        uid=[dic_userInfo objectForKey:@"uid"];
        token=[dic_userInfo objectForKey:@"token"];
    }
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    
    NSString *orderStr=@"";
    switch (self.orderType_farm) {
        case SearchOrderComPreTopType:
            orderStr=@"&distance=1&fans_count=2";
            break;
        case SearchOrderComPreBottomType:
            orderStr=@"&distance=2&fans_count=2";
            break;
        case SearchOrderSalesNumTopType:
            orderStr=@"&fans_count=1&distance=";
            break;
        case SearchOrderDistanceTopType:
            orderStr=@"&distance=1&fans_count=";
            break;
        case SearchOrderSalesNumBottomType:
            orderStr=@"&fans_count=2&distance=";
            break;
        case SearchOrderDistanceBottomType:
            orderStr=@"&distance=2&fans_count=";
            break;
        default:
            orderStr=@"&distance=1&fans_count=2";
            break;
    }
    NSURL *url = [NSURL URLWithString: [[NSString stringWithFormat:@"%@%@", [NSString stringWithFormat: KSearch_SearchFarms_URL,_keyWord,latitude,longitude,pageIndex_fram,uid,token ],orderStr ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block SearchResultViewController *weakSelf = self;
    

    [self.activityView2 startAnimation];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityView2 stopAnimation];
            [self.farmTableview.header endRefreshing];
            [self.farmTableview.footer endRefreshing];
        });
        
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    if(dict.count>0){
                        if(pageIndex_fram==1){
                            weakSelf.arry_Farm=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                            
                        }else{
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            [weakSelf.arry_Farm addObjectsFromArray:arry_Msg];
                        }
                        
                    }
                    
                    pageIndex_fram++;
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:[dict objectForKey:@"error"] duration:1.0];
                });
            }
            
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.farmTableview reloadData];
                
            });
            
        }else{
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
            
        }
        
    }];
}



#pragma mark - ###响应 事件 ###
#pragma mark 顶部 点击事件
-(void)Btn_ActionProduct:(UIButton *)sender{
    
    //修改 Btn样式
    [self.scrollView setContentOffset:CGPointMake(kDeviceWidth, 0.0) animated:YES];
    
    [self.productTableView reloadData ];
    
}
#pragma mark 顶部 点击事件
-(void)Btn_ActionFarm:(UIButton *)sender{
    
    //修改 Btn样式
    
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.farmTableview reloadData ];
    
    
}
//排序
-(void)shortItemWithFarm{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    [self.arry_Farm sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
}

#pragma mark 退出
- (void)goDismiss :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - ###监听 代理###
#pragma mark UITableViewDataSource 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.productTableView]){
        return self.arry_Product.count;
    }else{
        return self.arry_Farm.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView  isEqual:self.farmTableview]) {
        NSDictionary *dic_item= self.arry_Farm[indexPath.row];
        
        return  [SearchFarmTableViewCell cellHeightWithContact:dic_item]; ;
    }else{
         return (kDeviceWidth-14.0)/4.0*2.5+120.0 ;
    }
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
    if([tableView isEqual:self.productTableView]){
        
        //商品数据
        RecommendNewTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:KTodayTableViewCell forIndexPath:indexPath];
        
        if (self.arry_Product.count>=indexPath.row) {
            
            [cell setSuperVC:self];
            
            NSDictionary *dic= self.arry_Product[indexPath.row];
            
            NSString *str_pic=[dic objectForKey:@"group_pic" ];
            NSURL *url=[NSURL URLWithString:str_pic];
            [cell.cellImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defualtIcon.jpg"]];
            
            NSString *str_name=[dic objectForKey:@"name" ];
            NSString *str_price=[dic objectForKey:@"price" ];
            NSString *str_sale_count=[dic objectForKey:@"sale_count" ];

            [cell.titleLabel setText:str_name];
            [cell.xiaoliangLabel setText:[NSString stringWithFormat:@"销售:%@" ,str_sale_count ]];
            [cell.priceLabel setText:str_price];
            
            cell.idStr =[dic objectForKey:@"group_id"];
            cell.urlStr =[dic objectForKey:@"url"];

        }else{
            [cell.cellImageView setHidden:YES];
            [cell.titleLabel setHidden:YES];
            [cell.xiaoliangLabel setHidden:YES];
            [cell.priceLabel setHidden:YES];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        //农场数据
        SearchFarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSearchFarmTableViewCell forIndexPath:indexPath];

        if (self.arry_Farm.count>indexPath.row) {
            NSDictionary *dic_item= self.arry_Farm[indexPath.row];
            [cell setData_item:dic_item];
        }
        return cell;
    }
}


#pragma mark tableView代理  行选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取URL  执行操作
     if ([tableView isEqual:[self farmTableview]]) {
         NSDictionary *dic_item= self.arry_Farm[indexPath.row];
         
         NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
         NSString *latitude=[dicInfo objectForKey:@"latitude"];
         NSString *longitude=[dicInfo objectForKey:@"longitude"];
         
         NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
         NSString *uid=@"";
         NSString *token=@"";
         if (dic_userInfo) {
             uid=[dic_userInfo objectForKey:@"uid"];
             token=[dic_userInfo objectForKey:@"token"];
         }
        
         NSString *url=[NSString stringWithFormat:@"%@&uid=%@&token=%@&lat=%@&long=%@",[dic_item objectForKey:@"url"],uid,token,latitude,longitude ];
         UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
         [webview initUrlAndId:nil urlstr:url];
         [self.navigationController pushViewController:webview animated:YES];
     }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        
        if ([tableView isEqual:self.productTableView]) {
            if (!headView_product) {
                headView_product=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 40.0)];
                [headView_product setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
                //综合
                UIButton *btn_compre=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth/4.0, 40.0)];
                [btn_compre  setTitle:@"综合" forState:UIControlStateNormal];
                [btn_compre.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_compre setTitleColor:KSearchCheckedColor forState:UIControlStateNormal];
                [btn_compre setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                [btn_compre setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/7.0, 0.0, 0.0)];
                [btn_compre setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
                [btn_compre addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_compre setTag:1001];
                //销量
                UIButton *btn_salesNum=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0, 0.0, kDeviceWidth/4.0, 40.0)];
                [btn_salesNum  setTitle:@"销量" forState:UIControlStateNormal];
                [btn_salesNum.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_salesNum setTitleColor:kCellLineColor forState:UIControlStateNormal];
                [btn_salesNum setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                [btn_salesNum setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/7.0, 0.0, 0.0)];
                [btn_salesNum setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
                [btn_salesNum addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_salesNum setTag:1002];
                //价格
                UIButton *btn_price=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0*2.0, 0.0, kDeviceWidth/4.0, 40.0)];
                [btn_price  setTitle:@"价格" forState:UIControlStateNormal];
                [btn_price.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_price setTitleColor:kCellLineColor forState:UIControlStateNormal];
                [btn_price setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                [btn_price setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/7.0, 0.0, 0.0)];
                [btn_price setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
                [btn_price addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_price setTag:1003];
                //距离
                UIButton *btn_distance=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/4.0*3.0, 0.0, kDeviceWidth/4.0, 40.0)];
                [btn_distance  setTitle:@"距离" forState:UIControlStateNormal];
                [btn_distance.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_distance setTitleColor:kCellLineColor forState:UIControlStateNormal];
                [btn_distance setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                [btn_distance setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/7.0, 0.0, 0.0)];
                [btn_distance setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -18.0, 0.0, 18.0)];
                [btn_distance addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_distance setTag:1004];
                
                [headView_product addSubview:btn_compre];
                [headView_product addSubview:btn_salesNum];
                [headView_product addSubview:btn_price];
                [headView_product addSubview:btn_distance];
                
                self.orderType_Product=SearchOrderComPreTopType;
            }
            
            return headView_product;
        }else{
            if (!headView_farm) {
                headView_farm=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 40.0)];
                [headView_farm setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
                //综合
                UIButton *btn_compre=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth/3.0, 40.0)];
                [btn_compre  setTitle:@"综合" forState:UIControlStateNormal];
                [btn_compre.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_compre setTitleColor:KSearchCheckedColor forState:UIControlStateNormal];
                [btn_compre setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                [btn_compre setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/5.5, 0.0, 0.0)];
                [btn_compre setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -20.0, 0.0, 20.0)];
                [btn_compre addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_compre setTag:2001];
                //销量
                UIButton *btn_salesNum=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/3.0, 0.0, kDeviceWidth/3.0, 40.0)];
                [btn_salesNum  setTitle:@"关注" forState:UIControlStateNormal];
                [btn_salesNum.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_salesNum setTitleColor:kCellLineColor forState:UIControlStateNormal];
                [btn_salesNum setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                [btn_salesNum setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/5.5, 0.0, 0.0)];
                [btn_salesNum setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 40.0)];
                [btn_salesNum addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_salesNum setTag:2002];
                //距离
                UIButton *btn_distance=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth/3.0*2.0, 0.0, kDeviceWidth/3.0, 40.0)];
                [btn_distance  setTitle:@"距离" forState:UIControlStateNormal];
                [btn_distance.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
                [btn_distance setTitleColor:kCellLineColor forState:UIControlStateNormal];
                [btn_distance setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                [btn_distance setImageEdgeInsets:UIEdgeInsetsMake(0.0, kDeviceWidth/5.5, 0.0, 0.0)];
                [btn_distance setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 40.0)];
                [btn_distance addTarget:self action:@selector(btn_OrderAction:) forControlEvents:UIControlEventTouchUpInside];
                [btn_distance setTag:2003];
                
                [headView_farm addSubview:btn_salesNum];
                [headView_farm addSubview:btn_compre];
                [headView_farm addSubview:btn_distance];
                self.orderType_farm=SearchOrderComPreTopType;
            }
            
            return headView_farm;
        }
        
    }else{
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (![scrollView isKindOfClass:[UITableView class]]) {
        
        if (scrollView.contentOffset.x==0.0) {
            
            [self.segmentControl setSelectedSegmentIndex:0];
        }else if (scrollView.contentOffset.x==kDeviceWidth){
            [self.segmentControl setSelectedSegmentIndex:1];
            
        }
    }
    
}


-(void)btn_OrderAction:(UIButton *)sender{
    UIView *headView=headView_product;
    if (sender.tag>=2001) {
        headView=headView_farm;
    }
    for (UIView *v in headView.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)v;
            [btn setTitleColor:kCellLineColor forState:UIControlStateNormal];
            
            switch (btn.tag) {
                case 1001:
                    if(self.orderType_Product==SearchOrderComPreTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    }
                    else{
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                case 1002:
                    if(self.orderType_Product==SearchOrderSalesNumTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    }
                    else {
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                case 1003:
                    if(self.orderType_Product==SearchOrderPriceTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                        
                    }
                    else {
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                case 1004:
                    if(self.orderType_Product==SearchOrderDistanceTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    }
                    else {
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                case 2001:
                    if(self.orderType_farm==SearchOrderComPreTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    }
                    else {
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                case 2002:
                    if(self.orderType_farm==SearchOrderSalesNumTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    }
                    else {
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                case 2003:
                    if(self.orderType_farm==SearchOrderDistanceTopType){
                        [btn setImage:[UIImage imageNamed:@"icon_TopArrow"] forState:UIControlStateNormal];
                    }
                    else {
                        [btn setImage:[UIImage imageNamed:@"icon_bottomArrow"] forState:UIControlStateNormal];
                    }
                    break;
                    
                default:
                    break;
            }

            
        }
    }

    [sender setTitleColor:KSearchCheckedColor forState:UIControlStateNormal];
    
    switch (sender.tag) {
        case 1001:
            if(self.orderType_Product==SearchOrderComPreTopType){
                self.orderType_Product=SearchOrderComPreBottomType;
                
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            }
            else{
                self.orderType_Product=SearchOrderComPreTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
        case 1002:
            if(self.orderType_Product==SearchOrderSalesNumTopType){
                self.orderType_Product=SearchOrderSalesNumBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            }
            else {
                self.orderType_Product=SearchOrderSalesNumTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
        case 1003:
            if(self.orderType_Product==SearchOrderPriceTopType){
                self.orderType_Product=SearchOrderPriceBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
                
            }
            else {
                self.orderType_Product=SearchOrderPriceTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
        case 1004:
            if(self.orderType_Product==SearchOrderDistanceTopType){
                self.orderType_Product=SearchOrderDistanceBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            }
            else {
                self.orderType_Product=SearchOrderDistanceTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
        case 2001:
            if(self.orderType_farm==SearchOrderComPreTopType){
                self.orderType_farm=SearchOrderComPreBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            }
            else {
                self.orderType_farm=SearchOrderComPreTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
        case 2002:
            if(self.orderType_farm==SearchOrderSalesNumTopType){
                self.orderType_farm=SearchOrderSalesNumBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            }
            else {
                self.orderType_farm=SearchOrderSalesNumTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
        case 2003:
            if(self.orderType_farm==SearchOrderDistanceTopType){
                self.orderType_farm=SearchOrderDistanceBottomType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_bottom"] forState:UIControlStateNormal];
            }
            else {
                self.orderType_farm=SearchOrderDistanceTopType;
                [sender setImage:[UIImage imageNamed:@"icon_compre_top"] forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
    if (sender.tag>=2001){
        pageIndex_fram--;
        [self.activityView2 startAnimation];
        [self loadFarmData];
    }else{
        pageIndex_product--;
        [self.activityView1 startAnimation];
        [self loadProductData];
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
