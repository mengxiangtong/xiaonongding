//
//  RegisterViewController.m
//  LanKe
//
//  Created by admin on 15/8/15.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "Register3ViewController.h"
#import "NSString+StringTool.h"
#import "NewLoginViewController.h"
#import "Register2ViewController.h"

#import "ResetPWViewController.h"


@interface NewLoginViewController ()<UITextFieldDelegate>
{
    CGFloat btnMaxY;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Avatar;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;

@property(nonatomic,retain) AFHTTPRequestOperationManager *manager_authentication;//登录认证


@end

@implementation NewLoginViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)findPassword:(id)sender {
    
    ResetPWViewController *vc = [[ResetPWViewController alloc] initWithNibName:@"ResetPWViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}



+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static NewLoginViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NewLoginViewController new];
    });
    
    return _sharedManager;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBlackBgColor;
    
    self.navigationController.navigationBarHidden = YES;
   
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    

    self.heardImageView.layer.masksToBounds = YES;
    self.heardImageView.layer.cornerRadius = 45;

    
    

    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 2;
    
    [self.phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    //设置placeholder 颜色
    // 利用KVC设置它颜色,结果成功
    UILabel *label = [self.phoneTextField valueForKeyPath:@"_placeholderLabel"];
    label.textColor = kTextPlaceHolderColor;

    UILabel *label1 = [self.passwordTextField valueForKeyPath:@"_placeholderLabel"];
    label1.textColor = kTextPlaceHolderColor;
    
    // Do any additional setup after loading the view from its nib.
}


//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    // 设置富文本属性
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.phoneTextField.font;
    dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
    CGPoint point = CGPointMake(0, (rect.size.height - self.phoneTextField.font.lineHeight) * 0.5);
    
    [self.phoneTextField.placeholder drawAtPoint:point withAttributes:dictM];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self.phoneTextField setText:@""];
    [self.passwordTextField setText:@""];
    NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (userInfo) {
        [self.phoneTextField setText:[userInfo objectForKey:@"phone"]];
        
    }
    
}



- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.passwordTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];

    
}

- (IBAction)goCusstomDismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];

}


- (void)goDismiss :(id)sender
{

    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    //
}


//  完成
- (IBAction)registerBtnAction:(id)sender {
    
    [self.passwordTextField resignFirstResponder];
     [self.phoneTextField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
    
    //点击登陆
    [self loadAuthenticationData];
}

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
    _manager_authentication.requestSerializer.timeoutInterval = KHTTPTimeoutInterval;
    
    NSMutableDictionary * parameters =[NSMutableDictionary dictionaryWithCapacity:2];
    [parameters  setObject:self.phoneTextField.text.absoluteString forKey:@"mobile"];
    [parameters  setObject:[NSString_MD5 MD5EncryptBy32:self.passwordTextField.text.absoluteString ] forKey:@"pwd"];
    [parameters setObject:@"1" forKey:@"encrypt"];
    [parameters  setObject:@"1" forKey:@"is_mobile"];
    __weak typeof(self) weakSelf = self;
    [self.manager_authentication POST:K_URL_LOGIN parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        
        weakSelf.manager_authentication = nil;
        
        weakSelf.view.userInteractionEnabled =YES;
        id cacheDic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:nil];
        
        NSString *state =[NSString stringWithFormat:@"%d",[[cacheDic objectForKey:@"status"] intValue]];
        
        if ([state isEqualToString:@"1"])//登录成功
        {
            NSDictionary *dic_userInfo =[[NSDictionary alloc] initWithDictionary:[cacheDic objectForKey:@"msg"] ];
            if (dic_userInfo && ![dic_userInfo isEqual:[NSNull null]]) {
                [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionCloseViewController object:nil];
            }
            
        }else{
            NSString *msg =[NSString stringWithFormat:@"%@",[cacheDic objectForKey:@"errorMsg"]];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    
    [self.passwordTextField resignFirstResponder];

    
    [UIView animateWithDuration:0.01 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
    
    
    return YES;
}

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
    /////////////
    if (textField.tag == 2120) {
        [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, -10, kDeviceWidth, KDeviceHeight);
            
        } ];
    }

    if (textField.tag == 2121) {
        [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, -40, kDeviceWidth, KDeviceHeight);

        } ];
    }
    
    if (textField.tag == 2122) {
        [UIView animateWithDuration:0.01 animations:^{
            self.view.frame = CGRectMake(0, -80, kDeviceWidth, KDeviceHeight);
            
        }];
    }

    
    
    
}
// became first responder



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
