//
//  OrderCouponDetailViewController.m
//  XiaoNongding
//
//  Created by jion on 16/3/18.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "OrderCouponDetailViewController.h"
#import "CouponView.h"
#import "QRCodeGenerator.h"

@interface OrderCouponDetailViewController ()
@property (nonatomic, retain) CouponView *couponView;
@end

@implementation OrderCouponDetailViewController

- (void)viewDidLoad {
    @autoreleasepool {
        [super viewDidLoad];
        
        self.navigationItem.title=@"订单详情";
        //左侧
        self.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
            cancelBarButtonItem.tintColor = [UIColor whiteColor];
            cancelBarButtonItem;
        });
        
        
        [self.view addSubview:self.couponView];
        [self setViewValueWithItem];
    }
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark
-(void)setViewValueWithItem{
    if (_itemData) {
        self.couponView.lb_OrderCode.text=[_itemData objectForKey:@"order_id"];
        NSString * datelineStr=[_itemData objectForKey:@"dateline"];
        if (datelineStr.length>0) {
            int dateline=[datelineStr intValue];
            self.couponView.lb_OrderDate.text=[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:dateline] DateFormat:@"yyyy-MM-dd HH:mm"  ];
            
        }else{
            self.couponView.lb_OrderDate.text=@"";
        }
        
        NSArray *arryNum=[[_itemData objectForKey:@"order_name"] componentsSeparatedByString:@"*"] ;
        if (arryNum.count>1) {
             self.couponView.lb_OrderNo.text=[arryNum lastObject];//截取字段
        }else
             self.couponView.lb_OrderNo.text=@"";
       
        self.couponView.lb_OrderPayMoney.text=[NSString stringWithFormat:@"%@元",[_itemData objectForKey:@"payment_money"] ];
        NSString * pay_timeStr=[_itemData objectForKey:@"dateline"];
        if (pay_timeStr.length>0) {
            int pay_time=[datelineStr intValue];
             self.couponView.lb_OrderPayTime.text=[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:pay_time] DateFormat:@"yyyy-MM-dd HH:mm"  ];
            
        }else{
             self.couponView.lb_OrderPayTime.text=@"";
        }
       
        self.couponView.lb_OrderPhone.text=[_itemData objectForKey:@"phone"];
        NSString *paid=[_itemData objectForKey:@"paid"];
        if ([paid  isEqualToString:@"0"]) {
            self.couponView.Lb_payType.text=@"未支付";
        }else{
            NSString *pay_type=[_itemData objectForKey:@"pay_type"];
            if ([pay_type isEqualToString:@""]) {
                self.couponView.Lb_payType.text=@"余额支付";
            }else if([pay_type isEqualToString:@"weixin"]){
                 self.couponView.Lb_payType.text=@"微信支付";
            }else if([pay_type isEqualToString:@"alipay"]){
                self.couponView.Lb_payType.text=@"支付宝支付";
            }else if([pay_type isEqualToString:@"offline"]){
                self.couponView.Lb_payType.text=@"线下支付";
            }
        }
       
        
        self.couponView.lb_Price.text=[NSString stringWithFormat:@"%@元",[_itemData objectForKey:@"payment_money"] ];
        self.couponView.lb_ProductCode.text=[_itemData objectForKey:@"group_pass"];
        self.couponView.lb_productName.text=[_itemData objectForKey:@"merchant_name"];
        if (datelineStr.length>0) {
            int dateline=[datelineStr intValue];
            self.couponView.lb_ProductpatTime.text=[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:dateline] DateFormat:@"yyyy-MM-dd HH:mm"  ];
            
        }else{
            self.couponView.lb_ProductpatTime.text=@"";
        }
       
        self.couponView.lb_ProductTitle.text=[_itemData objectForKey:@"order_name"];
        
        [self.couponView.img_Product sd_setImageWithURL:[_itemData objectForKey:@"list_pic"] placeholderImage:[UIImage imageNamed:@""]];

        [self.couponView.img_QRCode setImage:[QRCodeGenerator qrImageForString:[_itemData objectForKey:@"qrcode_url"] imageSize:self.couponView.img_QRCode.bounds.size.width]];//生成二维码

    }
}

#pragma mark -懒加载
#pragma mark 主界面加载
-(CouponView *)couponView{
    if (!_couponView) {
        _couponView=[[CouponView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        _couponView.backgroundColor=[UIColor whiteColor];
    }
    return _couponView;
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
#pragma mark -
-(void)goDismiss:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
