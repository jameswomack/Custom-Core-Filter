//
//  CISurfaceBlurFilter.m
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Sunset Lake Software LLC. All rights reserved.
//


#import "CISurfaceBlurFilter.h"
#import "NSImage+FIlter.h"

NSString* const kCIDistanceNormalizationFactorKey = @"distanceNormalizationFactor";
NSString* const kCITexelSpacingMultiplierKey = @"texelSpacingMultiplier";
NSString* const kCISurfaceBlurFilter = @"CISurfaceBlur";


@implementation CISurfaceBlurFilter
{
  GPUImagePicture *inputPicture;
  GPUImageBilateralFilter *surfaceBlurFilter;
  GPUImageSharpenFilter *sharpenFilter;
  GPUImageFilterGroup *imageFilter;
  NSImage *filteredNSImage;
  NSImage *nsImage;
}


+ (void)initialize
{
  id constructor = self.new;
  [CIFilter registerFilterName:@"CISurfaceBlur"
                   constructor:constructor
               classAttributes:@{kCIAttributeFilterDisplayName: @"Surface Blur Filter",
                                 kCIAttributeFilterCategories:  @[kCICategoryStylize, kCICategoryBlur,
                                                                  kCICategoryStillImage]}];
}

- (CIFilter *)filterWithName:(NSString *)filterName {
  CISurfaceBlurFilter *filter = CISurfaceBlurFilter.new;
  return filter;
}


- (CIImage *)outputImage {
  CIImage *ciImage = [self valueForKey:kCIInputImageKey];
  
  nsImage = [self nsImageFromCiImage:ciImage];
  
  inputPicture = [GPUImagePicture.alloc initWithImage:nsImage];
  
  imageFilter = GPUImageFilterGroup.new;
  
  sharpenFilter = GPUImageSharpenFilter.new;
  sharpenFilter.sharpness = 1.f;
  [imageFilter addFilter:sharpenFilter];
  
  surfaceBlurFilter = GPUImageBilateralFilter.new;
  [imageFilter addTarget:surfaceBlurFilter];
  [imageFilter addFilter:surfaceBlurFilter];
  
  [imageFilter setInitialFilters:@[surfaceBlurFilter]];
  [imageFilter setTerminalFilter:sharpenFilter];
  
  [surfaceBlurFilter addTarget:sharpenFilter];
  
  [inputPicture addTarget:imageFilter];
  
  [sharpenFilter setSharpness:[[self valueForKey:kCIInputSharpnessKey] floatValue]];
  [surfaceBlurFilter setTexelSpacingMultiplier:[[self valueForKey:kCITexelSpacingMultiplierKey] floatValue]];
  [surfaceBlurFilter setDistanceNormalizationFactor:[[self valueForKey:kCIDistanceNormalizationFactorKey] floatValue]];
  
  filteredNSImage = [imageFilter imageByFilteringImage:nsImage];
  
  return [self ciImageFromNSImage:filteredNSImage];
}


- (NSImage *)outputNSImage {
  return filteredNSImage;
}


- (NSImage *)nsImageFromCiImage:(CIImage *)ciImage {
  NSCIImageRep *ciImageRep = [NSCIImageRep imageRepWithCIImage:ciImage];
  NSImage *_nsImage = [NSImage.alloc initWithSize:ciImageRep.size];
  [_nsImage addRepresentation:ciImageRep];
  return _nsImage;
}


- (CIImage *)ciImageFromNSImage:(NSImage *)_nsImage {
  return [_nsImage CIImage];
}


@end
