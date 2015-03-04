//
//  UIImage+CRCheckImage.h
//  CheckRecognition
//
//  Created by Viktor Levshchanovon 24.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import <UIKit/UIKit.h>

namespace CheckOCR {
    class CheckImage;
}

@interface UIImage (CRCheckImage)

- (CheckOCR::CheckImage *)CR_checkImage;

@end
