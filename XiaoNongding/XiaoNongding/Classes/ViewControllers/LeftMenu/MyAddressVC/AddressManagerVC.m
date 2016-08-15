//
//  AddressManagerVC.m
//  XiaoNongding
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "AddressManagerVC.h"
#import "AddAddressVC.h"
#import "AddressTableViewCell.h"
#import "NewLoginViewController.h"

@interface AddressManagerVC ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic , retain) UIView *bgView_NoData;

@property (nonatomic, retain) UIImageView *emptyImageView;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIView *bottomView;

@property (nonatomic, retain) NSMutableArray *arry_data;

//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView;

@end

@implementation AddressManagerVC{
    int pageIndex;
}


+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static AddressManagerVC *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [AddressManagerVC new];
    });
    
    return _sharedManager;
}

- (void)goDismiss :(id)sender
{
    NSLog(@"   000  fan hui   ");
    [self dismissViewControllerAnimated:YES completion:nil];
    //
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


#pragma mark - 懒加载
- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, (kDeviceWidth/2)*570/353) ];
        _emptyImageView.image = [UIImage imageNamed:@"empty_address.jpg"];
        _emptyImageView.center = CGPointMake(kDeviceWidth/2, kDeviceWidth*128/320);
        _emptyImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAddress)];
        [_emptyImageView addGestureRecognizer:tap];
        
    }
    return _emptyImageView;
}

-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}


-(NSMutableArray *)arry_data{
    if (!_arry_data) {
        _arry_data=[[NSMutableArray alloc]init];
    }
    return _arry_data;
}


#pragma mark -
- (void)addAddress
{
    AddAddressVC *vc = [AddAddressVC shareInstance];
    [vc clearAllData];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) gotoEditAction :(id)sender
{
    AddAddressVC *vc = [AddAddressVC shareInstance];
    [vc clearAllData];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void) gotoDeleteAction :(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您确定要删除该地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //删除地址
        
    }
    
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KDeviceHeight-50-64, kDeviceWidth, 51)];
        _bottomView.layer.borderColor = [kGrayBg_219Color CGColor] ;
        _bottomView.layer.borderWidth = 0.5;
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"add_address.jpg"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"add_address.jpg"] forState:UIControlStateHighlighted];
        
        addBtn.frame = CGRectMake(0, 0, 40*255/65, 40);
        addBtn.center = CGPointMake(kDeviceWidth/2, 25);
        
        [addBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:addBtn];
        
    }
    
    return _bottomView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    pageIndex=1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"地址管理"];
    
    //左侧添加  BarButtonItem
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
    });
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64-50) style:UITableViewStylePlain] ;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 分割线
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"addressCell"];
    
    __weak typeof(self) weakself = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageIndex=1;
//        [self.activityView startAnimation];
        [weakself loadAddressData];
    }];
    weakself.tableView.header.autoChangeAlpha = YES;
    [self.tableView setBackgroundView:self.bgView_NoData];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.activityView];
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pageIndex=1;
    [self loadAddressData];//获取地址数据
    
}
-(void)RefreshAddressData{
    pageIndex=1;
    [self loadAddressData];
}
//加载地址列表
-(void)loadAddressData{
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    [self.activityView startAnimation];
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KAddress_List_URL,pageIndex,uid,token ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block AddressManagerVC *weakSelf = self;
    
    
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
                        if(pageIndex==1){
                            weakSelf.arry_data=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"msg"]];
                            
                        }else{
                            NSMutableArray *arry_Msg= [dict objectForKey:@"msg"];
                            [weakSelf.arry_data addObjectsFromArray:arry_Msg];
                        }
                    }
                    pageIndex++;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView setHidden:NO];
                        [self.emptyImageView setHidden:YES];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView setHidden:YES];
                        [self.emptyImageView setHidden:NO];
                       
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:@"网络链接中断" duration:1.0];
                    [self.tableView setHidden:YES];
                    [self.emptyImageView setHidden:NO];
                    
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
    return  140 ;
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
    
    AddressTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
    [cell setDic_item:self.arry_data[indexPath.row]];
    
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
