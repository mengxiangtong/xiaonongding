//
//  OrderOtherTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "OrderOtherTableViewCell.h"
@interface OrderOtherTableViewCell()




@end
@implementation OrderOtherTableViewCell

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
        self.lb_Left.text=[_data_item objectForKey:@"name"];
        self.lb_Right.text=[_data_item objectForKey:@"value"];
    }
}
@end
