//
//  ResetPWViewController.m
//  LanKe
//
//  Created by admin on 15/8/17.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "ResetPWViewController.h"
#import "NSString+StringTool.h"



@interface ResetPWViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;



@property (weak, nonatomic) IBOutlet UILabel *hudLabel;



@property (weak, nonatomic) IBOutlet UIImageView *imageView;





@end

@implementation ResetPWViewController


+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static ResetPWViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ResetPWViewController new];
    });
    
    return _sharedManager;
}


- (IBAction)goBack:(id)sender {
    
          [self.navigationController popViewControllerAnimated:NO];
    
}


- (UIButton *)getBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
    // btn.backgroundColor = [UIColor yellowColor];
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kBlackBgColor;
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        /*
         UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navi_back_hl"] style:UIBarButtonItemStyleDone target:self action:@selector(goDismiss:)];
         cancelBarButtonItem.tintColor = [UIColor whiteColor];
         cancelBarButtonItem;*/
        
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
        
    });
    [self.phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.codeTextField setKeyboardType:UIKeyboardTypeNumberPad];

    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 45;
    
    
    self.getCodeBtn.layer.masksToBounds = YES;
    self.getCodeBtn.layer.cornerRadius = 2;
    
    self.submitBtn .layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 2;
    
    
    //设置placeholder 颜色
    // 利用KVC设置它颜色,结果成功
    
    UILabel *label = [self.codeTextField valueForKeyPath:@"_placeholderLabel"];
    label.textColor = kTextPlaceHolderColor;
    
    UILabel *label1 = [self.phoneTextField valueForKeyPath:@"_placeholderLabel"];
    label1.textColor = kTextPlaceHolderColor;
    
    UILabel *label2 = [self.passwordTextField valueForKeyPath:@"_placeholderLabel"];
    label2.textColor = kTextPlaceHolderColor;

    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.passwordTextField  resignFirstResponder];
    
    [UIView animateWithDuration:0.01 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
    
}

- (void)goDismiss :(id)sender
{
    NSLog(@" 返回   ");

    [self.navigationController popViewControllerAnimated:NO];
//    
}

//获取验证码
- (IBAction)getCodeBtnAction:(id)sender {
    //判断 输入转让框 非空
    if (self.phoneTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.phoneTextField.layer addAnimation:anim forKey:nil];
        return;
    }
    if (![Tooles isMobileNumber:self.phoneTextField.text]) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.phoneTextField.layer addAnimation:anim forKey:nil];
        
        [XNDProgressHUD showWithStatus:@"格式错误" duration:1.0];
        return;
    }

    __weak typeof(self) weakSelf = self;
    //关闭按钮
    self.getCodeBtn.enabled = NO;
    [self.getCodeBtn setTitle:@"验证码(60)" forState:UIControlStateDisabled];
    
    
    //构造参数
    NSMutableDictionary *dicParameter = [NSMutableDictionary dictionary];
    
    [dicParameter  setObject:self.phoneTextField.text forKey:@"mobile"];//电话号
    
    
    //
    AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    afManager.requestSerializer.timeoutInterval = KHTTPTimeoutInterval;
    
    [afManager POST:KAppSendNewVerifyCode_URL parameters:dicParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"status"] intValue]==1) { //返回正确信息  发送短信
            
            
            //倒计时时间
            __block int timeout = 60;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            
            dispatch_source_set_event_handler(_timer, ^{
                
                if(timeout<=0){ //倒计时结束，关闭
                    
                    dispatch_source_cancel(_timer);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置界面的按钮显示 根据自己需求设置
                        weakSelf.getCodeBtn.enabled = YES;
                        [weakSelf.getCodeBtn setTitle: @"获取验证码" forState:UIControlStateNormal];
                    });
                }
                else
                {
                    //            int minutes = timeout / 60;
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.0d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //设置界面的按钮显示 根据自己需求设置
                        weakSelf.getCodeBtn.enabled = NO;
                        weakSelf.getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                        
                        if (strTime.length == 0) {
                            [self.getCodeBtn setTitle:[NSString stringWithFormat:@"验证码(60)"] forState:UIControlStateDisabled];
                        }
                        else
                        {
                            [self.getCodeBtn setTitle:[NSString stringWithFormat:@"验证码(%@)",strTime] forState:UIControlStateDisabled];
                            
                        }
                        
                    });
                    
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        }
        else // 错误
        {
            
            [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"errorMsg"] duration:1.0];
            
            weakSelf.getCodeBtn.enabled = YES;
            [weakSelf.getCodeBtn setTitle: @"获取验证码" forState:UIControlStateNormal];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        weakSelf.getCodeBtn.enabled = YES;
        [weakSelf.getCodeBtn setTitle: @"获取验证码" forState:UIControlStateNormal];
        
    }];

}


//提交
- (IBAction)submitBtnAction:(id)sender {
    //判断 输入转让框 非空
    if (self.phoneTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.phoneTextField.layer addAnimation:anim forKey:nil];
        return;
    }
    if (![Tooles isMobileNumber:self.phoneTextField.text]) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.phoneTextField.layer addAnimation:anim forKey:nil];
        
        [XNDProgressHUD showWithStatus:@"格式错误" duration:1.0];
        return;
    }

    //判断 输入转让框 非空
    if (self.codeTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.codeTextField.layer addAnimation:anim forKey:nil];
        
        [XNDProgressHUD showWithStatus:@"请输入验证码" duration:1.0];
        return;
    }
    
    //判断 输入转让框    密码  非空
    if (self.passwordTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.passwordTextField.layer addAnimation:anim forKey:nil];
        
        [XNDProgressHUD showWithStatus:@"请输入密码" duration:1.0];
        return;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
    

    //开始提交
    [self submitRequest];
    
}


- (void)submitRequest
{
    [SVProgressHUD showWithStatus:@"密码重置中"];
    
    //发送请求
    NSString *urlString =[NSString stringWithFormat:KUser_forgetPwd_URL];
    ////数据请求地
    NSMutableDictionary *dicParameter = [NSMutableDictionary dictionary];
    
    [dicParameter  setObject:self.phoneTextField.text forKey:@"mobile"];//电话号
    [dicParameter  setObject:[NSString_MD5 MD5EncryptBy32:self.passwordTextField.text.absoluteString ] forKey:@"pwd"];
    [dicParameter setObject:@"1" forKey:@"encrypt"];
    [dicParameter  setObject:self.codeTextField.text forKey:@"verify_code"];//密码
    
    //
    AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    afManager.requestSerializer.timeoutInterval = KHTTPTimeoutInterval;
    
    __weak ResetPWViewController *weakSelf = self;
    [afManager POST:urlString parameters:dicParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        weakSelf.view.userInteractionEnabled =YES;
        id cacheDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:nil];
        
        NSString *state =[NSString stringWithFormat:@"%d",[[cacheDic objectForKey:@"status"] intValue]];
        
        if ([state isEqualToString:@"1"])//成功
        {
            NSDictionary *dic_userInfo =[[NSDictionary alloc] initWithDictionary:[cacheDic objectForKey:@"msg"] ];
            if (dic_userInfo && ![dic_userInfo isEqual:[NSNull null]]) {
                [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                [self dismissViewControllerAnimated:YES completion:nil];
                 [SVProgressHUD showSuccessWithStatus:@"密码修改成功" duration:1.0];
            }
            
        }else{
            NSString *msg =[NSString stringWithFormat:@"%@",[cacheDic objectForKey:@"errorMsg"]];
            if (!msg || [msg isEqual:[NSNull null]]) {
                msg=@"密码重置失败，请重试";
            }
            
            [XNDProgressHUD showWithStatus:msg duration:1.0];
            return;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *msg =@"密码重置失败，请重试";
        
        [XNDProgressHUD showWithStatus:msg duration:1.0];

        
    }];

    
    
}



- (void)resetViews
{
    // 按钮 tag =＝ 8888
    
    for (UIView *v in self.view.subviews) {
     
        v.hidden = YES;
        
        if (v.tag != 8888) {
           // [v removeFromSuperview];

        }
    }
    
    self.hudLabel.hidden = NO;
    
}

#pragma mark - 代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [self.passwordTextField  resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    
    
    [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
            
    } ];
    
    return YES;
    
}

// called when 'return' key pressed. return NO to ignore.


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (KDeviceHeight > 480) {
        return;
    }
    
    if (textField.tag == 2119) {
        [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
            
        } ];
    }
    
    if (textField.tag == 2120) {
        [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, -40, kDeviceWidth, KDeviceHeight);
            
        } ];
    }
    
    if (textField.tag == 2121) {
        [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, -70, kDeviceWidth, KDeviceHeight);
            
        } ];
    }
    
//    if (textField.tag == 2122) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.view.frame = CGRectMake(0, -80, kDeviceWidth, KDeviceHeight);
//            
//        }];
//    }
    
    
    
    
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
