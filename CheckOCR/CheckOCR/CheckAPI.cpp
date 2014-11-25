//
//  CheckOCR.cpp
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#include "CheckAPI.h"

#include <stdio.h>
#include <assert.h>

#include "baseapi.h"
#include "allheaders.h"

#include "CheckHelper.h"
#include "CheckImage.h"
#include "CheckResult.h"

namespace CheckOCR {
    
    CheckAPI::CheckAPI() {
         _tessAPI = new tesseract::TessBaseAPI();
    }
    
    CheckAPI::~CheckAPI() {
        FREE_PTR(_tessAPI);
    }
    
    bool CheckAPI::init(const char* datapath, const char* language) {
        int result = _tessAPI->Init(datapath, language, tesseract::OEM_TESSERACT_ONLY);
        return result == 0;
    }
    
    CheckResult* CheckAPI::recognize(CheckImage *image) {
        
        Pix *pix = image->getPix();
        _tessAPI->SetImage(pix);
        //tessAPI->Recognize(NULL);
        
        const char* text = _tessAPI->GetUTF8Text();
        CheckResult *result = new CheckResult(text);
        
        return result;
    }
    
    CheckResult* CheckAPI::recognize(const unsigned char* imagedata, int width, int height, int bytes_per_pixel, int bytes_per_line) {
        _tessAPI->SetImage(imagedata, width, height, bytes_per_pixel, bytes_per_line);
        
        const char* text = _tessAPI->GetUTF8Text();
        CheckResult *result = new CheckResult(text);
        
        return result;
    }
    
}