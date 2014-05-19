//
//  CISurfaceBlurFilter.h
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Noble Gesture. All rights reserved.
//

#import <QuartzCore/CoreImage.h>
#import <GPUImage/GPUImage.h>

NSString* const kCIDistanceNormalizationFactorKey;
NSString* const kCITexelSpacingMultiplierKey;
NSString* const kCISurfaceBlurFilter;

@interface CISurfaceBlurFilter : CIFilter <CIFilterConstructor>

// CIFilter/CIFilterConstructor API compatibility
+ (void)registerFilter;

// Output
- (NSImage *)outputNSImage;
- (CIImage *)outputImage;

// Registration
- (id)initWithCIImage:(CIImage *)CIImage;
- (CIFilter *)filterWithName:(NSString *)filterName CIImage:(CIImage *)CIImage;

// Appearance properties
@property (nonatomic, strong) CIImage  *inputImage;
@property (nonatomic, strong) NSNumber *inputSharpness;
@property (nonatomic, strong) NSNumber *distanceNormalizationFactor;
@property (nonatomic, strong) NSNumber *texelSpacingMultiplier;

@end
