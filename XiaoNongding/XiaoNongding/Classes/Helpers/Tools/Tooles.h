//
//  Tooles.h
//  BestBuyer
//
//  Created by zichenfang on 14/11/6.
//  Copyright (c) 2014年 24so. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KVHelper.h"
typedef void (^CropImageFinishedBlock)(UIImage *theImage);

@interface Tooles : NSObject



+ (UILabel *)CusstomTitleLabelWithTex:(NSString *)string;


#pragma mark - 隐藏多余cell 的分割线
//1、加方法
+ (void)setExtraCellLineHidden: (UITableView *)tableView;
+ (void)setBlackExtraCellLineHidden: (UITableView *)tableView;


//颜色转换成图片
+(UIImage*)getImageByColor:(UIColor*)aColor;

//取某天00:00:00时刻
+(NSDate *)defaultZeroPointOfDayDate :(NSDate *)aDate;
//取某天23:59:59时刻
+(NSDate *)defaultEndPointOfDayDate :(NSDate *)aDate;
//转化时间（s）为HH:mm:ss格式
+(NSString *)getHHmmssWithSeconds :(long int)seconds;
//图片缓存到本地
+ (void)setImageForView :(UIImageView *)aImageView WithUrlStr :(NSString *)aUrlStr placeholderImage :(UIImage *)aPlaceHolderImage;
+(UIButton *)defaultButtonWithTarget:(id)target Frame :(CGRect)frame Action:(SEL)action forControlEvents:(UIControlEvents)controlEvents NormalImage :(UIImage *)normalImage SelectedImage :(UIImage *)selectedImage;
#pragma mark-清除webView缓存何cookies
+ (void)clearUpCookiesAndCache;
//去掉html标签
+ (NSString *)deleteHTMLKeysInString:(NSString *)html;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//获取随机号码（X-Y）
+ (int)defaultRandomNumber:(int)from to:(int)to;
//UIImageView自适应居中
+ (void)defaultImageView :(UIImageView *)imageView FitInSize :(CGSize)size WithImage :(UIImage *)aImage;


+ (void)defaultImageView:(UIImageView *)imageView FitCenterWithImage:(UIImage *)aImage;
/**
 *  字典转字符串
 *
 *  @param object 字典对象
 *
 *  @return json字符串
 */
+(NSString*)DicTOjsonString:(NSDictionary *)object;
@end
