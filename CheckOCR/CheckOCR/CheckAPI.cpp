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
#include "CheckResultComponent.h"

namespace CheckOCR {
    
    CheckAPI::CheckAPI() {
         _tessAPI = new tesseract::TessBaseAPI();
    }
    
    CheckAPI::~CheckAPI() {
        FREE_PTR(_tessAPI);
    }
    
    bool CheckAPI::Init(const char* datapath, const char* language) {
        int result = _tessAPI->Init(datapath, language, tesseract::OEM_TESSERACT_ONLY);
        return result == 0;
    }
    
    void CheckAPI::SetImage(CheckOCR::CheckImage *image) {
        Pix *pix = image->getPix();
        _tessAPI->SetImage(pix);
    }
    
    CheckResult* CheckAPI::Recognize(CheckImage *image, ComponentType type) {
        SetImage(image);
        return Recognize(type);
    }
    
    CheckResult* CheckAPI::Recognize(ComponentType type) {
        
        int status = _tessAPI->Recognize(NULL);
        if(status != 0) {
            CheckResult *result = new CheckResult(status);
            return result;
        }
        
        tesseract::PageIteratorLevel level = (tesseract::PageIteratorLevel)PageIteratorLevelFromComponentType(type);
        
        Boxa* boxes = _tessAPI->GetComponentImages(level, true, NULL, NULL);
#ifdef DEBUG
        printf("Found %d components for type %d \n", boxes->n, level);
#endif
        
        std::vector<CheckResultComponent> components(boxes->n);
        
        for (int i = 0; i < boxes->n; i++) {
            BOX* box = boxaGetBox(boxes, i, L_CLONE);
            _tessAPI->SetRectangle(box->x, box->y, box->w, box->h);
            
            char *ocrResult = _tessAPI->GetUTF8Text();
            int conf = _tessAPI->MeanTextConf();
            
            components.at(i) = CheckResultComponent(type, box, conf, ocrResult);
            
            delete[] ocrResult;
        }
        CheckResult *result = new CheckResult(0, type, components);
        return result;
    }
}