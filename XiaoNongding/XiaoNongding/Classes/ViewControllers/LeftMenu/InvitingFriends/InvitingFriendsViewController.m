//
//  InvitingFriendsViewController.m
//  XiaoNongding
//
//  Created by jion on 15/12/25.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "InvitingFriendsViewController.h"
#import "SO_Convert.h"

@interface InvitingFriendsViewController ()<UMSocialUIDelegate>
@property (nonatomic,retain) UIButton *btn_back;
@property (nonatomic,retain) UIButton *view_QQ;
@property (nonatomic,retain) UIButton *view_wchat;
@property (nonatomic,retain) UIButton *view_wchatQuan;
@property (nonatomic,retain) UIButton *view_QQZone;
@property (nonatomic,retain) UIButton *view_Weibo;
@property (nonatomic,retain) UIButton *view_Nil;
@end

@implementation InvitingFriendsViewController

#pragma mark- 界面初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:242.0/255.0 blue:244.0/255.0 alpha:1.0]];
    
    //标题
    [self.navigationItem setTitle:@"邀请好友"];
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btn_back];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    
    
    [self.view addSubview:self.view_QQ];
    [self.view addSubview:self.view_wchat];
    [self.view addSubview:self.view_wchatQuan];
    [self.view addSubview:self.view_QQZone];
    [self.view addSubview:self.view_Weibo];
    [self.view addSubview:self.view_Nil];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 懒加载
-(UIButton *)btn_back{
    if (!_btn_back) {
        _btn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_back.frame = CGRectMake(0, 0, 40, 40);
        [_btn_back setImage:[UIImage imageNamed:@"icon_navi_back_hl"] forState:UIControlStateNormal];
        _btn_back.imageEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 14);
        _btn_back.tintColor = [UIColor whiteColor];
        [_btn_back addTarget:self action:@selector(goDismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_back;
    
}
-(UIButton *)view_QQ{
    if (!_view_QQ) {
        _view_QQ=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 20.0, (kDeviceWidth-2.0)/3.0, (kDeviceWidth-2.0)/3.0)];
        _view_QQ.tag=1;
        [_view_QQ setBackgroundColor:[UIColor whiteColor]];
        [_view_QQ setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_QQ setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_QQ.frame.size.width-100.0)/2.0, (_view_QQ.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_qq"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"QQ好友" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -22.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_QQ addSubview:btn_icon];
        [_view_QQ addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_QQ;
}
-(UIButton *)view_wchat{
    if (!_view_wchat) {
        _view_wchat=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_QQ.frame)+1.0, 20.0, (kDeviceWidth-2.0)/3.0, (kDeviceWidth-2.0)/3.0)];
        _view_wchat.tag=2;
        [_view_wchat setBackgroundColor:[UIColor whiteColor]];
        [_view_wchat setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_wchat setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_wchat.frame.size.width-100.0)/2.0, (_view_wchat.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_wchat"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"微信好友" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -25.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_wchat addSubview:btn_icon];
        [_view_wchat addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_wchat;
}
-(UIButton *)view_wchatQuan{
    if (!_view_wchatQuan) {
        _view_wchatQuan=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_wchat.frame)+1.0, 20.0, (kDeviceWidth-2.0)/3.0, (kDeviceWidth-2.0)/3.0)];
        _view_wchatQuan.tag=3;
        [_view_wchatQuan setBackgroundColor:[UIColor whiteColor]];
        [_view_wchatQuan setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_wchatQuan setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_wchatQuan.frame.size.width-100.0)/2.0, (_view_wchatQuan.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_pengyouquan"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"朋友圈" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -22.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_wchatQuan addSubview:btn_icon];
        [_view_wchatQuan addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_wchatQuan;
}
-(UIButton *)view_QQZone{
    if (!_view_QQZone) {
        _view_QQZone=[[UIButton alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.view_wchatQuan.frame)+1.0, (kDeviceWidth-2.0)/3.0, (kDeviceWidth-2.0)/3.0)];
        _view_QQZone.tag=4;
        [_view_QQZone setBackgroundColor:[UIColor whiteColor]];
        [_view_QQZone setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_QQZone setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_QQZone.frame.size.width-100.0)/2.0, (_view_QQZone.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_qqzone"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"QQ空间" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -22.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 33.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_view_QQZone addSubview:btn_icon];
        [_view_QQZone addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_QQZone;
}
-(UIButton *)view_Weibo{
    if (!_view_Weibo) {
        _view_Weibo=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_QQZone.frame)+1.0, CGRectGetMaxY(self.view_wchatQuan.frame)+1.0, (kDeviceWidth-2.0)/3.0, (kDeviceWidth-2.0)/3.0)];
        _view_Weibo.tag=5;
        [_view_Weibo setBackgroundColor:[UIColor whiteColor]];
        [_view_Weibo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_view_Weibo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
//        [_view_Weibo setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.9 alpha:1.0]] forState:UIControlStateHighlighted];
        UIButton *btn_icon=[[UIButton alloc]initWithFrame:CGRectMake((_view_Weibo.frame.size.width-100.0)/2.0, (_view_Weibo.frame.size.width-100.0)/2.0, 100.0, 100.0)];
        
        [btn_icon setImage:[UIImage imageNamed:@"sharemore_weibo"] forState:UIControlStateNormal];
        [btn_icon setTitle:@"新浪微博" forState:UIControlStateNormal];
        [btn_icon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_icon setTitleEdgeInsets:UIEdgeInsetsMake(50.0, -25.0, 0.0, 5.0)];
        [btn_icon setImageEdgeInsets:UIEdgeInsetsMake(0.0, 35.0, 18.0, 20.0)];
        [btn_icon setBackgroundColor:[UIColor clearColor]];
        [btn_icon setUserInteractionEnabled:NO];
        [btn_icon.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//        [_view_Weibo addSubview:btn_icon];
//        [_view_Weibo addTarget:self action:@selector(ShareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _view_Weibo;
}
-(UIButton *)view_Nil{
    if (!_view_Nil) {
        _view_Nil=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view_Weibo.frame)+1.0, CGRectGetMaxY(self.view_wchatQuan.frame)+1.0, (kDeviceWidth-2.0)/3.0, (kDeviceWidth-2.0)/3.0)];
        [_view_Nil setBackgroundColor:[UIColor whiteColor]];
     
    }
    return _view_Nil;
}


#pragma mark - 事件 代理
#pragma mark 返回上一页
-(void)goDismiss:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 发送分享
-(void)ShareAction:(UIButton *)sender{

    UMSocialUrlResource *resurceUrl=[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:KAppWebURL];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.qqData.title = @"小农丁";
    [UMSocialData defaultData].extConfig.qzoneData.title = @"小农丁";
    switch (sender.tag) {
            
            
        case 1:
            //QQ 好友
            [[UMSocialControllerService defaultControllerService] setShareText:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" shareImage:[UIImage imageNamed:@"180.png"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"小农丁绿色农产品交易平台－找回舌尖上的记忆" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    NSLog(@"分享成功！");
//                }
//            }];
            break;
        case 2:
            //微信好友
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            break;
        case 3:
            //朋友圈
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            break;
        case 4:
            //QQ空间
            [[UMSocialControllerService defaultControllerService] setShareText:@"小农丁- 国内首家O2O生态农场平台，每日为您推荐农特生鲜、创意团购众筹、主题农庄、特色生态游、农家宴、亲子采摘" shareImage:[UIImage imageNamed:@"180.png"] socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            break;
//        case 5:
//            //新浪微博
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"小农丁绿色农产品交易平台－找回舌尖上的味道" image:[UIImage imageNamed:@"180.png"] location:nil urlResource:resurceUrl presentedController:self completion:^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    NSLog(@"分享成功！");
//                }
//            }];
//            break;
        default:{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"该功能暂未开放" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }

}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
