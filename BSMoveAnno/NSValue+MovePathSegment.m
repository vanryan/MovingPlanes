//
//  NSValue+MovePathSegment.m
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

#import "NSValue+MovePathSegment.h"

@implementation NSValue (MovePathSegment)

+ (NSValue *)valueWithMovePathSegment:(movePathSegment)segment {
    return [NSValue valueWithBytes:&segment objCType:@encode(movePathSegment)];
}

- (movePathSegment)movePathSegmentValue {
    movePathSegment segment;
    [self getValue:&segment];
    return segment;
}

@end
