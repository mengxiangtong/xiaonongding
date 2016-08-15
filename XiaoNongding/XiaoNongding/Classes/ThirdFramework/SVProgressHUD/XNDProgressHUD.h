//
//  XNDProgressHUD.h
//
//  Created by Sam Vermette on 27.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/XNDProgressHUD
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

enum {
    XNDProgressHUDMaskTypeNone = 1, // allow user interactions while HUD is displayed
    XNDProgressHUDMaskTypeClear, // don't allow
    XNDProgressHUDMaskTypeBlack, // don't allow and dim the UI in the back of the HUD
    XNDProgressHUDMaskTypeGradient // don't allow and dim the UI with a a-la-alert-view bg gradient
};

typedef NSUInteger XNDProgressHUDMaskType;

@interface XNDProgressHUD : UIView

+ (void)show;
+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString *)string duration:(NSTimeInterval)duration;

+ (void)setStatus:(NSString*)string; // change the HUD loading status while it's showing

+ (void)dismiss; // simply dismiss the HUD with a fade+scale out animation

+ (BOOL)isVisible;

@end
