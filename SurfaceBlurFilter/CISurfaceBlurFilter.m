//
//  CISurfaceBlurFilter.m
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Noble Gesture. All rights reserved.
//


#import "CISurfaceBlurFilter.h"
#import "NSImage+Filter.h"


#define FILTER_NAME @"CISurfaceBlur"
#define DISPLAY_NAME @"Surface Blur Filter"
#define FILTER_CATEGORIES @[kCICategoryStylize, kCICategoryBlur,kCICategoryStillImage]


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
  [self registerFilter];
}


+ (void)registerFilter
{
  id constructor = self.new;
  [CIFilter registerFilterName:FILTER_NAME
                   constructor:constructor
               classAttributes:@{kCIAttributeFilterDisplayName:DISPLAY_NAME,
                                 kCIAttributeFilterCategories:FILTER_CATEGORIES}];
  
  id filterTest = [CIFilter filterWithName:FILTER_NAME];
  NSAssert((filterTest != nil), @"%@ is nil", FILTER_NAME);
}


- (id)initWithCIImage:(CIImage *)CIImage; {
  if ((self = super.init)) {
    [self setValue:CIImage forKey:kCIInputImageKey];
    [self setDefaults];
  }
  return self;
}


- (void)setDefaults {
  [self setValue:@(6)  forKey:kCIDistanceNormalizationFactorKey];
  [self setValue:@(5) forKey:kCITexelSpacingMultiplierKey];
  [self setValue:@(.4) forKey:kCIInputSharpnessKey];
}


- (CIFilter *)filterWithName:(NSString *)filterName {
  return CISurfaceBlurFilter.new;
}


- (CIFilter *)filterWithName:(NSString *)filterName CIImage:(CIImage *)CIImage {
  return [CISurfaceBlurFilter.alloc initWithCIImage:CIImage];
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
  if(!filteredNSImage) {
    [self outputImage];
  }
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
