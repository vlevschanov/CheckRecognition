//
//  UIImage+CRCheckImage.m
//  CheckRecognition
//
//  Created by Viktor Levshchanovon 24.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import "UIImage+CRCheckImage.h"
#include <CheckOCR/CheckImage.h>

@implementation UIImage (CRCheckImage)

- (UIImage *)CR_blackAndWhite
{
    CIImage *cii = [CIImage imageWithCGImage:self.CGImage];
    
    CIFilter *blackAndWhiteFilter = [CIFilter filterWithName:@"CIColorControls"
                                    keysAndValues:kCIInputImageKey,      cii,
                                                  kCIInputBrightnessKey, @(0.0),
                                                  kCIInputContrastKey,   @(1.1),
                                                  kCIInputSaturationKey, @(0.0),
                                                  nil];
    CIImage *blackAndWhiteImage = blackAndWhiteFilter.outputImage;
    
    CIFilter *exposureAdjustingFilter = [CIFilter filterWithName:@"CIExposureAdjust"
                                                   keysAndValues:kCIInputImageKey, blackAndWhiteImage,
                                                                 kCIInputEVKey, @(0.7),
                                                                 nil];
    CIImage *output = exposureAdjustingFilter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgi = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgi];
    
    CGImageRelease(cgi);
    
    return newImage;
}

- (CheckOCR::CheckImage *)CR_checkImage {
    
    int width  = self.size.width;
    int height = self.size.height;
    
    CGImage *cgi = self.CGImage;

    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(cgi));
    const UInt8 *pixels = CFDataGetBytePtr(imageData);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cgi);
    size_t bitsPerPixel     = CGImageGetBitsPerPixel(cgi);
    size_t bytesPerRow      = CGImageGetBytesPerRow(cgi);
    
    CheckOCR::CheckImage *checkImage = new CheckOCR::CheckImage(pixels, width, height, (int)(bitsPerPixel/bitsPerComponent), (int)bytesPerRow);
    
    CFRelease(imageData);
    
    return checkImage;
}

@end
