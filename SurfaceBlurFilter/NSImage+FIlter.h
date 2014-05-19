//
//  NSImage+Filter.h
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Noble Gesture. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Filter)
- (CIImage *)CIImage;
- (CGImageRef)CGImage;
- (CGFloat)scale;
+ (NSImage *)imageWithCGImage:(CGImageRef)ref;
@end
