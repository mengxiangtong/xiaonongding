//
//  KVHelper.h
//  Kejitong
//
//  Created by kevin xu on 11/18/13.
//  Copyright (c) 2013 LiuLibo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import"SVProgressHUD.h"
//#import"KVScrollViews.h"
//#import"VWCommonTableView.h"
//#import"VWNavigator.h"
//#import"LLBIndexCell.h"
//#import"ASIHTTPRequest.h"
//#import"ASIFormDataRequest.h"
//#import"JSONKit.h"
//#import"NSAppSingleton.h"
//#import<ShareSDK/ShareSDK.h>
//----------------------------------------------------------------------
typedef enum{CELL_TYPE_DingDanGuanLi=111,CELL_TYPE_WoDeTieZi,CELL_TYPE_WoDeShouRu,CELL_TYPE_WanZhuanWeiXin}ENUM_CELL_TYPE;
typedef enum{DATA_TYPE_DingDanGuanLi_YiFu=222,DATA_TYPE_DingDanGuanLi_DaiFu,DATA_TYPE_DingDanGuanLi_YiFa,DATA_TYPE_WoDeTieZi,DATA_TYPE_WoDeShouRu,DATA_TYPE_WanZhuanWeiXin}ENUM_DATA_TYPE;
//----------------------------------------------------------------------
#define URL_Server @"http://g.24so.com"

#define URL_SHANGPINGFABU @"product_add.aspx"

#define URL_YinHangKa @"card_add.aspx"

#define URL_LOGIN @"login.aspx"

#define POST_LOCATION_FINISHED @"POST_LOCATION_FINISHED"
#define POST_LOCATION_FAILED @"POST_LOCATION_FAILED"
#define LOCATION_KEY @"location"
//----------------------------------------------------------------------
#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7?YES:NO)
#define IP4_5(p_4,p_5) IS_iPhone5?(p_5):(p_4)
#define Device_Width 320//[[UIScreen mainScreen] currentMode].size.width/2
#define Device_Height (IP4_5(960/2,1136/2))  //IS_iPhone5?(1136:960)//
//#define Device_Height
//----------------------------------------------------------------------------------------
//btnNext=[[UIButton alloc] initWithFrame:CGRectMake(10, 440/2, 300, 72/2)];
//[btnNext setBackgroundImage:KVButtonBackImg forState:UIControlStateNormal];
//[btnNext setTitle:@"完成" forState:UIControlStateNormal];
//[btnNext.titleLabel setTextColor:[UIColor whiteColor]];
//[btnNext.titleLabel setFont:KVFont(CommonFont, CommonButtonFontSize)];
//[btnNext addTarget:self action:@selector(btnNextClick) forControlEvents:UIControlEventTouchUpInside];
//[btnNext.layer setCornerRadius:KVCommonCornerRadius];
//---------------------------------------------------------------------------------------
#define NAVIGATION_TAG 254
#define CommonNavFontSize 18.0f
#define CommonButtonFontSize 16.0f
#define KVCommonButtonHeight 72/2
#define KVCommonButtonWidth 300
#define KVCommonCornerRadius 4.0f
#define MAIN_CLOLOR  (COLOR_RGB(183,0,23))
#define Gray_CLOLOR  (COLOR_RGB(199,199,199))
//#define KVNA

#define KV_LABELCOLOR_SYSTEM COLOR_RGB(150.0f,150.0f,150.0f)
#define KV_LABELCOLOR_SELF COLOR_RGB(94.0f,94.0f,94.0f)

#define KVFont(FontName,FontSize) [UIFont fontWithName:FontName size:FontSize]
#define KVButtonBackImg [[UIImage imageNamed:@"img07.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)]

#define KVAnimateStart [KVHelper startAnimate:[self.view viewWithTag:NAVIGATION_TAG] frame:CGRectMake(320-34-8, (44-8)/2, 34, 8)]
#define KVAnimateStop [KVHelper stopAnimate]

#define COLOR_RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define COLOR_NORMAL [UIColor whiteColor]
#define COLOR_BLINK COLOR_RGB(217.0f,15.0f,13.0f)
#define NAVIGATION_POP [self.navigationController popViewControllerAnimated:YES]
#define Log_Class_Selector NSLog(@"%@:::%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd))
#define CommonBackColor COLOR_RGB(250.0f,250.0f,250.0f)

#define float(ff) [NSNumber numberWithFloat:ff]
#define integer(integ) [NSNumber numberWithInteger:integ]


//
#define IMG_PREFIX @"IMG_Product"


//提示信息----------------------------------------------------------------------------
#define ALERT_Prompt @"温馨提示"
#define ALERT_VCWoDeYinHangKa_KaiHuRenXingMing @"开户人姓名不能为空"
#define ALERT_VCWoDeYinHangKa_KaiHuZhangHao @"开户账号不能为空"
#define ALERT_VCWoDeYinHangKa_KaiHuYingHang @"开户银行不能为空"

#define ALERT_SHARE_SUCCESS @"分享成功"
#define ALERT_SHARE_FAIL @"分享失败"

#define ALERT_VCShangPinFaBuViewControllerPictures @"至少上传一张照片"
//开户人姓名不能为空 开户银行不能为空 开户账号不能为空 温馨提示
//----------------------------------------------------------------------------
@interface NSString (Helper)
-(BOOL)isNullOrEmpty;
//- (NSString *)URLEncodedString;
//- (NSString *)URLDecodedString;
@end

//@interface ASIFormDataRequest(Helper)
//-(void)addPostValues:(NSDictionary*)dicValues;
//@end
//@interface UIView (Helper)
//@property(nonatomic,retain)NSTimer* timer;
//@property(nonatomic,assign)NSInteger intRepeateTimes;
//-(void)blinkForTimeinterval:(NSTimeInterval)time times:(NSInteger)repeateTimes;
//@end

@interface KVHelper : NSObject

//+(void)NSLogFrame:(NSString*)descript frame:(CGRect)frame;
  //+(void)NSLogSize:(NSString*)descript size:(CGSize)size;
//+(void)NSLogPoint:(NSString*)descript point:(CGPoint)point;
+(void)NSLogArray:(NSArray*)ary;
+(NSString*)getDocumentFile:(NSString*)fileName;
+(NSString*)getTempFile:(NSString*)fileName;
+(NSString*)getLibraryFile:(NSString*)fileName;
+(bool)fileExist:(NSString*)filePath;
+(void)showAlert:(NSString*)titile message:(NSString*)msg;
//+(NSArray*)getHTMLPictureURLStr:(NSString*)html;
//+(void)parserNodes:(HTMLNode*)node array:(NSMutableArray*)ary;
+(NSString*)getClassName:(id)object;
+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
+(NSDate *)stringToDate:(NSString *)strdate;
+(NSString *)dateToString:(NSDate *)date;
+(NSString *)stringToJsonString:(NSString*)orginstr separator:(NSString*)separator;
+(NSString*)getStringFromPath:(NSString*)strPath;
//+(UIImageView*)getImageViewByName:(NSString*)imgName;
//+(CGSize)getImageSize:(NSString*)imgName;
+(NSString*)getStringFromData:(NSData*)data encode:(NSStringEncoding)encode;
//+(UIImage*)getImgwithPureColor:(UIColor*)color size:(CGSize)imageSize;
//+(void)shareAllWithContent:(id<ISSContent>)publishContent inViewController:(UIViewController*)vc;
//+(void)shareToQQ:(id<ISSContent>)publishContent;
//+(void)shareToWeChat:(id<ISSContent>)publishContent;
//+(void)shareToWeTimeLine:(id<ISSContent>)publishContent;

//+(UIImage*)getImage:(UIImage*)img cropRect:(CGRect)rect;
//+(void)startAnimate:(UIView*)superview frame:(CGRect)frame;
+(void)stopAnimate;
+(void)removeAnimate;
@end
