
//
//  EditorViewController.m
//  XiaoNongding
//
//  Created by jion on 15/12/24.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "EditorViewController.h"
#import "ProductTableViewCell.h"
#import "FarmTableViewCell.h"
#import "SO_Convert.h"
#import "NewLoginViewController.h"

#define kProductCell @"kProductCell"
#define kFarmCell @"kFarmCell"

@interface EditorViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ProductTableViewCellDelegate,FarmTableViewCellDelegate>
@property (nonatomic,retain) UIView *topview;
@property (nonatomic,retain) UITableView *tableview;
@property (nonatomic,retain) UIView *bottomview;

@property (nonatomic,retain) UIButton *btn_selectAll;

@property (nonatomic,retain) UILabel *lb_left;



@end

@implementation EditorViewController{
    BOOL isAllSelect;
}

+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static EditorViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [EditorViewController new];
    });
    
    return _sharedManager;
}

#pragma mark - 初始化 界面
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    isAllSelect=NO;

    
    
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(completion_Action)];
    [rightbar setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:rightbar];
    [self.navigationItem setTitle:@"编辑"];
    
    [self.view addSubview:self.topview];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.bottomview];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
-(UIView *)topview{
    
    if(!_topview){
        _topview=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 40.0)];
        
        _btn_selectAll=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, 39.0)];
        [_btn_selectAll setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [_btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        [_btn_selectAll setTitle:@"全部" forState:UIControlStateNormal];
        [_btn_selectAll.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_btn_selectAll setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
        [_btn_selectAll setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 20.0, 10.0, 0.0)];
        [_btn_selectAll setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 30.0)];
        [_btn_selectAll addTarget:self action:@selector(btn_select:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *view_Line=[[UIView alloc]initWithFrame:CGRectMake(20.0, 39.2, kDeviceWidth-20.0, 0.8)];
        [view_Line setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
        
        [_topview addSubview:_btn_selectAll];
        [_topview addSubview:view_Line];
    }
    return _topview;
    
}
-(UITableView *)tableview{
    if(!_tableview){
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 40.0, kDeviceWidth, KDeviceHeight-164.0) style:UITableViewStylePlain] ;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone; //去掉 分割线
        
        [_tableview registerClass:[FarmTableViewCell class] forCellReuseIdentifier:kFarmCell];
        if (_isProduct) {
            [_tableview registerClass:[ProductTableViewCell class] forCellReuseIdentifier:kProductCell];
        }
        
    }
    return _tableview;
}
-(UIView *)bottomview{
    if(!_bottomview){
        _bottomview=[[UIView alloc]initWithFrame:CGRectMake(0.0,CGRectGetMaxY(self.tableview.frame) , kDeviceWidth, 60.0)];
        [_bottomview setBackgroundColor:[UIColor whiteColor]];
        
        _lb_left=[[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 0.6*kDeviceWidth, 60.0)];
        _lb_left.text=@"请选择需要删除的商品";
        _lb_left.textAlignment=NSTextAlignmentCenter;
        _lb_left.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
        _lb_left.backgroundColor=[UIColor colorWithWhite:0.05 alpha:0.9];
        
        UIButton *btn_right=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lb_left.frame), 0.0, 0.4*kDeviceWidth, 60.0)];
        [btn_right setTitle:@"删除" forState:UIControlStateNormal];
        [btn_right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_right.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:40.0/255.0 blue:41.0/255.0 alpha:1.0];
        [btn_right setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithRed:247.0/255.0 green:40.0/255.0 blue:41.0/255.0 alpha:1.0]] forState:UIControlStateNormal];
        [btn_right setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithRed:190.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
        [btn_right addTarget:self action:@selector(delete_Action:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:_lb_left];
        [_bottomview addSubview:btn_right];
        
    }
    return _bottomview;
}

-(void)setArry_data:(NSMutableArray *)arry_data{
    _arry_data=arry_data;
    if(self.isProduct)
        _lb_left.text= @"请选择需要删除的商品";
    else{
        _lb_left.text= @"请选择需要删除的农场";
    }
}

#pragma mark - ###监听 代理###
#pragma mark UITableViewDataSource 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arry_data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  120 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isProduct){

        //商品数据
        ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProductCell forIndexPath:indexPath];
        cell.delegate=self;
        if (self.arry_data.count>indexPath.row) {
            NSDictionary *dic_item= self.arry_data[indexPath.row];
            [cell setData_item:dic_item];
            cell.str_isEditor=@"1";
            cell.isChecked=isAllSelect;
        }
        return cell;
    }else{

        //农场数据
        FarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFarmCell forIndexPath:indexPath];
        cell.delegate=self;
        if (self.arry_data.count>indexPath.row) {
            NSDictionary *dic_item= self.arry_data[indexPath.row];
            [cell setData_item:dic_item];
            cell.str_isEditor=@"1";

            cell.isChecked=isAllSelect;
           
        }
        return cell;
    }

}

#pragma mark tableView代理  行选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark UIAlertView 代理事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //不做操作
    }else{
        // 删除收藏
        NSMutableString *appendStr=[[NSMutableString alloc]init];
        for (NSDictionary *item in self.arry_selected) {
            [appendStr appendString:[item objectForKey:@"collect_id"] ];
            [appendStr appendString:@","];
        }
        if (appendStr.length<=1) {
            if(self.isProduct)
                [XNDProgressHUD showWithStatus:@"请选择要删除的商品" duration:1.0];
            else{
               [XNDProgressHUD showWithStatus:@"请选择要删除的农场" duration:1.0];
            }
            
            return;
        }
        
        appendStr=[NSMutableString stringWithFormat:@"%@", [appendStr substringToIndex:appendStr.length-1] ];
        
        [self deleteItem:appendStr];
        
    }
}
-(void)deleteItem:(NSString *)collect_ids{
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:KUserInfo];
    if (!dic_userInfo) {
        [XNDProgressHUD showWithStatus:@"请先登录" duration:1.0];
        NewLoginViewController *vc = [NewLoginViewController shareInstance];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nc animated:YES completion:nil];
        return;
    }
    NSString *uid=[dic_userInfo objectForKey:@"uid"];
    NSString *token=[dic_userInfo objectForKey:@"token"];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KCollect_Goods_Delete_URL,uid,token,collect_ids ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    //刷新数据
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (NSDictionary *item in self.arry_selected) {
                            [self.arry_data removeObject:item];
                        }
                        [self.arry_selected removeAllObjects];
                        
                        [self.tableview reloadData];
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XNDProgressHUD showWithStatus:[dict objectForKey:@"errorMsg"] duration:1.0];
                });
            }
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
            });
        }
        
    }];
}

#pragma mark - 事件
#pragma mark 完成事件
-(void)completion_Action{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 删除事件
-(void)delete_Action:(UIButton *)sender{
    
    if(self.arry_selected.count<=0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:@"请选择\n要删除的收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }else{
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:@"你确定要删除收藏吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertview show];
    }
    
    
}
#pragma mark 全选按钮
-(void)btn_select:(UIButton *)sender{
    isAllSelect=!isAllSelect;
    if (isAllSelect==YES) {
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        [self.arry_selected addObjectsFromArray:self.arry_data];
        if(self.isProduct)
           _lb_left.text=[NSString stringWithFormat: @"您已选择%d 件商品",(int)self.arry_data.count ];
        else{
            _lb_left.text=[NSString stringWithFormat: @"您已选择%d 个农场",(int)self.arry_data.count ];
        }
        
    }else{
        [sender setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        [self.arry_selected removeAllObjects];
        if(self.isProduct)
            _lb_left.text= @"请选择需要删除的商品";
        else
            _lb_left.text= @"请选择需要删除的农场";
    }
    [self.tableview reloadData];
    
}

-(NSMutableArray *)arry_selected{
    if (!_arry_selected) {
        _arry_selected=[[NSMutableArray alloc]init];
        
    }
    return _arry_selected;
}

-(void)selectedCell:(BOOL)isSelected item:(NSDictionary *)item{
    
    if (isSelected==YES) {
        [self.arry_selected addObject:item];
        _lb_left.text=[NSString stringWithFormat: @"您已选择%d 件商品",(int)self.arry_selected.count ];
    }else{
        [self.arry_selected removeObject:item];
        _lb_left.text=[NSString stringWithFormat: @"您已选择%d 件商品",(int)self.arry_selected.count ];
    }
    
    if (self.arry_selected.count==0) {
        _lb_left.text= @"请选择需要删除的商品";
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
    }else if (self.arry_selected.count>=self.arry_data.count) {
        
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
    }else if(self.arry_selected.count<self.arry_data.count){
        
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
    }
}
-(void)selectedFarmCell:(BOOL)isSelected item:(NSDictionary *)item{
    if (isSelected==YES) {
        [self.arry_selected addObject:item];
        _lb_left.text=[NSString stringWithFormat: @"您已选择%d 个农场",(int)self.arry_selected.count ];
    }else{
        [self.arry_selected removeObject:item];
        _lb_left.text=[NSString stringWithFormat: @"您已选择%d 个农场",(int)self.arry_selected.count ];
    }
    
    if (self.arry_selected.count==0) {
        _lb_left.text= @"请选择需要删除的农场";
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
    }else if (self.arry_selected.count>=self.arry_data.count) {
        
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
    }else if(self.arry_selected.count<self.arry_data.count){
        
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [self.btn_selectAll setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateHighlighted];
        
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
