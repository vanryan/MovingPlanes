//
//  NSValue+MovePathSegment.h
//  BSMoveAnno
//
//  Created by VanRyan on 15/5/11.
//  Copyright (c) 2015年 VRyan. All rights reserved.
//

/*
 * To implement a category from NSValue, we need to declare and define two methods:
 * valueWith(CategoryName), (CategoryName)Value
 */

@import Foundation;

#import "BSStructs.h"

@interface NSValue (movePathSegment)

+ (NSValue *)valueWithMovePathSegment:(movePathSegment)segment;

- (movePathSegment)movePathSegmentValue;

@end
