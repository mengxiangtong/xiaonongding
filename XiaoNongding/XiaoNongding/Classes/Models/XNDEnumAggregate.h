//
//  XNDEnumAggregate.h
//  XiaoNongding
//
//  Created by jion on 16/1/19.
//  Copyright © 2016年 Mxt. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  枚举区域等级/类型
 */
typedef NS_ENUM(SInt32, AreaType) {
    /**
     *  国家级
     */
    AreaTypeNone = 0,
    /**
     *  省级
     */
    AreaTypeArea = 1,
    /**
     *  市级
     */
    AreaTypeCity = 2,
    /**
     *  区县级
     */
    AreaTypeProvince = 3,
    /**
     *  商圈
     */
    AreaTypeCircle = 4,
    
};




@interface XNDEnumAggregate : NSObject

@end
