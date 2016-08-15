//
//  AddressTableViewCell.m
//  XiaoNongding
//
//  Created by admin on 15/12/25.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "AddressManagerVC.h"
#import "AddAddressVC.h"
#import "NewLoginViewController.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initWithPage];
        
        // [self setupLayoutConstraints];
    }
    
    return self;
}

-(void)initWithPage{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
    self.contentView.backgroundColor = kGroupCityCellBgColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 130)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    self.lb_name = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
     self.lb_name.text = @"收货人";
     self.lb_name.textColor = [UIColor blackColor];
     self.lb_name.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_lb_name];
    
    //  电话
    self.lb_Title=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(_lb_name.frame)+10, 10, 110, 30.0)];
    self.lb_Title.text=@"收货人电话";
    _lb_Title.numberOfLines = 2;
    _lb_Title.textColor = [UIColor blackColor];
    self.lb_Title.textAlignment=NSTextAlignmentLeft;
    [self.lb_Title setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:_lb_Title];
    
    //
    self.lb_address=[[UILabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(_lb_Title.frame), kDeviceWidth-30, 30.0)];
    self.lb_address.text=@"收货人地址";
    self.lb_address.textColor=[UIColor blackColor];
    [self.lb_address setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:_lb_address];
    

    
    
    //横线
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_lb_address.frame)+10,  kDeviceWidth-30, 0.5)];
    l1.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l1];

    
    self.Btn_One = [UIButton buttonWithType:UIButtonTypeCustom];
    _Btn_One.frame = CGRectMake(kDeviceWidth-15-60, CGRectGetMaxY(l1.frame)+10, 60, 28);
    [_Btn_One setTitle:@"编辑" forState:0];
    _Btn_One.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_Btn_One setTitleColor: RGBACOLOR(82, 83, 84, 1)  forState:0] ;
    _Btn_One.layer.borderColor = [RGBACOLOR(82, 83, 84, 1)  CGColor] ;
    _Btn_One.layer.borderWidth = 1;
    _Btn_One.layer.masksToBounds = YES;
    _Btn_One.layer.cornerRadius = 2;
    [self.Btn_One setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.Btn_One setBackgroundImage:[SO_Convert createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [bgView  addSubview:_Btn_One];
    
    self.Btn_Two = [UIButton buttonWithType:UIButtonTypeCustom];
    _Btn_Two.frame = CGRectMake(kDeviceWidth-15-60 -15-60, CGRectGetMaxY(l1.frame)+10, 60, 28);
    [_Btn_Two setTitle:@"删除" forState:0];
    _Btn_Two.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_Btn_Two setTitleColor: RGBACOLOR(82, 83, 84, 1)  forState:0] ;
    _Btn_Two.layer.borderColor = [RGBACOLOR(82, 83, 84, 1)  CGColor] ;
    _Btn_Two.layer.borderWidth = 1;
    _Btn_Two.layer.masksToBounds = YES;
    _Btn_Two.layer.cornerRadius = 2;
    [self.Btn_Two setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.Btn_Two setBackgroundImage:[SO_Convert createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [bgView  addSubview:_Btn_Two];
    
    [self.Btn_One addTarget:self action:@selector(gotoEditAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.Btn_Two addTarget:self action:@selector(gotoDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)gotoEditAction:(UIButton *)sender{
    AddAddressVC *vc=[AddAddressVC shareInstance];
    [vc clearAllData];
    [vc setAllDataWithDic:_dic_item];
    [[AddressManagerVC shareInstance].navigationController pushViewController:vc animated:YES];
}

-(void)gotoDeleteAction:(UIButton *)sender{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"您确定要删除该收货地址吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self deleteItem];
    }
}
-(void)deleteItem{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [[AddressManagerVC shareInstance] presentViewController:nc animated:YES completion:nil];
        return;
    }
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KAddress_List_Delete_URL,[[_dic_item objectForKey:@"adress_id"] intValue],uid,token ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    //刷新数据
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                        [[AddressManagerVC shareInstance] RefreshAddressData];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XNDProgressHUD showWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                });
            }
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];
}


-(void)setDic_item:(NSDictionary *)dic_item{
    _dic_item=dic_item;
    if (_dic_item) {
        self.lb_name.text = [_dic_item objectForKey:@"name"];
        self.lb_Title.text=[_dic_item objectForKey:@"phone"];
        self.lb_address.text=[NSString stringWithFormat:@"%@%@%@%@",[_dic_item objectForKey:@"province_txt"],[_dic_item objectForKey:@"city_txt"],[_dic_item objectForKey:@"area_txt"],[_dic_item objectForKey:@"adress"] ];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
