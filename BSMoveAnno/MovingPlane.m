//
//  MovingPlane.m
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

#import "MovingPlane.h"
#import "MovePath.h"

static double interpolate(double from, double to, NSTimeInterval time) {
    return (to - from) * time + from;
}

static CLLocationDegrees interpolateDegrees(CLLocationDegrees from, CLLocationDegrees to, NSTimeInterval time) {
    return interpolate(from, to, time);
}

static CLLocationCoordinate2D interpolateCoordinate(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval time) {
    return CLLocationCoordinate2DMake(interpolateDegrees(from.latitude, to.latitude, time),
                                      interpolateDegrees(from.longitude, to.longitude, time));
}

@interface MovingPlane()

@property (nonatomic, assign, readwrite) movePathSegment currentSegment;
@property (nonatomic, assign, readwrite) float angle;

@end

@implementation MovingPlane{
    CFTimeInterval _lastStep;
    NSTimeInterval _timeOffset;
}

@synthesize coordinate,title,subtitle;

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentSegment = movePathSegmentNull;
    }
    return self;
}

- (void)moveStep {
    if (![self isMoving]) {
        _lastStep = CACurrentMediaTime();
        
        if (movePathSegmentIsNull(_currentSegment)) {
            _currentSegment = [self.movePath popSegment];
        }
        
        if (!movePathSegmentIsNull(_currentSegment)) {
            self.moving = YES;
            [self updateAngle];
        }
    }
    
    if (movePathSegmentIsNull(_currentSegment)) {
        if (self.moving) {
            self.moving = NO;
        }
        _timeOffset = 0;
        return;
    }
    
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - _lastStep;
    _lastStep = thisStep;
    _timeOffset = MIN(_timeOffset + stepDuration, _currentSegment.duration);
    NSTimeInterval time = _timeOffset / _currentSegment.duration;
    
    self.coordinate = interpolateCoordinate(_currentSegment.from, _currentSegment.to, time);
    
    if (_timeOffset >= _currentSegment.duration) {
        _currentSegment = [self.movePath popSegment];
        _timeOffset = 0;
        
        BOOL isCurrentSegmentNull = movePathSegmentIsNull(_currentSegment);
        if (isCurrentSegmentNull && self.moving) {
            self.moving = NO;
        }
        
        if (!isCurrentSegmentNull) {
            [self updateAngle];
        }
    }
}

- (void)updateAngle {
    self.angle = movePathSegmentGetAngle(_currentSegment);
}

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if(self){
        self.title =newTitle;
        self.coordinate=location;
    }
    return self;
}

-(MKAnnotationView *)planeAnnoView
{
    MKAnnotationView *annoView =[[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MovingPlane"];
    
    annoView.enabled=YES;
    annoView.canShowCallout=YES;
    
    // Resize the plane img
    CGSize planeImgSize=CGSizeMake(21, 21);
    UIImage *planeImage = [self OriginImage:[UIImage imageNamed:@"plane.png"] scaleToSize:planeImgSize];
    
    annoView.image=planeImage;
    annoView.leftCalloutAccessoryView =[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annoView;
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
