//
//  CISurfaceBlurFilter.h
//  SurfaceBlurFilter
//
//  Created by James Womack on 5/15/14.
//  Copyright (c) 2014 Sunset Lake Software LLC. All rights reserved.
//

#import <QuartzCore/CoreImage.h>
#import <GPUImage/GPUImage.h>

NSString* const kCIDistanceNormalizationFactorKey;
NSString* const kCITexelSpacingMultiplierKey;
NSString* const kCISurfaceBlurFilter;

@interface CISurfaceBlurFilter : CIFilter <CIFilterConstructor>
- (NSImage *)outputNSImage;
- (CIImage *)outputImage;
@property (nonatomic, strong) CIImage  *inputImage;
@property (nonatomic, strong) NSNumber *inputSharpness;
@property (nonatomic, strong) NSNumber *distanceNormalizationFactor;
@property (nonatomic, strong) NSNumber *texelSpacingMultiplier;
@end
