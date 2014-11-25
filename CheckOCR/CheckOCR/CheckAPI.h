//
//  CheckAPI.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckOCR_CheckAPI_h
#define CheckOCR_CheckAPI_h

namespace tesseract {
    class TessBaseAPI;
}

namespace CheckOCR {
    
    class CheckImage;
    class CheckResult;
    
    class CheckAPI {
    private:
        tesseract::TessBaseAPI *_tessAPI;
    
    public:
        CheckAPI();
        ~CheckAPI();
        
        bool init(const char* datapath, const char* language);
        bool deinit();
        
        CheckResult* recognize(CheckImage *image);
        CheckResult* recognize(const unsigned char* imagedata, int width, int height, int bytes_per_pixel, int bytes_per_line);
    };
}

#endif
