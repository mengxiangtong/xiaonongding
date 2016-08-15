
//
//  UIWebViewViewController.m
//  XiaoNongding
//
//  Created by jion on 16/1/22.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UIWebViewViewController.h"
#import "PayManager.h"
#import "NewLoginViewController.h"
#import "UIShareUMCustomView.h"

@interface UIWebViewViewController ()<UIWebViewDelegate,UMSocialUIDelegate,UIShareUMCustomViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) UIShareUMCustomView *shareView;
@property (nonatomic, retain) UIXndActivityView *activityView;
@end

@implementation UIWebViewViewController

-(UIWebView *)webView{
    if (!_webView) {
        _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth,KDeviceHeight-64 )];
        _webView.delegate=self;
        _webView.scrollView.showsVerticalScrollIndicator  = YES;//锤直
        _webView.scrollView.showsHorizontalScrollIndicator  = NO;//水平
    }
    return _webView;
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
- (UIButton *)getShareButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn setImage:[UIImage imageNamed:@"iconfont-fenxiang"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(shareMoreUM:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}
-(UIShareUMCustomView *)shareView{
    if (!_shareView) {
        
        _shareView=[[UIShareUMCustomView alloc]initWithFrame:CGRectMake(0.0, KDeviceHeight, kDeviceWidth, kDeviceWidth/3.0*2.0)];
        _shareView.target=self;
        _shareView.delegate=self;
        _isHiddenShareView=YES;
    }
    
    return _shareView;
}
#pragma mark - 分享

-(void)shareMoreUM:(UIBarButtonItem *)sender{
//    [self.shareView setHidden:!self.shareView.hidden];
    _isHiddenShareView=!_isHiddenShareView;
    
    [self setInfoViewFrame:_isHiddenShareView];
}

- (void)setInfoViewFrame:(BOOL)isDown{
    _isHiddenShareView=isDown;
     [self.shareView.view_Bg setHidden:isDown];
    if(!isDown)
    {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:0
                         animations:^{
                             [self.shareView setFrame:CGRectMake(0, KDeviceHeight-kDeviceWidth/3.0*2.0-65.0, kDeviceWidth, self.shareView.height)];
                         }
                         completion:^(BOOL finished) {
                          
                         }];
        
    }else
    {
        
        [self.shareView.view_Bg setHidden:isDown];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:0
                         animations:^{
                             [self.shareView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, self.shareView.height)];
                         }
                         completion:^(BOOL finished) {
                            
                         }];
        
    }
}

#pragma mark 发送分享
-(void)ShareAction:(int)tag{
    
//    [self.shareView setHidden:YES];
    NSString *urlStr2=self.urlStr;
    if ([urlStr2 rangeOfString:@"&uid="].location!=NSNotFound || [urlStr2 rangeOfString:@"&token="].location!=NSNotFound) {
        NSArray *arry=[urlStr2  componentsSeparatedByString:@"&"];
        NSString *urlStr3=arry[0];
        for (int i=1; i<arry.count; i++) {
            if ([arry[i] rangeOfString:@"uid="].location!=NSNotFound || [arry[i] rangeOfString:@"token="].location!=NSNotFound) {
                continue;
            }
             urlStr3=[NSString stringWithFormat:@"%@&%@",urlStr3,arry[i]] ;
        }
        urlStr2=[NSString stringWithFormat:@"%@",urlStr3] ;
    }
    
    if([urlStr2 rangeOfString:@"&lat="].location==NSNotFound && [urlStr2 rangeOfString:@"&long="].location==NSNotFound
       &&[urlStr2 rangeOfString:@"g=Mobile&c=Pay&a=go_pay"].location==NSNotFound
       ){
        NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
        NSString *latitude=@"";
        NSString *longitude=@"";
        if (dicInfo) {
            latitude=[dicInfo objectForKey:@"latitude"];
            longitude=[dicInfo objectForKey:@"longitude"];
        }
        
        urlStr2=[NSString stringWithFormat:@"%@&lat=%@&long=%@&client=iOS",urlStr2,latitude,longitude];
       
    }
    
    UMSocialUrlResource *resurceUrl=[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[[NSString alloc]initWithString: urlStr2 ]];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.qqData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr2;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr2;
    [UMSocialData defaultData].extConfig.qqData.url = urlStr2;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlStr2;
    
    switch (tag) {
        case 1:
            //QQ 好友
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            break;
        case 2:
            //微信好友
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            break;
        case 3:
            //朋友圈
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            break;
        case 4:
            //QQ空间
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];

            break;
            //        case 5:
            //            //新浪微博
            //            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"小农丁绿色农产品交易平台－找回舌尖上的味道" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
            //                if (response.responseCode == UMSResponseCodeSuccess) {
            //                    NSLog(@"分享成功！");
            //                }
            //            }];
            //            break;
        default:{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该功能暂未开放" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
    
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}

- (void)viewDidLoad {
    @autoreleasepool {
        [super viewDidLoad];
        
        self.view.backgroundColor=[UIColor whiteColor];
        [self.navigationController setNavigationBarHidden:NO];
        
        //左侧 返回
        self.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
            cancelBarButtonItem.tintColor = [UIColor whiteColor];
            cancelBarButtonItem;
        });
        //右侧 分享
        self.navigationItem.rightBarButtonItem = ({
            UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getShareButton]];
            shareBarButtonItem.tintColor = [UIColor whiteColor];
            shareBarButtonItem;
        });
        [self.navigationController setNavigationBarHidden:NO];
    
        
        [self.view addSubview:self.webView];
        
        
        NSURL *url=[[NSURL alloc]initWithString:self.urlStr];
        self.request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
        [self.request setValue:@"sobuyer/1" forHTTPHeaderField:@"X-client"];
        
        [self.request setHTTPMethod:@"GET"];
        [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];//这个很关键，一定要设置
        [self.webView loadRequest:self.request];
    }
    
    [self.view addSubview: self.shareView ];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [self.view addSubview:self.activityView];
    [self.view bringSubviewToFront:self.activityView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_webView stopLoading];
    _request=nil;
    _webView=nil;
    _urlStr=nil;
}

-(void)goDismiss:(UIButton *)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    
    }else{

        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)initUrlAndId:(NSString *)idstr urlstr:(NSString *)urlstr{
    self.urlStr=nil;
    self.idStr=nil;
    if (idstr) {
        self.idStr=idstr;
    }
    if (urlstr) {
        self.urlStr=urlstr;
    }
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView{

    [self.activityView startAnimation];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{


    NSString * title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self.navigationItem setTitle:title];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self.activityView stopAnimation];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url=[NSString stringWithFormat:@"%@", request.URL ];
    
    NSLog(@"url=====%@",url);
    
    if([url  hasSuffix:@"url.order.list"]){
        [XNDProgressHUD showWithStatus:@"下单：余额支付成功" duration:1.0];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else if([url  hasPrefix:@"app:redirect:"]){
        //未登录的情况下 弹出登录页
        //重定向到url
        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        return NO;
    }else{
        if([url rangeOfString:@"/mobile.php?g=Mobile&c=Group&a=buy"].location==NSNotFound){
            if([url hasPrefix:@"app:weixin:"]){
                
                //微信支付
                NSLog(@"微信支付");
                NSString *strOrder=[url stringByReplacingOccurrencesOfString:@"app:weixin:" withString:@""];
                
                NSString *OrderType =@"";
                NSString *orderId   =@"";
                if (strOrder) {
                    NSArray *arryOrder=[strOrder componentsSeparatedByString:@":"];
                    if (arryOrder && arryOrder.count>1) {
                        OrderType=arryOrder[0];
                        orderId=arryOrder[1];
                    }
                }
                [[[PayManager alloc]init] LoadProductMessageWithPayType:@"weixin" OrderType:OrderType orderId:orderId];
   
            }else if([url hasPrefix:@"app:alipay:"]){
                //支付宝支付
                NSLog(@"支付宝支付");
                NSString *strOrder=[url stringByReplacingOccurrencesOfString:@"app:alipay:" withString:@""];
                
                NSString *OrderType =@"";
                NSString *orderId   =@"";
                if (strOrder) {
                    NSArray *arryOrder=[strOrder componentsSeparatedByString:@":"];
                    if (arryOrder && arryOrder.count>1) {
                        OrderType=arryOrder[0];
                        orderId=arryOrder[1];
                    }
                }

                [[[PayManager alloc]init] LoadProductMessageWithPayType:@"alipay" OrderType:OrderType orderId:orderId];

            }else if(![url hasPrefix:@"tel:"]){
               
                if([url rangeOfString:@"&lat="].location==NSNotFound && [url rangeOfString:@"&long="].location==NSNotFound
                   &&[url rangeOfString:@"g=Mobile&c=Pay&a=go_pay"].location==NSNotFound
                   ){
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
                    self.request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url ] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
                    [self.request setValue:@"sobuyer/1" forHTTPHeaderField:@"X-client"];
                    
                    [self.request setHTTPMethod:@"GET"];
                    [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [self.webView loadRequest:self.request];
                    return NO;
                }
            }
        }
    }

    return  YES;
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
