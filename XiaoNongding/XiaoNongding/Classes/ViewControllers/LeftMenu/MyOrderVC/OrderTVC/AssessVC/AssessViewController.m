//
//  AssessViewController.m
//  XiaoNongding
//
//  Created by admin on 15/12/26.
//  Copyright © 2015年 Mxt. All rights reserved.
//

#import "AssessViewController.h"
#import "AMRatingControl.h"
#import "YBImgPickerViewController.h"
#import "XND_UploadFileTool.h"

@interface AssessViewController ()<UITextViewDelegate,YBImgPickerViewControllerDelegate,XND_UploadFileToolDelegate,UIGestureRecognizerDelegate>
{
    UILabel * lb_placeholder;
    UIScrollView *bgView ;
    UILabel *l3;
    
    NSString *str_RatingNum;
    
    NSArray *arry_img;
    
}


@property (nonatomic, retain) UILabel       *lb_farm;
@property (nonatomic, retain) UILabel       *lb_distance;
@property (nonatomic, retain) UIImageView   *img_Product;
@property (nonatomic, retain) UILabel       *lb_Title;
@property (nonatomic, retain) UILabel       *lb_Date;
@property (nonatomic, retain) UITextView    *assessTextView;
@property (nonatomic, retain) UIButton      *Btn_One;
@property (nonatomic, retain) UIButton      *Btn_AddPhoto;
@property (nonatomic, retain) UIView        *view_Photos;


@property (nonatomic, retain)  AMRatingControl *imagesRatingControl;// 评分控件



@end

@implementation AssessViewController



- (void)goDismiss :(id)sender
{
    NSLog(@"   000  fan hui   ");
    
    [self.navigationController popViewControllerAnimated:YES];
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
-(UIButton *)Btn_AddPhoto{
    if (!_Btn_AddPhoto) {
        _Btn_AddPhoto=[[UIButton alloc]initWithFrame:CGRectMake(20.0, CGRectGetMaxY(_assessTextView.frame)+10, 50, 33)];
        [_Btn_AddPhoto setImage:[UIImage imageNamed:@"AddPhotos.png"] forState:UIControlStateNormal];
        [_Btn_AddPhoto setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        [_Btn_AddPhoto addTarget:self action:@selector(AddPhoto_Action:) forControlEvents:UIControlEventTouchUpInside];
        
        [_Btn_AddPhoto setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_Btn_AddPhoto setBackgroundImage:[SO_Convert createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        
    }
    return _Btn_AddPhoto;
}
-(UIView *)view_Photos{
    if (!_view_Photos) {
        _view_Photos=[[UIView alloc]initWithFrame:CGRectMake(20.0, self.Btn_AddPhoto.frame.origin.y+self.Btn_AddPhoto.height, kDeviceWidth-150, 1.0)];
        
    }
    return _view_Photos;
}

#pragma mark -懒加载
/**
 *
 */
- (AMRatingControl *)imagesRatingControl
{
    if (!_imagesRatingControl) {
        _imagesRatingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(110, 152)
                                                                              emptyImage:[UIImage imageNamed:@"dot_new.png"]
                                                                              solidImage:[UIImage imageNamed:@"star_new.png"]
                                                                            andMaxRating:5];
        [_imagesRatingControl addTarget:self action:@selector(updateRating:) forControlEvents:UIControlEventEditingChanged];
        [_imagesRatingControl addTarget:self action:@selector(updateEndRating:) forControlEvents:UIControlEventEditingDidEnd];
    }
    return _imagesRatingControl;
}


- (UIButton *)Btn_One
{
    if (!_Btn_One) {
        _Btn_One = [UIButton buttonWithType:UIButtonTypeCustom];
        _Btn_One.frame = CGRectMake(kDeviceWidth-15-100, CGRectGetMaxY(self.assessTextView.frame)+10, 100, 30);
        [_Btn_One setTitle:@"发表评价" forState:0];
        _Btn_One.titleLabel.font = [UIFont systemFontOfSize:15];
        [_Btn_One setTitleColor: RGBACOLOR(250, 87, 93, 1)  forState:0] ;
        _Btn_One.layer.borderColor = [RGBACOLOR(250, 87, 93, 1) CGColor] ;
        _Btn_One.layer.borderWidth = 1;
        _Btn_One.layer.masksToBounds = YES;
        _Btn_One.layer.cornerRadius = 2;
        [_Btn_One setBackgroundImage:[SO_Convert createImageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [_Btn_One setBackgroundImage:[SO_Convert createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_Btn_One addTarget:self action:@selector(btn_Action:) forControlEvents:UIControlEventTouchUpInside ];
    }
    return _Btn_One;
}


- (UITextView *)assessTextView
{
    if (!_assessTextView) {
        _assessTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(l3.frame)+10, kDeviceWidth-30, 80 )];
        _assessTextView.delegate = self;
        _assessTextView.text = @"";
        _assessTextView.font=[UIFont systemFontOfSize:17.0];
        
        lb_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(l3.frame)+10, kDeviceWidth-30, 60)];
        lb_placeholder.frame = CGRectMake(0, 5, _assessTextView.bounds.size.width, _assessTextView.bounds.size.height);
        lb_placeholder.font = [UIFont systemFontOfSize:14];
        lb_placeholder.numberOfLines = 3;
        lb_placeholder.text = @"在此发表评论 （1～500 字之间）\n写下购物体会或使用帮助等，为其他小伙伴提供参考";
        lb_placeholder.enabled = NO;//lable必须设置为不可用
        lb_placeholder.backgroundColor = [UIColor clearColor];
        lb_placeholder.textColor = kGrayBg_239Color ;
        [_assessTextView addSubview:lb_placeholder];
        
    }
    return _assessTextView;
}




- (void)setAllViews
{
    
    //左侧添加  (语法糖)
    self.navigationItem.leftBarButtonItem = ({
    
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton]];
        cancelBarButtonItem.tintColor = [UIColor whiteColor];
        cancelBarButtonItem;
    });
    
    self.navigationItem.titleView = [Tooles CusstomTitleLabelWithTex:@"发表评价"];
    
    self.view.backgroundColor = kGroupCityCellBgColor;
    
    //
    bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kDeviceWidth, 350)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView setContentSize:CGSizeMake(kDeviceWidth, KDeviceHeight)];
    [self.view  addSubview:bgView];
    //
    self.lb_farm = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 220, 40)];

    self.lb_farm.text = [_data_item objectForKey:@"merchant_name"];
    self.lb_farm.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:_lb_farm];
    
    //横线
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kDeviceWidth-30, 0.5)];
    l1.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l1];
    
    //产品图片
    self.img_Product=[[UIImageView alloc]initWithFrame:CGRectMake(15, 50.0, 80.0, 80.0)];
    [self.img_Product sd_setImageWithURL:[NSURL URLWithString:[_data_item objectForKey:@"list_pic"]] placeholderImage:[UIImage imageNamed:@"defualtIcon.jpg"]];//图片地址
    [self.img_Product setBackgroundColor:kGrayBg_239Color];
    [bgView addSubview:_img_Product];
    
    // 标题
    self.lb_Title=[[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(_img_Product.frame)+10, 50.0, kDeviceWidth-120, 50.0)];
    self.lb_Title.text=[_data_item objectForKey:@"order_name"];
    _lb_Title.numberOfLines = 2;
    _lb_Title.textColor = [UIColor colorWithHexString:@"333333"];
    self.lb_Title.textAlignment=NSTextAlignmentLeft;
    [self.lb_Title setFont:[UIFont systemFontOfSize:15.0]];
    [bgView addSubview:_lb_Title];
    
    self.lb_Date=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_img_Product.frame)+10,CGRectGetMaxY(_lb_Title.frame)+10, kDeviceWidth-30-80-10, 20.0)];
    NSString* dateline=[_data_item objectForKey:@"dateline"] ;
    self.lb_Date.text=[SO_Convert DateToString:[NSDate dateWithTimeIntervalSince1970:[dateline intValue]] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.lb_Date.textColor=[UIColor lightGrayColor];
    [self.lb_Date setFont:[UIFont systemFontOfSize:14.0]];
    [bgView addSubview:_lb_Date];
    
    //横线2
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_img_Product.frame)+10, kDeviceWidth-30, 0.5)];
    l2.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l2];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(l2.frame)+10, 65, 30)];
    la.textColor = [UIColor blackColor];
    la.font = [UIFont systemFontOfSize:16];
    la.text = @"商品评分";
    [bgView  addSubview:la];
    
    //评分控件
    [bgView addSubview:self.imagesRatingControl];
    
    //横线3
    l3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_img_Product.frame)+60, kDeviceWidth-30, 0.5)];
    l3.backgroundColor = kGrayBg_219Color;
    [bgView  addSubview:l3];
    
    //3TextView
    [bgView addSubview:self.assessTextView];
    [bgView addSubview:self.Btn_AddPhoto];
    //提交评论
    [bgView  addSubview:self.Btn_One];
    [bgView addSubview:self.view_Photos];
    [bgView setContentSize:CGSizeMake(kDeviceWidth,350.0)];
}

/**************************************************************************************************/
#pragma mark - Private Methods

- (void)updateRating:(id)sender
{
    NSLog(@"Rating: %ld", (long)[(AMRatingControl *)sender rating]);
    str_RatingNum=[NSString stringWithFormat:@"%ld", (long)[(AMRatingControl *)sender rating]];
}

- (void)updateEndRating:(id)sender
{
    NSLog(@"  －－－－  End Rating: %ld", (long)[(AMRatingControl *)sender rating]);

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleViewTap:)];
    singleTap.delegate=self;
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}


#pragma mark -textView 代理
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat y = -160;

    if (kDeviceWidth >= 375) {
        return;
    }else if(  KDeviceHeight == 568)
    {
        y = -75;
    }
    
    [UIView animateWithDuration:0.01 animations:^{
        bgView.frame = CGRectMake(0, y, kDeviceWidth, KDeviceHeight);
            
    } ];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    //    self.assessTextView.text =  textView.text;
    if (textView.text.length == 0) {
        lb_placeholder.text = @"在此发表评论 （1～500 字之间）\n写下购物体会或使用帮助等，为其他小伙伴提供参考";
    }else{
        lb_placeholder.text = @"";
    }
}
#pragma mark - image picker delegte
-(void)YBImagePickerDidFinishWithImages:(NSArray *)imageArray{
    
    NSLog(@" 选中 图片  %@ ", imageArray );
    arry_img=imageArray;
    int jiange = 5.0;
    int x = 1;
    int y=5.0;
    for (int i=0;i<imageArray.count;i++) {
        
        UIImage *image = imageArray[i];
        if (i>0 && i%3==0){
            y+=65.0;
            x=1;
        }
        NSData *imageData=nil;
        
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
       
        
        UIImageView *img_View1=[[UIImageView alloc]initWithFrame:CGRectMake(jiange*x+60*(x-1), y, 60.0, 60.0)];
        img_View1.image=image;
        img_View1.tag=10000+i;
        [self.view_Photos addSubview:img_View1];
        self.view_Photos.frame=CGRectMake((kDeviceWidth-240.0)/2.0, self.Btn_AddPhoto.frame.origin.y+self.Btn_AddPhoto.frame.size.height+5.0, 240.0, 65.0+y);
      
        self.Btn_One.frame=CGRectMake(self.Btn_One.frame.origin.x, self.view_Photos.frame.origin.y+self.view_Photos.frame.size.height+10.0, self.Btn_One.frame.size.width, self.Btn_One.frame.size.height);
        [bgView setContentSize:CGSizeMake(kDeviceWidth, self.Btn_One.frame.origin.y+self.Btn_One.frame.size.height+20)];
        
        if(bgView.height<KDeviceHeight-60){
            bgView.frame=CGRectMake(0.0, 10.0, kDeviceWidth, self.Btn_One.frame.origin.y+self.Btn_One.frame.size.height+20);
        }
        x++;
        
    }

}

-(void)XND_UploadFileToolDelegate_Compent:(NSDictionary *)msg isOK:(BOOL)isok{
    if (isok) {
        //成功 则跳转
        if (msg) {
            int status=[[msg objectForKey:@"status"]  intValue];
            if (status ==1) {
                [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"评论失败"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else{
        [SVProgressHUD showSuccessWithStatus:@"评论失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//隐藏键盘，实现UITextViewDelegate
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        
//        [UIView animateWithDuration:0.01 animations:^{
//            bgView.frame = CGRectMake(0, 10, kDeviceWidth, 350);
//        } ];
//        [_assessTextView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

//

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"AMRatingControl"]) {
        return NO;
    }
    return YES;
}
-(void)singleViewTap:(UITapGestureRecognizer*)gesture{
    
    [_assessTextView resignFirstResponder];
}
-(void)AddPhoto_Action:(UIButton *)sender{
    
    YBImgPickerViewController * next = [[YBImgPickerViewController alloc]init];
    next.photoCount=3;
    [next showInViewContrller:self choosenNum:0 delegate:self];
}
-(void)btn_Action:(UIButton *)sender{

    if (!str_RatingNum || str_RatingNum.length<=0) {
        [XNDProgressHUD showWithStatus:@"请添加评分"];
        return;
    }
    if (self.assessTextView.text.length<=0) {
        [XNDProgressHUD showWithStatus:@"请填写评价"];
        return;
    }
    
    NSDictionary *dic_userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:KUserInfo];
    NSMutableDictionary *bodyParams=[[NSMutableDictionary alloc]init];
    [bodyParams setObject:[dic_userInfo objectForKey:@"uid"] forKey:@"uid"];
    [bodyParams setObject:[dic_userInfo objectForKey:@"token"] forKey:@"token"];
    [bodyParams setObject:str_RatingNum forKey:@"score"];
    [bodyParams setObject:self.assessTextView.text forKey:@"comment"];
    [bodyParams setObject:@"1" forKey:@"anonymous"];
    [bodyParams setObject:[_data_item objectForKey:@"order_id"] forKey:@"order_id"];
     NSString *orderType=[_data_item objectForKey:@"name"];
    [bodyParams setObject:[orderType isEqualToString:@"1"]?@"1":@"0" forKey:@"order_type"];
    
    
    XND_UploadFileTool *xndUpload=[[XND_UploadFileTool alloc]init];
    xndUpload.delegate=self;
    [xndUpload uploadReplyImageWithimageWithUrl:KReply_To_URL name:@"reply" imgArry:arry_img parmas:bodyParams ];
}

-(void)setData_item:(NSDictionary *)data_item{
    _data_item=data_item;
    if (_data_item) {
        [self setAllViews];
    }
}


-(void)didReceiveMemoryWarning {
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
