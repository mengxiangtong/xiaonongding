//
//  RecommendNewTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/3/9.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "RecommendNewTableViewCell.h"
#import "UIWebViewViewController.h"
#import "RecommendViewController.h"
#import "NewLoginViewController.h"

@implementation RecommendNewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addAllViews];
    }
    return self;
}


#pragma mark - 添加所有视图元素
- (void)addAllViews
{
    CGFloat imageWidth = kDeviceWidth-14.0;
    CGFloat imageHight = (kDeviceWidth-14.0)/4.0*2.5;
    
    self.contentView.backgroundColor = kLightGraryColor;
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, imageHight+110.0)];
    bgview.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:bgview];
    
   
    
    self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, imageWidth, imageHight)];
    _cellImageView.image = [UIImage imageNamed:@"defualtIcon.jpg"];
    [self.cellImageView setUserInteractionEnabled:YES];
    [bgview addSubview:_cellImageView];
    
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(14+imageWidth, 0, 0.5, kTodayCellH)];
    [bgview addSubview:line1];
   
    

    
    self.priceLabel =[[UILabel alloc] initWithFrame:CGRectMake( 7, CGRectGetMaxY(self.cellImageView.frame) , 100.0, 105)];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor colorWithHexString:@"fe7666"];
    _priceLabel.text = @"";
    _priceLabel.font = [UIFont boldSystemFontOfSize:20 ];
    _priceLabel.numberOfLines = 2;
    [bgview addSubview:_priceLabel];
    
    //1
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+15.0, CGRectGetMaxY(_cellImageView.frame)+5, kDeviceWidth-self.priceLabel.width-29.0, 60)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#404040"];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont systemFontOfSize:15 ];
    _titleLabel.numberOfLines = 3;
    [bgview addSubview:_titleLabel];
    [self.titleLabel setUserInteractionEnabled:YES];
    
    self.xiaoliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+15.0, CGRectGetMaxY(self.titleLabel.frame)+5, kDeviceWidth-self.priceLabel.width-29.0, 30)];
    _xiaoliangLabel.textColor = [UIColor colorWithHexString:@"#a6a6a6"];
    _xiaoliangLabel.text = @"";
    _xiaoliangLabel.font = [UIFont systemFontOfSize:15 ];
    _xiaoliangLabel.numberOfLines = 1;
    [bgview addSubview:_xiaoliangLabel];
    
    
    UIView *jin = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame)+5.0, CGRectGetMaxY(self.cellImageView.frame)+8, 1.5, 88)];
    [jin setBackgroundColor:kCellLineColor];
    [bgview addSubview:jin];
    
    
    
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    [self.cellImageView addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    [self.titleLabel addGestureRecognizer:tapRecognizer2];
    
   
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapRecognizer_Action:(UIGestureRecognizer *)recognizer{
    
    
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
    
    
    
    if ([recognizer.view isEqual:self.cellImageView] || [recognizer.view isEqual:self.titleLabel]) {
        
        if (self.idStr && self.idStr.length>0) {
            self.urlStr=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",self.urlStr,latitude,longitude,uid,token];
            
//            [[UIWebViewViewController shareInstance] initUrlAndId:self.idStr urlstr:self.urlStr];
//            if (self.superVC) {
//                [self.superVC.navigationController pushViewController:[UIWebViewViewController shareInstance] animated:YES];
//            }else
//                [[RecommendViewController shareInstance].navigationController pushViewController:[UIWebViewViewController shareInstance] animated:YES];
            UIWebViewViewController *webview=[[UIWebViewViewController alloc] init ];
             [webview initUrlAndId:self.idStr urlstr:self.urlStr];
            if (self.superVC) {
                [self.superVC.navigationController pushViewController:webview animated:YES];
            }else
                [[RecommendViewController shareInstance].navigationController pushViewController:webview animated:YES];
        }
    }
}

@end
