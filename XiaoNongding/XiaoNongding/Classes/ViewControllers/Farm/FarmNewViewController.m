//
//  MyCollectionVC.m
//  XiaoNongding
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "FarmNewViewController.h"
#import "TodayTableViewCell.h"
#import "SearchFarmTableViewCell.h"
#import "UIWebViewViewController.h"

@interface FarmNewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain)  UITableView *farmTableview;
//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView;

@property (nonatomic, retain) NSMutableArray *RecommendDataArray;
//数据类
@property (nonatomic, retain) NSMutableArray *arry_Farm;
@property (nonatomic , retain) UIView *bgView_NoData;

@end

@implementation FarmNewViewController{

    int pageIndex_fram;

}


-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}
#pragma mark - ###界面###

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex_fram=1;



    //标题

    [self.view addSubview:self.farmTableview];
    [self.farmTableview setBackgroundView:self.bgView_NoData];
    [self.view addSubview:self.activityView];
    [self loadFarmData];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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


#pragma mark 搜索框的代理方法


- (UITableView *)farmTableview
{
    
    if (!_farmTableview) {
        _farmTableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, self.view.height-64.0) style:UITableViewStylePlain] ;
        _farmTableview.showsVerticalScrollIndicator = NO;
        _farmTableview.dataSource = self;
        _farmTableview.delegate = self;
        _farmTableview.backgroundColor = [UIColor whiteColor   ];
        _farmTableview.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        [_farmTableview registerClass:[SearchFarmTableViewCell class] forCellReuseIdentifier:KSearchFarmTableViewCell];
        _farmTableview.rowHeight=150.0;
        
     
        
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

-(UIView *)bgView_NoData{
    if (!_bgView_NoData) {
        _bgView_NoData=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.farmTableview.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData addSubview:img];
    }
    return _bgView_NoData;
}

//加载默认农场列表
-(void)loadFarmData{
    [self.activityView startAnimation];
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    NSString *uid=@"";
    NSString *token=@"";
    if (dic_userInfo) {
        uid=[dic_userInfo objectForKey:@"uid"];
        token=[dic_userInfo objectForKey:@"token"];
    }
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=@"";
    NSString *longitude=@"";
    if (dicInfo) {
        latitude=[dicInfo objectForKey:@"latitude"];
        longitude=[dicInfo objectForKey:@"longitude"];
    }
 
    NSURL *url = [NSURL URLWithString: [[NSString stringWithFormat: KFarm_List_URL,latitude,longitude,pageIndex_fram,uid,token ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block FarmNewViewController *weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityView stopAnimation];
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
   
        return self.arry_Farm.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        NSDictionary *dic_item= self.arry_Farm[indexPath.row];
        
        return  [SearchFarmTableViewCell cellHeightWithContact:dic_item]; ;
    
    return 200.0;
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
    
        //农场数据
        SearchFarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSearchFarmTableViewCell forIndexPath:indexPath];
    
            NSDictionary *dic_item= self.arry_Farm[indexPath.row];
            [cell setData_item:dic_item];
        
        return cell;
    
}


#pragma mark tableView代理  行选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取URL  执行操作

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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
          return [[UIView alloc]initWithFrame:CGRectZero];
    
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
