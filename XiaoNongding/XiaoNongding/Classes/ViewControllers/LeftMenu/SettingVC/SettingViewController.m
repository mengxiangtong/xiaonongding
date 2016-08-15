//
//  SettingViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "SettingViewController.h"
#include "StatementViewController.h"
#import "YBImgPickerViewController.h"
#import "XND_UploadFileTool.h"
#import "RegisterViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate,YBImgPickerViewControllerDelegate,XND_UploadFileToolDelegate>


@property (retain, nonatomic) UITableView * tableView;

@property (nonatomic, retain) UIXndActivityView *activityView;

@end

@implementation SettingViewController



#pragma mark - 隐藏多余cell 的分割线
//1、加方法
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64-(kDeviceWidth*120/715 +50*5+20 ))];
    
    view.backgroundColor =  RGBACOLOR(237, 243, 244, 1);
    
    [tableView setTableFooterView:view];
}




- (void)goDismiss :(id)sender
{
    NSLog(@"   000  fan hui   ");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //标题
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"设置"];
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    
    
    //表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self setExtraCellLineHidden:_tableView];
    [self.view addSubview:self.activityView];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.tableView reloadData];
    
}

-(UIXndActivityView *)activityView{
    if (!_activityView) {
        
        _activityView = [[UIXndActivityView alloc] initWithFrame:CGRectMake((kDeviceWidth-40.0)/2.0, (KDeviceHeight-104.0)/2.0, 40.0, 40.0)] ;
        
    }
    return _activityView;
}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return kDeviceWidth*120/715 ;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        return  70 ;
    }
    return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return 4;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil ];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 120, 35)];
    textLabel.center = CGPointMake(15+60, 25);
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = RGBACOLOR(40, 40, 40, 1);
    [cell.contentView addSubview:textLabel];
    
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-30, 0.5)];
    l1.backgroundColor = [UIColor  colorWithHexString:@"a8a8a8"];
    l1.alpha = 0.5;
    [cell.contentView addSubview:l1];
    
    if ( indexPath.row == 0 && indexPath.section == 0) {//头像
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIImageView *heardImaView = [[UIImageView alloc] initWithFrame:CGRectMake( kDeviceWidth-15-50 ,(kDeviceWidth*120/715-50)/2 , 50, 50)];
        
        if (dic_userInfo) {
            [heardImaView sd_setImageWithURL:[NSURL URLWithString:[dic_userInfo objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"heardDefault.jpg"] ];
        }else{
            heardImaView.image = [UIImage imageNamed:@"heardDefault.jpg"];
        }
        
        heardImaView.layer.cornerRadius = 25;
        heardImaView.layer.masksToBounds = YES;
        heardImaView.backgroundColor = kGroupCityCellBgColor;
        [cell.contentView addSubview:heardImaView];
        
        textLabel.center = CGPointMake(15+60, 25+10);
        textLabel.text = @"头像";
        l1.hidden = YES;
    }else  if ( indexPath.row == 1 && indexPath.section == 0 ) {//昵称
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        textLabel.text = @"昵称";
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-120-15, 10, 120, 50-20)];
        l.textColor = [UIColor  colorWithHexString:@"a8a8a8"];
        l.textAlignment = NSTextAlignmentRight;
        
        
        if (dic_userInfo) {
            l.text = [dic_userInfo objectForKey:@"nickname"];
        }else{
            l.text=@"";
        }
        [cell.contentView addSubview:l];
        
    }else  if ( indexPath.row == 2  && indexPath.section == 0 ) {//清除缓存
        
        textLabel.text = @"清除缓存";
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-150, 10, 110, 50-20)];
        l.textColor = [UIColor  colorWithHexString:@"a8a8a8"];
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        CGFloat sizeCach = [self folderSizeAtPath:cachPath];
        l.text = [NSString stringWithFormat:@"%.2fM", sizeCach];
        l.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:l];
        
    }else  if ( indexPath.row == 0  && indexPath.section == 1 ) {//帮助中心
        l1.hidden = YES;
        
        textLabel.text = @"帮助中心";
        
    }else  if ( indexPath.row == 1  && indexPath.section == 1 ) {//免责声明
        textLabel.text = @"免责声明";
        
    }else  if ( indexPath.row == 2   && indexPath.section == 1  ) {//退出登录
        textLabel.text = @"当前版本号";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-120-45, 10, 120, 50-20)];
        l.textColor = [UIColor  colorWithHexString:@"a8a8a8"];
        l.textAlignment = NSTextAlignmentRight;
        
        NSString *CFBundleShortVersionString=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *CFBundleVersion=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        l.text =[NSString stringWithFormat:@"%@.%@",CFBundleShortVersionString,CFBundleVersion] ;
       
        [cell.contentView addSubview:l];
        
    }else  if ( indexPath.row == 3   && indexPath.section == 1  ) {//退出登录
        l1.hidden = YES;
        cell.contentView.backgroundColor =  RGBACOLOR(237, 243, 244, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 30, kDeviceWidth - 40,39);
        [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        [btn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
        if (!dic_userInfo) {
            [btn setTitle: @"去登录" forState:UIControlStateNormal];
        }else {
            [btn setTitle:@"退出登录" forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:btn];
        
    }
    
    return cell;
}



#pragma mark - image picker delegte
-(void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray{
    
     [self.activityView startAnimation];
    NSLog(@" 选中 图片  %@ ", imageArray );
    
    for (int i=0;i<imageArray.count;) {
        
        UIImage *image = imageArray[i];
        
        
        NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo];
        NSMutableDictionary *bodyParams=[[NSMutableDictionary alloc]init];
        [bodyParams setObject:[dic_userInfo objectForKey:@"uid"] forKey:@"uid"];
        [bodyParams setObject:[dic_userInfo objectForKey:@"token"] forKey:@"token"];
        
        XND_UploadFileTool *xndUpload=[[XND_UploadFileTool alloc]init];
        xndUpload.delegate=self;
        [xndUpload uploadAvatarImageWithimageWithUrl:KUser_changeAvatar_URL name:@"avatar" imgArry:@[image] parmas:bodyParams ];
        
        
        return;
        
        
    }
    
}
-(void)XND_UploadFileToolDelegate_Compent:(NSDictionary *)msg isOK:(BOOL)isok{
    if (isok) {
        //成功 则跳转
        if (msg) {
            int status=[[msg objectForKey:@"status"]  intValue];
            if (status ==1) {
                NSString *avatar=[msg objectForKey:@"errorMsg"];
                NSMutableDictionary *dic_userInfo=[[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo] ];
                [dic_userInfo setObject:avatar forKey:@"avatar" ];
                [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                
                [self.tableView reloadData];
            }
        }
    }
     [self.activityView stopAnimation];
}


//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



- (void)logoutAction:(id)sender
{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        RegisterViewController *vc = [RegisterViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [nc setNavigationBarHidden:YES];
        nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出当前账户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertVC.tag=3000;
    [alertVC show];
}






#pragma mark - tableView代理 头高度


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
    l.backgroundColor = kGroupCityCellBgColor;
    return l;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    
    if ( indexPath.row == 0 && indexPath.section == 0) {//头像
        
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            RegisterViewController *vc = [RegisterViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [nc setNavigationBarHidden:YES];
            nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            return;
        }
        YBImgPickerViewController * next = [[YBImgPickerViewController alloc]init];
        next.photoCount=1;
        [next showInViewContrller:self choosenNum:0 delegate:self];
        
    }else  if ( indexPath.row == 1 && indexPath.section == 0 ) {//昵称
        if (!dic_userInfo) {
            [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
            RegisterViewController *vc = [RegisterViewController shareInstance];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [nc setNavigationBarHidden:YES];
            nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nc animated:YES completion:nil];
            return;
        }
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入" message:@"昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
        dialog.tag=10086;
        [dialog show];
        
    }else  if ( indexPath.row == 2  && indexPath.section == 0 ) {//清除缓存
        
        // 清除缓存
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           
                           //线程间 通信
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
        
        
    }else  if ( indexPath.row == 0  && indexPath.section == 1 ) {//帮助中心
        
        
    }else  if ( indexPath.row == 1  && indexPath.section == 1 ) {//免责声明
        //免责声明
        
        StatementViewController *vc = [[StatementViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}



#pragma mark - 清理缓存
-(void)clearCacheSuccess
{
    [XNDProgressHUD showWithStatus:@"清理成功" duration:1.0 ];
    [self.tableView  reloadData];
    
}



#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10086) {
        if (buttonIndex == 1) {//确定
            UITextField *tf=(UITextField *)[alertView textFieldAtIndex:0];
            NSString *nickname=[[tf text] stringByReplacingOccurrencesOfString:@" " withString:@"" ];
            if (nickname && nickname.length>0) {
                //接口提交
                [self requestSaveWithNickName:nickname];
            }
        }
    }else if(alertView.tag==3000 && buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KUserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
        
    }else if(alertView.tag==3001 && buttonIndex == 1){
        RegisterViewController *vc = [RegisterViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [nc setNavigationBarHidden:YES];
        nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
    
    }else{
        if (buttonIndex == 0) {//
            NSLog(@"取消 登出  ");
            return;
        }
        else if (buttonIndex == 1) {//确定
            
            //保存用户名称、密码
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:KUserInfo];
            [defaults synchronize];
            [self.tableView reloadData];
            
            
        }
    }
    
    
    
}



//加载产品列表
- (void)requestSaveWithNickName:(NSString *)nickname
{
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        RegisterViewController *vc = [RegisterViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [nc setNavigationBarHidden:YES];
        nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: KUser_changeNickname_URL  ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"POST"];
    NSString *bodyStr=[NSString stringWithFormat:@"nickname=%@&uid=%@&token=%@",nickname,uid,token];
    
    NSData *bodyData= [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityView stopAnimation];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        });
        
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                        NSMutableDictionary *dic_userInfo=[[NSMutableDictionary alloc]initWithDictionary: [[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo] ];
                        [dic_userInfo setObject:nickname forKey:@"nickname" ];
                        [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                        
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [XNDProgressHUD showWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                        
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:@"网络链接中断" duration:1.0];
                    
                });
            }
            
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
            
        }else{
            //更新页面
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
            
        }
        
    }];
    
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
