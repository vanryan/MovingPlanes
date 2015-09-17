//
//  MovePath.m
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

#import "MovePath.h"
#import "NSValue+MovePathSegment.h"

@interface MovePath()

@property (nonatomic, strong) NSMutableArray *mutableSegments;

@end

@implementation MovePath

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableSegments = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isEmpty {
    return (self.mutableSegments.count == 0);
}

- (movePathSegment)popSegment { //Pop out the first movePathSegment
    if ([self isEmpty]) {
        return movePathSegmentNull;
    }
    
    movePathSegment segment = [self.mutableSegments.firstObject movePathSegmentValue];
    [self.mutableSegments removeObjectAtIndex:0];
    
    return segment;
}

- (void)addSegment:(movePathSegment)segment {
    [self.mutableSegments addObject:[NSValue valueWithMovePathSegment:segment]];
}

- (void)addSegments:(NSArray *)segments {
    [self.mutableSegments addObjectsFromArray:segments];
}

- (void)clearPath { // Delete all the movePathSegments
    [self.mutableSegments removeAllObjects];
}


@end
