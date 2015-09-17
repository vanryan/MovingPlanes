//
//  MovingPlanesAnimator.h
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/12.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

@import Foundation;

@class MovingPlane;

extern NSInteger const AnimatorFrameIntervalDefault;

@interface MovingPlanesAnimator : NSObject

- (instancetype)initWithFrameInterval:(NSInteger)frameInterval;
- (instancetype)init;

- (void)addPlane:(MovingPlane *)plane;
- (void)addPlanes:(NSSet *)planes;

- (void)removePlane:(MovingPlane *)planes;
- (void)removePlanes:(NSSet *)planes;
- (void)removeAllPlanes;

- (void)startAnimating;
- (void)stopAnimating;

@end
