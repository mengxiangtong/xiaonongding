//
//  KVHelper.m
//  Kejitong
//
//  Created by kevin xu on 11/18/13.
//  Copyright (c) 2013 LiuLibo. All rights reserved.
//

#import "KVHelper.h"
//#import "HTMLParser.h"


#import <objc/runtime.h>
//static const void *TimerKey = &Helper;
//static UIImageView* imgvwAnimation;

@implementation NSString (Helper)

-(BOOL)isNullOrEmpty
{
    if ([self isEqualToString:@""]||[[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]||self==nil) {
        return YES;
    }
    return NO;
}
//- (NSString *)URLEncodedString{
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                           (CFStringRef)self,
//                                                                           NULL,
//                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
//                                                                           kCFStringEncodingUTF8));
////    [result autorelease];
//    return result;
//}
//
//- (NSString*)URLDecodedString{
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
//                                                                                           (CFStringRef)self,
//                                                                                           CFSTR(""),
//                                                                                           kCFStringEncodingUTF8));
//    //[result autorelease];
//    return result;
//}
@end

//------------------------------------------------------------
//@implementation ASIFormDataRequest(Helper)
//
//-(void)addPostValues:(NSDictionary *)dicValues
//{
//    for (NSString* key in [dicValues allKeys] ) {
//        [self setPostValue:[dicValues objectForKey:key] forKey:key];
//    }
//}
//
//@end


//@implementation UIView(Helper)
//@dynamic intRepeateTimes,timer;
//-(NSTimer*)timer
//{
//    return nil;
//    //return objc_getAssociatedObject(self,intr);
//}
//-(NSInteger)intRepeateTimes
//{
//    return self.intRepeateTimes;
//}
//-(void)setTimer:(NSTimer *)timer
//{
//    timer=timer;
//}
//-(void)setIntRepeateTimes:(NSInteger)intRepeateTimes
//{
//    intRepeateTimes=intRepeateTimes;
//}
//-(void)blinkForTimeinterval:(NSTimeInterval)time times:(NSInteger)repeateTimes
//{
//    if (self.timer) {
//        [self.timer invalidate];
//    }
//    self.timer=[NSTimer timerWithTimeInterval:time target:self selector:@selector(timeHandler) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    self.intRepeateTimes=repeateTimes;
//    [self.timer fire];
//}
//
//-(void)timeHandler
//{
//    static NSInteger count=0;
//    if (self.intRepeateTimes<=count) {//假如闪烁完成 则获取焦点
//        [self.timer invalidate];
//        count=0;
//        [self becomeFirstResponder];
//        
//        return;
//    }
//    if ([self.backgroundColor isEqual:COLOR_NORMAL]) {
//        self.backgroundColor=COLOR_BLINK;
//        NSLog(@"white");
//    }
//    else{
//        self.backgroundColor=COLOR_NORMAL;
//        NSLog(@"red");
//    }
//    count++;
//}
//
//@end


@implementation KVHelper
//
//+(void)NSLogFrame:(NSString *)descript frame:(CGRect)frame
//{
//   // NSLog(@"%@:::%f  %f  %f  %f",descript,frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
//}
//+(void)NSLogPoint:(NSString *)descript point:(CGPoint)point
//{
//   //  NSLog(@"%@:::%f  %f",descript,point.x,point.y);
//}
+(void)NSLogArray:(NSArray *)ary
{
    for (id obj in ary) {
      //  NSLog(@"%@   ",obj);
    }
}
+(NSString*)getStringFromPath:(NSString*)strPath
{
    NSError *error;
    
    NSString *textFileContents = [NSString
                                  
                                  stringWithContentsOfFile:[[NSBundle mainBundle]
                                                            
                                                            pathForResource:@"form"
                                                            
                                                            ofType:@"txt"]
                                  
                                  encoding:NSUTF8StringEncoding
                                  
                                  error: & error];
    return textFileContents;
}

+(NSString*)getDocumentFile:(NSString*)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return  [path stringByAppendingPathComponent:fileName];
}

+(NSString*)getTempFile:(NSString*)fileName
{
    NSString* path=NSTemporaryDirectory();
    return [path stringByAppendingPathComponent:fileName];
}

+(NSString*)getLibraryFile:(NSString *)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return  [path stringByAppendingPathComponent:fileName];
}

+(bool)fileExist:(NSString*)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
return NO;
}

//
//+(void)showAlert:(NSString *)titile message:(NSString *)msg
//{
//    
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:titile message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//}
//+(NSArray*)getHTMLPictureURLStr:(NSString*)html {
//    NSMutableArray* ary=[[NSMutableArray alloc] init];
//    
//    html = [html stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
//    NSError *error = nil;
//    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
//    
//    if (error) {
//        NSLog(@"Error: %@", error);
//        return nil;
//    }
//    
//    HTMLNode *bodyNode = [parser body];
//    [KVHelper parserNodes:bodyNode array:ary];
//    //    NSArray *inputNodes = [bodyNode children];
//    
////    for (HTMLNode *node in inputNodes)
////    {
////        
////        NSArray *childNodes = [node children];
////        NSLog(@"childnodes=%@",childNodes);
////        if (childNodes.count > 0)
////        {
////            if (childNodes.count == 1)
////            {
////                HTMLNode *theNode = [childNodes objectAtIndex:0];
////                if (theNode.nodetype == HTMLImageNode) {
////                    [ary addObject:[theNode getAttributeNamed:@"src"]];
////                }
////            }
////        }
////    
////    }
//    NSLog(@"aru=%@",ary);
//    return ary;
//}
//+(void)parserNodes:(HTMLNode*)node array:(NSMutableArray*)ary
//{
//    if (!node) {
//        return;
//    }
//    if (node.nodetype==HTMLImageNode) {
//        [ary addObject:[node getAttributeNamed:@"src"]];
//    }
//    else if(node.children){
//        for (HTMLNode* nd in node.children) {
//            [self parserNodes:nd array:ary];
//        }
//    }
//   
//}
+(NSString*)getClassName:(id)object
{
    return [NSString stringWithUTF8String:object_getClassName(object)];
}

//+(void)NSLogSize:(NSString*)descript size:(CGSize)size
//{
//   // NSLog(@"size of %@ is:::%f %f",descript,size.width,size.height);
//}

+(NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+(NSDate *)stringToDate:(NSString *)strdate

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *retdate = [dateFormatter dateFromString:strdate];
    
    return retdate;
    
}


//NSDate 2 NSString

+(NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
    
}

+(NSString*)stringToJsonString:(NSString *)orginstr separator:(NSString *)separator
{
    //[orginstr stringByReplacingOccurrencesOfString:orginstr withString:@",\""]stringByReplacingOccurrencesOfString
  
    NSString* str=[orginstr stringByReplacingOccurrencesOfString:separator withString:@"\",\""] ;
    NSString* result=[[NSString stringWithFormat:@"[\"%@\"]",str] stringByReplacingOccurrencesOfString:@",\"\"" withString:@""];
    NSLog(@"result:::%@",result);
    return result;
}
//
//+(UIImageView*)getImageViewByName:(NSString*)imgName
//{
//    UIImage* img=[UIImage imageNamed:imgName];
//    UIImageView* imgvw=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
//    imgvw.userInteractionEnabled=YES;
//    imgvw.image=img;
//    return imgvw;
//}
//
//+(CGSize)getImageSize:(NSString*)imgName
//{
//    UIImage* img=[UIImage imageNamed:imgName];
//    
//    
//    return img.size;
//}
//
//+(NSString*)getStringFromData:(NSData*)data encode:(NSStringEncoding)encode
//{
//    return @"";
//}
//
//+(UIImage*)getImgwithPureColor:(UIColor*)color size:(CGSize)imageSize
//{
//        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
//        [color set];
//        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
//        UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return pressedColorImg;
//}

//
//+(UIImage*)getImage:(UIImage*)img cropRect:(CGRect)rect
//{
//    CGImageRef imageRef=CGImageCreateWithImageInRect([img CGImage],rect);
//    UIImage *imgResult=[UIImage imageWithCGImage:imageRef];
//    return imgResult;
//}
//
//
//+(void)startAnimate:(UIView*)superview frame:(CGRect)frame
//{
//    if (!imgvwAnimation) {
//        
//    NSArray *magesArray = [NSArray arrayWithObjects:
//                           [UIImage imageNamed:@"circle_3.png"],
//                           [UIImage imageNamed:@"circle_2.png"],
//                           [UIImage imageNamed:@"circle_1.png"],
//                           [UIImage imageNamed:@"circle_0.png"],
//                           nil];
//    
//    
//    imgvwAnimation = [[UIImageView alloc]init];
//    
//    imgvwAnimation.animationImages = magesArray;
//    
//    imgvwAnimation.frame=frame;//CGRectMake(270, 27+8, 34, 8); //45,30
//    //将序列帧数组赋给UIImageView的animationImages属性
//    imgvwAnimation.animationDuration = 0.5;//设置动画时间
//    imgvwAnimation.animationRepeatCount = 0;//设置动画次数 0 表示无限
//    }
//    if ([imgvwAnimation isAnimating]) {
//        [imgvwAnimation stopAnimating];
//    }
//    [imgvwAnimation removeFromSuperview];
//    [superview addSubview:imgvwAnimation];
//    [imgvwAnimation startAnimating];
//}
//+(void)stopAnimate
//{
//    if (!imgvwAnimation)
//        return;
//    if ([imgvwAnimation isAnimating]) {
//        [imgvwAnimation stopAnimating];
//        //[imgvwAnimation removeFromSuperview];
//    }
//    
//}
//
//
//+(void)removeAnimate
//{
//    if (!imgvwAnimation)
//        return;
//    if ([imgvwAnimation isAnimating]) {
//        [imgvwAnimation stopAnimating];
//    }
//    [imgvwAnimation removeFromSuperview];
//}
//
//
//+(void)shareAllWithContent:(id<ISSContent>)publishContent inViewController:(UIViewController *)vc
//{
//        NSArray *shareList = [ShareSDK getShareListWithType:
//                              ShareTypeWeixiSession,
//                              ShareTypeWeixiTimeline,
//                              ShareTypeSinaWeibo,
//                              ShareTypeQQ,
//                              ShareTypeQQSpace,
//                              nil];
//        //定义容器
//        id<ISSContainer> container = [ShareSDK container];
//        [container setIPhoneContainerWithViewController:vc];
//        [ShareSDK showShareActionSheet:container
//                             shareList:shareList
//                               content:publishContent
//                         statusBarTips:NO
//                           authOptions:nil
//                          shareOptions: nil
//                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    if (state == SSResponseStateSuccess)
//                                    {
//                                        NSLog(@"分享成功");
//                                    }
//                                    else if (state == SSResponseStateFail)
//                                    {
//                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                                    }
//                                }];
//
//}

//
//
//+(void)shareToQQ:(id<ISSContent>)publishContent
//{
//    [ShareSDK clientShareContent:publishContent type:ShareTypeQQ statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSResponseStateSuccess)
//        {
//            NSLog(@"分享成功");
//            [SVProgressHUD showSuccessWithStatus:ALERT_SHARE_SUCCESS];
//        }
//        else if (state == SSResponseStateFail)
//        {
//            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//            [XNDProgressHUD showWithStatus:ALERT_SHARE_FAIL];
//        }
//        
//    }];
//
//}
//+(void)shareToWeChat:(id<ISSContent>)publishContent
//{
//    [ShareSDK clientShareContent:publishContent type:ShareTypeWeixiSession statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSResponseStateSuccess)
//        {
//            NSLog(@"分享成功");
//            [SVProgressHUD showSuccessWithStatus:ALERT_SHARE_SUCCESS];
//        }
//        else if (state == SSResponseStateFail)
//        {
//            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//            [XNDProgressHUD showWithStatus:ALERT_SHARE_FAIL];
//        }
//        
//    }];
//}
//+(void)shareToWeTimeLine:(id<ISSContent>)publishContent
//{
//    [ShareSDK clientShareContent:publishContent type:ShareTypeWeixiTimeline statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSResponseStateSuccess)
//        {
//            NSLog(@"分享成功");
//            [SVProgressHUD showSuccessWithStatus:ALERT_SHARE_SUCCESS];
//        }
//        else if (state == SSResponseStateFail)
//        {
//            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//            [XNDProgressHUD showWithStatus:ALERT_SHARE_FAIL];
//        }
//        
//    }];
//}
@end
