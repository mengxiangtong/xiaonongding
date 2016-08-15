//
//  RankTableViewCell.m
//  ITNews
//
//  Created by Unlce Wang on 15/1/12.
//  Copyright (c) 2015年 Uncle Wang. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "UIWebViewViewController.h"
#import "RecommendViewController.h"
#import "NewLoginViewController.h"

@implementation RecommendTableViewCell

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
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat imageWidth = (kDeviceWidth -28)/2;
    CGFloat imageHight = imageWidth*216/325;
    
    self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, imageWidth, imageHight)];
    _cellImageView.image = [UIImage imageNamed:@"89.jpg"];
    [self.cellImageView setUserInteractionEnabled:YES];
    [self.contentView addSubview:_cellImageView];
    
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(14+imageWidth, 0, 0.5, kTodayCellH)];
    [self.contentView addSubview:line1];
    
    self.cellImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(21+imageWidth, 7, imageWidth, imageHight)];
    _cellImageView2.image = [UIImage imageNamed:@"89.jpg"];
    [self.contentView addSubview:_cellImageView2];
    [self.cellImageView2 setUserInteractionEnabled:YES];
    
    //1
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(_cellImageView.frame)+5, imageWidth, 40)];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#404040"];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont systemFontOfSize:15 ];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    [self.titleLabel setUserInteractionEnabled:YES];
    
    self.xiaoliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(_titleLabel.frame)+10, imageWidth/2, 20)];
    // _xiaoliangLabel.backgroundColor = [UIColor cyanColor];
    _xiaoliangLabel.textColor = [UIColor colorWithHexString:@"#a6a6a6"];
    _xiaoliangLabel.text = @"";
    _xiaoliangLabel.font = [UIFont systemFontOfSize:13 ];
    _xiaoliangLabel.numberOfLines = 1;
    [self.contentView addSubview:_xiaoliangLabel];
    
    self.priceLabel =[[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_xiaoliangLabel.frame), CGRectGetMaxY(_titleLabel.frame)+5 , imageWidth/2-20, 25)];
    // _priceLabel.backgroundColor = [UIColor cyanColor];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = [UIColor colorWithHexString:@"fe7666"];
    _priceLabel.text = @"";
    _priceLabel.font = [UIFont systemFontOfSize:16 ];
    _priceLabel.numberOfLines = 1;
    [self.contentView addSubview:_priceLabel];
    
    
    UILabel *jin = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel.frame)+3, CGRectGetMaxY(_titleLabel.frame)+10, 17, 20)];
    jin.textColor = RGBACOLOR(170, 170, 170, 1);
    jin.text = @"/斤";
    jin.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:jin];
    
    
    /////
    //2
    self.titleLabel2 =[[UILabel alloc] initWithFrame:CGRectMake(21+imageWidth, CGRectGetMaxY(_cellImageView.frame)+5, imageWidth, 40)];
    _titleLabel2.textColor = [UIColor colorWithHexString:@"#404040"];
    _titleLabel2.text = @"";
    _titleLabel2.font = [UIFont systemFontOfSize:15 ];
    _titleLabel2.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel2];
    [self.titleLabel2 setUserInteractionEnabled:YES];
    
    self.xiaoliangLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(21+imageWidth, CGRectGetMaxY(_titleLabel2.frame)+10, imageWidth/2, 20)];
    // _xiaoliangLabel.backgroundColor = [UIColor cyanColor];
    _xiaoliangLabel2.textColor = [UIColor colorWithHexString:@"#a6a6a6"];
    _xiaoliangLabel2.text = @"";
    _xiaoliangLabel2.font = [UIFont systemFontOfSize:13 ];
    _xiaoliangLabel2.numberOfLines = 1;
    [self.contentView addSubview:_xiaoliangLabel2];
    
    self.priceLabel2 =[[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_xiaoliangLabel2.frame), CGRectGetMaxY(_titleLabel.frame)+5 , imageWidth/2-20, 25)];
    // _priceLabel.backgroundColor = [UIColor cyanColor];
    _priceLabel2.textAlignment = NSTextAlignmentRight;
    _priceLabel2.textColor = [UIColor colorWithHexString:@"fe7666"];
    _priceLabel2.text = @"";
    _priceLabel2.font = [UIFont systemFontOfSize:16 ];
    _priceLabel2.numberOfLines = 1;
    [self.contentView addSubview:_priceLabel2];
    
    
    _jin2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceLabel2.frame)+3, CGRectGetMaxY(_titleLabel.frame)+10, 17, 20)];
    _jin2.textColor = RGBACOLOR(170, 170, 170, 1);
    _jin2.text = @"/斤";
    _jin2.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_jin2];
    
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    [self.cellImageView addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    [self.titleLabel addGestureRecognizer:tapRecognizer2];
    
    UITapGestureRecognizer *tapRecognizer3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    [self.cellImageView2 addGestureRecognizer:tapRecognizer3];
    
    UITapGestureRecognizer *tapRecognizer4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer_Action:)];
    [self.titleLabel2 addGestureRecognizer:tapRecognizer4];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 重写
#pragma mark dealloc
- (void)dealloc
{
    
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
    }else{
        //        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        //        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        //        [[RecommendViewController shareInstance].navigationController pushViewController:vc animated:YES];
        //        return;
    }

    
    
    if ([recognizer.view isEqual:self.cellImageView] || [recognizer.view isEqual:self.titleLabel]) {
        
        if (self.idStr1 && self.idStr1.length>0) {
            self.urlStr1=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",self.urlStr1,latitude,longitude,uid,token];
            
            UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
            [webview initUrlAndId:self.idStr1 urlstr:self.urlStr1];
            if (self.superVC) {
                [self.superVC.navigationController pushViewController:webview animated:YES];
            }else
                [[RecommendViewController shareInstance].navigationController pushViewController:webview animated:YES];
        }
    }else{
        
        if (self.idStr2 && self.idStr2.length>0) {
            self.urlStr2=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",self.urlStr2,latitude,longitude,uid,token];
            
            UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
            [webview initUrlAndId:self.idStr2 urlstr:self.urlStr2];
            if (self.superVC) {
                [self.superVC.navigationController pushViewController:webview animated:YES];
            }else
                [[RecommendViewController shareInstance].navigationController pushViewController:webview animated:YES];
        }
    }
}

@end
