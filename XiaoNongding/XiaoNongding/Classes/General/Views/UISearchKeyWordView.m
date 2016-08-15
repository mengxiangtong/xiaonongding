//
//  UISearchKeyWordView.m
//  XiaoNongding
//
//  Created by jion on 16/1/27.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "UISearchKeyWordView.h"
@interface UISearchKeyWordView ()
@property (nonatomic, retain) UIButton *btn_ketWord;
@end

@implementation UISearchKeyWordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn_ketWord];
    }
    return self;
}
-(UIButton *)btn_ketWord{
    if (!_btn_ketWord) {
        _btn_ketWord=[[UIButton alloc]initWithFrame:self.bounds];
        [_btn_ketWord  setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.99 alpha:1.0]] forState:UIControlStateNormal];
        [_btn_ketWord  setBackgroundImage:[SO_Convert createImageWithColor:[UIColor colorWithWhite:0.7 alpha:1.0]] forState:UIControlStateHighlighted];
        [_btn_ketWord setTitle:@"" forState:UIControlStateNormal];
        [_btn_ketWord addTarget:self action:@selector(btn_ketWordAction:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_ketWord.layer setBorderColor:[UIColor colorWithWhite:0.6 alpha:1.0].CGColor];
        [_btn_ketWord.layer setBorderWidth:1.0];
        [_btn_ketWord.layer setCornerRadius:5.0];
        [_btn_ketWord.layer setMasksToBounds:YES];
        [_btn_ketWord.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_btn_ketWord setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0] forState:UIControlStateNormal];
        [_btn_ketWord setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    }
    return _btn_ketWord;
}
-(void)setItem:(NSDictionary *)item{
    _item=item;
    if (_item) {
        [self.btn_ketWord  setTitle:[item objectForKey:@"name"] forState:UIControlStateNormal];
    }
}
-(void)btn_ketWordAction:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(UISearchKeyWordViewClicked:)]){
        [self.delegate UISearchKeyWordViewClicked:self.item];
    }
}
@end
