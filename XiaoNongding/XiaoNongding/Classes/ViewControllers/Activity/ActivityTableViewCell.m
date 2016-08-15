//
//  ActivityTableViewCell.m
//  XiaoNongding
//
//  Created by jion on 16/1/12.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "ActivityViewController.h"
#import "UIWebViewViewController.h"
#import "NewLoginViewController.h"

@interface ActivityTableViewCell()
@property (nonatomic,retain) UIImageView *img_Activity;
@property (nonatomic,retain) UIView  *view_line;
@property (nonatomic,retain) UILabel *lb_Title;
@property (nonatomic,retain) UILabel *lb_EndDate;
@property (nonatomic,retain) UIView  *viewBg;
@end
@implementation ActivityTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor grayColor]];
        
        [self addAllViews];
    }
    return self;
}
#pragma mark - 添加所有视图元素
- (void)addAllViews
{
    
    self.contentView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    self.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    
    float imgWidth=(kDeviceWidth-20)/7.0*4.0;
    float imgHeight=imgWidth/4.0*2.8;
    self.viewBg=[[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, kDeviceWidth-20, imgHeight)];
    [self.viewBg setBackgroundColor:[UIColor whiteColor]];
    
    self.img_Activity = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, (kDeviceWidth-20)/7.0*4.0, imgHeight)];
    
    
    self.lb_Title=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_Activity.frame)+10.0, 0.0, kDeviceWidth-CGRectGetMaxX(self.img_Activity.frame)-40.0, imgHeight/5.0*3.0)];
    [self.lb_Title setNumberOfLines:3.0];
    [self.lb_Title setFont:[UIFont systemFontOfSize:18.0]];
    
    self.view_line=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_Activity.frame)+10.0, imgHeight/5.0*3.0, kDeviceWidth-CGRectGetMaxX(self.img_Activity.frame)-40.0, 1.0)];
    [self.view_line setBackgroundColor:KScrollViewBackGroundColor];
    
    
    self.lb_EndDate=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.img_Activity.frame)+10.0, CGRectGetMaxY(self.view_line.frame), self.view_line.width, imgHeight/5.0*2.0)];
    [self.lb_EndDate setNumberOfLines:2.0];
    [self.lb_EndDate setFont:[UIFont systemFontOfSize:14.0]];
    [self.viewBg addSubview:self.img_Activity];
    [self.viewBg addSubview:self.lb_EndDate];
    [self.viewBg addSubview:self.lb_Title];
    [self.viewBg addSubview:self.view_line];
    [self.contentView addSubview:self.viewBg];
}

-(void)setItem_Activity:(NSDictionary *)item_Activity{
    _item_Activity=item_Activity;
    
    if (_item_Activity) {
       
        NSString *list_pic=[_item_Activity objectForKey:@"list_pic"];
        [_img_Activity sd_setImageWithURL:[NSURL URLWithString:list_pic] placeholderImage:[UIImage imageNamed:@"2"]];
        [self.lb_EndDate setText:[NSString stringWithFormat:@"截止: %@",[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:[[_item_Activity objectForKey:@"end_time"] integerValue]] DateFormat:@"yyyy-MM-dd"]]];
        [self.lb_Title setText:[_item_Activity objectForKey:@"product_name"]];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)tapRecognizer_Action:(UIGestureRecognizer *)sender{
    if ([sender.view  isEqual:self.img_Activity]) {
        if (_item_Activity) {
            NSMutableDictionary *dicInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"CLLocation"];
            NSString *latitude=[dicInfo objectForKey:@"latitude"];
            NSString *longitude=[dicInfo objectForKey:@"longitude"];
            
            NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
            if (!dic_userInfo) {
                [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
                NewLoginViewController *vc = [NewLoginViewController shareInstance];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [[ActivityViewController shareInstance] presentViewController:nc animated:YES completion:nil];
                return;
            }
            NSString *uid=[dic_userInfo objectForKey:@"uid"];
            NSString *token=[dic_userInfo objectForKey:@"token"];
            NSString *url=[_item_Activity objectForKey:@"url"];
            url=[NSString stringWithFormat:@"%@&lat=%@&long=%@&uid=%@&token=%@",url,latitude,longitude,uid,token];
            
            UIWebViewViewController*webview=[[UIWebViewViewController alloc]init];
            [webview initUrlAndId:nil urlstr:url];
            
            [[ActivityViewController shareInstance].navigationController pushViewController:webview animated:YES];
        }
    }
    self.contentView.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    self.backgroundColor=[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    [self.viewBg setBackgroundColor:[UIColor whiteColor]];
}



@end
