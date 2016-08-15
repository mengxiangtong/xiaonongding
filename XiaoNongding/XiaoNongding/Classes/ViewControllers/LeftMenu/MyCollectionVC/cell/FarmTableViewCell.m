//
//  FarmTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 15/12/24.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "FarmTableViewCell.h"
#import "UIWebViewViewController.h"
#import "MyCollectionVC.h"
#import "NewLoginViewController.h"

@implementation FarmTableViewCell{
    UILabel *l2;
}

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        
        [self initWithPage];
        // [self setupLayoutConstraints];
    }
    
    return self;
}
-(void)initWithPage{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 120)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
 
    self.btn_select=[[UIButton alloc]initWithFrame:CGRectZero];
    [self.btn_select setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    [self.btn_select setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
    [self.btn_select addTarget:self action:@selector(btn_selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.btn_select];
 
    //产品图片
    self.img_Product=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.img_Product setImage:[UIImage imageNamed:@"index_wcl"]];
    [self.img_Product setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    [bgView addSubview:_img_Product];
    
    // 标题
    self.lb_Title=[[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_Title.text=@"青岛克里斯蒂娜农庄";
    _lb_Title.numberOfLines = 2;
    _lb_Title.textColor = [UIColor colorWithHexString:@"333333"];
    self.lb_Title.textAlignment=NSTextAlignmentLeft;
    [self.lb_Title setFont:[UIFont systemFontOfSize:17.0]];
    [bgView addSubview:_lb_Title];
    
    self.lb_Score=[[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_Score.text=@"农庄评分: ";
    self.lb_Score.textColor=[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    [self.lb_Score setFont:[UIFont systemFontOfSize:15.0]];
    [bgView addSubview:self.lb_Score];
    
    self.img_Score1=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.img_Score1 setImage:[UIImage imageNamed:@"stars"]];
    [bgView addSubview:self.img_Score1];
    
    self.img_Score2=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.img_Score2 setImage:[UIImage imageNamed:@"stars"] ];
    [bgView addSubview:self.img_Score2];
    
    self.img_Score3=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.img_Score3 setImage:[UIImage imageNamed:@"stars"] ];
    [self.contentView addSubview:self.img_Score3];
    
    self.img_Score4=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.img_Score4 setImage:[UIImage imageNamed:@"stars"] ];
    [bgView addSubview:self.img_Score4];
    
    self.img_Score5=[[UIImageView alloc]initWithFrame:CGRectZero];
    [self.img_Score5 setImage:[UIImage imageNamed:@"stars"] ];
    [bgView addSubview:self.img_Score5];
    
    
    
    self.lb_Attention=[[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_Attention.text=@"关注: ";
    self.lb_Attention.textColor=[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    [self.lb_Attention setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:self.lb_Attention];
    
    self.lb_Distance=[[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_Distance.text=@"距离: 未知";
    [self.lb_Distance setTextAlignment:NSTextAlignmentRight];
    self.lb_Distance.textColor=[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    [self.lb_Distance setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:self.lb_Distance];
    
    //横线2
    l2 = [[UILabel alloc] initWithFrame:CGRectZero];
    l2.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l2];
}
-(void)setViewOffset{
    
    self.contentView.backgroundColor = kGroupCityCellBgColor;

    if ([_str_isEditor isEqualToString:@"1"]) {
        self.btn_select.frame=CGRectMake(15.0, 0.0, 30.0, 120.0);
    }else{
        self.btn_select.frame=CGRectMake(0.0, 25.0, 0.0, 0.0);
    }
    
    //产品图片
    self.img_Product.frame=CGRectMake(CGRectGetMaxX(self.btn_select.frame)+15.0, 20.0, 80.0, 80.0);

    // 标题
    self.lb_Title.frame=CGRectMake( CGRectGetMaxX(_img_Product.frame)+10, 15.0, kDeviceWidth-CGRectGetMaxX(_img_Product.frame)-10, 27.0);

    self.lb_Score.frame=CGRectMake(CGRectGetMaxX(_img_Product.frame)+10,CGRectGetMaxY(_lb_Title.frame)+5.0, 65.0, 27.0);

    self.img_Score1.frame=CGRectMake(CGRectGetMaxX(_lb_Score.frame)+10.0, CGRectGetMaxY(_lb_Title.frame)+10.0, 18.0, 18.0);

    self.img_Score2.frame=CGRectMake(CGRectGetMaxX(_img_Score1.frame)+5.0, CGRectGetMaxY(_lb_Title.frame)+10.0, 18.0, 18.0);

    self.img_Score3.frame=CGRectMake(CGRectGetMaxX(_img_Score2.frame)+5.0, CGRectGetMaxY(_lb_Title.frame)+10.0, 18.0, 18.0);

    self.img_Score4.frame=CGRectMake(CGRectGetMaxX(_img_Score3.frame)+5.0, CGRectGetMaxY(_lb_Title.frame)+10.0, 18.0, 18.0);
    
    self.img_Score5.frame=CGRectMake(CGRectGetMaxX(_img_Score4.frame)+5.0, CGRectGetMaxY(_lb_Title.frame)+10.0, 18.0, 18.0);
    
    self.lb_Attention.frame=CGRectMake(CGRectGetMaxX(_img_Product.frame)+10,CGRectGetMaxY(_lb_Score.frame)+5.0, 100.0, 27.0);
    
    self.lb_Distance.frame=CGRectMake(kDeviceWidth-125.0,CGRectGetMaxY(_lb_Score.frame)+5.0, 120, 27.0);

    l2.frame=CGRectMake(15, CGRectGetMaxY(self.img_Product.frame)+19.0, kDeviceWidth-30.0, 1.0);
    
}

-(void)setStr_isEditor:(NSString *)str_isEditor{
    _str_isEditor=str_isEditor;
    
   
    [self setViewOffset];
}
-(void)btn_selectAction:(UIButton *)sender{
    _isChecked=!_isChecked;
    if (_isChecked==YES) {
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
    }else{
        [sender setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
    }
    if ([self.delegate respondsToSelector:@selector(selectedFarmCell:item:)]) {
        [self.delegate selectedFarmCell:_isChecked item:_data_item];
    }
}
-(void)setIsChecked:(BOOL)isChecked{
    _isChecked=isChecked;
    if (_isChecked==YES) {
        [self.btn_select setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.btn_select setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
    }else{
        [self.btn_select setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [self.btn_select setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
    }
    if ([self.delegate respondsToSelector:@selector(selectedFarmCell:item:)]) {
        [self.delegate selectedFarmCell:_isChecked item:_data_item];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
        NSString *latitude=[dicInfo objectForKey:@"latitude"];
        NSString *longitude=[dicInfo objectForKey:@"longitude"];
        
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            NewLoginViewController *vc = [NewLoginViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [[MyCollectionVC shareInstance] presentViewController:nc animated:YES completion:nil];
            return;
        }
        NSString *uid=[dic_userInfo objectForKey:@"uid"];
        NSString *token=[dic_userInfo objectForKey:@"token"];
        
        
        NSString *urlStr=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",[_data_item objectForKey:@"url"],latitude,longitude,uid,token];
        
        UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
        [webview initUrlAndId:nil urlstr:urlStr];
        
        [[MyCollectionVC shareInstance].navigationController pushViewController:webview animated:YES];
        
    }
    // Configure the view for the selected state
}



-(void)setData_item:(NSDictionary *)data_item{
    _data_item=data_item;
    if (_data_item) {
        [self.img_Product sd_setImageWithURL:[NSURL URLWithString:[_data_item objectForKey:@"image"]] placeholderImage:nil];
        self.lb_Title.text=[_data_item objectForKey:@"name"];
        int score=[[_data_item objectForKey:@"score" ] intValue];
        switch (score) {
            
            case 1:
                [self.img_Score1 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score2 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score3 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score4 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score5 setImage:[UIImage imageNamed:@"stars"]];
                break;
            case 2:
                [self.img_Score1 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score2 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score3 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score4 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score5 setImage:[UIImage imageNamed:@"stars"]];
                break;
            case 3:
                [self.img_Score1 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score2 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score3 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score4 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score5 setImage:[UIImage imageNamed:@"stars"]];
                break;
            case 4:
                [self.img_Score1 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score2 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score3 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score4 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score5 setImage:[UIImage imageNamed:@"stars"]];
                break;
            case 5:
                [self.img_Score1 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score2 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score3 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score4 setImage:[UIImage imageNamed:@"starsSelected"]];
                [self.img_Score5 setImage:[UIImage imageNamed:@"starsSelected"]];
                break;
                
            default:
                [self.img_Score1 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score2 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score3 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score4 setImage:[UIImage imageNamed:@"stars"]];
                [self.img_Score5 setImage:[UIImage imageNamed:@"stars"]];
                break;
        }
        
        self.lb_Attention.text=[NSString stringWithFormat:@"关注: %@",[_data_item objectForKey:@"fans_count" ] ];
        if ([_data_item objectForKey:@"distance" ]  &&[[_data_item objectForKey:@"distance" ] length]>0) {
            float distance=[[_data_item objectForKey:@"distance" ] floatValue];
            NSString *distanceStr;
            if (distance>1000) {
                distance=distance/1000.0;
                distanceStr=[NSString stringWithFormat:@"%.f km",distance];
            }else{
                distanceStr=[NSString stringWithFormat:@"%.f m",distance];
            }
            
            self.lb_Distance.text=[NSString stringWithFormat:@"距离: %@",distanceStr ];
        }


    }
}

@end
