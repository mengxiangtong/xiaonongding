//
//  IndexTableViewCell.m
//  LanKe(Businesses)
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 WanHao. All rights reserved.
//

#import "OverActiveTableViewCell.h"
@interface OverActiveTableViewCell()



@end
@implementation OverActiveTableViewCell

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
    
    self.contentView.backgroundColor = kGroupCityCellBgColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 190)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    self.lb_farm = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 40)];
    self.lb_farm.text = @"黄岛区前园";
    self.lb_farm.font = [UIFont systemFontOfSize:16];
    
    //自适应宽度
    CGFloat farmWith = [self.lb_farm.text
                        boundingRectWithSize:CGSizeMake(220, 40)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
                        context:nil
                        ].size.width ;
    
    _lb_farm.frame = CGRectMake(15, 0, farmWith, 40);
    [bgView addSubview:_lb_farm];
    
    self.lb_distance =[[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_lb_farm.frame)+10, 0, 80, 40)];
    _lb_distance.font = [UIFont systemFontOfSize:14];
    _lb_distance.text = @"50km";
    _lb_distance.textColor = [UIColor grayColor];
    [bgView addSubview:_lb_distance];
    
    self.lb_state =[[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-15-50, 0, 50, 40)];
    _lb_state.textAlignment  = NSTextAlignmentRight;
    _lb_state.font = [UIFont systemFontOfSize:16];
    _lb_state.text = @"已过期";
    _lb_state.textColor = RGBACOLOR(250, 87, 93, 1);
    [bgView addSubview:_lb_state];
    
    
    //横线
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kDeviceWidth-30, 0.5)];
    l1.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l1];
    
    
    //产品图片
    self.img_Product=[[UIImageView alloc]initWithFrame:CGRectMake(15, 50.0, 80.0, 80.0)];
    //[self.img_Product setImage:[UIImage imageNamed:@"index_wcl"]];
    [bgView addSubview:_img_Product];
    
    // 标题
    self.lb_Title=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(_img_Product.frame)+10, 50.0, kDeviceWidth-30-80-10, 50.0)];
    self.lb_Title.text=@"青岛大樱桃🍒很便宜，很好吃，23肯德基贷款贷款";
    _lb_Title.numberOfLines = 2;
    _lb_Title.textColor = [UIColor colorWithHexString:@"333333"];
    self.lb_Title.textAlignment=NSTextAlignmentLeft;
    [self.lb_Title setFont:[UIFont systemFontOfSize:15.0]];
    [bgView addSubview:_lb_Title];
    
    self.lb_Date=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_img_Product.frame)+10,CGRectGetMaxY(_lb_Title.frame)+10, kDeviceWidth-30-80-10, 20.0)];
    self.lb_Date.text=@"2014-12-12 09:23:11";
    self.lb_Date.textColor=[UIColor lightGrayColor];
    [self.lb_Date setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:_lb_Date];
    
    //横线2
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_img_Product.frame)+10, kDeviceWidth-30, 0.5)];
    l2.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l2];
    
    //
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(l2.frame)+10, 60, 30)];
    la.textColor = [UIColor grayColor];
    la.font = [UIFont systemFontOfSize:16];
    la.text = @"实付款:";
    [bgView  addSubview:la];
    
    //3
    self.lb_Price=[[UILabel alloc]initWithFrame:CGRectMake(15+60 , CGRectGetMaxY(l2.frame)+10, 100.0, 30.0)];
    self.lb_Price.text=@"234.0";
    self.lb_Price.textColor= [UIColor blackColor];
    self.lb_Price.textAlignment=NSTextAlignmentLeft;
    [self.lb_Price setFont:[UIFont boldSystemFontOfSize:16.0]];
    [bgView  addSubview:_lb_Price];
    
    //支付
    self.Btn_One = [UIButton buttonWithType:UIButtonTypeCustom];
    //_Btn_One.backgroundColor = [UIColor cyanColor];
    _Btn_One.frame = CGRectMake(kDeviceWidth-15-70, CGRectGetMaxY(l2.frame)+10, 70, 30);
    [_Btn_One setTitle:@"去支付" forState:0];
    [_Btn_One setTitleColor: RGBACOLOR(250, 87, 93, 1)  forState:0] ;
    _Btn_One.layer.borderColor = [RGBACOLOR(250, 87, 93, 1) CGColor] ;
    _Btn_One.layer.borderWidth = 1;
    _Btn_One.layer.masksToBounds = YES;
    _Btn_One.layer.cornerRadius = 2;
    [bgView  addSubview:_Btn_One];
    
    
    //地图
    self.Btn_Two = [UIButton buttonWithType:UIButtonTypeCustom];
    _Btn_Two.frame = CGRectMake(kDeviceWidth - 15-_Btn_One.frame.size.width - 10 -70 , CGRectGetMaxY(l2.frame)+10, 70, 30);
    [_Btn_Two setTitle:@"查地图" forState:0];
    [_Btn_Two setTitleColor: RGBACOLOR(250, 87, 93, 1)  forState:0] ;
    _Btn_Two.layer.borderColor = [RGBACOLOR(250, 87, 93, 1) CGColor] ;
    _Btn_Two.layer.borderWidth = 1;
    _Btn_Two.layer.masksToBounds = YES;
    _Btn_Two.layer.cornerRadius = 2;
    [bgView  addSubview:_Btn_Two];
    [_Btn_Two setHidden:YES];
}


-(void)setDic_Item:(NSDictionary *)dic_Item{
    _dic_Item=dic_Item;
    if (_dic_Item) {
        self.lb_farm.text =[dic_Item objectForKey:@"farm_name"];
        _lb_state.text = @"已过期";
        
        NSString *distanceStr=[dic_Item objectForKey:@"distance"];
        if (distanceStr && distanceStr.length>0) {
            CGFloat distance=[distanceStr floatValue];
            if(distance>1000){
                distanceStr=[NSString stringWithFormat:@"%.2fkm",distance/1000.0];
            }else{
                distanceStr=[NSString stringWithFormat:@"%.0fkm",distance];
            }
        }
        
        _lb_distance.text = distanceStr;
        [self.img_Product sd_setImageWithURL:[NSURL URLWithString:[dic_Item objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"index_wcl"]];
        self.lb_Title.text=[dic_Item objectForKey:@"name"];
        
        CGSize size = CGSizeMake(180,20); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: self.lb_Title.font};
        CGSize labelsize = [self.lb_Title.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        self.lb_Title.frame=CGRectMake(self.lb_Title.frame.origin.x, self.lb_Title.frame.origin.y, labelsize.width, self.lb_Title.frame.size.height);
        
        NSDictionary *attribute2 = @{NSFontAttributeName: self.lb_farm.font};
        CGSize labelsize2 = [self.lb_farm.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
        labelsize2.width=labelsize2.width>180.0?180.0:labelsize2.width;
        self.lb_farm.frame=CGRectMake(self.lb_farm.frame.origin.x, self.lb_farm.frame.origin.y, labelsize2.width, self.lb_farm.frame.size.height);
        self.lb_distance.frame=CGRectMake(CGRectGetMaxX(self.lb_farm.frame)+10.0, self.lb_distance.frame.origin.y, self.lb_distance.width, self.lb_distance.height);
        
        self.lb_Date.text=[NSString stringWithFormat:@"截止时间: %@",[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:[[dic_Item objectForKey:@"end_time"] integerValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss"]];
        self.lb_Price.text=[NSString stringWithFormat:@"¥%@", [dic_Item objectForKey:@"money"] ];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
