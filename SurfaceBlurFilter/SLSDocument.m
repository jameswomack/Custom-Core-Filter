#import "SLSDocument.h"
#import "CISurfaceBlurFilter.h"
#import "NSImage+FIlter.h"

@implementation SLSDocument
{
  CISurfaceBlurFilter *surfaceBlur;
}

@synthesize imageView = _imageView;
@synthesize distanceNormalizationFactor = _distanceNormalizationFactor;
@synthesize texelSpacingMultiplier = _texelSpacingMultiplier;
@synthesize sharpening = _sharpening;

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"SLSDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
  [super windowControllerDidLoadNib:aController];
  
  [CISurfaceBlurFilter initialize];

  dispatch_async(dispatch_get_main_queue(), ^{
    if(!surfaceBlur) {
      surfaceBlur = CISurfaceBlurFilter.new;
      [surfaceBlur setValue:[self.imageView.image CIImage] forKey:kCIInputImageKey];
    }
    
    [surfaceBlur setValue:@(_distanceNormalizationFactor)  forKey:kCIDistanceNormalizationFactorKey];
    [surfaceBlur setValue:@(_texelSpacingMultiplier) forKey:kCITexelSpacingMultiplierKey];
    [surfaceBlur setValue:@(_sharpening) forKey:kCIInputSharpnessKey];
    
    [surfaceBlur outputImage];
    self.imageView.image = [surfaceBlur outputNSImage];
  });
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{

  
  return YES;
}

- (void)processImage {
  dispatch_async(dispatch_get_main_queue(), ^{
    if(!surfaceBlur) {
      surfaceBlur = CISurfaceBlurFilter.new;
      [surfaceBlur setValue:[self.imageView.image CIImage] forKey:kCIInputImageKey];
    }
    
    [surfaceBlur setValue:@(_distanceNormalizationFactor)  forKey:kCIDistanceNormalizationFactorKey];
    [surfaceBlur setValue:@(_texelSpacingMultiplier) forKey:kCITexelSpacingMultiplierKey];
    [surfaceBlur setValue:@(_sharpening) forKey:kCIInputSharpnessKey];
    
    [surfaceBlur outputImage];
    self.imageView.image = [surfaceBlur outputNSImage];
  });
}

#pragma mark -
#pragma mark Accessors

- (void)setDistanceNormalizationFactor:(CGFloat)newValue;
{
    _distanceNormalizationFactor = newValue;
    
    [surfaceBlurFilter setDistanceNormalizationFactor:_distanceNormalizationFactor];
    [self processImage];
}

- (void)setTexelSpacingMultiplier:(CGFloat)newValue;
{
  _texelSpacingMultiplier = newValue;
  
  [surfaceBlurFilter setTexelSpacingMultiplier:_texelSpacingMultiplier];
  [self processImage];
}

- (void)setSharpening:(CGFloat)newValue;
{
  _sharpening = newValue;
  
  [sharpenFilter setSharpness:_sharpening];
  [self processImage];
}


@end
