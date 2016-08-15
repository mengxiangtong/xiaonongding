//
//  UISearchBar+TextFieldAndButton.m
//  XiaoNongding
//
//  Created by jion on 16/1/28.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UISearchBar_TextFieldAndButton.h"

@implementation UISearchBar_TextFieldAndButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) layoutSubviews
{
    
    UITextField *searchField;
    UIButton *button;
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]) {
            button=[self.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        
    }
    if (button) {
        [button setBackgroundColor:[UIColor clearColor]];
        [button setImage:nil forState:UIControlStateNormal];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    
    [super layoutSubviews];
}
@end
