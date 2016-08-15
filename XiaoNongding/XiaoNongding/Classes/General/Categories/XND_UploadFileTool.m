//
//  XND_UploadFileTool.m
//  XiaoNongding
//
//  Created by jion on 16/1/23.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "XND_UploadFileTool.h"
 #define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
@implementation XND_UploadFileTool




- (void)uploadWithUrl:(NSString *)urlStr name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params
 {
         // 文件上传
         NSURL *url = [NSURL URLWithString:urlStr];
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
         request.HTTPMethod = @"POST";
    
         // 设置请求体
         NSMutableData *body = [NSMutableData data];
    
         /***************文件参数***************/
         // 参数开始的标志
         [body appendData:YYEncode(@"--YY\r\n")];
         // name : 指定参数名(必须跟服务器端保持一致)
         // filename : 文件名
         NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
         [body appendData:YYEncode(disposition)];
         NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
         [body appendData:YYEncode(type)];
    
         [body appendData:YYEncode(@"\r\n")];
         [body appendData:data];
         [body appendData:YYEncode(@"\r\n")];
    
         /***************普通参数***************/
         [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                 // 参数开始的标志
                 [body appendData:YYEncode(@"--YY\r\n")];
                 NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
                 [body appendData:YYEncode(disposition)];
        
                 [body appendData:YYEncode(@"\r\n")];
                 [body appendData:YYEncode(obj)];
                 [body appendData:YYEncode(@"\r\n")];
             }];
    
         /***************参数结束***************/
         // YY--\r\n
         [body appendData:YYEncode(@"--YY--\r\n")];
         request.HTTPBody = body;
    
         // 设置请求头
         // 请求体的长度
         [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
         // 声明这个POST请求是个文件上传
         [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    
         // 发送请求
         [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
             if (!connectionError) {
                 NSDictionary *results =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                 if (results) {
                     int status=[[results objectForKey:@"status"]  intValue];
                     if (status ==1) {
                         
                         NSDictionary *dic_userInfo=[[NSDictionary alloc]initWithDictionary:[results objectForKey:@"msg"]];
                         [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                         
                         
                         [SVProgressHUD dismiss];
                     }else{
                         [XNDProgressHUD showWithStatus:[results objectForKey:@"errorMsg"] duration:1.0];
                     }
                 }else{
                     [SVProgressHUD dismiss];
                 }
             }else{
                 [XNDProgressHUD showWithStatus:@"当前网络堵车,请检查网络" duration:1.0];
             }

        }];
}

 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
         // Socket 实现断点上传
    
         //apache-tomcat-6.0.41/conf/web.xml 查找 文件的 mimeType
     //    UIImage *image = [UIImage imageNamed:@"test"];
     //    NSData *filedata = UIImagePNGRepresentation(image);
     //    [self upload:@"file" filename:@"test.png" mimeType:@"image/png" data:filedata parmas:@{@"username" : @"123"}];
    
         // 给本地文件发送一个请求
         NSURL *fileurl = [[NSBundle mainBundle] URLForResource:@"itcast.txt" withExtension:nil];
         NSURLRequest *request = [NSURLRequest requestWithURL:fileurl];
         NSURLResponse *repsonse = nil;
         NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&repsonse error:nil];
    
         // 得到mimeType
        NSLog(@"%@", repsonse.MIMEType);
     [self uploadWithUrl:@"" name:@"file" filename:@"itcast.txt" mimeType:repsonse.MIMEType data:data parmas:@{@"username" : @"999",@"type" : @"XML"}];
}


#pragma mark - 上传头像
-(void)uploadAvatarImageWithimageWithUrl:(NSString *)urlStr name:(NSString *)name imgArry:(NSArray *)imageArry parmas:(NSDictionary *)params{

        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        manager.requestSerializer =  [AFJSONRequestSerializer serializer];//
        manager.responseSerializer =  [AFJSONResponseSerializer serializer];//
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer.timeoutInterval = 60.0;
    
        
        [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (UIImage *image in imageArry) {
                NSData *imageData=nil;
                NSString *str_mimeType=@"jpeg";
                
                if (UIImagePNGRepresentation(image)) {
                    //返回为png图像。
                    imageData = UIImagePNGRepresentation(image);
                    str_mimeType=@"png";
                }else {
                    //返回为JPEG图像。
                    imageData = UIImageJPEGRepresentation(image, 1.0);
                }
                if (imageData.length>1024.f*1024.f) {
                    UIImage *img=[self scaleImage:image toScale:0.5];
                    
                    if (UIImagePNGRepresentation(img)) {
                        //返回为png图像。
                        imageData = UIImagePNGRepresentation(img);
                        str_mimeType=@"png";
                    }else {
                        //返回为JPEG图像。
                        imageData = UIImageJPEGRepresentation(img, 1.0);
                    }
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmssfff";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                int randNum=(int)(500+arc4random()%501);
                
                NSString *fileName = [NSString stringWithFormat:@"%@%d_%@.%@", str,randNum,name,str_mimeType];
                
                // 上传图片，以文件流的格式
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@",str_mimeType ]];
            }
           
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"请求  图片 成功   %@", responseObject );
            
            NSDictionary *results =(NSDictionary *)responseObject;
            if (results) {
                int status=[[results objectForKey:@"status"]  intValue];
                if (status ==1) {
                    if ([urlStr isEqualToString:KUser_changeAvatar_URL]
                        ||[urlStr isEqualToString:KReply_To_URL]
                        ) {
                       
                    }else{
                        NSDictionary *dic_userInfo=[[NSDictionary alloc]initWithDictionary:[results objectForKey:@"msg"]];
                        [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                    }
               
                }else{
                    [XNDProgressHUD showWithStatus:[results objectForKey:@"errorMsg"] duration:1.0];
                }
            }else{
                [XNDProgressHUD showWithStatus:@"头像上传失败" duration:1.0];
            }

            if ([self.delegate respondsToSelector:@selector(XND_UploadFileToolDelegate_Compent:isOK:)]) {
                [self.delegate XND_UploadFileToolDelegate_Compent:results isOK:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"  请求 失败 ");
        
            if ([self.delegate respondsToSelector:@selector(XND_UploadFileToolDelegate_Compent:isOK:)]) {
                [self.delegate XND_UploadFileToolDelegate_Compent:nil isOK:NO];
            }
        }];
    
    
}
#pragma mark - 上传评价图片
-(void)uploadReplyImageWithimageWithUrl:(NSString *)urlStr name:(NSString *)name imgArry:(NSArray *)imageArry parmas:(NSDictionary *)params{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];//
    manager.responseSerializer =  [AFJSONResponseSerializer serializer];//
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.timeoutInterval = 60.0;
    
    [SVProgressHUD showWithStatus:nil];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (UIImage *image in imageArry) {
            NSData *imageData=nil;
            NSString *str_mimeType=@"jpeg";
            
            if (UIImagePNGRepresentation(image)) {
                //返回为png图像。
                imageData = UIImagePNGRepresentation(image);
                str_mimeType=@"png";
            }else {
                //返回为JPEG图像。
                imageData = UIImageJPEGRepresentation(image, 1.0);
            }
            if (imageData.length>1024.f*1024.f) {
                UIImage *img=[self scaleImage:image toScale:0.5];
                
                if (UIImagePNGRepresentation(img)) {
                    //返回为png图像。
                    imageData = UIImagePNGRepresentation(img);
                    str_mimeType=@"png";
                }else {
                    //返回为JPEG图像。
                    imageData = UIImageJPEGRepresentation(img, 1.0);
                }
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmssfff";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            int randNum=(int)(500+arc4random()%501);
            
            NSString *fileName = [NSString stringWithFormat:@"%@%d_%@.%@", str,randNum,name,str_mimeType];
            
            // 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@",str_mimeType ]];
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"请求  图片 成功   %@", responseObject );
        [SVProgressHUD dismiss];
        
        NSDictionary *results =(NSDictionary *)responseObject;
        if (results) {
            int status=[[results objectForKey:@"status"]  intValue];
            if (status ==1) {
                if ([urlStr isEqualToString:KUser_changeAvatar_URL]
                    ||[urlStr isEqualToString:KReply_To_URL]
                    ) {
                    
                }else{
                    NSDictionary *dic_userInfo=[[NSDictionary alloc]initWithDictionary:[results objectForKey:@"msg"]];
                    [[NSUserDefaults standardUserDefaults] setObject:dic_userInfo forKey:KUserInfo];
                }
                [SVProgressHUD dismiss];
            }else{
                [XNDProgressHUD showWithStatus:[results objectForKey:@"errorMsg"] duration:1.0];
            }
        }else{
            [SVProgressHUD dismiss];
        }
        
        if ([self.delegate respondsToSelector:@selector(XND_UploadFileToolDelegate_Compent:isOK:)]) {
            [self.delegate XND_UploadFileToolDelegate_Compent:results isOK:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"  请求 失败 ");
        [SVProgressHUD dismiss];
        if ([self.delegate respondsToSelector:@selector(XND_UploadFileToolDelegate_Compent:isOK:)]) {
            [self.delegate XND_UploadFileToolDelegate_Compent:nil isOK:NO];
        }
    }];
    
    
}
#pragma mark -
#pragma mark 等比縮放image
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
