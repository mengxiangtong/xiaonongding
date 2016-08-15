//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface HZAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
}

@end

@implementation HZAreaPickerView

@synthesize delegate=_delegate;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;


-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0] ;
    if (self) {
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        self.backgroundColor = kGrayBg_239Color;
        
        CGRect myFram = CGRectMake(0, 0, kDeviceWidth, 220) ;
        self.frame = myFram;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kDeviceWidth-60, 0, 50, 30);
        [btn setTitle:@"完成"forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        //加载数据
        [self siginUserNotifictionCenter];
        


    }
        
    return self;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
-(void)siginUserNotifictionCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePicker:) name:KNotifictionChangeArea object:nil];
    
    [[XNDAreaModule instance] loadAreaList];

    
    self.locate.province=@"";
    self.locate.city=@"";
    self.locate.area=@"";
    self.locate.provinceId=@"";
    self.locate.cityId=@"";
    self.locate.areaId=@"";
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}

-(void)changePicker:(NSNotification *)notify{
    if ([notify.name  isEqualToString:KNotifictionChangeArea]) {
        if(notify.object){
            dispatch_async(dispatch_get_main_queue(), ^{
                provinces=[NSArray arrayWithArray:[[XNDAreaModule instance] modelAreaArry] ];
                cities=[NSArray arrayWithArray:[[XNDAreaModule instance] modelCityArry] ];
                areas=[NSArray arrayWithArray:[[XNDAreaModule instance] modelProvinceArry] ];
                
                
                
                if ([notify.object integerValue]==0) {
                    if (provinces.count>0) {
                        self.locate.province=((XNDAreaModel*)provinces[0]).area_name;
                        self.locate.provinceId=((XNDAreaModel*)provinces[0]).area_id;
                    }else{
                        self.locate.province=@"";
                        self.locate.provinceId=@"";
                    }
                    self.locate.city=@"" ;
                    self.locate.area=@"" ;
                    self.locate.cityId=@"" ;
                    self.locate.areaId=@"" ;
                }else if([notify.object integerValue]==1){
                    if (cities.count>0) {
                        self.locate.city=((XNDAreaModel*)cities[0]).area_name;
                        self.locate.cityId=((XNDAreaModel*)cities[0]).area_id;
                    }else{
                        self.locate.city=@"" ;
                        self.locate.cityId=@"" ;
                    }
                    self.locate.area=@"" ;
                    self.locate.areaId=@"" ;
                }else if([notify.object integerValue]==2){
                    if (areas.count>0) {
                        self.locate.area=((XNDAreaModel*)areas[0]).area_name;
                        self.locate.areaId=((XNDAreaModel*)areas[0]).area_id;
                    }else{
                        self.locate.area=@"" ;
                        self.locate.areaId=@"" ;
                    }
                    
                }
                
                [self.locatePicker reloadComponent:[notify.object integerValue]];
                if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
                    [self.delegate pickerDidChaneStatus:self];
                }
            });
            
        }
    }
}


#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                if ([provinces count] > 0) {
   
                    return [((XNDAreaModel *)[provinces objectAtIndex:row]) area_name ];
                    break;
                }
                
            case 1:
                if ([cities count] > 0) {
      
                    return [((XNDAreaModel *)[cities objectAtIndex:row]) area_name ];
                     break;
                }
               
            case 2:
                if ([areas count] > 0) {
      
                    return [((XNDAreaModel *)[areas objectAtIndex:row]) area_name ];
                    break;
                }
            default:
                return  @"";
                break;
        }
    } else{
        switch (component) {
            case 0:
                return [((XNDAreaModel *)[provinces objectAtIndex:row]) area_name ];
                break;
            case 1:
                return [((XNDAreaModel *)[cities objectAtIndex:row]) area_name ];
                break;
            default:
                return @"";
                break;
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:19.f]];
    }
    
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                [[XNDAreaModule instance] loadCityList:[((XNDAreaModel*)provinces[row]).area_id intValue]];
                cities=nil;
                areas=nil;
                [self.locatePicker reloadComponent:1];
                [self.locatePicker reloadComponent:2];
                if(provinces.count>row){
                    self.locate.province=((XNDAreaModel*)provinces[row]).area_name;
                    self.locate.provinceId=((XNDAreaModel*)provinces[row]).area_id;
                }else{
                    self.locate.province=@"";
                    self.locate.provinceId=@"";
                }
                
                self.locate.city=@"";
                self.locate.area=@"";
                
                self.locate.cityId=@"";
                self.locate.areaId=@"";
                break;
            case 1:
                [[XNDAreaModule instance] loadProvinceList:[((XNDAreaModel*)cities[row]).area_id intValue]];
                areas=nil;
                [self.locatePicker reloadComponent:2];
                if (cities.count>row) {
                    self.locate.city=((XNDAreaModel*)cities[row]).area_name;
                    self.locate.cityId=((XNDAreaModel*)cities[row]).area_id;
                }else{
                    self.locate.city=@"";
                    self.locate.cityId=@"";
                }
               
                self.locate.area=@"";
                
                self.locate.areaId=@"";
                break;
            case 2:
                if (areas.count>row) {
                    self.locate.area=((XNDAreaModel*)areas[row]).area_name;
                    self.locate.areaId=((XNDAreaModel*)areas[row]).area_id;
                }else{
                    self.locate.areaId=@"";
                    self.locate.area=@"";
                }
                
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                [[XNDAreaModule instance] loadCityList:[((XNDAreaModel*)provinces[row]).area_id intValue]];
                break;
            case 1:
                [[XNDAreaModule instance] loadProvinceList:[((XNDAreaModel*)cities[row]).area_id intValue]];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }

}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
   // self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, 220);

    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
      //  self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
         self.frame = CGRectMake(0, 50*4, self.frame.size.width, 220);
        
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                        // self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         self.frame = CGRectMake(0, self.frame.origin.y+220, self.frame.size.width, 220);

                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
