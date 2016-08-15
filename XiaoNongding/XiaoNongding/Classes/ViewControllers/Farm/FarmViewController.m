//
//  FarmViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/12.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "FarmViewController.h"

@interface FarmViewController ()<UIWebViewDelegate>


@property (nonatomic, retain) UIWebView *contentWebView;
@property (nonatomic, retain) NSMutableURLRequest *request;

@property (nonatomic, retain) UIButton *btn_back;


@end

@implementation FarmViewController

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static FarmViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [FarmViewController new];
    });
    
    return _sharedManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"  农场  viewDidLoad   ");

    
    self.contentWebView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth,KDeviceHeight-44-64 )];
    [self.view addSubview:self.contentWebView];
    self.contentWebView.scrollView.showsVerticalScrollIndicator  = YES;//锤直
    self.contentWebView.scrollView.showsHorizontalScrollIndicator  = NO;//水平
    
    self.contentWebView.delegate = self;
    
    NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
    NSString *latitude=[dicInfo objectForKey:@"latitude"];
    NSString *longitude=[dicInfo objectForKey:@"longitude"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.xiaonongding.com/mobile.php?g=Mobile&c=Merchant&lat=%@&long=%@",latitude,longitude ]];

    
    //新申请页面时 移除缓存
    if (self.request){
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_request];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    }
    //WebView 没有提供设置user-agent 的接口，无论是设置要加载的request，还是在delegate 中设置request，经测试都是无效的。
    
    //创建一个请求
    self.request=[NSMutableURLRequest requestWithURL:url
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:KHTTPTimeoutInterval];
    [self.request setValue:@"sobuyer/1" forHTTPHeaderField:@"X-client"];
    
    [self.request setHTTPMethod:@"GET"];
    [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];//这个很关键，一定要设置
    //另外：AFNetworking 是会自动的去[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]取Cookie的
    
    [self.contentWebView loadRequest:self.request];
    
    [self.view addSubview:self.btn_back];
    
    // Do any additional setup after loading the view.
}

-(UIButton *)btn_back{
    if (!_btn_back) {
        _btn_back =[[UIButton alloc]initWithFrame:CGRectMake(5.0, 55.0, 30.0, 30.0)];
        [_btn_back setBackgroundImage:[SO_Convert createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        [_btn_back setBackgroundImage:[SO_Convert createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [_btn_back setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
        [_btn_back addTarget:self action:@selector(btn_Goback:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_back.layer setMasksToBounds:YES];
        [_btn_back.layer setCornerRadius:15.0];
    }
    return _btn_back;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"  农场  viewWillAppear   ");
    
    
}






#pragma mark-UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString * title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    NSLog(@" 1 --   title  == %@",   title);

    
    NSLog(@"url====%@",request.URL);
    NSString *url=[NSString stringWithFormat:@"%@",request.URL];

        if([url rangeOfString:@"&long="].location == NSNotFound  && [url rangeOfString:@"&lat="].location==NSNotFound){
            NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
            NSString *latitude=[dicInfo objectForKey:@"latitude"];
            NSString *longitude=[dicInfo objectForKey:@"longitude"];
            
            NSString *urlStr=[NSString stringWithFormat:@"%@&lat=%@&long=%@",request.URL,latitude,longitude];
            NSMutableURLRequest* request2=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:KHTTPTimeoutInterval];
            [request2 setValue:@"sobuyer/1" forHTTPHeaderField:@"X-client"];
            [request2 setHTTPMethod:@"GET"];
            [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
             [self.contentWebView loadRequest:request2];
        }
       [self.btn_back setEnabled:YES];

    

    
    return YES;
}




- (void)webViewDidStartLoad:(UIWebView *)webView
{

     [SVProgressHUD showWithStatus:nil];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    

    [SVProgressHUD dismiss];
    
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s --%@",__func__,error);

}

-(void)btn_Goback:(UIButton *)sender{
    if ([self.contentWebView canGoBack]) {
        [self.contentWebView goBack];
    }else{
        //        [XNDProgressHUD showWithStatus:@"已经是第一页"]
        [sender setEnabled:NO];
    }
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
