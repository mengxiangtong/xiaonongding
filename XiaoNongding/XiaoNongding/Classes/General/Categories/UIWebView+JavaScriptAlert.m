//
//  UIWebView+JavaScriptAlert.m
//  XiaoNongding
//
//  Created by jion on 16/2/26.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

@implementation UIWebView (JavaScriptAlert)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(UIWebView *)frame {
    
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"小农丁" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [customAlert show];
    
}

@end
