//
//  OrderDetailModule.m
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "OrderDetailModule.h"
@interface OrderDetailModule()
@property (nonatomic, retain) NSMutableArray *array_Order;
@property (nonatomic, retain) NSDictionary *dic_OrderDetail;
@property (nonatomic, retain) NSDictionary *item_Order;
@end
@implementation OrderDetailModule

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static OrderDetailModule *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OrderDetailModule new];
    });
    
    return _sharedManager;
}
-(void)setOrderItem:(NSDictionary *)orderItem{
    self.item_Order=orderItem;
}

-(NSMutableArray *)getOrderArrayData{
    return self.array_Order;
}

-(void)getOrderArrayDataWithFarmDic:(NSDictionary *)orderItem Complete:(CompleteGetDataBlock)CompleteBlock{
    
    self.item_Order=orderItem;
    [self getDataWithServerWithComplete:CompleteBlock];
    
}
-(void)dataReworkWithComplete:(CompleteGetDataBlock)CompleteBlock{
    self.array_Order=[[NSMutableArray alloc]init];
    NSString *phone,*name,*address,*pay_type_txt,*contact_name;
    if (self.dic_OrderDetail) {
        phone=[self.dic_OrderDetail objectForKey:@"phone"]?[self.dic_OrderDetail objectForKey:@"phone"]:@"";
        name=[self.dic_OrderDetail objectForKey:@"name"]?[self.dic_OrderDetail objectForKey:@"name"]:@"";
        address=[self.dic_OrderDetail objectForKey:@"adress"]?[self.dic_OrderDetail objectForKey:@"adress"]:@"";
        pay_type_txt=[self.dic_OrderDetail objectForKey:@"pay_type_txt"]?[self.dic_OrderDetail objectForKey:@"pay_type_txt"]:@"";
        contact_name=[self.dic_OrderDetail objectForKey:@"contact_name"]?[self.dic_OrderDetail objectForKey:@"contact_name"]:@"";
    }
    NSDictionary *dic_address=[[NSDictionary alloc]initWithObjectsAndKeys:contact_name,@"name",phone,@"phone",address,@"address", nil];
    
    //查询地址
    [self.array_Order addObject:@[dic_address]];
    //农场
    [self.array_Order addObject:@[self.item_Order]];
    //支付方式
    NSDictionary *dic_payType=[[NSDictionary alloc]initWithObjectsAndKeys:@"支付方式",@"name",pay_type_txt,@"value", nil];
    NSDictionary *dic_kuaidi=[[NSDictionary alloc]initWithObjectsAndKeys:@"配送信息",@"name",@"无法显示",@"value", nil];
    NSDictionary *dic_fapiao=[[NSDictionary alloc]initWithObjectsAndKeys:@"发票信息",@"name",@"不开发票",@"value", nil];
    [self.array_Order addObject:@[dic_payType,dic_kuaidi,dic_fapiao]];
    //商品总额
    NSString *order_price=[NSString stringWithFormat:@"¥%.2f",[[self.item_Order objectForKey:@"order_price"] floatValue]];
    NSDictionary *dic_Price=[[NSDictionary alloc]initWithObjectsAndKeys:@"商品总额",@"name",order_price,@"value", nil];
    NSDictionary *dic_fanxian=[[NSDictionary alloc]initWithObjectsAndKeys:@"-返现",@"name",@"¥0.00",@"value", nil];
    NSDictionary *dic_yunfei=[[NSDictionary alloc]initWithObjectsAndKeys:@"+运费",@"name",@"¥0.00",@"value", nil];
    [self.array_Order addObject:@[dic_Price,dic_fanxian,dic_yunfei]];
    
    CompleteBlock([NSArray arrayWithArray:_array_Order ]);
}
-(void)getDataWithServerWithComplete:(CompleteGetDataBlock)CompleteBlock{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        
        return;
    }
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSString *orderId=[self.item_Order objectForKey:@"order_id"];
    NSString *orderType=[self.item_Order objectForKey:@"name"];
    if([orderType isEqualToString:@"1"])
        orderType=@"2";
    else if([orderType isEqualToString:@"2"])
        orderType=@"1";
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KUser_getOrderDetail_URL,orderId,orderType,uid,token ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    __block OrderDetailModule *weakSelf = self;
    weakSelf.dic_OrderDetail=nil;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    weakSelf.dic_OrderDetail=[[NSDictionary alloc]initWithDictionary:[dict objectForKey:@"msg"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dataReworkWithComplete:CompleteBlock];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XNDProgressHUD showWithStatus:@"获取订单信息失败，请重试" duration:1.0];
                        
                    });
                }
            }
        }else{
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
                
            });
        }
        
    }];

}

@end
