//
//  IntegralViewController.m
//  XiaoNongding
//
//  Created by jion on 16/2/25.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "IntegralViewController.h"
#import "IntegralTableViewCell.h"

@interface IntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView   *tableView;
@property (nonatomic , retain) UIView *bgView_NoData;
@property (nonatomic, retain) NSMutableArray       *dataSuource;

@property (nonatomic, retain) UIXndActivityView *activityView;
@end

@implementation IntegralViewController{
    int pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex=1;
    
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"积分列表"];
    
    //左侧添加
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
    });

    
    
     [self.tableView setBackgroundView:self.bgView_NoData];
    
     [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0];
        _tableView.separatorColor = [UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0];
        [_tableView registerNib:[UINib nibWithNibName:@"IntegralTableViewCell" bundle:nil] forCellReuseIdentifier:@"IntegralTableViewCell"];
        
        
    }
    return _tableView;
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
#pragma mark - Table 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSuource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntegralTableViewCell *cell=(IntegralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IntegralTableViewCell"];
    if (!cell) {
        cell=[[IntegralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntegralTableViewCell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.data_item=[self.dataSuource objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.row!=1) {
    //        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该模块尚未开放" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
}
- (void)goDismiss :(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES ];
    //
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

-(void)loadData{
        
        
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            return;
        }
    [self.activityView startAnimation];
        NSString *uid=[dic_userInfo objectForKey:@"uid"];
        NSString *token=[dic_userInfo objectForKey:@"token"];
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KUser_getPoint_URL,pageIndex,uid,token ] ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
        request.timeoutInterval=KHTTPTimeoutInterval;
        [request setHTTPMethod:@"GET"];
        
        
        __block IntegralViewController *weakSelf = self;
        
        
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
                            weakSelf.dataSuource=[[NSMutableArray alloc]initWithArray: [dict objectForKey:@"msg"]];
                        }else{
                            [weakSelf.dataSuource addObjectsFromArray:[dict objectForKey:@"msg"]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
