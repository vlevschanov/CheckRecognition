//
//  CheckImage.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef __CheckOCR__CheckImage__
#define __CheckOCR__CheckImage__

#include <stdio.h>
#include <stdint.h>

class Pix;

namespace CheckOCR {
    
    class CheckImage {
    private:
        Pix *_pix;
        
    public:
        CheckImage(const uint8_t *imageData, int width, int height, int bytes_per_pixel, int bytes_per_line);
        ~CheckImage();
        
        Pix* getPix();
    };
    
}

#endif /* defined(__CheckOCR__CheckImage__) */
