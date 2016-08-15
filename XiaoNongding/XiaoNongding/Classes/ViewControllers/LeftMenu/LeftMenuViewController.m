//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "InvitingFriendsViewController.h"
#import "MyOrderVC/MyOrderViewController.h"
#import "MyAddressVC/AddressManagerVC.h"
#import "MyCollectionVC/MyCollectionVC.h"
#import "SettingVC/SettingViewController.h"
#import "RemindActive/RemindActiveVC.h"
#import "walletMainViewController.h"
#import "NewLoginViewController.h"

#define  kLeftW   (kDeviceWidth*540/715)


@interface LeftMenuViewController ()
{
    BOOL isLogin;
}
@property (nonatomic, retain) NSArray  *itemsArray;//标题
@property (nonatomic, retain) NSArray  *imagesArray;//图片

@property (nonatomic, retain) UIImageView *imageView ;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *loginBtn;

@property (nonatomic, retain) UILabel * redHint;

@end


@implementation LeftMenuViewController


#pragma mark - 懒加载

- (NSArray *)itemsArray
{
    if (!_itemsArray) {
        _itemsArray = @[@"我的订单", @"活动提醒",  @"我的收藏", @"我的钱包" , @"邀请好友", @"地址管理",  @"设置"];
    }
    return _itemsArray;
}

- (NSArray *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = @[@"order", @"active",  @"collection",@"iconfont-qianbao", @"invitation", @"address",  @"setting"];

    }
    return _imagesArray;
}


- (UILabel *)redHint
{
    if (!_redHint) {
        _redHint = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth*54/64 -20 -25, kDeviceWidth/14-9 , 16, 16)];
        _redHint.backgroundColor = RGBACOLOR(246, 80, 63, 1);
        _redHint.text = @"2";
        _redHint.font = [UIFont systemFontOfSize:15];
        _redHint.layer.masksToBounds = YES;
        _redHint.layer.cornerRadius = 8;
        _redHint.textAlignment = NSTextAlignmentCenter;
        _redHint.textColor = [UIColor whiteColor];
        
        CGFloat hintWith = [_redHint.text
                            boundingRectWithSize:CGSizeMake(40, 16)
                            options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                            context:nil
                            ].size.width ;
        
        _redHint.frame = CGRectMake(kDeviceWidth*54/64 -20-25,  kDeviceWidth/14-9, 8+ hintWith, 16);
        
    }
    return _redHint;
}






- (instancetype)init
{
    self = [super init];
    if (self) {
        isLogin = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];//黑色背景
    [self.view setAlpha:0.85];
    
    
    
    
    self.tableView.separatorColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:0.2f];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = YES;
    [Tooles setBlackExtraCellLineHidden:self.tableView];
    
    
    //self.tableView.scrollEnabled = NO;
    //self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.backgroundColor = [UIColor grayColor];
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 60+kDeviceWidth*190/715 +5+30+20 )];
        
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(60, 60+kDeviceWidth*190/715+5+30+20 , kDeviceWidth*54/64 -60-20, 0.2)];
//        line.backgroundColor = RGBACOLOR(218, 218, 218, 0.5);
//        [view addSubview:line];
        
        view.userInteractionEnabled = YES;
        
        CGFloat heardW = kDeviceWidth*190/715;
        
        //头像
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, heardW, heardW)];
        self.imageView .autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.imageView .image = [UIImage imageNamed:@"heardDefault.jpg"];
        self.imageView .layer.masksToBounds = YES;
        self.imageView .layer.cornerRadius = heardW/2;
        self.imageView .layer.borderColor = [UIColor whiteColor].CGColor;
        self.imageView .layer.borderWidth = 3.0f;
        self.imageView .layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.imageView .layer.shouldRasterize = YES;
        self.imageView .clipsToBounds = YES;
        self.imageView .userInteractionEnabled=YES;
        [view addSubview:self.imageView ];
        
        
        
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView .frame)+5, 0, 30)];
        self.label.text = @"点击登录,体验更多";
        self.label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        self.label.textColor = [UIColor colorWithRed:54.0/255.0 green:180.0/255.0 blue:148.0/255.0 alpha:1.0];
        self.label.textAlignment=NSTextAlignmentCenter;
        [self.label sizeToFit];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;//自动调整左右边距
        [self.label setUserInteractionEnabled:YES];
        [view addSubview:self.label];
        
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame =CGRectMake(60, 60, 200, heardW+24);
        _loginBtn.backgroundColor = [UIColor clearColor];
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:_loginBtn];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginBtnAction)];
        [self.label addGestureRecognizer:tap];
        [self.imageView addGestureRecognizer:tap];
        
        view;
    });
    
    
    //右
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0.0, 60.0, 0.0, 20.0)];
        
    }
    //左
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo];
    
    if (dic_userInfo) {
        NSString *avatar=[dic_userInfo objectForKey:@"avatar"];
        NSString *nickName=[dic_userInfo objectForKey:@"nickname"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"heardDefault.jpg"]];
        self.label.text=nickName;
    }else{
        [self.imageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"heardDefault.jpg"]];
        self.label.text=@"登录/注册";
    }
    
}

- (void)loginBtnAction
{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo];
    
    if (dic_userInfo) {
        //已经登录
    }else{
        RegisterViewController *vc = [RegisterViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [nc setNavigationBarHidden:YES];
        nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        
        [self.frostedViewController hideMenuViewController];
    }
    
}




#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

#pragma mark 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.row == 4){//邀请
        
        InvitingFriendsViewController *invitingVC=[[InvitingFriendsViewController alloc]init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:invitingVC];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    }else  if ( indexPath.row == 6){// 设置
        
        SettingViewController *vc = [[SettingViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        
    }else{
        NSDictionary *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!userInfo && userInfo.allKeys.count<=0) {
            if ( indexPath.row == 0) {
                MyOrderViewController *vc = [[MyOrderViewController alloc] init];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
                
            } else  if ( indexPath.row == 1){
                RemindActiveVC *vc = [[RemindActiveVC alloc] init];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
                
            }else  if ( indexPath.row == 2){//收藏
                
                MyCollectionVC *vc = [MyCollectionVC shareInstance];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
                
            }else  if ( indexPath.row == 3){//钱包
                
                
                walletMainViewController *invitingVC=[walletMainViewController shareInstance];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:invitingVC];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
                
                
            }else  if ( indexPath.row == 5){// 地址
                
                AddressManagerVC *vc = [AddressManagerVC shareInstance];
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nc animated:YES completion:nil];
                
            }
        }else{
            NewLoginViewController *vc = [NewLoginViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
        }
    }

    [self.frostedViewController hideMenuViewController];
}


/*
////将要绘制cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ( indexPath == 0 ) {


        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {

            //右边分割线间距
            // [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell setSeparatorInset:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];

        }

        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

            //左边分割线间距
            [cell setLayoutMargins:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];

        }

    }


}

*/

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDeviceWidth/7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellLeft";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    

    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (kDeviceWidth/7-20)/2, 20, 20)];
    [cell.contentView addSubview:logoImageView];
    
    logoImageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]] ;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40+20, (kDeviceWidth/7-30)/2, 120, 30)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = self.itemsArray[indexPath.row];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.highlightedTextColor=RGBACOLOR(30.0, 168.0, 75.0, 1.0);
    [cell.contentView addSubview:titleLabel];

//    if (indexPath.row == 1) {
//        [cell.contentView addSubview:self.redHint];
//    }

    return cell;
}

@end
