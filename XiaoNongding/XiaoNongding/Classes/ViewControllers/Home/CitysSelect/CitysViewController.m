//
//  CitysViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/18.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "CitysViewController.h"

@interface CitysViewController () <UITableViewDelegate, UITableViewDataSource  >

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableDictionary *allDataDic;

@property (nonatomic, retain) NSArray *allKeys;
@property (nonatomic, retain) UILabel *currentCityLabel;

@property (nonatomic, retain) UIView *myTableHeaderView;

@end

@implementation CitysViewController

#define arry_short @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"]
#define arry_short2 @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]
- (void)dealloc
{

}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.allDataDic = [NSMutableDictionary dictionary];
        //标题
        self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"切换城市"];
    }
    return self;
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



- (void)goDismiss :(id)sender
{
    NSLog(@"   000  fan hui   ");
    // [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *filePath = [bundle pathForResource:@"足球队dictionary" ofType:@"plist"];
        self.allDataDic = [[NSUserDefaults standardUserDefaults] objectForKey:KCitesInfo];
        if (!self.allDataDic) {
            self.allDataDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        }
   
        self.allKeys =  _allDataDic.allKeys;
        
        NSMutableArray *arrykeys=[[NSMutableArray alloc]init];
        for (int i=0; i<arry_short.count; i++) {
            for (int j=0; j<self.allKeys.count; j++) {
                if ([self.allKeys[j] isEqualToString:arry_short[i] ]) {
                    [arrykeys addObject:self.allKeys[j]];
                    continue;
                }
                
            }
        }
        self.allKeys = [NSArray arrayWithArray:arrykeys];
  
        
    }
    return self;
}




- (void)viewDidLoad {
    NSLog(@" viewDidLoad   ");
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
        
         UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(goDismiss:)];
         cancelBarButtonItem.tintColor = [UIColor whiteColor];
         cancelBarButtonItem;
    });

    NSLog(@" 创建 表 ");
    
    
    NSLog(@" 传入  城市  %@ ", self.currentCityString);
    
    
}


#pragma mark - 懒加载

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64) style:UITableViewStyleGrouped] ;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
    
}

- (UIView *)myTableHeaderView
{
    if (!_myTableHeaderView) {
        
        _myTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30 +20+44 )];
        _myTableHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, kDeviceWidth, 30)];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"选择最近的地址，获取附近优惠";
        [_myTableHeaderView addSubview:titleL];
        
        UILabel *titleL1 = [[UILabel alloc] initWithFrame:CGRectMake( 0, 30, kDeviceWidth, 20)];
        titleL1.font = [UIFont systemFontOfSize:13];
        titleL1.text = @"     当前城市";
        [_myTableHeaderView addSubview:titleL1];
        titleL1.textColor=KSearchCheckedColor;
        //当前地址
        self.currentCityLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15 , 30+20+7, 100, 30)];
        _currentCityLabel.font = [UIFont systemFontOfSize:17];
        _currentCityLabel.text = self.currentCityString;
        _currentCityLabel.textColor=KSearchCheckedColor;
        [_myTableHeaderView addSubview:_currentCityLabel];
      
        
        UIImageView *duiimg = [[UIImageView alloc] initWithFrame:CGRectMake( kDeviceWidth-70 , 30+20+7+5, 20, 20)];
        
        duiimg.image =[UIImage imageNamed:@"iconfont-duihao-3.png"];
        [_myTableHeaderView addSubview:duiimg];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 30+20, kDeviceWidth, 44);
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(senderCurrent) forControlEvents:UIControlEventTouchUpInside];
        [_myTableHeaderView  addSubview:btn];
        
    }
    return _myTableHeaderView;
}



#pragma mark -   重写 setter方法

- (void)setCurrentCityString:(NSString *)currentCityString
{
    _currentCityString = currentCityString;
    NSLog(@"  重写  设置 城市setCurrentCityString ");
    
    //添加表
    [self.view addSubview: self.tableView];
    //添加表头
    self.tableView.tableHeaderView = self.myTableHeaderView;
}


#pragma mark - 调用 block
//3, 调用  执行（把文本框的内容作为参数 传回），回调了（3）

- (void)senderCurrent
{
    if (self.sendCityBlock) {
        
        self.sendCityBlock(_currentCityLabel.text);
        
        [self  dismissViewControllerAnimated:YES completion:nil ];
    }

}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return self.allKeys.count;
        return arry_short.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = arry_short[section];
    
    return [self.allDataDic[key] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellid";
    UITableViewCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellId ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId ];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSString *key = arry_short[indexPath.section];
    
    if([key isEqualToString:@"i"]){
        NSLog(@"");
    }
        
    
    NSArray *array = self.allDataDic[key];

    cell.textLabel.font = [UIFont systemFontOfSize:17];
    if ([array[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text =array[indexPath.row];
    }else{
        cell.textLabel.text =[array[indexPath.row] objectForKey:@"area_name"];
    }

    return cell;
}




#pragma mark - tableView代理


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



//heard 高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  //  return kDeviceWidth *40/713;
    return 22;

}


//替换分组标题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth, 22)];
    
    label.text = [NSString stringWithFormat:@"  %@",arry_short2[section]];
    label.font = [UIFont boldSystemFontOfSize:19.0f];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = kGroupCityCellBgColor;

    return label;
    
}

//foot
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}// custom view for footer. will be adjusted to default or specified footer height




//添加索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arry_short2;
}

//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    

     NSString *key = arry_short[indexPath.section];

    NSArray *array = _allDataDic[key];

    NSString *cityStr ;
    if ([array[indexPath.row] isKindOfClass:[NSString class]]) {
        cityStr =array[indexPath.row];
    }else{
        cityStr =[array[indexPath.row] objectForKey:@"area_name"];
    }
    
    if (self.sendCityBlock) {
        //3, 执行（把文本框的内容作为参数 传回），回调了（3）
        self.sendCityBlock(cityStr);
        
        [self  dismissViewControllerAnimated:YES completion:nil ];
    }
    
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
