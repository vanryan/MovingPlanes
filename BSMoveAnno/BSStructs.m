//
//  BSStructs.m
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

#import "BSStructs.h"

movePathSegment const movePathSegmentNull = { {0, 0}, {0, 0}, 0 };

BOOL movePathSegmentIsNull(movePathSegment segment) {
    return (segment.from.latitude == 0) && (segment.from.longitude == 0)
            && (segment.to.latitude == 0) && (segment.to.longitude == 0)
            && (segment.duration == 0);
}

movePathSegment movePathSegmentMake(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval duration) {
    movePathSegment segment;
    segment.from = from;
    segment.to = to;
    segment.duration = duration;
    return segment;
}

float movePathSegmentGetAngle(movePathSegment segment) {
    return atan2(segment.to.latitude - segment.from.latitude, segment.to.longitude - segment.from.longitude);
}