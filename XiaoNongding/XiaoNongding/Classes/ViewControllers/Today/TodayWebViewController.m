//
//  UIWebViewViewController.m
//  XiaoNongding
//
//  Created by jion on 16/1/22.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "TodayWebViewController.h"
#import "PayManager.h"
#import "NewLoginViewController.h"
#import "UIWebViewViewController.h"



@interface TodayWebViewController ()<UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) UIButton *btn_back;
@property (nonatomic, retain) UIXndActivityView *activityView;

@end


@implementation TodayWebViewController

static NSString* IsFinish=@"0";

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static TodayWebViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [TodayWebViewController new];
    });
    
    return _sharedManager;
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth,KDeviceHeight-64-44.0 )];
        _webView.delegate=self;
        _webView.scrollView.showsVerticalScrollIndicator  = YES;//锤直
        _webView.scrollView.showsHorizontalScrollIndicator  = NO;//水平
        _webView.scrollView.bounces=NO;
      
    }
    return _webView;
}

-(UIXndActivityView *)activityView{
    if (!_activityView) {
    
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self notifictionCenter];

 
    
  
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    if (dicInfo && latitude && longitude) {
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        NSString *uid=@"";
        NSString *token=@"";
        if (dic_userInfo) {
            uid=[dic_userInfo objectForKey:@"uid"];
            token=[dic_userInfo objectForKey:@"token"];
        }
        
        self.urlStr=[NSString stringWithFormat: @"http://www.xiaonongding.com/mobile.php?g=Mobile&c=Index&a=index&uid=%@&token=%@&lat=%@&long=%@",uid,token,latitude,longitude ];
        [self.view addSubview:self.webView];

        NSURL *url=[[NSURL alloc]initWithString:self.urlStr];
        self.request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
        [self.request setValue:@"sobuyer/1" forHTTPHeaderField:@"X-client"];
        
        [self.request setHTTPMethod:@"GET"];
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];//这个很关键，一定要设置
        [self.webView loadRequest:self.request];
        
    }
    
   
    [self.view addSubview:self.activityView];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([IsFinish isEqualToString:@"1"]) {
        [self.activityView stopAnimation];
    }else{
        [self.activityView startAnimation];
    }
}

-(void)notifictionCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiction_ReloadAction:) name:KNotifictionTodayWebReload object:nil];
    
}
-(void)notifiction_ReloadAction:(NSNotification *)notify{
    if ([notify.name isEqualToString:KNotifictionTodayWebReload]) {
        NSMutableDictionary *dicInfo=[notify object];
        NSString *latitude=[dicInfo objectForKey:@"latitude"];
        NSString *longitude=[dicInfo objectForKey:@"longitude"];
        if (dicInfo && latitude && longitude) {
            NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
            NSString *uid=@"";
            NSString *token=@"";
            if (dic_userInfo) {
                uid=[dic_userInfo objectForKey:@"uid"];
                token=[dic_userInfo objectForKey:@"token"];
            }
            
            self.urlStr=[NSString stringWithFormat: @"http://www.xiaonongding.com/mobile.php?g=Mobile&c=Index&a=index&uid=%@&token=%@&lat=%@&long=%@&client=iOS",uid,token,latitude,longitude ];
            [self.view addSubview:self.webView];
            NSURL *url=[[NSURL alloc]initWithString:self.urlStr];
            self.request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
            [self.request setValue:@"sobuyer/1" forHTTPHeaderField:@"X-client"];
            
            [self.request setHTTPMethod:@"GET"];
            [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];//这个很关键，一定要设置
            [self.webView loadRequest:self.request];
            
        }
       
    }
}
-(UIButton *)btn_back{
    if (!_btn_back) {
        _btn_back =[[UIButton alloc]initWithFrame:CGRectMake(15.0, 55.0, 30.0, 30.0)];
        [_btn_back setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.0 alpha:0.3]] forState:UIControlStateNormal];
        [_btn_back setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.5 alpha:0.3]] forState:UIControlStateHighlighted];
        [_btn_back setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
        [_btn_back addTarget:self action:@selector(btn_Goback:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_back.layer setMasksToBounds:YES];
        [_btn_back.layer setCornerRadius:15.0];
    }
    return _btn_back;
    
}
-(void)btn_Goback:(UIButton *)sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [sender setEnabled:NO];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)webViewDidStartLoad:(UIWebView *)webView{

    [self.activityView startAnimation];
   
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.btn_back setEnabled:YES];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//    [_activityView setHidden:YES];
    IsFinish=@"1";
    [self.activityView stopAnimation];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url=[NSString stringWithFormat:@"%@", request.URL ];

    NSLog(@"url=====%@",url);
    if([url  hasPrefix:@"app:redirect:"]){

        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }else{
        
        if([url rangeOfString:@"&lat="].location==NSNotFound && [url rangeOfString:@"&long="].location==NSNotFound){
            NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
            NSString *latitude=@"";
            NSString *longitude=@"";
            if (dicInfo) {
                latitude=[dicInfo objectForKey:@"latitude"];
                longitude=[dicInfo objectForKey:@"longitude"];
            }
            
            NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
            NSString *uid=@"";
            NSString *token=@"";
            if (dic_userInfo) {
                uid=[dic_userInfo objectForKey:@"uid"];
                token=[dic_userInfo objectForKey:@"token"];
            }
            url=[NSString stringWithFormat:@"%@&uid=%@&token=%@&lat=%@&long=%@&client=iOS",url,uid,token,latitude,longitude];
        }
        if (![self.urlStr isEqualToString:url]) {
            UIWebViewViewController *webviewV=[[UIWebViewViewController alloc]init];
            [webviewV initUrlAndId:nil urlstr:url];
            [self.navigationController pushViewController:webviewV animated:YES];
            return NO;
        }
    }
    
    
    return  YES;
}

-(void)LoadProductMessageWithPayType:(NSString *)payType OrderType:(NSString *)orderType orderId:(NSString *)orderId{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    NSString *uid=@"";
    NSString *token=@"";
    if (dic_userInfo) {
        uid=[dic_userInfo objectForKey:@"uid"];
        token=[dic_userInfo objectForKey:@"token"];
    }
    NSURL *url = [NSURL URLWithString:KPay_URL ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    [request setHTTPMethod:@"POST"];
    NSString *bodyStr=[NSString stringWithFormat:@"&pay_type=%@&order_type=%@&order_id=%@&uid=%@&token=%@",payType,orderType,orderId,uid,token];
    NSData *bodyData= [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    __block TodayWebViewController *hotTVC = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    NSDictionary *dic=[dict objectForKey:@"msg"];
                    if (dic && dic.allKeys.count>0) {
                        if([payType isEqualToString:@"weixin"])
                        [hotTVC SendPayWithDic:dic];
                        else if([payType isEqualToString:@"alipay"]){
                            [hotTVC ALiPayActionWithDic:dic OrderId:orderId];
                        }
                    }
                }else{
                    
                }
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];

    
}

-(void)ALiPayActionWithDic:(NSDictionary *)dic OrderId:(NSString *)orderId{
    //支付宝
    NSLog(@"支付宝支付",nil);
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = kpartner;
    order.seller = kseller;
    order.tradeNO= [dic objectForKey:@"order_sn"];
    order.productName = [dic objectForKey:@"name"]; //商品标题
    order.productDescription = [dic objectForKey:@"name"]; //商品描述
    order.amount = [dic objectForKey:@"amount"]; //商品价格
    order.notifyURL =  [dic objectForKey:@"notify_url"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkxiaonongding";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(kprivateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];

        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSString *  state = [resultDic objectForKey:@"resultStatus"];
            NSString *  result = [resultDic objectForKey:@"memo"];

            if ([state isEqualToString:@"9000"] ){
                [SVProgressHUD showSuccessWithStatus:@"支付成功!" duration:1.0];
          
            }
            else if([state isEqualToString:@"6001"] )
            {
                NSLog(@"------支付 取消---");
                [SVProgressHUD showSuccessWithStatus:@"支付已取消!" duration:1.0];
                
            }else
            {
                NSLog(@"------支付   失败---");
                [XNDProgressHUD showWithStatus:result duration:1.0];
            }
            
        }];
        
    }
    
}
#pragma mark - 微信支付  支付完成后，微信APP会返回到商户APP并回调onResp函数
-(void)SendPayWithDic:(NSDictionary *)data{

    if (data) {
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [data objectForKey:@"appid"];
        req.partnerId           = [data objectForKey:@"partnerid"];
        req.prepayId            = [data objectForKey:@"prepayid"];
        req.nonceStr            = [data objectForKey:@"noncestr"];
        req.timeStamp           = [[data objectForKey:@"timestamp"] intValue];
        req.package             = [data objectForKey:@"package"];
        req.sign                = [data objectForKey:@"sign"];
        
        [WXApi sendReq:req];
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
