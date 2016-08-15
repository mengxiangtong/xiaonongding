//
//  OrderAdressTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "OrderAdressTableViewCell.h"
#import "OrderDetailViewController.h"
#import "AddAddressVC.h"

@interface OrderAdressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_Phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_Address;
@property (weak, nonatomic) IBOutlet UIButton *btn_AddAddress;




@end
@implementation OrderAdressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData_item:(NSDictionary *)data_item{
    _data_item=data_item;
    if (_data_item) {
        self.lb_name.text=[_data_item objectForKey:@"name"];
        self.lb_Phone.text=[_data_item objectForKey:@"phone"];
        self.lb_Address.text=[_data_item objectForKey:@"address"];
//        if ([[_data_item objectForKey:@"address"] length]<=0)
//            [self.btn_AddAddress setHidden:NO];
//        else
            [self.btn_AddAddress setHidden:YES];
    }else{
        self.lb_name.text=@"";
        self.lb_Phone.text=@"";
        self.lb_Address.text=@"";
         [self.btn_AddAddress setHidden:NO];
    }
}
- (IBAction)addAddress_Action:(id)sender {
    [[OrderDetailViewController shareInstance].navigationController pushViewController:[AddAddressVC shareInstance] animated:YES ];
}

@end
