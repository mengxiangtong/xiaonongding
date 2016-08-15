//
//  ProductTableViewCell.m
//  XiaoNongding
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "EditorViewController.h"
#import "UIWebViewViewController.h"
#import "MyCollectionVC.h"
#import "RegisterViewController.h"

@implementation ProductTableViewCell{
    UILabel *l2 ;
}

- (void)awakeFromNib {
    // Initialization code
}




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _isChecked=NO;
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
    self.lb_Title.text=@"";
    _lb_Title.numberOfLines = 2;
    _lb_Title.textColor = [UIColor colorWithHexString:@"333333"];
    self.lb_Title.textAlignment=NSTextAlignmentLeft;
    [self.lb_Title setFont:[UIFont systemFontOfSize:15.0]];
    [bgView addSubview:_lb_Title];
    
    
    self.lb_OldPrice=[[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_OldPrice.text=@"";
    self.lb_OldPrice.textColor=[UIColor lightGrayColor];
    [self.lb_OldPrice setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:self.lb_OldPrice];
    
    self.lb_Price=[[UILabel alloc]initWithFrame:CGRectZero];
    self.lb_Price.text=@"";
    self.lb_Price.textColor=[UIColor colorWithRed:203.0/255.0 green:80.0/255.0 blue:32.0/255.0 alpha:1.0];
    [self.lb_Price setFont:[UIFont systemFontOfSize:14.0]];
    [self.lb_Price setTextAlignment:NSTextAlignmentRight];
    [bgView addSubview:_lb_Price];
    
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
    self.lb_Title.frame=CGRectMake( CGRectGetMaxX(_img_Product.frame)+10, 20.0, kDeviceWidth-CGRectGetMaxX(_img_Product.frame)-10, 50.0);
    
    CGSize size = CGSizeMake(180,20); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: self.lb_OldPrice.font};
    CGSize labelsize = [self.lb_OldPrice.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    [self.lb_OldPrice setFrame:CGRectMake(CGRectGetMaxX(_img_Product.frame)+10,CGRectGetMaxY(_lb_Title.frame)+10, labelsize.width+20.0, 20.0)];
    
    self.lb_Price.frame=CGRectMake(kDeviceWidth-110,CGRectGetMaxY(_lb_Title.frame)+10, 100, 20.0);

    l2.frame=CGRectMake(15, CGRectGetMaxY(self.img_Product.frame)+19.0, kDeviceWidth-30.0, 1.0);
    
}


-(void)setStr_isEditor:(NSString *)str_isEditor{
    _str_isEditor=str_isEditor;
    [self setViewOffset];
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
            RegisterViewController *vc = [RegisterViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [nc setNavigationBarHidden:YES];
            nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
         
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
-(void)btn_selectAction:(UIButton *)sender{
    _isChecked=!_isChecked;
    if (_isChecked==YES) {
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];

    }
    if ([self.delegate respondsToSelector:@selector(selectedCell:item:)]) {
        [self.delegate selectedCell:_isChecked item:_data_item];
    }
}

-(void)setData_item:(NSDictionary *)data_item{
    _data_item=data_item;
    if (_data_item) {
        [self.img_Product sd_setImageWithURL:[NSURL URLWithString:[_data_item objectForKey:@"image"]] placeholderImage:nil];
        self.lb_Title.text=[_data_item objectForKey:@"name"];
        self.lb_Price.text=[NSString stringWithFormat:@"¥%@", [_data_item objectForKey:@"price"] ];

        NSAttributedString *attrStr =[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", [_data_item objectForKey:@"old_price"] ]
                                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c0c0c0"],
                                                                                 NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                 NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#c0c0c0"]}
                                      ];
        
        self.lb_OldPrice.attributedText = attrStr;
        
        [self setViewOffset];
    }
}

@end
