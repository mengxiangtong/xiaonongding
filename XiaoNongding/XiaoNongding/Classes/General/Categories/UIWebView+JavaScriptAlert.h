//
//  UIWebView+JavaScriptAlert.h
//  XiaoNongding
//
//  Created by jion on 16/2/26.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(UIWebView *)frame;  
@end
