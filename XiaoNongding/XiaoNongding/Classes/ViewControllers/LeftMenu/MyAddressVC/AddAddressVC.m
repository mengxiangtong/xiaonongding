//
//  AddAddressVC.m
//  XiaoNongding
//
//  Created by admin on 15/12/24.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "AddAddressVC.h"
#import "HZAreaPickerView.h"
#import "NewLoginViewController.h"

@interface AddAddressVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, HZAreaPickerDelegate, UITextFieldDelegate>{
    BOOL isEditor;
    NSString *adress_id;
}


@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *telTextField;
@property (nonatomic, retain) UITextField *areaTextField;
@property (nonatomic, retain) UITextField *detailedTextField;

@property (retain, nonatomic) HZAreaPickerView *locatePicker;

@property (retain, nonatomic) NSString *areaValue, *cityValue;

//等待图标
@property (nonatomic, retain) UIXndActivityView *activityView;
@property (nonatomic, retain) HZLocation *locate;


@end

@implementation AddAddressVC{
    int pageIndex;
}


+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static AddAddressVC *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [AddAddressVC new];
    });
    
    return _sharedManager;
}

-(void)clearAllData{
    
    if (self.nameTextField) {
      self.nameTextField.text=@"";
    }
    if (self.telTextField) {
        self.telTextField.text=@"";
    }
    if (self.areaTextField) {
        self.areaTextField.text=@"";
    }
    if (self.detailedTextField) {
        self.detailedTextField.text=@"";
    }
    self.locate=nil;
    isEditor=NO;
}
-(void)setAllDataWithDic:(NSDictionary *)dic{
    if (self.nameTextField) {
        self.nameTextField.text=[dic objectForKey:@"name"];
    }
    if (self.telTextField) {
        self.telTextField.text=[dic objectForKey:@"phone"];
    }
    if (self.areaTextField) {
        self.areaTextField.text=[NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"province_txt"],[dic objectForKey:@"city_txt"],[dic objectForKey:@"area_txt"] ];
    }
    if (self.detailedTextField) {
        self.detailedTextField.text=[dic objectForKey:@"adress"];
    }
    self.locate=[[HZLocation alloc]init];
    self.locate.province=[dic objectForKey:@"province_txt"];
    self.locate.provinceId=[dic objectForKey:@"province"];
    self.locate.city=[dic objectForKey:@"city_txt"];
    self.locate.cityId=[dic objectForKey:@"city"];
    self.locate.area=[dic objectForKey:@"area_txt"];
    self.locate.areaId=[dic objectForKey:@"area"];
    adress_id=[dic objectForKey:@"adress_id"];
    isEditor=YES;
}

#pragma mark -  lan_jia_zai

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 30)];
        _nameTextField.placeholder = @"收货人姓名";
        _nameTextField.clearButtonMode   = UITextFieldViewModeWhileEditing;
        _nameTextField.delegate = self;
        _nameTextField.tag = 5001;
    }
    return _nameTextField;
    
}

- (UITextField *)telTextField
{
    if (!_telTextField) {
        _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 30)];
        _telTextField.placeholder = @"手机号";
        _telTextField.clearButtonMode   = UITextFieldViewModeWhileEditing;
        _telTextField.delegate = self;
        _telTextField.tag = 5002;

    }
    return _telTextField;
    
}

- (UITextField *)areaTextField
{
    if (!_areaTextField) {
        _areaTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 30)];
        _areaTextField.placeholder = @"省, 市, 区";
        _areaTextField.delegate = self;
        _areaTextField.clearButtonMode   = UITextFieldViewModeWhileEditing;
        _areaTextField.tag = 5003;

        //_areaTextField.text = @"省  市  区";
    }
    return _areaTextField;
    
}

- (UITextField *)detailedTextField
{
    if (!_detailedTextField) {
        _detailedTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kDeviceWidth-40, 30)];
        _detailedTextField.placeholder = @"详细地址";
        _detailedTextField.clearButtonMode   = UITextFieldViewModeWhileEditing;
        _detailedTextField.delegate = self;
        _detailedTextField.tag = 5004;

    
    }
    return _detailedTextField;
    
}
-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}


- (void)goDismiss :(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];

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
-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64-50*4 -20)];
    view.backgroundColor =RGBACOLOR(237, 243, 244, 1);
    
    //温馨提示
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    l.textColor = kCellLineColor;
    l.backgroundColor = [UIColor clearColor];
    l.text = @"温馨提示：点击右上角“保存”按钮，可以保存哟！";
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:13];
    [view addSubview:l];
    
    
    [tableView setTableFooterView:view];
}

- (void)setUpTableView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64) style:UITableViewStylePlain] ;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; // 分割线
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_tableView];
    [self setExtraCellLineHidden:self.tableView];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"allordercelll"];
    
    
    //右
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
        
    }
    //左
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


- (void)setUpNavViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"添加地址"];
    
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
    });
    
    // 右
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
        save.tintColor = [UIColor whiteColor];
        save;
    });
    

}


#pragma mark - 点击 保存
- (void)saveAction
{
    if ( [self.nameTextField.text absoluteString].length == 0) {   // 去掉两边空格
        [XNDProgressHUD showWithStatus:@"收货人不能为空" duration:1.0];
        return;
    }
    
    if ( [self.telTextField.text absoluteString].length == 0) {   // 去掉两边空格
        [XNDProgressHUD showWithStatus:@"手机号码不能为空" duration:1.0];
        return;
    }
    
    if ( [self.areaTextField.text absoluteString].length == 0) {   // 去掉两边空格
        [XNDProgressHUD showWithStatus:@"省，市，区不能为空" duration:1.0];
        return;
    }
    
    if ( [self.detailedTextField.text absoluteString].length == 0) {   // 去掉两边空格
        [XNDProgressHUD showWithStatus:@"详细地址不能为空" duration:1.0];
        return;
    }
    BOOL isIncomplete=NO;
    if (!self.locate.cityId || [self.locate.cityId isEqualToString:@""]) {
        isIncomplete=YES;
    }
    if (isIncomplete==NO) {
        if(!self.locate.areaId || [self.locate.areaId isEqualToString:@""]){
            isIncomplete=YES;
            if ([self.locate.provinceId isEqualToString:@"3242"] || [self.locate.provinceId isEqualToString:@"3235"]) {
                
                isIncomplete=NO;
            }
        }
    }
    if (isIncomplete) {
        [XNDProgressHUD showWithStatus:@"地区选择不完整" duration:1.0];
        return;
    }
    
    
    
    [self requestSave];
    
    
}

- (void)requestSave
{
        
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        return;
    }
    [self.activityView startAnimation];
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KAddress_Add_URL,uid,token ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"POST"];
    NSString *bodyStr=[NSString stringWithFormat:@"area=%@&city=%@&province=%@&adress=%@&name=%@&phone=%@",self.locate.areaId,self.locate.cityId,self.locate.provinceId,[self.detailedTextField.text absoluteString],[self.nameTextField.text absoluteString],[self.telTextField.text absoluteString]];
    if (isEditor==YES) {
        bodyStr=[NSString stringWithFormat:@"area=%@&city=%@&province=%@&adress=%@&name=%@&phone=%@&adress_id=%@",self.locate.areaId,self.locate.cityId,self.locate.provinceId,[self.detailedTextField.text absoluteString],[self.nameTextField.text absoluteString],[self.telTextField.text absoluteString],adress_id];
    }
    NSData *bodyData= [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    
    
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                       self.nameTextField.text=@"";
                        self.telTextField.text=@"";
                        self.areaTextField.text=@"";
                        self.detailedTextField.text=@"";
                        self.locate=nil;
                        [self.navigationController popViewControllerAnimated:YES];
                    });
             
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XNDProgressHUD showWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                        
                    });
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageIndex=1;
    
    [self setUpNavViews];
    
    
    [self setUpTableView];
    [self.view addSubview:self.activityView];
   
    
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
}



-(void)setAreaValue:(NSString *)areaValue
{
    if (![_areaValue  isEqualToString:areaValue]) {
        _areaValue = areaValue ;
        self.areaTextField.text = areaValue;
    }
}



#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.province, picker.locate.city, picker.locate.area];
        
    } else{
        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.province, picker.locate.city];
    }
    self.locate=picker.locate;
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}


#pragma mark - TextField delegate

//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.areaTextField]) {
        
        [self cancelLocatePicker];
        
        self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self] ;
        [self.locatePicker showInView:self.view];
        
        [self.telTextField resignFirstResponder];

        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.nameTextField  resignFirstResponder];
    [self.telTextField resignFirstResponder];
    [self.areaTextField resignFirstResponder];
    [self.detailedTextField resignFirstResponder];
    
    
    [UIView animateWithDuration:0.01 animations:^{
        self.view.frame = CGRectMake(0, 64, kDeviceWidth, KDeviceHeight);
        
    } ];
    
    return YES;
    
}

// called when 'return' key pressed. return NO to ignore.


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (KDeviceHeight > 480) {
        return;
    }
    

    if (textField.tag == 5004) {
        [UIView animateWithDuration:0.5 animations:^{
                self.view.frame = CGRectMake(0, -15, kDeviceWidth, KDeviceHeight);
    
            }];
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
   // [self cancelLocatePicker];
}


#pragma mark - UITableView  代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}
//Header 高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    v.backgroundColor = RGBACOLOR(237, 243, 244, 1);
    return v;
}



//将要绘制cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //右边分割线间距
        [cell setSeparatorInset:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

#pragma mark -
#pragma mark - Tableview 数据源


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allordercelll" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.nameTextField];
        
    }else if (indexPath.row == 1)
    {
        [cell.contentView addSubview:self.telTextField];
        
    }else if (indexPath.row == 2)
    {
        [cell.contentView addSubview:self.areaTextField];
        
    }else if (indexPath.row == 3)
    {
        [cell.contentView addSubview:self.detailedTextField];
        
    }
   
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
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
