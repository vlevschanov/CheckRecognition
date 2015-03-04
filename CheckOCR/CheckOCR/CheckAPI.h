//
//  CheckAPI.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckOCR_CheckAPI_h
#define CheckOCR_CheckAPI_h

#include "CheckResultComponentType.h"

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
        
        bool Init(const char* datapath, const char* language);
        
        void SetImage(CheckImage *image);
        
        CheckResult* Recognize(ComponentType type = CT_BLOCK);
        CheckResult* Recognize(CheckImage *image, ComponentType type = CT_BLOCK);
    };
}

#endif
