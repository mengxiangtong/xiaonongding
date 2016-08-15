//
//  AMRatingControl.m
//  RatingControl
//


#import "AMRatingControl.h"


// Constants :
static const CGFloat kFontSize = 40;
static const NSInteger kStarWidthAndHeight = 40;

static const NSString *kDefaultEmptyChar = @"☆";
static const NSString *kDefaultSolidChar = @"★";


@interface AMRatingControl (Private)

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;


- (void)handleTouch:(UITouch *)touch;

@end


@implementation AMRatingControl


/**************************************************************************************************/
#pragma mark - Getters & Setters

@synthesize rating = _rating;
- (void)setRating:(NSInteger)rating
{
    _rating = (rating < 0) ? 0 : rating;
    _rating = (rating > _maxRating) ? _maxRating : rating;
    [self setNeedsDisplay];
}


/**************************************************************************************************/
#pragma mark - Birth & Death

- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:nil
                       solidImage:nil
                       emptyColor:nil
                       solidColor:nil
                     andMaxRating:maxRating];
}

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating
{
	return [self initWithLocation:location
                       emptyImage:emptyImageOrNil
                       solidImage:solidImageOrNil
                       emptyColor:nil
                       solidColor:nil
                     andMaxRating:maxRating];
}




- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating
{
    return [self initWithLocation:location
                       emptyImage:nil
                       solidImage:nil
                       emptyColor:emptyColor
                       solidColor:solidColor
                     andMaxRating:maxRating];
}

- (void)dealloc
{
	_emptyImage = nil,
	_solidImage = nil;
    _emptyColor = nil;
    _solidColor = nil;
}


/**************************************************************************************************/
#pragma mark - View Lifecycle

/**
 *再说明一下重绘，重绘操作仍然在drawRect方法中完成，但是苹果不建议直接调用drawRect方法，当然如果你强 直接调用此方法，当然是没有效果的。
  苹果要求我们调用UIView类中的setNeedsDisplay方法，则程序会自动调用drawRect方法进行重绘。（调用setNeedsDisplay会自动调用drawRect）
 
 在UIView中,重写drawRect: (CGRect) aRect方法,可以自己定义想要画的图案.且此方法一般情况下只会画一次.也就是说这个drawRect方法一般情况下只会被掉用一次. 当某些情况下想要手动重画这个View,只需要掉用[self setNeedsDisplay]方法即可.
 
 drawRect调是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量值).
 
 1.如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。
 2.该方法在调用sizeThatFits后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3.通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4.直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0.
 以上1,2推荐；而3,4不提倡
 1、若使用UIView绘图，只能在drawRect：方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate的ref并且不能用于画图。drawRect：方法不能手动显示调用，必须通过调用setNeedsDisplay 或者 setNeedsDisplayInRect ，让系统自动调该方法。
 2、若使用calayer绘图，只能在drawInContext: 中（类似鱼drawRect）绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedDisplay等间接调用以上方法。
 3、若要实时画图，不能使用gestureRecognizer，只能使用touchbegan等方法来掉用setNeedsDisplay实时刷新屏幕
 */

- (void)drawRect:(CGRect)rect
{
	CGPoint currPoint = CGPointZero;
	  
    NSLog(@"   星星  %lu ", (long)_rating  );
    
    //默认
    
	for (int i = 0; i < _rating; i++)
	{
		if (_solidImage)
        {
            [_solidImage drawAtPoint:currPoint];
        }
		else
        {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), _solidColor.CGColor);
            
           // [kDefaultSolidChar drawAtPoint:currPoint withFont:[UIFont boldSystemFontOfSize:kFontSize]];
            
            
            
            /*NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];
            
            NSDictionary *attrsDictionary =
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             font, NSFontAttributeName,
             [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
            使用 attrsDictionary 作为参数。
            请参阅：归因于字符串编程指南
            请参阅：标准属性*/
           // drawAtPoint:withAttributes
            
            UIFont *font = [UIFont systemFontOfSize: kFontSize];
             NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
             font, NSFontAttributeName,
             [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
            
            [kDefaultSolidChar drawAtPoint:currPoint withAttributes:attrsDictionary];
        }
			
		currPoint.x += kStarWidthAndHeight;
	}
	
     
     
	NSInteger remaining = _maxRating - _rating;
	
	for (int i = 0; i < remaining; i++)
	{
		if (_emptyImage)
        {
			[_emptyImage drawAtPoint:currPoint];
        }
		else
        {
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), _emptyColor.CGColor);
            //
            UIFont *font = [UIFont systemFontOfSize: kFontSize];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                             font, NSFontAttributeName,
                                             [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
            
            [kDefaultSolidChar drawAtPoint:currPoint withAttributes:attrsDictionary];
            
        }
		currPoint.x += kStarWidthAndHeight;
	}
    
    
    
    
    
    //////
  
    
    
    
}


/**************重写************************************************************************************/
#pragma mark - UIControl

// 开始跟踪 点击
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self handleTouch:touch];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self handleTouch:touch];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
}








/***************** 初始化  *********************************************************************************/
#pragma mark - Private Methods

- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating
{
    if (self = [self initWithFrame:CGRectMake(location.x,
                                              location.y,
                                              (maxRating * kStarWidthAndHeight) ,
                                              kStarWidthAndHeight  )])
	{
        
		_rating = 0;
		self.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = [UIColor cyanColor];
        
		self.opaque = NO;
		
		_emptyImage = emptyImageOrNil;
		_solidImage = solidImageOrNil;
        _emptyColor = emptyColor;
        _solidColor = solidColor;
        _maxRating = maxRating ;// 星星 个数
	}
	
    
 

    
    
	return self;
}


#pragma mark - 点击事件
- (void)handleTouch:(UITouch *)touch
{
    
        NSLog(@" ----  %@ ", touch);
    
    CGFloat width = self.frame.size.width;
	CGRect section = CGRectMake(0, 0, (width / _maxRating), self.frame.size.height);
	
	CGPoint touchLocation = [touch locationInView:self];
	
	if (touchLocation.x < 0)
	{
		if (_rating != 0)
		{
			_rating = 0;
			[self sendActionsForControlEvents:UIControlEventEditingChanged];
		}
	}
	else if (touchLocation.x > width)
	{
		if (_rating != _maxRating)
		{
			_rating = _maxRating;
			[self sendActionsForControlEvents:UIControlEventEditingChanged];
		}
	}
	else
	{   // 主要
		for (int i = 0 ; i < _maxRating ; i++)
		{
			if ((touchLocation.x > section.origin.x) && (touchLocation.x < (section.origin.x + section.size.width)))
			{
				if (_rating != (i+1))
				{
					_rating = i+1;
					[self sendActionsForControlEvents:UIControlEventEditingChanged];
				}
				break;
			}
			section.origin.x += section.size.width;
		}
	}
    
    //手动调用 重绘
	[self setNeedsDisplay];
}








@end
