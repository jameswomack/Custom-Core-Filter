//
//  NSImage+FIlter.m
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Sunset Lake Software LLC. All rights reserved.
//

#import "NSImage+FIlter.h"

@implementation NSImage (FIlter)
- (CIImage *)CIImage; {
  return [CIImage imageWithCGImage:self.CGImage];
}

- (CGImageRef)CGImage; {
  NSGraphicsContext *context = NSGraphicsContext.currentContext;
  CGRect rect = (CGRect){.size=self.size};
  CGImageRef ref = [self CGImageForProposedRect:&rect context:context hints:NULL];
  return ref;
}

- (CGFloat)scale; {
  return 1.f;
}

+ (NSImage *)imageWithCGImage:(CGImageRef)ref {
  NSImage *image = [[NSImage alloc] initWithCGImage:ref size:CGSizeMake(CGImageGetWidth(ref), CGImageGetHeight(ref))];
  return image;
}

@end
