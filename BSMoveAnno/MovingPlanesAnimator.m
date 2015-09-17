//
//  MovingPlanesAnimator.m
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/12.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

@import QuartzCore;

#import "MovingPlanesAnimator.h"

#import "MovingPlane.h"

NSInteger const AnimatorFrameIntervalDefault = 2;

@interface MovingPlanesAnimator()

@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation MovingPlanesAnimator{
    NSInteger _frameInterval;
    NSMutableSet *_planes;
    NSMutableSet *_planesToRemove;
    NSMutableSet *_planesToAdd;
}

- (instancetype)initWithFrameInterval:(NSInteger)frameInterval {
    self = [super init];
    if (self) {
        _planes = [NSMutableSet set];
        _frameInterval = frameInterval;
        _planesToRemove = [NSMutableSet set];
        _planesToAdd = [NSMutableSet set];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrameInterval:AnimatorFrameIntervalDefault];
}

- (void)addPlane:(MovingPlane *)plane {
    NSParameterAssert(plane);
    [_planesToAdd addObject:plane];
}

- (void)addPlanes:(NSSet *)planes {
    NSParameterAssert(planes);
    [_planesToAdd unionSet:planes];
}

- (void)removePlane:(MovingPlane *)plane {
    NSParameterAssert(plane);
    [_planesToRemove addObject:plane];
}

- (void)removePlanes:(NSSet *)plane {
    NSParameterAssert(plane);
    [_planesToRemove unionSet:plane];
}

- (void)removeAllPlanes {
    [_planesToRemove unionSet:_planes];
}

- (void)startAnimating {
    [self.timer invalidate];
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(doStep)];
    self.timer.frameInterval = _frameInterval;
    
    NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];
    [self.timer addToRunLoop:mainRunLoop forMode:NSDefaultRunLoopMode];
    [self.timer addToRunLoop:mainRunLoop forMode:UITrackingRunLoopMode];
}

- (void)stopAnimating {
    [self.timer invalidate];
    self.timer = nil;
    [self setAllPlanesStopped];
}

- (void)setAllPlanesStopped {
    for (MovingPlane *plane in _planes) {
        [plane setMoving:NO];
    }
}

- (void)doStep {
    [_planes minusSet:_planesToRemove];
    [_planes unionSet:_planesToAdd];
    [_planesToAdd removeAllObjects];
    [_planesToRemove removeAllObjects];
    [self step];
}

- (void)step {
    for (MovingPlane *plane in _planes) {
        [plane moveStep];
    }
}

@end
