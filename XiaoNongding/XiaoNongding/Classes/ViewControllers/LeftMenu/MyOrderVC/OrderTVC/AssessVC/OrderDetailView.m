//
//  OrderDetailView.m
//  XiaoNongding
//
//  Created by jion on 16/2/24.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "OrderDetailView.h"
#import "OrderGoodsTableViewCell.h"
#import "OrderOtherTableViewCell.h"
#import "OrderAdressTableViewCell.h"
#import "OrderDetailModule.h"
#import "OrderDetailViewController.h"

@interface OrderDetailView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableview;
@property (nonatomic, retain) UIView *tableFooterView;

@property (nonatomic, retain) NSArray *arry_detail;
@end
@implementation OrderDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=kTableViewSectionColor;
        [self addSubview: self.tableview];
        [self refershdata];
           }
    return self;
}
-(void)refershdata{
    [[OrderDetailModule shareInstance] getOrderArrayDataWithFarmDic:[[OrderDetailViewController shareInstance] orderData] Complete:^(NSArray *allData) {
        self.arry_detail=allData;
        [self.tableview reloadData];
    }];

}
-(UITableView *)tableview{
    if (!_tableview) {
        _tableview=[[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableview.delegate=self;
        _tableview.dataSource=self;
        _tableview.backgroundColor=kTableViewSectionColor;
        [_tableview setTableFooterView:self.tableFooterView];
        
        [_tableview registerClass:[OrderGoodsTableViewCell class] forCellReuseIdentifier:KOrderGoodsTableViewCell];
        [_tableview registerNib:[UINib nibWithNibName:KOrderOtherTableViewCell bundle:nil] forCellReuseIdentifier:KOrderOtherTableViewCell];
        [_tableview registerNib:[UINib nibWithNibName:KOrderAdressTableViewCell bundle:nil] forCellReuseIdentifier:KOrderAdressTableViewCell];
    }
    return _tableview;
}
-(UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 80.0)];
        _tableFooterView.backgroundColor=kTableViewSectionColor;
    }
    return _tableFooterView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arry_detail.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arry_detail[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        OrderAdressTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:KOrderAdressTableViewCell];
        if (!cell) {
            cell=[[OrderAdressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KOrderAdressTableViewCell];
        }
        NSDictionary*item= self.arry_detail[indexPath.section][indexPath.row];
        cell.data_item=item;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
         return cell;
    }else if(indexPath.section==1){
        OrderGoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:KOrderGoodsTableViewCell];
        NSDictionary*item= self.arry_detail[indexPath.section][indexPath.row];
        cell.item_Data=item;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        OrderOtherTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:KOrderOtherTableViewCell];
        if (!cell) {
            cell=[[OrderOtherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KOrderOtherTableViewCell];
        }
        NSDictionary*item= self.arry_detail[indexPath.section][indexPath.row];
        cell.data_item=item;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if(indexPath.section==3){
            [cell.lb_Right setTextColor:kRedColor];
            [cell.lb_Right setFont:[UIFont systemFontOfSize:19.0]];
            if (indexPath.row>0) {
                [cell.lb_Left setFont:[UIFont systemFontOfSize:15.0]];
            }
        }
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 120.0;
    }else if(indexPath.section==1){
        return 200.0;
        
    }else {
        if(indexPath.section==3 && indexPath.row>0){
            return 40.0;
        }
        return 50.0;
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section<=0) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, kDeviceWidth, 15.0)];
    [view setBackgroundColor:kTableViewSectionColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section<=0) {
        return 0.00001;
    }
    return 15.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
@end
