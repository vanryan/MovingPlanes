//
//  MovePath.h
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#import "BSStructs.h"

@interface MovePath : NSObject

@property (nonatomic, readonly) NSArray *segments;

- (movePathSegment)popSegment;

- (BOOL)isEmpty;

- (void)addSegment:(movePathSegment)segment;
- (void)addSegments:(NSArray *)segments;

- (void)clearPath;

@end
