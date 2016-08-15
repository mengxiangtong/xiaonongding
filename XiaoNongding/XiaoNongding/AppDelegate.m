//
//  AppDelegate.m
//  XiaoNongding
//
//  Created by admin on 15/12/10.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "AppDelegate.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Reachability.h"
#import "REFrostedViewController.h"
#import "CustomNavigationController.h"
#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "WelcomeViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate,WXApiDelegate>
@property (nonatomic, retain) Reachability *internetReach;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    [self setApperanceViewColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSDictionary *myInfo=(NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
     NSMutableDictionary *dicInfo=[[NSMutableDictionary alloc]initWithDictionary:myInfo ];
    if (![dicInfo objectForKey:@"latitude"] || ![dicInfo objectForKey:@"longitude"]) {
        [dicInfo setObject:@"36.0981"  forKey:@"latitude"];
        [dicInfo setObject:@"120.4625"  forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:dicInfo forKey:@"CLLocation"];
    }
    
    
    [self getCities];
    
    //    获取当前位置
    if([CLLocationManager locationServicesEnabled]) {
        if(self.locationManager ==nil)
        {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        self.locationManager.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        
    }
    [self.locationManager startUpdatingLocation];
    NSString *str_IsFirst=[[NSUserDefaults standardUserDefaults] objectForKey:KIsFirst];
    
    if (str_IsFirst && [str_IsFirst isEqualToString:@"1"]) {
        // Create content and menu controllers
        //
        CustomNavigationController *navigationController = [[CustomNavigationController alloc] initWithRootViewController:[HomeViewController shareInstance]];
        
        
        LeftMenuViewController *menuController = [[LeftMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        
        // Create frosted view controller
        //
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
        
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;//模糊风格
        
        
        
        // Make it a root controller
        //
        self.window.rootViewController = frostedViewController;
        
    }else{

        
        WelcomeViewController *frostedViewController = [[WelcomeViewController alloc] init];
        
        self.window.rootViewController = frostedViewController;
    }
    
    self.window.backgroundColor = kBlackBgColor;
   
    [self.window makeKeyAndVisible];
    
    
    //执行地址查询
    [[XNDAreaModule instance] loadAreaList];
    [[XNDAreaModule instance] loadAreaList];
    [[XNDAreaModule instance] loadAreaList];
    
    
    //微信支付 注册
    [WXApi registerApp:K_WX_APPID withDescription:@"小农丁微信支付"];
    
    [self configureUMSDK];
    
    [self CreateNotification];
    

    return YES;

}
-(void)configureUMSDK{
    
    [UMSocialData setAppKey:@"56c4132067e58e23bc002580"];
    [UMSocialWechatHandler setWXAppId:@"wx25d6b9689e6d7e5b" appSecret:@"4d391b3e171918383754dc258df79254" url:KAppWebURL];
    [UMSocialQQHandler setQQWithAppId:@"1105061643" appKey:@"4QVivYAGqdNvgDw9" url:KAppWebURL];
    
    
}



#pragma mark - 获取区域列表
-(void)getCities{
    
    
    NSURL *url = [NSURL URLWithString:KUser_getCities_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:KHTTPTimeoutInterval];
    
    __block AppDelegate *weakSelf = self;
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(dict && [dict objectForKey:@"msg"])
                [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"msg"] forKey:KCitesInfo];
        }
        
    }];

}

#pragma mark-位置获取回调 CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    self.location = [locations lastObject];
    
    CLLocationDegrees latitude = self.location .coordinate.latitude;
    CLLocationCoordinate2D coordinate = self.location .coordinate;
    CLLocationDegrees longitude = self.location .coordinate.longitude;
    
    
    //CLGeocoder：地理编码器，其中Geo是地理的英文单词Geography的简写。
    //1.使用CLGeocoder可以完成“地理编码”和“反地理编码”
    //地理编码：根据给定的地名，获得具体的位置信息（比如经纬度、地址的全称等
    //反地理编码：根据给定的经纬度，获得具体的位置信息
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:kAPPALL.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && [placemarks count] > 0)
        {
            for (CLPlacemark *placemark in placemarks)
            {
               
                //取出地标
                NSDictionary *myInfo = placemark.addressDictionary;
                //市
                NSString *mtCity = [myInfo objectForKey:@"City"];
                mtCity = [mtCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
                
                kAPPALL.cityLabel.text = mtCity;
                 NSDictionary *CLLocationInfo=(NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
                NSMutableDictionary *dicInfo=[[NSMutableDictionary alloc]initWithDictionary:myInfo];
                if ([CLLocationInfo objectForKey:@"latitude"] && [CLLocationInfo objectForKey:@"longitude"]) {
                    if ([[NSString stringWithFormat:@"%.6f", latitude ] isEqualToString:[CLLocationInfo objectForKey:@"latitude"]]
                        &&
                        [[NSString stringWithFormat:@"%.6f", longitude ] isEqualToString:[CLLocationInfo objectForKey:@"longitude"]]
                        ) {
                        return ;
                    }
                }
                [dicInfo setObject:[NSString stringWithFormat:@"%.6f", latitude ]  forKey:@"latitude"];
                [dicInfo setObject:[NSString stringWithFormat:@"%.6f", longitude ]  forKey:@"longitude"];
                [[NSUserDefaults standardUserDefaults] setObject:dicInfo forKey:@"CLLocation"];
             
//                [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionTodayWebReload object:dicInfo];
                return;
            }
        }
        else
        {
            //[XNDProgressHUD showWithStatus:error.localizedDescription];
        }
    }];
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
   // [FVCustomAlertView showWarningWithTitle:@"无法获取当前位置\n开启定位以获取附近信息！"];
}
//若用户开启定位后返回一搜，则重新定位
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}



#pragma mark - 设置全局颜色
- (void)setApperanceViewColor
{
    NSString * imageStr = nil;
        NSLog(@"--   %f ", kDeviceWidth );
    
    if (kDeviceWidth == 320) {
        imageStr = @"LastMinute_TitleBar_320.png";
    }else if (kDeviceWidth >= 320 &&  kDeviceWidth<=400)
    {
        imageStr = @"LastMinute_TitleBar_375.png";

        
    }else if (kDeviceWidth >= 400 &&  kDeviceWidth<=750)
    {
        imageStr = @"LastMinute_TitleBar_621.png";
    }else if (kDeviceWidth >= 700 )
    {
        imageStr = @"LastMinute_TitleBar_max.png";
    }
    
    // 设置导航条 背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:imageStr] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance]  setAlpha:0.15];
    //设置 前景 颜色  即 字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];

    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - 支付代码  禁止改动
#pragma mark - 当用户通过其它应用启动本应用时，会回调这个方法，url参数是其它应用调用openURL:方法时传过来的。

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 
    
    if([url.host isEqualToString:@"pay"]){
        
        //        wx6288c21bd31a1db0://pay/?returnKey=&ret=0
        //处理微信通过URL启动App时传递的数据
        return [WXApi handleOpenURL:url delegate:self];
    }else if([[[NSString stringWithFormat:@"%@",url] substringToIndex:18] isEqualToString: kalipayScheme]){
        //支付宝支付 结果返回
        NSLog(@"url====%@",url);
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result) {
        //调用微信
//        [XNDProgressHUD showWithStatus:@"" duration:<#(NSTimeInterval)#>]
    }
//    return result;
    return YES;
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
//微信支付回调
-(void) onResp:(BaseResp*)resp
{
    NSLog(@" onResp  %d   " ,  resp.errCode   );
    //启动微信支付的response
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:{
                strMsg = @"微信 支付结果：成功！";
                NSLog(@"  微信 支付 成功    ！！！！！---");
                
                [SVProgressHUD showSuccessWithStatus:strMsg duration:1.0];
                break;
            }
            case -1:{
                strMsg = @"微信 支付结果：失败！";
                [XNDProgressHUD showWithStatus:strMsg duration:1.0];
                break;
            }
            case -2:{
                strMsg = @"微信 支付：用户已经退出支付！";
                [SVProgressHUD showSuccessWithStatus:strMsg duration:1.0];
                break;
            }
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [XNDProgressHUD showWithStatus:strMsg duration:1.0];
                break;
            }
        }
    }
}

//创建通知对象
-(void)CreateNotification{
    /**
     * 根据网络切换通知
     */
        if([[UIDevice currentDevice].model isEqualToString:@"iPhone"] || [[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"]|| [[UIDevice currentDevice].model isEqualToString:@"iPad"] ){
            //Network Detect
            _internetReach = [Reachability reachabilityForInternetConnection];
            [_internetReach startNotifier];
            
            [self checkNetworkState:_internetReach];
            
            //添加通知对象
            [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: _internetReach];
            
        }
        
    
    
    
}

//根据通知对象发送通知
-(void)reachabilityChanged: (NSNotification* )note{
    //网络切换检测
    if(note.name==kReachabilityChangedNotification){
        Reachability* curReach = [note object];
        NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
        [self checkNetworkState:curReach];
    }
    
}
- (void)checkNetworkState:(Reachability*)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus)
    {
        case NotReachable:        {
            //木有网
            NSLog(@"没有网络");
            [XNDProgressHUD showWithStatus:@"网络已断开"  duration:1.0];
            break;
        }
            
        case ReachableViaWWAN:        {
            //手机网络
            NSLog(@"手机网络");
            break;
        }
        case ReachableViaWiFi:        {
            //wifi
            NSLog(@"wifi网络");
            break;
        }
    }
    
}
@end
