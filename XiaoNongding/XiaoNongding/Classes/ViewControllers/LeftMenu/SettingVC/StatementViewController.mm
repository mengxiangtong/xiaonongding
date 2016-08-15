//
//  StatementViewController.m
//  LanKe
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "StatementViewController.h"

@interface StatementViewController ()

@end

@implementation StatementViewController



//icon_navi_back_hl@2x

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        titleLabel.center = self.navigationController.navigationBar.center;
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"免责声明"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.center = self.view.center;
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)goDismiss :(id)sender
{
    NSLog(@"  000  返回 0000");
     [self.navigationController popViewControllerAnimated:YES];
    
   //[self dismissViewControllerAnimated:YES completion:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        /*
         UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_navi_back_hl"] style:UIBarButtonItemStyleDone target:self action:@selector(goDismiss:)];
         cancelBarButtonItem.tintColor = [UIColor whiteColor];
         cancelBarButtonItem;*/
        
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
        
        
    });


    
    
    
    
    // Do any additional setup after loading the view from its nib.
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
