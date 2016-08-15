//
//  SearchFarmTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/1/28.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "SearchFarmTableViewCell.h"
@interface SearchFarmTableViewCell()
@property (nonatomic, retain) UILabel       *lb_Title;
@property (nonatomic, retain) UILabel       *lb_Name;
@property (nonatomic, retain) UILabel       *lb_Distance;
@property (nonatomic, retain) UIButton      *btn_CareDo;
@property (nonatomic, retain) UIImageView   *img_Bg;
@property (nonatomic, retain) UIImageView   *img_avatar;
@property (nonatomic, retain) UIImageView   *img_Care;
@property (nonatomic, retain) UILabel       *lb_Care;
@property (nonatomic, retain) UILabel       *lb_introduction;

@property (nonatomic, retain) UIView        *viewBg;

@end
@implementation SearchFarmTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        self.viewBg=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, self.height-10.0)];
        [self.viewBg setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.viewBg];
        
        self.img_avatar=[[UIImageView alloc]initWithFrame:CGRectMake(10.0, 10.0, 45.0, 45.0)];
        [self.img_avatar.layer setCornerRadius:22.5];
        [self.img_avatar.layer setMasksToBounds:YES];
        [self.img_avatar setImage:[UIImage imageNamed:@"1024"]];
        
        self.lb_Name=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_avatar.frame)+10.0, 10.0, 110.0, 20.0)];
        [self.lb_Name setTextAlignment:NSTextAlignmentLeft];
        [self.lb_Name setFont:[UIFont systemFontOfSize:17.0]];
        [self.lb_Name setText:@"农场主"];
        
        
        self.lb_Distance=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_avatar.frame)+10.0, CGRectGetMaxY(self.lb_Name.frame)+5.0, 180.0, 20.0)];
        [self.lb_Distance setTextAlignment:NSTextAlignmentLeft];
        [self.lb_Distance setFont:[UIFont systemFontOfSize:15.0]];
        [self.lb_Distance setText:@"距离:0km"];
        [self.viewBg addSubview:self.lb_Distance];

        self.btn_CareDo=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-70.0, 20.0, 60.0, 30.0)];
        [self.btn_CareDo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.btn_CareDo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        [self.btn_CareDo.titleLabel  setFont:[UIFont systemFontOfSize:15.0]];
        [self.btn_CareDo.titleLabel setTextAlignment:NSTextAlignmentRight];
        [self.btn_CareDo setTitleColor:KSearchCheckedColor forState:UIControlStateNormal];
        [self.btn_CareDo setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.btn_CareDo.layer setBorderColor:KSearchCheckedColor.CGColor];
        [self.btn_CareDo.layer setBorderWidth:1.5];
        [self.btn_CareDo.layer setCornerRadius:5.0];
        [self.btn_CareDo.layer setMasksToBounds:YES];
        [self.btn_CareDo setTitle:@"加关注" forState:UIControlStateNormal];
        [self.btn_CareDo addTarget:self action:@selector(btn_CareDoAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.viewBg addSubview:self.btn_CareDo];
        
        self.img_Bg=[[UIImageView alloc]initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.img_avatar.frame)+20.0, kDeviceWidth-20.0,(kDeviceWidth-20.0)/5.0*2.0)];
        [self.img_Bg setBackgroundColor:[UIColor grayColor]];
        [self.img_Bg setImage:[UIImage imageNamed:@"88.jpg"]];
        
        
        self.lb_Title=[[UILabel alloc]initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.img_Bg.frame)+10.0, kDeviceWidth, 20.0)];
        [self.lb_Title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [self.lb_Title setTextAlignment:NSTextAlignmentLeft];
        [self.lb_Title setText:@"青岛农场"];
        
        
        self.img_Care =[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth-100.0, 30.0, 14.0, 14.0)];
        [self.img_Care setImage:[UIImage imageNamed:@"collection"]];
        
        self.lb_Care=[[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-80.0, 25.0, 70.0, 25.0)];
        [self.lb_Care setTextColor:[UIColor whiteColor]];
        [self.lb_Care setTextAlignment:NSTextAlignmentLeft];
        [self.lb_Care setFont:[UIFont systemFontOfSize:14.0]];
        [self.lb_Care setText:@"关心人数"];
        
        UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.img_Bg.frame.size.height-50.0, kDeviceWidth-20.0, 50)];
        
        CAGradientLayer* _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        _gradientLayer.bounds = layerView.bounds;
        _gradientLayer.borderWidth = 0;
        
        _gradientLayer.frame = layerView.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[[UIColor clearColor] CGColor],
                                 (id)[[UIColor colorWithWhite:0.2 alpha:1.0] CGColor], nil, nil];
        _gradientLayer.startPoint = CGPointMake(0.5, 0.5);
        _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        
        [layerView.layer insertSublayer:_gradientLayer atIndex:0];
        
        
        [layerView addSubview:self.img_Care];
        [layerView addSubview:self.lb_Care];
        [self.img_Bg addSubview:layerView];
        
        self.lb_introduction=[[UILabel alloc]initWithFrame:CGRectMake(10.0, CGRectGetMaxY(self.lb_Title.frame)+5.0, kDeviceWidth-20.0, 20.0)];
        [self.lb_introduction setTextAlignment:NSTextAlignmentLeft];
        [self.lb_introduction setFont:[UIFont systemFontOfSize:15.0]];
        [self.lb_introduction setText:@"简介"];
        [self.lb_introduction setTextColor:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0]];
        [self.lb_introduction setNumberOfLines:0];
        
        [self.viewBg addSubview:self.img_Bg];
        [self.viewBg addSubview:self.img_avatar];
        [self.viewBg addSubview:self.lb_Name];
        [self.viewBg addSubview:self.lb_Title];
        [self.viewBg addSubview:self.lb_introduction];
        
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)btn_CareDoAction:(UIButton *)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该功能尚未开放" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)setData_item:(NSDictionary *)data_item{
    _data_item=data_item;
    
    if (_data_item) {

        [self.img_Bg sd_setImageWithURL:[_data_item objectForKey:@"merchant_theme_image"] placeholderImage:[UIImage imageNamed:@"defualtIcon.jpg"]];
        [self.img_avatar sd_setImageWithURL:[_data_item objectForKey:@"person_image"] placeholderImage:[UIImage imageNamed:@"defualtIcon.jpg"]];
        [self.lb_Title setText:[NSString stringWithFormat:@"%@",[_data_item objectForKey:@"name"]]];
        [self.lb_Name setText:[_data_item objectForKey:@"person_name"]];
        [self.lb_Care setText:[_data_item objectForKey:@"fans_count"]];
        
        CGSize size = CGSizeMake(self.lb_Care.frame.size.width,180); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: self.lb_Care.font};
        CGSize labelsize = [self.lb_Care.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        [self.lb_Care setFrame:CGRectMake(kDeviceWidth-labelsize.width-5.0-30.0, self.lb_Care.frame.origin.y, labelsize.width+5.0,  self.lb_Care.frame.size.height)];
        [self.img_Care setFrame:CGRectMake(kDeviceWidth-labelsize.width-5.0-30.0-20.0, self.img_Care.frame.origin.y, 14.0,  14.0)];
        
        
        NSString *distanceStr=[_data_item objectForKey:@"distance"];
        if (![distanceStr isEqual:[NSNull null]] && distanceStr && distanceStr.length>0) {
            CGFloat distance=[distanceStr floatValue];
            if(distance>1000){
                distanceStr=[NSString stringWithFormat:@"距离: %.2fkm",distance/1000.0];
            }else{
                distanceStr=[NSString stringWithFormat:@"距离: %.0fkm",distance];
            }
        }else{
            distanceStr=@"距离: 未知";
        }
        [self.lb_Distance setText:distanceStr];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self.lb_Distance.text];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0]
         
                              range:NSMakeRange(0, 3)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:KSearchCheckedColor
         
                              range:NSMakeRange(3, distanceStr.length-3)];
        self.lb_Distance.attributedText=AttributedStr;
        
        [self.lb_introduction setText:[_data_item objectForKey:@"person_info"]];
        
        size = CGSizeMake(self.lb_introduction.frame.size.width,180); //设置一个行高上限
        attribute = @{NSFontAttributeName: self.lb_introduction.font};
        labelsize = [self.lb_introduction.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        [self.lb_introduction setFrame:CGRectMake(self.lb_introduction.frame.origin.x, self.lb_introduction.frame.origin.y, self.lb_introduction.frame.size.width, labelsize.height)];
        self.viewBg.frame=CGRectMake(0.0, 0.0, kDeviceWidth, self.height-10.0);
        self.backgroundColor=[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        
        
        
    }
}


+ (CGFloat)cellHeightWithContact:(NSDictionary *)note{
    
    CGSize size = CGSizeMake(kDeviceWidth-20.0,180); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0]};
    CGSize labelsize = [[note objectForKey:@"person_info"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return  labelsize.height+(kDeviceWidth-20.0)/5.0*2.0-130.0+265.0;
}


@end
