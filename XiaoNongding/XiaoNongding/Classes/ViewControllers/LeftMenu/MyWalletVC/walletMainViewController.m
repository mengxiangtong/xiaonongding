//
//  walletMainViewController.m
//  XiaoNongding
//
//  Created by jion on 16/2/18.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "walletMainViewController.h"
#import "walletTableView.h"

@interface walletMainViewController ()
@property (nonatomic, retain) walletTableView *tableView;
@end

@implementation walletMainViewController
+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static walletMainViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [walletMainViewController new];
    });
    
    return _sharedManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"我的钱包"];
    
    //左侧添加
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
    });
    
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView refreshdata];
}
- (UIButton *)getBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}
-(walletTableView *)tableView{
    if (!_tableView) {
        _tableView=[[walletTableView alloc] initWithFrame:self.view.bounds];
    }
    return _tableView;
}
- (void)goDismiss :(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
