//
//  IntegralTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/2/25.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "IntegralTableViewCell.h"
@interface IntegralTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lb_Right;
@property (weak, nonatomic) IBOutlet UILabel *lb_Title;
@property (weak, nonatomic) IBOutlet UILabel *lb_Date;

@end
@implementation IntegralTableViewCell

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
        self.lb_Date.text=[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:[[_data_item objectForKey:@"time"] integerValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss"  ];
        self.lb_Title.text=[_data_item objectForKey:@"desc"];
        self.lb_Right.text=[_data_item objectForKey:@"score"];
        NSString *type=[_data_item objectForKey:@"type"];
        if (![[_data_item objectForKey:@"score"] isEqualToString:@"0"]) {
            if (type && [type isEqualToString:@"1"]) {
                [self.lb_Right setTextColor:kRedColor];
                self.lb_Right.text=[NSString stringWithFormat:@"+%@",[_data_item objectForKey:@"score"] ];
            }else{
                self.lb_Right.text=[NSString stringWithFormat:@"-%@",[_data_item objectForKey:@"score"] ];
                [self.lb_Right setTextColor:kBlackBgColor];
            }
        }
        
    }
}

@end
