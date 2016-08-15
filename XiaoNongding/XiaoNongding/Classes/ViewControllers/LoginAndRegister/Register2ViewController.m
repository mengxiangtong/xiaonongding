//
//  RegisterViewController.m
//  LanKe
//
//  Created by admin on 15/8/15.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "Register2ViewController.h"
#import "NSString+StringTool.h"
#import "Register3ViewController.h"
#import "NewLoginViewController.h"


@interface Register2ViewController ()<UITextFieldDelegate>
{
    CGFloat btnMaxY;
}

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;




@end

@implementation Register2ViewController





- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static Register2ViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [Register2ViewController new];
    });
    
    return _sharedManager;
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
    
//    self.codeTextField.keyboardType=UIKeyboardTypeNamePhonePad;
    
    self.view.backgroundColor = kBlackBgColor;
    
   

    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    

   // self.getCodeBtn.hidden = YES;
    self.getCodeBtn.layer.masksToBounds = YES;
    self.getCodeBtn.layer.cornerRadius = 2;
    
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 2;
    

    
    [self.getCodeBtn  setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    
    //设置placeholder 颜色
    // 利用KVC设置它颜色,结果成功
    UILabel *label = [self.codeTextField valueForKeyPath:@"_placeholderLabel"];
    label.textColor = kTextPlaceHolderColor;

    // Do any additional setup after loading the view from its nib.
}


//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect
{
    // 设置富文本属性
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = self.codeTextField.font;
    dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
    CGPoint point = CGPointMake(0, (rect.size.height - self.codeTextField.font.lineHeight) * 0.5);
    
    [self.codeTextField.placeholder drawAtPoint:point withAttributes:dictM];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 self.navigationController.navigationBarHidden = YES;
}



- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.codeTextField resignFirstResponder];
    

    [UIView animateWithDuration:0.01 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
}

- (IBAction)goCusstomDismiss:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)goDismiss :(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];

}

//获取验证码
- (IBAction)getCodeBtnAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    //关闭按钮
    self.getCodeBtn.enabled = NO;
    [self.getCodeBtn setTitle:@"验证码(60)" forState:UIControlStateDisabled];


    //构造参数
    NSMutableDictionary *dicParameter = [NSMutableDictionary dictionary];

    [dicParameter  setObject:self.phoneString forKey:@"mobile"];//电话号

    
    //
    AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
    afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    afManager.requestSerializer.timeoutInterval = KHTTPTimeoutInterval;
    
    [afManager POST:KAppSendVerifyCode_URL parameters:dicParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

        
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




- (IBAction)goLogin:(id)sender {
    
//    NewLoginViewController *vc = [NewLoginViewController shareInstance];
//    [self.navigationController pushViewController:vc animated:YES];
    NewLoginViewController *vc = [NewLoginViewController shareInstance];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}




//下一步
- (IBAction)registerBtnAction:(id)sender {
    
    [self.codeTextField resignFirstResponder];
   
    //判断 输入转让框 非空
    if (self.codeTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.codeTextField.layer addAnimation:anim forKey:nil];

        return;
    }
    
    //判断 输入转让框 非空
    if ([self.codeTextField.text isEqualToString:_localCodeString] ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.codeTextField.layer addAnimation:anim forKey:nil];
        
        [XNDProgressHUD showWithStatus:@"验证码输入错误" duration:1.0];
        return;
    }

    Register3ViewController *vc = [Register3ViewController shareInstance];
    vc.phoneString = _phoneString;
    vc.verifyCode=self.codeTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
    
      
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    
    [self.codeTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
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
