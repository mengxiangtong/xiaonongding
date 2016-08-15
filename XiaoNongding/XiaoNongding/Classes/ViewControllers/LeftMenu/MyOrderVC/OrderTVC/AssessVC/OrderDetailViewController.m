//
//  OrderDetailViewController.m
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailView.h"
@interface OrderDetailViewController ()
@property (nonatomic, retain) OrderDetailView *orderDetailView;
@end

@implementation OrderDetailViewController

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static OrderDetailViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OrderDetailViewController new];
    });
    
    return _sharedManager;
}

- (void)viewDidLoad {
    @autoreleasepool {
        [super viewDidLoad];
        self.navigationItem.title=@"订单详情";
        //左侧
        self.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
            cancelBarButtonItem.tintColor = [UIColor whiteColor];
            cancelBarButtonItem;
        });

        _orderDetailView=[[OrderDetailView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_orderDetailView];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [_orderDetailView refershdata];
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
-(void)goDismiss:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
