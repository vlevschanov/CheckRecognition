//
//  UIImage+CRCheckImage.m
//  CheckRecognition
//
//  Created by Admin on 24.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import "UIImage+CRCheckImage.h"
#include <CheckOCR/CheckImage.h>

@implementation UIImage (CRCheckImage)

- (CheckOCR::CheckImage *)CR_CheckImage {
    
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
