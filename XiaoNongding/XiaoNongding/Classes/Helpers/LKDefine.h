//
//  LKDefine.h
//  LanKe(Businesses)
//
//  Created by admin on 15/10/26.
//  Copyright © 2015年 WanHao. All rights reserved.
//

#ifndef LKDefine_h
#define LKDefine_h


//图片质量
typedef enum{
    
    AUTO_QUAILTY = 0,
    HEIGHT_QUAILTY,
    LOW_QUAILTY
    
}ImageQuailty;


#pragma mark -
#pragma mark 网络畅通测试地址
#define	kNetworkTestAddress						@"http://www.baidu.com"

//下拉刷新
#define kOrderBaseUrlStr(status)    [NSString stringWithFormat:@"http://g.24so.com/index.php?app=seller_soubi&act=index&user_id=%@&status=%@&token=%@",[kAPPALL.userInfo objectForKey:@"userid"] ,status, [kAPPALL.userInfo objectForKey:@"token"] ]
//上拉加载
#define kOrderMoreUrlStr(status, id)    [NSString stringWithFormat:@"http://g.24so.com/index.php?app=seller_soubi&act=index&user_id=%@&status=%@&token=%@&id=%@",[kAPPALL.userInfo objectForKey:@"userid"], status, [kAPPALL.userInfo objectForKey:@"token"], id ]


//
#define kOrderDetailUrlStr  [NSString stringWithFormat:@"http://g.24so.com/index.php?app=seller_soubi&act=get_order_info&orderid=%@", [_dic objectForKey:@"id"]]


//我的
#define kTitleCell_H       (kDeviceWidth*5/16)
#define kInfoCell_H        (kDeviceWidth*3/20 )
#define kGrayBg_239Color    [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1  ]
#define kGrayBg_219Color    [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1  ]


#define kTextColor  [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1  ]

#define kTopTabRedColor  [UIColor colorWithHexString:@"ff9500"]

#define kTopTabBlackColor  [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100/255.0 alpha:1.0]

#define kButtonTintColor  [UIColor colorWithRed:245/255.0 green:58/255.0  blue:24/255.0  alpha:1 ]


#import "MJRefresh.h"




#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

/**
 * SN_EXTERN user this as extern
 */
#if !defined(SN_EXTERN)
#  if defined(__cplusplus)
#   define SN_EXTERN extern "C"
#  else
#   define SN_EXTERN extern
#  endif
#endif

/**
 * SN_INLINE user this as static inline
 */
#if !defined(SN_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define SN_INLINE static inline
# elif defined(__cplusplus)
#  define SN_INLINE static inline
# elif defined(__GNUC__)
#  define SN_INLINE static __inline__
# else
#  define SN_INLINE static
# endif
#endif


#if !__has_feature(objc_arc)

/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
CFRelease(__REF); \
__REF = nil;\
}\
}

//view安全释放
#undef TTVIEW_RELEASE_SAFELY
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
CFRelease(__REF);\
__REF = nil;\
}\
}

//释放定时器
#undef TT_INVALIDATE_TIMER
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
[__TIMER release];\
__TIMER = nil;\
}

#else

/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}

//view安全释放
#define TTVIEW_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF))\
{\
[__REF removeFromSuperview];\
__REF = nil;\
}\
}

//释放定时器
#define TT_INVALIDATE_TIMER(__TIMER) \
{\
[__TIMER invalidate];\
__TIMER = nil;\
}

#endif

//国际化
#undef L
#define L(key) \
[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)










#endif /* LKDefine_h */
