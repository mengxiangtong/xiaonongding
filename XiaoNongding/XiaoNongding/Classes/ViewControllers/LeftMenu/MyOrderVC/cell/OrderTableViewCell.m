//
//  OrderTableViewCell.m
//  XiaoNongding
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "UIWebViewViewController.h"
#import "NewLoginViewController.h"
#import "AssessViewController.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        [self addAllViews];
        
        // [self setupLayoutConstraints];
    }
    
    return self;
}

-(void)addAllViews{
    
    self.contentView.backgroundColor = kTableViewSectionColor;
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    

    
    //卡券标志图片
    self.img_couponFlg=[[UIImageView alloc]initWithFrame:CGRectMake(0.0 , 10.0, 50.0, 20.0)];
    self.img_couponFlg.backgroundColor = [UIColor whiteColor];
    [self.img_couponFlg setImage:[UIImage imageNamed:@"券横.png"]];
    [bgView addSubview:self.img_couponFlg];
    self.lb_couponFlgtext=[[UILabel alloc]initWithFrame:CGRectMake(5.0, 10.0, 40.0, 20.0)];
    self.lb_couponFlgtext.text=@"卡券";
    self.lb_couponFlgtext.textAlignment=NSTextAlignmentLeft;
    self.lb_couponFlgtext.font=[UIFont systemFontOfSize:14.0 ];
    self.lb_couponFlgtext.textColor=[UIColor whiteColor];
    [bgView addSubview:self.lb_couponFlgtext];
    
    //卡券背景图片
    self.img_couponBg=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-210.0, 120.0, 120.0, 80.0)];
    self.img_couponBg.backgroundColor = [UIColor clearColor];
    [self.img_couponBg setImage:[UIImage imageNamed:@"券.png"]];
    [bgView addSubview:self.img_couponBg];
    
    
    //
    self.lb_farm = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 40)];
   // _lb_farm.backgroundColor = [UIColor yellowColor];
    self.lb_farm.text = @"黄岛区前园鸿佳桐家庭农场";
    self.lb_farm.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_lb_farm];
    
    //
    self.lb_state =[[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-15-50, 0, 50, 40)];
    //_lb_state.backgroundColor = [UIColor yellowColor];
    _lb_state.textAlignment  = NSTextAlignmentRight;
    _lb_state.font = [UIFont systemFontOfSize:16];
    _lb_state.text = @"待付款";
    _lb_state.textColor = RGBACOLOR(199.0, 199.0, 199.0, 1);
    [bgView addSubview:_lb_state];
    
    
    //横线
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kDeviceWidth-30, 0.5)];
    l1.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l1];
    

    //产品图片
    self.img_Product=[[UIImageView alloc]initWithFrame:CGRectMake(15, 50.0, 100.0, 80.0)];
    _img_Product.backgroundColor = [UIColor grayColor];
    //[self.img_Product setImage:[UIImage imageNamed:@"index_wcl"]];
    [bgView addSubview:_img_Product];
    
    // 标题
    self.lb_Title=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(_img_Product.frame)+10, 50.0, kDeviceWidth-30-100-10, 50.0)];
    self.lb_Title.text=@"青岛大樱桃🍒很便宜，很好吃，23肯德基贷款贷款";
    _lb_Title.numberOfLines = 2;
    _lb_Title.textColor = [UIColor colorWithHexString:@"333333"];
    self.lb_Title.textAlignment=NSTextAlignmentLeft;
    [self.lb_Title setFont:[UIFont systemFontOfSize:15.0]];
    [bgView addSubview:_lb_Title];
    
    self.lb_Date=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_img_Product.frame)+10,CGRectGetMaxY(_lb_Title.frame)+10, kDeviceWidth-30-100-10, 20.0)];
    self.lb_Date.text=@"2014-12-12 09:23:11";
    self.lb_Date.textColor=[UIColor lightGrayColor];
    [self.lb_Date setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:_lb_Date];

    
   
    
    //横线2
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_img_Product.frame)+10, kDeviceWidth-30, 0.5)];
    l2.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l2];
    
    //
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(l2.frame)+10, 60, 40)];
    la.textColor = [UIColor grayColor];
    la.font = [UIFont systemFontOfSize:16];
    la.text = @"实付款:";
    [bgView  addSubview:la];

    //3
    self.lb_Price=[[UILabel alloc]initWithFrame:CGRectMake(15+60 , CGRectGetMaxY(l2.frame)+10, 100.0, 40.0)];
    self.lb_Price.text=@"234.0";
    self.lb_Price.textColor= [UIColor blackColor];
    self.lb_Price.textAlignment=NSTextAlignmentLeft;
    [self.lb_Price setFont:[UIFont systemFontOfSize:16.0]];
    [bgView  addSubview:_lb_Price];

    
    self.Btn_One = [UIButton buttonWithType:UIButtonTypeCustom];
    _Btn_One.frame = CGRectMake(kDeviceWidth-15-70, CGRectGetMaxY(l2.frame)+15, 70, 30);
    [_Btn_One setTitle:@"去支付" forState:0];
    _Btn_One.titleLabel.font = [UIFont systemFontOfSize:15];
    [_Btn_One setTitleColor: RGBACOLOR(53, 170, 109, 1)  forState:0] ;
    _Btn_One.layer.borderColor = [RGBACOLOR(53, 170, 109, 1) CGColor] ;
    _Btn_One.layer.borderWidth = 1;
    _Btn_One.layer.masksToBounds = YES;
    _Btn_One.layer.cornerRadius = 2;
    [_Btn_One  addTarget:self action:@selector(btnOneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView  addSubview:_Btn_One];

    self.Btn_Two = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Btn_Two.frame = CGRectMake(kDeviceWidth-85-105, CGRectGetMaxY(l2.frame)+15, 90, 30);
    [self.Btn_Two setTitle:@"再次购买" forState:0];
    self.Btn_Two.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.Btn_Two setTitleColor: RGBACOLOR(250, 87, 93, 1)  forState:0] ;
    self.Btn_Two.layer.borderColor = [RGBACOLOR(250, 87, 93, 1) CGColor] ;
    self.Btn_Two.layer.borderWidth = 1;
    self.Btn_Two.layer.masksToBounds = YES;
    self.Btn_Two.layer.cornerRadius = 2;
    [_Btn_Two  addTarget:self action:@selector(btnTwoAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView  addSubview:self.Btn_Two];
}


-(void)setItem_Data:(NSDictionary *)item_Data{
    _item_Data=item_Data;
    [self.Btn_Two  setHidden:YES];
    [self.Btn_One  setHidden:YES];
    
    [_Btn_One setTitleColor: RGBACOLOR(53, 170, 109, 1)  forState:0] ;
    _Btn_One.layer.borderColor = [RGBACOLOR(53, 170, 109, 1) CGColor] ;
    
    if (_item_Data) {
        self.lb_farm.text=[_item_Data objectForKey:@"merchant_name"];
        NSString *status=[_item_Data objectForKey:@"status"];
        NSString *orderType=[_item_Data objectForKey:@"name"];
        NSString *user_confirm=[_item_Data objectForKey:@"user_confirm"];
        NSString *paid=[_item_Data objectForKey:@"paid"];
        /**
        name=2 状态status：0为未消费，1为未评价，2为已完成，3为已退款，4为已删除（目前删除状态的不会显示）
        还要说明user_confirm=1，为确认收货;user_confirm=0,为未确认
        paid=1为已支付，paid=0为未支付
        
        name=1 状态status：0:未使用，1:已使用未评价，2:已完成，3：已删除（如果是已支付并删除则为退款，目前删除状态的不会显示）
        还要说明user_confirm=1，为确认收货;user_confirm=0,为未确认
        paid=1为已支付，paid=0为未支付
        **/
        if ([orderType isEqualToString:@"1"]) {
            
            if ([status isEqualToString:@"0"]) {
                if ([paid isEqualToString:@"1"]) {
                    self.lb_state.text = @"已付款";
                    [self.Btn_One  setHidden:NO];
                    
                    [self.Btn_One setTitle:@"待发货" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:NO];
                }else if([paid isEqualToString:@"0"]){
                    self.lb_state.text = @"待付款";
                    [self.Btn_One  setHidden:NO];
                    [_Btn_One setTitleColor: RGBACOLOR(250, 87, 93, 1)  forState:0] ;
                     _Btn_One.layer.borderColor = [RGBACOLOR(250, 87, 93, 1) CGColor] ;
                    [self.Btn_One setTitle:@"去付款" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:YES];
                }
            }else if ([status isEqualToString:@"1"]) {
                if([user_confirm isEqualToString:@"0"]){
                    
                    self.lb_state.text = @"待收货";
                    [self.Btn_One  setHidden:NO];
                    [self.Btn_One setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:YES];
                }else{
                    self.lb_state.text = @"待评价";
                    [self.Btn_One  setHidden:NO];
                    [self.Btn_One setTitle:@"去评价" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:YES];
                    
                    [self.Btn_Two  setHidden:NO];
                    [self.Btn_Two setTitle:@"再次购买" forState:UIControlStateNormal];
                }
            }else if([status isEqualToString:@"2"]){
                self.lb_state.text = @"已完成";
                
            }else if([status  isEqualToString:@"3"]){
                self.lb_state.text = @"已退款";
            }else if([status  isEqualToString:@"4"]){
                self.lb_state.text = @"已删除";
            }else{
                self.lb_state.text = @"";
            }
           
        }else if ([orderType isEqualToString:@"2"]){
            
            NSString *tuan_type=[_item_Data objectForKey:@"tuan_type"];
           
            if ([status isEqualToString:@"0"]) {
                if ([paid isEqualToString:@"1"]) {
                    self.lb_state.text = @"已付款";
                  
                    [self.Btn_One  setHidden:NO];
                    [self.Btn_One setTitle:@"待发货" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:NO];
                }else if([paid isEqualToString:@"0"]){
                    self.lb_state.text = @"待付款";
                    [self.Btn_One  setHidden:NO];
                    [_Btn_One setTitleColor: RGBACOLOR(250, 87, 93, 1)  forState:0] ;
                     _Btn_One.layer.borderColor = [RGBACOLOR(250, 87, 93, 1) CGColor] ;
                    [self.Btn_One setTitle:@"去付款" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:YES];
                }
            }else if ([status isEqualToString:@"1"]) {
                
                if([user_confirm isEqualToString:@"0"]){
                    
                    self.lb_state.text = @"待收货";
                    [self.Btn_One  setHidden:NO];
                    [self.Btn_One setTitle:@"确认收货" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:YES];
                }else{
                    self.lb_state.text = @"待评价";
                    [self.Btn_One  setHidden:NO];
                    [self.Btn_One setTitle:@"去评价" forState:UIControlStateNormal];
                    [self.Btn_One setEnabled:YES];
                    
                    [self.Btn_Two  setHidden:NO];
                    [self.Btn_Two setTitle:@"再次购买" forState:UIControlStateNormal];
                }
            }else if([status isEqualToString:@"2"]){
                self.lb_state.text = @"已完成";
            }else if([status  isEqualToString:@"3"]){
                self.lb_state.text = @"已删除";
            }else{
                self.lb_state.text = @"";
            }
            
            //如果是虚拟商品
            if(![tuan_type isEqualToString:@"2"]){
                
                if ([status isEqualToString:@"0"]) {
                    if ([paid isEqualToString:@"1"]) {
                        self.lb_state.text = @"待使用";
                        [self.Btn_Two  setHidden:YES];
                        [self.Btn_One  setHidden:YES];
                    }
                }else if ([status isEqualToString:@"1"]) {
                    if([user_confirm isEqualToString:@"0"]){
                        self.lb_state.text = @"待使用";
                        [self.Btn_Two  setHidden:YES];
                        [self.Btn_One  setHidden:YES];
                    }else if([user_confirm isEqualToString:@"1"]){
                        self.lb_state.text = @"已使用";
                        [self.Btn_Two  setHidden:YES];

                        [self.Btn_One  setHidden:YES];
                        [self.Btn_One setTitle:@"去评价" forState:UIControlStateNormal];
                        [self.Btn_One setEnabled:YES];
                    }
                }else if ([status isEqualToString:@"2"]) {
                    self.lb_state.text = @"已完成";
                    [self.Btn_Two  setHidden:YES];
                    [self.Btn_One  setHidden:YES];
                }
            }
        }
        
        self.lb_Title.text=[_item_Data objectForKey:@"order_name"];//订单名称
        NSString* dateline=[_item_Data objectForKey:@"dateline"] ;
        
        self.lb_Date.text=[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:[dateline intValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss"];//下单日期
         self.lb_Price.text=[NSString stringWithFormat:@"¥%@",[_item_Data objectForKey:@"order_price"] ];//订单总价格
        [self.img_Product sd_setImageWithURL:[NSURL URLWithString:[_item_Data objectForKey:@"list_pic"]] placeholderImage:[UIImage imageNamed:@"defualtIcon.jpg"]];//图片地址
        
        if([[_item_Data  objectForKey:@"name"] isEqualToString:@"2"] &&[[_item_Data objectForKey:@"tuan_type"] isEqualToString:@"2"]){
            [self.img_couponFlg setHidden:YES];
            [self.img_couponBg setHidden:YES];
            [self.lb_couponFlgtext setHidden:YES];
            [self.lb_farm setFrame:CGRectMake(15, 0, 220, 40)];
        }else{
            [self.img_couponFlg setHidden:NO];
            [self.img_couponBg setHidden:NO];
            [self.lb_couponFlgtext setHidden:NO];
            [self.lb_farm setFrame:CGRectMake(60.0, 0, 195.0, 40)];
        }
    }
}

//去付款 去评价  确认收货
-(void)btnOneAction:(UIButton *)sender{
    
    NSString *status=[_item_Data objectForKey:@"status"];
    NSString *orderType=[_item_Data objectForKey:@"name"];
    NSString *user_confirm=[_item_Data objectForKey:@"user_confirm"];
    NSString *paid=[_item_Data objectForKey:@"paid"];
    NSString *orderId=[_item_Data objectForKey:@"order_id"];
    
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

    if ([orderType isEqualToString:@"1"]) {
        
        if ([status isEqualToString:@"0"]) {
            
            if([paid isEqualToString:@"0"]){
       
                //去付款
                UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
                [webview setUrlStr:[NSString stringWithFormat: KPayWebURL,orderId,uid,token,latitude,longitude ] ];
                [_superVC.navigationController pushViewController:webview animated:YES];
            }
        }else if ([status isEqualToString:@"1"]) {
            
            if([user_confirm isEqualToString:@"0"]){
                //确认收货
                if ([self.delegate respondsToSelector:@selector(OrderConfirmWithDic:)]) {
                    [self.delegate OrderConfirmWithDic:_item_Data];
                }
            }else{
                //去评价
                AssessViewController *assessVC= [[AssessViewController alloc]init];
                [assessVC setData_item:_item_Data];
                [self.superVC.navigationController pushViewController:assessVC animated:YES];
                
            }
         
            return;
        }
        
    }else if ([orderType isEqualToString:@"2"]){
        
        if ([status isEqualToString:@"0"]) {
            
            if([paid isEqualToString:@"0"]){
                //去付款
                UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
                [webview setUrlStr:[NSString stringWithFormat: KPayWebURL,orderId,uid,token,latitude,longitude ] ];
                [_superVC.navigationController pushViewController:webview animated:YES];
            }
        }else if ([status isEqualToString:@"1"]) {
            
            if([user_confirm isEqualToString:@"0"]){
                //确认收货
                if ([self.delegate respondsToSelector:@selector(OrderConfirmWithDic:)]) {
                    [self.delegate OrderConfirmWithDic:_item_Data];
                }
            }else{
                //去评价
                AssessViewController *assessVC= [[AssessViewController alloc]init];
                [assessVC setData_item:_item_Data];
                [self.superVC.navigationController pushViewController:assessVC animated:YES];
            }
            
            return;
        }
    }
}

//再次购买
-(void)btnTwoAction:(UIButton *)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该功能尚未开放" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
