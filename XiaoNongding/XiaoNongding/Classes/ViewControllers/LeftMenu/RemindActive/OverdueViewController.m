//
//  OverdueViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/22.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "OverdueViewController.h"
#import "OverActiveTableViewCell.h"
#import "NewLoginViewController.h"

@interface OverdueViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , retain) UIView *bgView_NoData;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *arry_data;

@property (nonatomic, retain) UIXndActivityView *activityView;

@end

@implementation OverdueViewController{
    int pageIndex;
}

+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static OverdueViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OverdueViewController new];
    });
    
    return _sharedManager;
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-64-44) style:UITableViewStylePlain] ;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        
        [_tableView registerClass:[OverActiveTableViewCell class] forCellReuseIdentifier:KOverActiveTableViewCell];
        __weak typeof(self) weakself = self;
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            pageIndex=1;
//            [self.activityView startAnimation];
            [weakself loadData];
        }];
        weakself.tableView.header.autoChangeAlpha = YES;
        weakself.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{[weakself loadData];}];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    pageIndex=1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView setBackgroundView: self.bgView_NoData ];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityView];
    [self.activityView startAnimation];
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}

#pragma mark - 数据加载
-(void)loadData{
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KActivity_JoinEndActivities_URL,pageIndex,uid,token,latitude,longitude ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block OverdueViewController *weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activityView stopAnimation];
            [weakSelf.tableView.header endRefreshing];
            [weakSelf.tableView.footer endRefreshing];
        });
     
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    if(dict.count>0){
                        if(pageIndex==1){
                            weakSelf.arry_data=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                            
                        }else{
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            [weakSelf.arry_data addObjectsFromArray:arry_Msg];
                        }
         
                    }
                    pageIndex++;
                    
                }                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:@"网络链接中断" duration:1.0];
                    
                });
            }
            
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
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
    return  200 ;
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
    return self.arry_data.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OverActiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KOverActiveTableViewCell forIndexPath:indexPath];
    
    cell.dic_Item=self.arry_data[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
