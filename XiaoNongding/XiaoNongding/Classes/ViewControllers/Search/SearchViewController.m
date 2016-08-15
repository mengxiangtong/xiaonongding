//
//  SearchViewController.m
//  XiaoNongding
//
//  Created by jion on 16/1/27.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "SearchViewController.h"
#import "UISearchKeyWordView.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UISearchKeyWordViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, retain) UISearchBar *searchView;
@property (nonatomic, retain) UIView *bgMainView;
@property (nonatomic, retain) UILabel *lb_HotSearch;
@end

@implementation SearchViewController

+(instancetype )shareInstance{
    static dispatch_once_t onceToken;
    static SearchViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [SearchViewController new];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark
-(UISearchBar *)searchView{
    if (!_searchView) {
        _searchView=[[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 20.0, kDeviceWidth, 50.0)];
        _searchView.backgroundColor=[UIColor whiteColor];
        _searchView.showsCancelButton=YES;
        _searchView.delegate=self;
        _searchView.placeholder=@"搜索农场或商品名称";
        [_searchView setSearchBarStyle:UISearchBarStyleMinimal];
    }
    return _searchView;
}
-(UIView *)bgMainView{
    if(!_bgMainView){
        _bgMainView=[[UIView alloc]initWithFrame:CGRectMake(0.0, self.searchView.bottom, kDeviceWidth, KDeviceHeight-self.searchView.bottom)];
        _bgMainView.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1.0];
        
        UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureSingle:)];
        [_bgMainView addGestureRecognizer:tapgesture];
    }
    return _bgMainView;
}
-(UILabel *)lb_HotSearch{
    if (!_lb_HotSearch) {
        _lb_HotSearch=[[UILabel alloc]initWithFrame:CGRectMake(20.0, 20.0, 100, 19.0)];
        _lb_HotSearch.text=@"热门搜索";
        [_lb_HotSearch setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [_lb_HotSearch  setFont:[UIFont systemFontOfSize:19.0]];
    }
    return _lb_HotSearch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor= kBlackBgColor;
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.bgMainView];
    [self.bgMainView addSubview:self.lb_HotSearch];
    
    [self loadHotSearchData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:YES];
    [self.searchView becomeFirstResponder];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}
-(void)tapGestureSingle:(UITapGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer.view isEqual:self.bgMainView]) {
        [self.searchView resignFirstResponder];
    }
    
    for (id views in self.searchView.subviews) {
        if ([views isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)views;
            btn.enabled=YES;
            return;
        }
        for (id sv in ((UIView*)views).subviews) {
            if ([sv isKindOfClass:[UIButton class]]) {
                UIButton *btn=(UIButton*)sv;
                btn.enabled=YES;
                return;
            }
        }
        
    }
}


#pragma mark - UISearchbarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchView resignFirstResponder];
    SearchResultViewController *searchVC=[[SearchResultViewController alloc]init];
    [searchVC setKeyWord:searchBar.text ];
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchView resignFirstResponder];
    [self.searchView setText:@""];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 数据查询
-(void)loadHotSearchData{
    
        NSURL *url = [NSURL URLWithString:KSearch_getKeywords_URL ];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
        request.timeoutInterval=KHTTPTimeoutInterval;
        [request setHTTPMethod:@"GET"];
        
        __block SearchViewController *weakSelf = self;
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){

            
            if (!connectionError) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if (dict) {
                    int status=[[dict objectForKey:@"status"] intValue];
                    if (status==1) {
                        //更新页面
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf updateUIMainThread:[dict objectForKey:@"msg"]];
                            
                        });
                    }
                    
                }
            }
            
        }];
    
}
//更新主UI
-(void)updateUIMainThread:(NSArray *)arry{
    
    if (!arry ||[arry isEqual:[NSNull null]] || arry.count<=0) {
        return;
    }

    float x=20.0;
    float y=self.lb_HotSearch.bottom+20.0;
    int z=0;
    for (int i=0;i<arry.count/3+1;i++) {
        for (int j=0; j<3; j++) {
            NSDictionary *item=[arry objectAtIndex:z];
            x=j*90.0+(j+1)*(kDeviceWidth-270.0)/4.0;
            y=i*30.0+(i+1)*(kDeviceWidth-270.0)/4.0+self.lb_HotSearch.bottom;
            UISearchKeyWordView *keyWordView=[[UISearchKeyWordView alloc] initWithFrame:CGRectMake(x, y, 90.0, 30.0)];
            keyWordView.delegate=self;
            [keyWordView setItem:item];
            [self.bgMainView addSubview:keyWordView];
            z++;
            if (z>=arry.count) {
                return;
            }
        }
        
    }
    
}

-(void)UISearchKeyWordViewClicked:(NSDictionary *)item{
    if (item) {
        //跳转到搜索页
        SearchResultViewController *searchVC=[[SearchResultViewController alloc]init];
        [searchVC setKeyWord:[item objectForKey:@"name"] ];
        [self.navigationController pushViewController:searchVC animated:YES];
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
