//
//  Tooles.m
//  BestBuyer
//
//  Created by zichenfang on 14/11/6.
//  Copyright (c) 2014年 24so. All rights reserved.
//

#import "Tooles.h"
#import "AppDelegate.h"

@implementation Tooles

#pragma mark - 隐藏多余cell 的分割线


#pragma mark - 隐藏多余cell 的分割线

+ (UILabel *)CusstomTitleLabelWithTex:(NSString *)string
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    // titleLabel.backgroundColor = [UIColor cyanColor];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:string];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    return titleLabel;
}


//1、加方法
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    [tableView setTableFooterView:view];
}

//1、灰色加方法
+ (void)setBlackExtraCellLineHidden: (UITableView *)tableView
{
  //  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-(60+kDeviceWidth*190/715+5+20+10 ))];
    
    
    UIView *view = [[UIView alloc] init];

    view.backgroundColor = kBlackBgColor;
    //view.backgroundColor = [UIColor whiteColor];
    
    [tableView setTableFooterView:view];
}



+(UIImage*)getImageByColor:(UIColor*)aColor
{
    CGSize as = CGSizeMake(1, 1);
    UIImage *img = nil;
    CGRect rect = CGRectMake(0, 0, as.width, as.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   aColor.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//取某天00:00:00时刻
+(NSDate *)defaultZeroPointOfDayDate :(NSDate *)aDate
{
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    [gregorian setTimeZone:gmt];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: aDate];
    [components setHour: -8];
    [components setMinute:0];
    [components setSecond: 0];
    NSDate *newDate = [gregorian dateFromComponents: components];
    return newDate;
}
//取某天23:59:59时刻
+(NSDate *)defaultEndPointOfDayDate :(NSDate *)aDate
{
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    [gregorian setTimeZone:gmt];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: aDate];
    [components setHour: 15];
    [components setMinute:59];
    [components setSecond: 59];
    NSDate *newDate = [gregorian dateFromComponents: components];
    return newDate;
}
//转化时间（s）为HH:mm:ss格式
+(NSString *)getHHmmssWithSeconds :(long int)seconds
{
    seconds=seconds>24*60*60-1?24*60*60-1:seconds;
    long int hour =seconds/3600;
    long int second =seconds%60;
    long int minute =(seconds -hour*3600-second)/60;
    NSString *hour_str =hour>=10?[NSString stringWithFormat:@"%ld",hour]:[NSString stringWithFormat:@"0%ld",hour];
    NSString *minute_str =minute>=10?[NSString stringWithFormat:@"%ld",minute]:[NSString stringWithFormat:@"0%ld",minute];
    NSString *second_str =second>=10?[NSString stringWithFormat:@"%ld",second]:[NSString stringWithFormat:@"0%ld",second];
    NSString *HHmmss =[NSString stringWithFormat:@"%@: %@: %@",hour_str,minute_str,second_str];
    return HHmmss;
}


//内容写入到tmp文件夹下的子文件夹,返回data路径
+ (NSString *)writeData :(NSData *)theData ToTMPWithSubFloderName :(NSString *)theFloderName FileName :(NSString *)theFileName
{
    if (!theData) {
        NSLog(@"%s ,writting Data is nil",__FUNCTION__);
        return @"";
    }
    
    NSString *temppath=NSTemporaryDirectory();
    NSString *floderPath=[temppath stringByAppendingPathComponent:theFloderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:floderPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath=[floderPath stringByAppendingPathComponent:theFileName];
    
    
    if([theData writeToFile:filePath atomically:YES])
    {
        NSLog(@"Data 写入成功 filePath=%@",filePath);
        return filePath;
    }
    else
    {
        NSLog(@"Data 写入失败 filePath=%@",filePath);
        return @"";
    }
    
}

#pragma mark-图片缓存到本地
+ (void)setImageForView :(UIImageView *)aImageView WithUrlStr :(NSString *)aUrlStr placeholderImage :(UIImage *)aPlaceHolderImage
{
    //step 1 转换地址“／”关键字
    NSString *imageName =[aUrlStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    //step 2 指定路径(temp文件夹下的)
    NSString *temppath=NSTemporaryDirectory();
    NSString *floderPath=[temppath stringByAppendingPathComponent:@"headimage"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:floderPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath=[floderPath stringByAppendingPathComponent:imageName];
    
    NSData *localImagedata =[NSData dataWithContentsOfFile:filePath];
    
    //如果本地存在该图片，则直接取之
    if ([fileManager fileExistsAtPath:filePath]&&localImagedata.length>0) {
        NSLog(@"获取本地图片成功！localImagedata =%ld",(unsigned long)localImagedata.length);
        [aImageView setImage:[UIImage imageWithData:localImagedata]];
        return;
    }
    //如果不存在该图片，则网络请求
    NSLog(@"获取本地图片失败！");
    NSData *requestImageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:aUrlStr]];
    //    NSData *requestImageData =UIImagePNGRepresentation(aPlaceHolderImage);
    if (!requestImageData)//请求失败
    {
        NSLog(@"请求失败--%@",aUrlStr);
        [aImageView setImage:aPlaceHolderImage];
        return;
    }
    //请求成功，则赋值，并写入本地
    NSLog(@"请求成功");
    [aImageView setImage:[UIImage imageWithData:requestImageData]];
    if ([requestImageData writeToFile:filePath atomically:YES]) {
        NSLog(@"Data 写入成功 filePath=%@",filePath);
    }
    else
    {
        NSLog(@"Data 写入失败 filePath=%@",filePath);
    }
    
}
//自定义UIBarButtonItem，可显示选中和非选中两个状态
+(UIButton *)defaultButtonWithTarget:(id)target Frame :(CGRect)frame Action:(SEL)action forControlEvents:(UIControlEvents)controlEvents NormalImage :(UIImage *)normalImage SelectedImage :(UIImage *)selectedImage
{
    UIButton *cuntomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [cuntomBtn setFrame:frame];
    [cuntomBtn addTarget:target action:action forControlEvents:controlEvents];
    [cuntomBtn setImage:normalImage forState:UIControlStateNormal];
    [cuntomBtn setImage:selectedImage forState:UIControlStateSelected];
    return cuntomBtn;
}
#pragma mark-清除webView缓存何cookies
+ (void)clearUpCookiesAndCache
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //    UIWebView清除缓存：
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
//去掉html标签
+ (NSString *)deleteHTMLKeysInString:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//获取随机号码（X-Y）
+ (int)defaultRandomNumber:(int)from to:(int)to

{
    return (int)(from + (arc4random() % (to-from+1)));
    //+1,result is [from to]; else is [from, to)!!!!!!!
}
//UIImageView自适应居中
+ (void)defaultImageView :(UIImageView *)imageView FitInSize :(CGSize)size WithImage :(UIImage *)aImage
{
    CGSize imageSize =size;
    if (aImage) {
        imageSize =aImage.size;
    }
    //父视图宽高比
    float scale_parent =size.width/size.height;
    //图片宽高比
    float scale_image =imageSize.width/imageSize.height;
    
    float width;
    float height;
    if (scale_image>scale_parent)
    {
        //按照图片宽度满屏适应
        width =size.width;
        height =imageSize.height*(size.width/imageSize.width);
    }
    else
    {
        //按照图片高度满屏适应
        height =size.height;
        width =imageSize.width*(size.height/imageSize.height);
    }
    
    [imageView setFrame:CGRectMake((size.width-width)*0.5, (size.height-height)*0.5, width, height)];
    
    NSLog(@"%@ - %@",NSStringFromCGSize(aImage.size),NSStringFromCGRect(imageView.frame));
}

+ (void)defaultImageView:(UIImageView *)imageView FitCenterWithImage:(UIImage *)aImage
{
    CGSize size;
    if (aImage==nil) {
        size =imageView.frame.size;
    }
    else
    {
        size =CGSizeMake(MIN(aImage.size.height, aImage.size.width), MIN(aImage.size.height, aImage.size.width));
    }
    
    CGRect rect =CGRectMake((aImage.size.width-size.width)*0.5, (aImage.size.height-size.height)*0.5, size.width, size.height);
    
    
    CGImageRef sourceImageRef = [aImage CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    imageView.image =newImage;
}

+(NSString*)DicTOjsonString:(NSDictionary *)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
