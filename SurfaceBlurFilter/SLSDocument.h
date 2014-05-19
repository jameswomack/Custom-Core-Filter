#import <Cocoa/Cocoa.h>
#import <GPUImage/GPUImage.h>

@interface SLSDocument : NSDocument
{
  GPUImagePicture *inputPicture;
  GPUImageBilateralFilter *surfaceBlurFilter;
  GPUImageSharpenFilter *sharpenFilter;
  GPUImageFilterGroup *imageFilter;
}

@property(readwrite, weak) IBOutlet NSImageView *imageView;
@property(readwrite, nonatomic) CGFloat distanceNormalizationFactor;
@property(readwrite, nonatomic) CGFloat texelSpacingMultiplier;
@property(readwrite, nonatomic) CGFloat sharpening;

@end
