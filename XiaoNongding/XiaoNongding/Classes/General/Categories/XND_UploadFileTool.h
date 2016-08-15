//
//  XND_UploadFileTool.h
//  XiaoNongding
//
//  Created by jion on 16/1/23.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol XND_UploadFileToolDelegate<NSObject>
-(void)XND_UploadFileToolDelegate_Compent:(NSDictionary *)msg isOK:(BOOL)isok;
@end

@interface XND_UploadFileTool : NSObject
- (void)uploadWithUrl:(NSString *)urlStr name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params;
-(void)uploadAvatarImageWithimageWithUrl:(NSString *)urlStr name:(NSString *)name imgArry:(NSArray *)imageArry parmas:(NSDictionary *)params;
-(void)uploadReplyImageWithimageWithUrl:(NSString *)urlStr name:(NSString *)name imgArry:(NSArray *)imageArry parmas:(NSDictionary *)params;
@property (nonatomic, assign) id<XND_UploadFileToolDelegate> delegate;

@end
