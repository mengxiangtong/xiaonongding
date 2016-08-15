//
//  XNDAreaModule.m
//  XiaoNongding
//
//  Created by jion on 16/1/19.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import "XNDAreaModule.h"

@implementation XNDAreaModule

+ (instancetype)instance
{
    static XNDAreaModule* g_AreaModule;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_AreaModule = [[XNDAreaModule alloc] init];
    });
    return g_AreaModule;
}

-(BOOL)IsExitisWithAreaId:(int)area_id{
    
    for (XNDAreaModel *model in self.modelAreaArry) {
        if ([model.area_id intValue]==area_id) {
            return  YES;
        }
    }
    for (XNDAreaModel *model in self.modelCityArry) {
        if ([model.area_id intValue]==area_id) {
            return  YES;
        }
    }
    for (XNDAreaModel *model in self.modelProvinceArry) {
        if ([model.area_id intValue]==area_id) {
            return  YES;
        }
    }
    for (XNDAreaModel *model in self.modelCircleArry) {
        if ([model.area_id intValue]==area_id) {
            return  YES;
        }
    }
    
    return NO;
}


-(void)AddAreaWithModel:(XNDAreaModel *)model Completion:(XNDUpdateAreaModelCompletion)completion{
    if (model) {
        [[[DBManager alloc]init] insertAreas:@[model] Completion:^(BOOL success, NSString *error) {
            completion(success,nil);
        }];
    }
}
-(void)AddAreaWithArray:(NSArray *)arryModel Completion:(XNDUpdateAreaModelCompletion)completion{
    if (arryModel) {
        [[[DBManager alloc]init] insertAreas:arryModel Completion:^(BOOL success, NSString *error) {
            completion(success,nil);
        }];
    }
}
-(void)UpdateAreaWithModel:(XNDAreaModel *)model Completion:(XNDUpdateAreaModelCompletion)completion{
    if (model) {
        [[[DBManager alloc]init] updateMessageForMessage:model completion:^(BOOL result) {
            completion(result,nil);
        }];
    }
}
-(void)LoadAllAreaWithCompletion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadAreaArrayAllWithCompletion:^(NSArray *messages, NSError *error) {
           self.modelAreaArry=[[NSMutableArray alloc]initWithArray: messages ];
    }];
}
-(void)LoadAllCityWithCompletion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadCityArrayAllWithCompletion:^(NSArray *messages, NSError *error) {
        self.modelCityArry=[[NSMutableArray alloc]initWithArray: messages ];
    }];
}
-(void)LoadAllProvinceWithCompletion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadProvinceArrayAllWithCompletion:^(NSArray *messages, NSError *error) {
        self.modelProvinceArry=[[NSMutableArray alloc]initWithArray: messages ];
    }];
}
-(void)LoadAllCircleWithCompletion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadCircleArrayAllWithCompletion:^(NSArray *messages, NSError *error) {
        self.modelCircleArry=[[NSMutableArray alloc]initWithArray: messages ];
    }];
}

-(void)LoadAllCityWithPid:(int)pid Completion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadCityArrayAllWithPid:pid Completion:^(NSArray *messages, NSError *error) {
        self.modelCityArry=[[NSMutableArray alloc]initWithArray: messages ];
        completion(nil,nil);
    }];
}
-(void)LoadAllProvinceWithPid:(int)pid Completion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadProvinceArrayAllWithPid:pid Completion:^(NSArray *messages, NSError *error) {
        self.modelProvinceArry=[[NSMutableArray alloc]initWithArray: messages ];
        completion(nil,nil);
    }];
}
-(void)LoadAllCircleWithPid:(int)pid Completion:(XNDLoadAreaModelCompletion)completion{
    [[[DBManager alloc]init] loadCircleArrayAllWithPid:pid Completion:^(NSArray *messages, NSError *error) {
        self.modelCircleArry=[[NSMutableArray alloc]initWithArray: messages ];
        completion(nil,nil);
    }];
}
-(NSMutableArray*)LoadAllArea{
    return [[[DBManager alloc]init] loadAreaArrayAll];
}
-(NSMutableArray*)LoadAllCityWithPid:(int)pid {
    return [[[DBManager alloc]init] loadCityArrayAllWithPid:pid ];
    
}
-(NSMutableArray*)LoadAllProvinceWithPid:(int)pid {
    return [[[DBManager alloc]init] loadProvinceArrayAllWithPid:pid ];
}

-(void)loadAreaList{
    /**
     *  获取本地数据，并返回展示，
     *  获取网络数据，并保存到本地
     */
    BOOL isPosted=NO;
    NSMutableArray *arry=[self LoadAllArea];
    if (arry && arry.count>0) {
        self.modelAreaArry=arry;
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionChangeArea object:@"0"];
        isPosted=YES;
    }
    
    NSURL *url = [NSURL URLWithString: KAddress_Area_URL ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    
                    NSMutableArray* arry=  [[NSMutableArray alloc]initWithArray: [dict objectForKey:@"msg"]] ;
                    if (arry && arry.count>0) {
                        arry=[[[XNDAreaModel alloc]init] arrayWithArray:arry];
                        
                        
                        [[XNDAreaModule instance] AddAreaWithArray:arry Completion:^(BOOL success, NSError *error) {
                            [[XNDAreaModule instance] LoadAllAreaWithCompletion:^(NSArray *messages, NSError *error) {
                                if (isPosted==NO) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionChangeArea object:@"0"];
                                }
                            
                            }];
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadCityList:[((XNDAreaModel*)arry[0]).area_id intValue]];
                        });
                    }
                    
                    
                }
            }
        }
        
        
    }];
    
}
-(void)loadCityList:(int)pid{
    
    /**
     *  获取本地数据，并返回展示，
     *  获取网络数据，并保存到本地
     */
    BOOL isPosted=NO;
    NSMutableArray *arry=[self LoadAllCityWithPid:pid];
    if (arry && arry.count>0) {
        self.modelCityArry=arry;
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionChangeArea object:@"1"];
        isPosted=YES;
    }
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: KAddress_City_URL,pid ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    
                    NSMutableArray* arry=  [[NSMutableArray alloc]initWithArray: [dict objectForKey:@"msg"]] ;
                    if (arry && arry.count>0) {
                        arry=[[[XNDAreaModel alloc]init] arrayWithArray:arry];
                        [[XNDAreaModule instance] AddAreaWithArray:arry Completion:^(BOOL success, NSError *error) {
                            //调用 block做参数的方法 传入
                            [[XNDAreaModule instance] LoadAllCityWithPid:pid Completion:^(NSArray *messages, NSError *error) {
                                if (isPosted==NO) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionChangeArea object:@"1"];
                                }
                            
                            }];
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                              [self loadProvinceList:[((XNDAreaModel*)arry[0]).area_id intValue]];
                        });
                    }
                    
                }
            }
        }
        
        
    }];
    
}
#pragma mark - 获取区域列表
-(void)loadProvinceList:(int)pid{
    
    /**
     *  获取本地数据，并返回展示，
     *  获取网络数据，并保存到本地
     */
    BOOL isPosted=NO;
    NSMutableArray *arry=[self LoadAllProvinceWithPid:pid];
    if (arry && arry.count>0) {
        self.modelProvinceArry=arry;
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionChangeArea object:@"2"];
        isPosted=YES;
    }
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:KAddress_Province_URL,pid ] ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url ];
    request.timeoutInterval=KHTTPTimeoutInterval;
    [request setHTTPMethod:@"GET"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!connectionError) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (dict) {
                int status=[[dict objectForKey:@"status"] intValue];
                if (status==1) {
                    
                    NSMutableArray* arry=  [[NSMutableArray alloc]initWithArray: [dict objectForKey:@"msg"]] ;
                    if (arry && arry.count>0) {
                        arry=[[[XNDAreaModel alloc]init] arrayWithArray:arry];
                        [[XNDAreaModule instance] AddAreaWithArray:arry Completion:^(BOOL success, NSError *error) {
                            [[XNDAreaModule instance] LoadAllProvinceWithPid:pid Completion:^(NSArray *messages, NSError *error) {
                                if (isPosted==NO) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifictionChangeArea object:@"2"];
                                }
                                
                            }];
                        }];
                        
                    }
                    
                }
            }
        }
        
        
    }];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
@end
