//
//  YBImgPickerTableViewCell.h
//  settingsTest
//
//  Created by 宋奕兴 on 15/9/7.
//  Copyright (c) 2015年 宋奕兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBImgPickerTableViewCell : UITableViewCell
@property (nonatomic , retain) UIImage * albumImg;
@property (nonatomic , retain) NSString * albumTitle;
@property (nonatomic , assign) NSInteger photoNum;
@end
