//
//  walletTableView.m
//  XiaoNongding
//
//  Created by jion on 16/2/18.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "walletTableView.h"
#import "walletTableViewCell.h"
#import "walletMainViewController.h"
#import "IntegralViewController.h"

@interface walletTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UITableView   *tableView;
@property (nonatomic, retain) UIView        *headrView;
@property (nonatomic, retain) UIImageView   *avatarView;
@property (nonatomic, retain) UIButton      *nickView;
@property (nonatomic, retain) UILabel       *label_left;
@property (nonatomic, retain) UILabel       *label_right;
@property (nonatomic, retain) NSArray       *dataSuource;
@property (nonatomic , retain) UIView       *bgView_NoData;

@end

@implementation walletTableView


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
//        _dataSuource=@[@"消费记录",@"我的积分",@"优惠卷"];
        _dataSuource=@[@"我的积分"];
        self.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0];
        [self.headrView addSubview:self.avatarView];
        [self.headrView addSubview:self.nickView];
        [self.headrView addSubview:self.label_left];
        [self.headrView addSubview:self.label_right];
        [self.tableView setTableHeaderView:self.headrView];
        [self.tableView setTableFooterView:self.bgView_NoData];
        [self addSubview:self.tableView];
        
    }
    return self;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0];
        _tableView.separatorColor = [UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0];
        [_tableView registerNib:[UINib nibWithNibName:KwalletTableViewCell bundle:nil] forCellReuseIdentifier:KwalletTableViewCell];
       
        
    }
    return _tableView;
}
-(UIView *)headrView{
    if (!_headrView) {
        _headrView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 250.0)];
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 150.0)];
        [imgView setImage:[UIImage imageNamed:@"bgWalletHead.png"]];
        [_headrView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0]];
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(-1.0, 230.0, kDeviceWidth+2.0, 20.0)];
        view.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1.0];
        view.layer.borderWidth=1.0;
        view.layer.borderColor=[UIColor colorWithRed:232.0/255.0 green:237.0/255.0 blue:241.0/255.0 alpha:1.0].CGColor;
        
        [_headrView addSubview:imgView];
        [_headrView addSubview:view];
    }
    return _headrView;
}
-(UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView=[[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth/2.0-40.0, 25.0, 80.0, 80.0)];
        [_avatarView.layer setCornerRadius:40.0];
        [_avatarView.layer setMasksToBounds:YES];
        [_avatarView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_avatarView.layer setBorderWidth:2.0];
        NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        NSString *avatar=[userInfo objectForKey:@"avatar"];
        [_avatarView  sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"180.png"]];
//        [_avatarView addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}
-(UIButton *)nickView{
    if (!_nickView) {
        _nickView=[[UIButton alloc]initWithFrame:CGRectMake(50.0, 110.0, kDeviceWidth-100.0, 30.0)];
        [_nickView.layer setCornerRadius:15.0];
        [_nickView.layer setMasksToBounds:YES];
        [_nickView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:108.0/255.0 blue:73.0/255.0 alpha:0.3]];
        NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        NSString *nickname=[userInfo objectForKey:@"nickname"];
        [_nickView setTitle:nickname forState:UIControlStateNormal];
        [_nickView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nickView.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [_nickView addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nickView;
}
-(UILabel *)label_left{
    if (!_label_left) {
        _label_left=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 150.0, kDeviceWidth/2.0-0.5, 80.0)];
        [_label_left setBackgroundColor:[UIColor whiteColor]];
        [_label_left setTextAlignment: NSTextAlignmentCenter];
        NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        NSString *now_money=[userInfo objectForKey:@"now_money"];
        [_label_left setText:[NSString stringWithFormat:@"¥%@\n我的余额",now_money ] ];

        _label_left.numberOfLines=2;
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_label_left.text];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:25.0]
         
                              range:NSMakeRange(0, now_money.length+1)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor redColor]
         
                              range:NSMakeRange(0, now_money.length+1)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor grayColor]
         
                              range:NSMakeRange(now_money.length+2, 4)];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:14.0]
         
                              range:NSMakeRange(now_money.length+2, 4)];
        _label_left.attributedText=AttributedStr;
    }
    return _label_left;
}
-(UILabel *)label_right{
    if (!_label_right) {
        _label_right=[[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/2.0+0.5, 150.0, kDeviceWidth/2.0-0.5, 80.0)];
        [_label_right setBackgroundColor:[UIColor whiteColor]];
        [_label_right setTextAlignment:NSTextAlignmentCenter];
        _label_right.numberOfLines=2;
        NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        NSString *score_count=[userInfo objectForKey:@"score_count"];
        [_label_right setText:[NSString stringWithFormat:@"%@\n我的积分",score_count ] ];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_label_right.text];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:25.0]
         
                              range:NSMakeRange(0, score_count.length)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor blackColor]
         
                              range:NSMakeRange(0, score_count.length)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor grayColor]
         
                              range:NSMakeRange(score_count.length+1, 4)];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:14.0]
         
                              range:NSMakeRange(score_count.length+1, 4)];
        _label_right.attributedText=AttributedStr;

        
     
    }
    return _label_right;
}

-(UIView *)bgView_NoData{
    if (!_bgView_NoData) {
        _bgView_NoData=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, KDeviceHeight)];
        [_bgView_NoData setBackgroundColor:kGroupCityCellBgColor];
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth-250.0)/2.0, (self.tableView.height-50.0)/2.0, 250.0, 50.0)];
        [img setImage:[UIImage imageNamed:@"bgDefault.png"]];
        [_bgView_NoData addSubview:img];
    }
    return _bgView_NoData;
}

-(void)userInfoAction:(UIButton *)sender{
    
}
#pragma mark - Table 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSuource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    walletTableViewCell *cell=(walletTableViewCell *)[tableView dequeueReusableCellWithIdentifier:KwalletTableViewCell];
    if (!cell) {
        cell=[[walletTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KwalletTableViewCell];
    }
    [cell.titlelabel setText:_dataSuource[indexPath.row] ];
    NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    NSString *score_count=[userInfo objectForKey:@"score_count"];
    [cell.valueLabel setText:score_count ];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row!=1) {
        [[walletMainViewController shareInstance].navigationController pushViewController:[[IntegralViewController alloc]init] animated:YES];
    }
}
-(void)refreshdata{
    [self.tableView reloadData ];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
