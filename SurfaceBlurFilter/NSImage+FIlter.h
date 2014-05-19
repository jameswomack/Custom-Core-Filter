//
//  NSImage+FIlter.h
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Sunset Lake Software LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (FIlter)
- (CIImage *)CIImage;
- (CGImageRef)CGImage;
- (CGFloat)scale;
+ (NSImage *)imageWithCGImage:(CGImageRef)ref;
@end
