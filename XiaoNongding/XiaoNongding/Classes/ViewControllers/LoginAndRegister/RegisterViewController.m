//
//  RegisterViewController.m
//  LanKe
//
//  Created by admin on 15/8/15.
//  Copyright (c) 2015年 Mxt. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+StringTool.h"
#import "NewLoginViewController.h"
#import "Register2ViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    CGFloat btnMaxY;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, retain) UIButton *loginButton;



@end

@implementation RegisterViewController





- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
    
}


+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static RegisterViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [RegisterViewController new];
    });
    
    return _sharedManager;
}




- (IBAction)goLogin:(id)sender {
//    NewLoginViewController *vc = [[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    NewLoginViewController *vc = [NewLoginViewController shareInstance];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}




- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 40, 40);
        [_backButton setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
        _backButton.tintColor = [UIColor whiteColor];
        [_backButton addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return _backButton;
    
}
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(0, 0, 40, 40);
        [_loginButton setTitle:@"已有账号" forState:UIControlStateNormal];
        _loginButton.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
        _loginButton.tintColor = [UIColor whiteColor];
        [_loginButton addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return _loginButton;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBlackBgColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goCusstomDismiss:) name:KNotifictionCloseViewController object:nil];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 2;

    //设置placeholder 颜色
    // 利用KVC设置它颜色,结果成功
    UILabel *label = [self.phoneTextField valueForKeyPath:@"_placeholderLabel"];
    label.textColor = kTextPlaceHolderColor;

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
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.phoneTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.01 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
    
}

- (IBAction)goCusstomDismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)goDismiss :(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}


// 下一步
- (IBAction)registerBtnAction:(id)sender {
    
    [self.phoneTextField resignFirstResponder];
   
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
    
    Register2ViewController *vc = [Register2ViewController shareInstance];
    vc.phoneString = _phoneTextField.text ;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
