//
//  PayManager.m
//  XiaoNongding
//
//  Created by jion on 16/2/4.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "PayManager.h"

@implementation PayManager
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
    __block PayManager *hotTVC = self;
    
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
        
        //2015-10-23  遇到问题   reason: '+[WXApi safeSendReq:]: unrecognized selector sent to class 0x417360'
        //解决方法  换成   [WXApi sendReq:req];
        //@brief 发送请求到微信(安全方式)，等待微信返回onResp
        //[WXApi safeSendReq:req];
        //发送请求到微信，等待微信返回onResp
        
        [WXApi sendReq:req];
    }
    
    
    
    
    
    
}
@end
