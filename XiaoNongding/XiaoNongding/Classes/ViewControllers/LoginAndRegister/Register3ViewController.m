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
#import "YBImgPickerViewController.h"
#import "XND_UploadFileTool.h"
#import "RegisterViewController.h"

@interface Register3ViewController ()<UITextFieldDelegate,YBImgPickerViewControllerDelegate, XND_UploadFileToolDelegate>
{
    CGFloat btnMaxY;
}


@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *invatePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;

@property (retain, nonatomic) AFHTTPRequestOperationManager *manager;


@end

@implementation Register3ViewController

+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static Register3ViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [Register3ViewController new];
    });
    
    return _sharedManager;
}

- (IBAction)goLogin:(id)sender {
    
//    NewLoginViewController *vc = [NewLoginViewController shareInstance];
//    [self.navigationController pushViewController:vc animated:YES];
    NewLoginViewController *vc = [NewLoginViewController shareInstance];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

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
    
    
    //设置placeholder 颜色
    UILabel *label = [self.passwordTextField valueForKeyPath:@"_placeholderLabel"];
    label.textColor = kTextPlaceHolderColor;

    UILabel *label1 = [self.invatePasswordTextField valueForKeyPath:@"_placeholderLabel"];
    label1.textColor = kTextPlaceHolderColor;
    

    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBarHidden = YES;
    
}


- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.passwordTextField resignFirstResponder];
    [self.invatePasswordTextField resignFirstResponder];

    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
}
- (IBAction)goDismiss:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

//  完成
- (IBAction)registerBtnAction:(id)sender {
    
    [self.passwordTextField resignFirstResponder];
    [self.invatePasswordTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        
    } ];
    //判断 输入转让框 非空
    if (self.passwordTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.passwordTextField.layer addAnimation:anim forKey:nil];

        return;
    }
    //判断 输入转让框 非空
    if (self.invatePasswordTextField.text.absoluteString.length == 0 ) {
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-10,@10,@-10];
        anim.duration = 0.2;
        [self.invatePasswordTextField.layer addAnimation:anim forKey:nil];
        
        return;
    }
    
    [self RegistAction];
 
    
}

//调用注册接口
-(void)RegistAction{

    [SVProgressHUD showWithStatus:nil];
    

    
    NSMutableDictionary *bodyParams=[[NSMutableDictionary alloc]init];
    [bodyParams setObject:self.phoneString forKey:@"mobile"];
    [bodyParams  setObject:[NSString_MD5 MD5EncryptBy32:self.passwordTextField.text.absoluteString ] forKey:@"pwd"];
    [bodyParams setObject:@"1" forKey:@"encrypt"];
    [bodyParams setObject:self.verifyCode forKey:@"verify_code"];
    [bodyParams setObject:@"1" forKey:@"is_mobile"];
    
    XND_UploadFileTool *xndUpload=[[XND_UploadFileTool alloc]init];
    xndUpload.delegate=self;
    [xndUpload uploadAvatarImageWithimageWithUrl:KUser_Regist_URL name:@"avatar" imgArry:@[self.heardImageView.image] parmas:bodyParams ];
 
    
}
-(void)XND_UploadFileToolDelegate_Compent:(NSDictionary *)msg isOK:(BOOL)isok{
    if (isok) {
        //成功 则跳转
        if (msg) {
            int status=[[msg objectForKey:@"status"]  intValue];
            if (status ==1) {
                [self.navigationController popToRootViewControllerAnimated:YES ];
                [[RegisterViewController shareInstance] dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordTextField resignFirstResponder];
    
    [self.invatePasswordTextField resignFirstResponder];
    
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

///选择图片
-(IBAction)btn_selectIMGAction:(UIButton *)sender{
    
    YBImgPickerViewController * next = [[YBImgPickerViewController alloc]init];
    next.photoCount=1;
    [next showInViewContrller:self choosenNum:0 delegate:self];
}


#pragma mark - image picker delegte
-(void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray{
    
    NSLog(@" 选中 图片  %@ ", imageArray );

    for (int i=0;i<imageArray.count;i++) {
        
        UIImage *image = imageArray[i];

        NSData *imageData=nil;
        
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        while (imageData.length>(1024.f*1024.f*4.0)) {
            image=[self scaleImage:image toScale:0.5];
            if (UIImagePNGRepresentation(image)) {
                //返回为png图像。
                imageData = UIImagePNGRepresentation(image);
            }else {
                //返回为JPEG图像。
                imageData = UIImageJPEGRepresentation(image, 1.0);
            }
        }
        
        
        self.heardImageView.image=[UIImage imageWithData:imageData];
        
        
    }
    
}

#pragma mark -
#pragma mark 等比縮放image
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
