//
//  BSStructs.h
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//
// Lib for Structs &

#ifndef BSMoveAnno_BSStructs_h
#define BSMoveAnno_BSStructs_h


#endif

@import Foundation;
@import CoreLocation;

/*
 * movePathSegment: segment of a plane's path represented by a line (2 points - "from" and "to") and duration (in seconds).
 * Planes will move along the line with a certain speed decided by the duration.
 */
typedef struct {
    CLLocationCoordinate2D from;
    CLLocationCoordinate2D to;
    NSTimeInterval duration;
} movePathSegment;

/*
 * Null constant
 */
extern movePathSegment const movePathSegmentNull;

/*
 * segment methods
 */

extern BOOL movePathSegmentIsNull(movePathSegment segment);

extern movePathSegment movePathSegmentMake(CLLocationCoordinate2D from, CLLocationCoordinate2D to, NSTimeInterval duration);

/*
 * Get the angle between the line and 0-degree (starting from the right)
 */
float movePathSegmentGetAngle(movePathSegment segment);
