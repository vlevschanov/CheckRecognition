//
//  UIImage+CRFilters.m
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/4/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#import "UIImage+CRFilters.h"

@implementation UIImage (CRFilters)

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

@end
