//
//  MovingPlane.h
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

@import Foundation;
@import MapKit;

#import "BSStructs.h"

@class MovePath;

@interface MovingPlane : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *subtitle;


@property (nonatomic, strong) MovePath *movePath;

@property (nonatomic, assign, readonly) movePathSegment currentSegment;

@property (nonatomic, assign, getter = isMoving) BOOL moving;

@property (nonatomic, assign, readonly) float angle;

- (void)moveStep;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;

-(MKAnnotationView *)planeAnnoView;

-(UIImage*)  OriginImage:(UIImage *)image   scaleToSize:(CGSize)size;

@end
