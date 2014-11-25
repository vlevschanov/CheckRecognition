//
//  CheckImage.cpp
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#include "CheckImage.h"

#include <memory.h>

#include "thresholder.h"
#include "environ.h"
#include "pix.h"
#include "allheaders.h"

#include "CheckHelper.h"

namespace CheckOCR {
    
    CheckImage::CheckImage(const uint8_t *imageData, int width, int height, int bytes_per_pixel, int bytes_per_line) {
        
        tesseract::ImageThresholder thresholder = tesseract::ImageThresholder();
        thresholder.SetImage(imageData, width, height, bytes_per_pixel, bytes_per_line);
        
        _pix = thresholder.GetPixRect();
    }
    
    CheckImage::~CheckImage() {
        if(_pix != nullptr) {
            pixDestroy(&_pix);
            _pix = nullptr;
        }
    }
    
    Pix* CheckImage::getPix() {
        return _pix;
    }
    
}