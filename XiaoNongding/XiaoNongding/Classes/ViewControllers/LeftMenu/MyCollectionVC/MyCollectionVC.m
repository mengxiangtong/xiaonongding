//
//  MyCollectionVC.m
//  XiaoNongding
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "MyCollectionVC.h"
#import "ProductTableViewCell.h"
#import "FarmTableViewCell.h"
#import "EditorViewController.h"
#import "NewLoginViewController.h"



@interface MyCollectionVC ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
//控件类
@property (nonatomic, retain)  UISegmentedControl *segmentControl;
@property (nonatomic, retain)  UIView *topView_Product;
@property (nonatomic, retain)  UIView *topView_Farm;
@property (nonatomic, retain)  UIScrollView *scrollView;
@property (nonatomic, retain)  UITableView *productTableView;
@property (nonatomic, retain)  UITableView *farmTableview;
@property (nonatomic , retain) UIView *bgView_NoData1;
@property (nonatomic , retain) UIView *bgView_NoData2;

//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView1;
@property (nonatomic, retain) UIXndActivityView *activityView2;
//数据类
@property (nonatomic, retain) NSMutableArray *arry_Product;
@property (nonatomic, retain) NSMutableArray *arry_AllProduct;//所有宝贝
@property (nonatomic, retain) NSMutableArray *arry_ReduceProduct;//降价宝贝
@property (nonatomic, retain) NSMutableArray *arry_defualtFarm;
@property (nonatomic, retain) NSMutableArray *arry_Farm;
@property (nonatomic, retain) NSMutableArray *arry_FarmOrder;
@end

@implementation MyCollectionVC{
    int pageIndex_product;
    int pageIndex_framDefualt;
    int pageIndex_framOrder;
    int senderFarmTag;
}


+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static MyCollectionVC *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [MyCollectionVC new];
    });
    
    return _sharedManager;
}
#pragma mark - ###界面###

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex_framDefualt=1;
    pageIndex_framOrder=1;
    pageIndex_product=1;
    senderFarmTag=101;
    self.view.backgroundColor=kTableViewSectionColor;
    //标题
    self.navigationItem.titleView = self.segmentControl ;
    
    //左侧
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    [self.productTableView setBackgroundView:self.bgView_NoData1];
    [self.farmTableview setBackgroundView:self.bgView_NoData2];
    [self.scrollView addSubview:self.topView_Product];
    [self.scrollView addSubview:self.topView_Farm];
    [self.scrollView addSubview:self.productTableView];
    [self.scrollView addSubview:self.farmTableview];

    [self.view addSubview:self.scrollView];
    
    
    [self.view addSubview:self.activityView1];
    [self.view addSubview:self.activityView2];
 
    
    self.arry_Farm=self.arry_defualtFarm;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadProductData];
    [self loadFarmData];
    [self loadFarmOrderData];
    self.arry_Farm=self.arry_defualtFarm;
}

#pragma mark 懒加载

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
-(UIXndActivityView *)activityView1{
    if (!_activityView1) {
        
        _activityView1 = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView1;
}
-(UIXndActivityView *)activityView2{
    if (!_activityView2) {
        
        _activityView2 = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView2;
}
- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"商品", @"农场"]];

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
-(UIView *)bgView_NoData1{
    if (!_bgView_NoData1) {
        _bgView_NoData1=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData1 setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.productTableView.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData1 addSubview:img];
    }
    return _bgView_NoData1;
}
-(UIView *)bgView_NoData2{
    if (!_bgView_NoData2) {
        _bgView_NoData2=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData2 setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.farmTableview.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData2 addSubview:img];
    }
    return _bgView_NoData2;
}


- (UITableView *)productTableView
{

    if (!_productTableView) {
       _productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 40.0, kDeviceWidth, KDeviceHeight-64.0-40.0) style:UITableViewStylePlain] ;
        _productTableView.showsVerticalScrollIndicator = NO;
        _productTableView.dataSource = self;
        _productTableView.delegate = self;
        _productTableView.backgroundColor = [UIColor whiteColor];
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        [_productTableView registerClass:[ProductTableViewCell class] forCellReuseIdentifier:kProductCell];
        
        __weak typeof(self) weakself = self;
        self.productTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex_product=1;
//            [self.activityView1 startAnimation];
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
        _farmTableview = [[UITableView alloc] initWithFrame:CGRectMake(kDeviceWidth, 40.0, kDeviceWidth, KDeviceHeight-64.0-40.0) style:UITableViewStylePlain] ;
        _farmTableview.showsVerticalScrollIndicator = NO;
        _farmTableview.dataSource = self;
        _farmTableview.delegate = self;
        _farmTableview.backgroundColor = [UIColor whiteColor];
        _farmTableview.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        [_farmTableview registerClass:[FarmTableViewCell class] forCellReuseIdentifier:kFarmCell];
        
        __weak typeof(self) weakself = self;
        self.farmTableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if ([self.arry_Farm  isEqual:self.arry_defualtFarm]) {
                pageIndex_framDefualt=1;
                [weakself loadFarmData];
            }else{
                pageIndex_framOrder=1;
                [weakself loadFarmOrderData];
            }
            
            
            
        }];
        weakself.farmTableview.header.autoChangeAlpha = YES;
        weakself.farmTableview.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if ([self.arry_Farm  isEqual:self.arry_defualtFarm]) {
                [weakself loadFarmData];
            }else{
                [weakself loadFarmOrderData];
            }
        }];
        
    }
    return _farmTableview;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight-40.0)];
        [_scrollView setBackgroundColor:KScrollViewBackGroundColor];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsVerticalScrollIndicator:YES];
        [_scrollView setDelegate:self ];
        [_scrollView setContentSize:CGSizeMake(kDeviceWidth*2.0, KDeviceHeight-40.0)];
    }
    return _scrollView;
}
-(UIView *)topView_Product{
    if (!_topView_Product) {
        _topView_Product=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 40.0)];
        [_topView_Product setBackgroundColor:kClassTabBgColor];
        UIButton *btn_defualt=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 40.0)];
        [btn_defualt setTag:101];
        [btn_defualt setTitle:@"全部宝贝" forState:UIControlStateNormal];
        [btn_defualt.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [btn_defualt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_defualt addTarget:self action:@selector(Btn_ActionProduct:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_distance=[[UIButton alloc]initWithFrame:CGRectMake( 110.0, 0.0, 100.0, 40.0)];
        [btn_distance setTag:102];
        [btn_distance.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [btn_distance setTitle:@"降价宝贝" forState:UIControlStateNormal];
        [btn_distance setTitleColor:[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_distance addTarget:self action:@selector(Btn_ActionProduct:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_Editor=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-70.0, 0.0, 70.0, 40.0)];
        [btn_Editor setTag:103];
        [btn_Editor.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [btn_Editor setTitle:@"编辑" forState:UIControlStateNormal];
        [btn_Editor setTitleColor:[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_Editor setTitleColor:[UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [btn_Editor addTarget:self action:@selector(Btn_ActionProduct:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view_line=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth-80.0, 5.0, 1.0, 30.0)];
        [view_line setBackgroundColor:[UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0 ]];
        
        [_topView_Product addSubview:btn_defualt];
        [_topView_Product addSubview:btn_distance];
        [_topView_Product addSubview:btn_Editor];
        [_topView_Product addSubview:view_line];
    }
    return _topView_Product;
}
-(UIView *)topView_Farm{
    if (!_topView_Farm) {
        _topView_Farm=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth, 0.0, kDeviceWidth, 40.0)];
        [_topView_Farm setBackgroundColor:kClassTabBgColor];
        UIButton *btn_defualt=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 100.0, 40.0)];
        [btn_defualt setTag:101];
        [btn_defualt setTitle:@"默认排序" forState:UIControlStateNormal];
        [btn_defualt.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [btn_defualt setTitleColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_defualt addTarget:self action:@selector(Btn_ActionFarm:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_distance=[[UIButton alloc]initWithFrame:CGRectMake( 110.0, 0.0, 100.0, 40.0)];
        [btn_distance setTag:102];
        [btn_distance.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [btn_distance setTitle:@"距离排序" forState:UIControlStateNormal];
        [btn_distance setTitleColor:[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_distance addTarget:self action:@selector(Btn_ActionFarm:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn_Editor=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-70.0, 0.0, 70.0, 40.0)];
        [btn_Editor setTag:103];
        [btn_Editor.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [btn_Editor setTitle:@"编辑" forState:UIControlStateNormal];
        [btn_Editor setTitleColor:[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_Editor setTitleColor:[UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [btn_Editor addTarget:self action:@selector(Btn_ActionFarm:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view_line=[[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth-80.0, 5.0, 1.0, 30.0)];
        [view_line setBackgroundColor:[UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0 ]];
        
        [_topView_Farm addSubview:btn_defualt];
        [_topView_Farm addSubview:btn_distance];
        [_topView_Farm addSubview:btn_Editor];
        [_topView_Farm addSubview:view_line];
    }
    return _topView_Farm;
}


//加载产品列表
-(void)loadProductData{
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    [self.activityView1 startAnimation];
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KCollect_GoodsList_URL,pageIndex_product,uid,token ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];

    __block MyCollectionVC *weakSelf = self;
    
    
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
                        weakSelf.arry_ReduceProduct=[[NSMutableArray alloc]init];
                        if(pageIndex_product==1){
                            weakSelf.arry_AllProduct=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                            
                        }else{
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            [weakSelf.arry_AllProduct addObjectsFromArray:arry_Msg];
                        }
                        
                        for (NSDictionary *item in weakSelf.arry_AllProduct) {
                            NSString *old_priceStr=[item objectForKey:@"old_price"];
                            NSString *priceStr=[item objectForKey:@"price"];
                            float old_price=[old_priceStr floatValue];
                            float price=[priceStr floatValue];
                            if (old_price>price) {
                                [weakSelf.arry_ReduceProduct addObject:item];
                            }
                        }
                        weakSelf.arry_Product=weakSelf.arry_AllProduct;
                        
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
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];

        return;
    }
    [self.activityView2 startAnimation];
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];

    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KCollect_FarmList_URL,pageIndex_framDefualt,uid,token,latitude,longitude ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block MyCollectionVC *weakSelf = self;
    
    
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
                        if(pageIndex_framDefualt==1){
                            weakSelf.arry_defualtFarm=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];

                        }else{
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            [weakSelf.arry_defualtFarm addObjectsFromArray:arry_Msg];
                        }
                        
                    }
                    if(senderFarmTag==101){
                        weakSelf.arry_Farm=weakSelf.arry_defualtFarm;
                    }
                    pageIndex_framDefualt++;
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
//加载距离排序农场
-(void)loadFarmOrderData{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    [self.activityView2 startAnimation];
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    
    
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KCollect_FarmListOrder_URL,pageIndex_framOrder,uid,token,latitude,longitude ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block MyCollectionVC *weakSelf = self;
    
    
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
                        
                        if(pageIndex_framOrder==1){
                            weakSelf.arry_FarmOrder=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                            
                        }else{
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            [weakSelf.arry_FarmOrder addObjectsFromArray:arry_Msg];
                        }
                        
                    }
                    if(senderFarmTag==102){
                        weakSelf.arry_Farm=weakSelf.arry_FarmOrder;
                    }
                    pageIndex_framOrder++;
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
    if (sender.tag==103) {
        //
        EditorViewController *editor=[[EditorViewController alloc]init];
        editor.isProduct=YES;
        editor.arry_data=self.arry_Product;
        UINavigationController*navg=[[UINavigationController alloc]initWithRootViewController:editor];
        navg.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navg animated:YES completion:nil];
    }else{
        //修改 Btn样式
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        for (UIView *view in self.topView_Product.subviews) {
            if (![view isEqual:sender] && [view isKindOfClass:[UIButton class]]) {
                UIButton *btn=(UIButton *)view;
                [btn setTitleColor:[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
        senderFarmTag=(int)sender.tag;
        if (sender.tag==102) {
            //降价宝贝
             self.arry_Product=self.arry_ReduceProduct;
            
        }else if(sender.tag==101){
            //全部宝贝
            self.arry_Product=self.arry_AllProduct;
            
        }
        [self.productTableView reloadData ];
    }
}
#pragma mark 顶部 点击事件
-(void)Btn_ActionFarm:(UIButton *)sender{
    if (sender.tag==103) {
        //
        EditorViewController *editor=[EditorViewController shareInstance];
        editor.isProduct=NO;
        editor.arry_data=self.arry_Farm;
        UINavigationController*navg= [[UINavigationController alloc]initWithRootViewController:editor];
        navg.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navg animated:YES completion:nil];
    }else{
        //修改 Btn样式
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        for (UIView *view in self.topView_Farm.subviews) {
            if (![view isEqual:sender] && [view isKindOfClass:[UIButton class]]) {
                UIButton *btn=(UIButton *)view;
                [btn setTitleColor:[UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
        
        if (sender.tag==102) {
            //距离排序
            self.arry_Farm=self.arry_FarmOrder;
            
        }else if(sender.tag==101){
            //默认排序
            self.arry_Farm=self.arry_defualtFarm;
            
        }
        [self.farmTableview reloadData ];
    }
    
}
//排序
-(void)shortItemWithFarm{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    [self.arry_Farm sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

}

#pragma mark 退出
- (void)goDismiss :(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark segmentControl 下标变更事件
- (void)segmentControlAction:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex==0){
        //商品数据
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }else{
        //农场数据
        [self.scrollView setContentOffset:CGPointMake(kDeviceWidth, 0.0) animated:YES];
    }
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
    return  120 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.productTableView]){

        //商品数据
        ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCell forIndexPath:indexPath];
        if (self.arry_Product.count>indexPath.row) {
           NSDictionary *dic_item= self.arry_Product[indexPath.row];
            [cell setData_item:dic_item];
            cell.str_isEditor=@"0";
        }
        return cell;
    }else{

        //农场数据
        FarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFarmCell forIndexPath:indexPath];
        if (self.arry_Farm.count>indexPath.row) {
            NSDictionary *dic_item= self.arry_Farm[indexPath.row];
            [cell setData_item:dic_item];
            cell.str_isEditor=@"0";
        }
        return cell;
    }
}

#pragma mark tableView代理  行选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
