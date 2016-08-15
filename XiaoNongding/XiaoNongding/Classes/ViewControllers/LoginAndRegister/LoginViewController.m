//
//  LoginViewController.m
//  LanKe
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "LoginViewController.h"
#include "RegisterViewController.h"
#import "ResetPWViewController.h"
#import "NSString+StringTool.h"


#define kTimeOutValue  10.0

@interface LoginViewController ()<UITextFieldDelegate>
{
    CGFloat btnMaxY;
}

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;



//
@property(nonatomic,retain) AFHTTPRequestOperationManager *manager_authentication;//登录认证




@end

@implementation LoginViewController

+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static LoginViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [LoginViewController new];
    });
    
    return _sharedManager;
}



- (UIButton *)registerBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
   // btn.backgroundColor = [UIColor cyanColor];
    btn.titleLabel.text =@"注册" ;
    [btn setTitle:@"注册" forState: UIControlStateNormal ];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //黑色背景
    self.view.backgroundColor = [UIColor whiteColor];

    //左侧添加  (语法糖)
    self.navigationItem.rightBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self registerBtn]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    
    
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 40;

    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 2;

    btnMaxY = CGRectGetMaxY(_loginBtn.frame);
    NSLog(@"  btnMaxY   %f ",   btnMaxY);

}





- (void)keyboardWillShow:(NSNotification *)notif {
    
    //键盘位置
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y - 10;
    
    //上移 距离
    CGFloat h =   fabs(btnMaxY - y) ; //绝对值
    self.view.center = CGPointMake(kDeviceWidth/2, KDeviceHeight/2 - h);
    
    
}


- (void)keyboardWillHide:(NSNotification *)notif {
    
    self.view.center = CGPointMake(kDeviceWidth/2, KDeviceHeight/2 +32);
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.passwordTextField resignFirstResponder];
}


//登录
- (IBAction)loginBtnAction:(id)sender {
    
    //登录 请求
    [self loadAuthenticationData];

}


- (void)checkInfo
{
}



#pragma mark-httpRequest 登陆请求
- (void)loadAuthenticationData
{
    
    //电话号为空
    if (self.phoneTextField.text.absoluteString.length == 0  ) {
        //添加晃动动画
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 2;
        anim.values = @[@-10, @10, @-10];
        anim.duration = 0.2;
        [self.phoneTextField.layer addAnimation:anim forKey:nil];
        
        return;
    }
    
    //密码为空
    if (self.passwordTextField.text.absoluteString.length==0) {
        //添加晃动动画 （关键帧）
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 2;
        anim.values = @[ @-10, @10, @-10 ];
        anim.duration = 0.2;
        [self.passwordTextField.layer addAnimation:anim forKey:nil];
        return;
    }

    
    _manager_authentication =nil;
    [SVProgressHUD  showWithStatus:@"登录中"];
    self.view.userInteractionEnabled = NO;
    
    
    _manager_authentication = [AFHTTPRequestOperationManager manager];
    _manager_authentication.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _manager_authentication.requestSerializer.timeoutInterval = kTimeOutValue;
    
    NSMutableDictionary * parameters =[NSMutableDictionary dictionaryWithCapacity:2];
    [parameters  setObject:self.phoneTextField.text.absoluteString forKey:@"mobile"];
    [parameters  setObject:[NSString_MD5 MD5EncryptBy32: self.passwordTextField.text.absoluteString ] forKey:@"pwd"];
    [parameters  setObject:@"1" forKey:@"is_mobile"];
    [parameters setObject:@"1" forKey:@"encrypt"];
    __weak typeof(self) weakSelf = self;
    [self.manager_authentication POST:K_URL_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSLog(@"登录 请求 成功 ");
        weakSelf.manager_authentication = nil;
        
        weakSelf.view.userInteractionEnabled =YES;
        id cacheDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:nil];

        NSString *state =[NSString stringWithFormat:@"%d",[[cacheDic objectForKey:@"status"] intValue]];
        
        if ([state isEqualToString:@"1"])//登录成功
        {
             NSDictionary *dic_userInfo =[[NSDictionary alloc] initWithDictionary:[cacheDic objectForKey:@"msg"] ];
            if (dic_userInfo && ![dic_userInfo isEqual:[NSNull null]]) {
                [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
            }
       
        }else{
             NSString *msg =[NSString stringWithFormat:@"%@",[cacheDic objectForKey:@"msg"]];
            if (!msg || [msg isEqual:[NSNull null]]) {
                msg=@"登录失败, 请重试";
            }
            
            [XNDProgressHUD showWithStatus:msg duration:3.0];
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@" 登录请求失败  Error: %@", error);
        [SVProgressHUD dismiss];

        _manager_authentication = nil;
        self.view.userInteractionEnabled = YES;
        [XNDProgressHUD showWithStatus:@"网络拥堵, 请重试" duration:3.0];
        
    }];
}


- (IBAction)dianzhangguiLogin:(id)sender {
    
    //登录 请求
    [self loadAuthenticationData];
    
    
}




- (IBAction)findPasswordBtnAction:(id)sender {
   
    ResetPWViewController * resignC=[ResetPWViewController shareInstance];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:resignC];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self presentViewController:nc animated:NO completion:nil];
    
    
}





- (void)goDismiss :(id)sender
{
    NSLog(@" 进入 注册   ");
   // [self.view endEditing:YES];
    
    RegisterViewController * resignC=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:resignC animated:YES];
    //
}


#pragma mark - 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1001 ) {
        NSLog(@"  编辑 ");
        
        self.loginBtn.hidden = NO;
        self.findPasswordBtn.hidden = NO;
    }

}// became first responder


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called




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
