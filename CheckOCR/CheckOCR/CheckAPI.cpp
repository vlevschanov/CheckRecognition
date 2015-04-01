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
    
    CheckAPI::CheckAPI()
    {
         _tessAPI = new tesseract::TessBaseAPI();
    }
    
    CheckAPI::~CheckAPI()
    {
        FREE_PTR(_tessAPI);
    }
    
    bool CheckAPI::Init(const char* datapath, const char* language)
    {
        int result = _tessAPI->Init(datapath, language, tesseract::OEM_TESSERACT_ONLY);
        return result == 0;
    }
    
    void CheckAPI::SetImage(CheckOCR::CheckImage *image)
    {
        Pix *pix = image->getPix();
        _tessAPI->SetImage(pix);
    }
    
    CheckResult* CheckAPI::Recognize(ComponentType type)
    {
        if(_isRecognizing)
        {
            return new CheckResult(CHECK_OCR_ERROR, -1);
        }
        _isRecognizing = true;
        
        int resultCode = _tessAPI->Recognize(NULL);
        if(resultCode != 0)
        {
            CheckResult *result = new CheckResult(CHECK_OCR_TESSERACT_ERROR, resultCode);
            return result;
        }
        
        tesseract::PageIteratorLevel level = (tesseract::PageIteratorLevel)PageIteratorLevelFromComponentType(type);
        
        Boxa* boxes = _tessAPI->GetComponentImages(level, true, NULL, NULL);
#ifdef DEBUG
        printf("Found %d components for type %d \n", boxes->n, level);
#endif
        int count = boxes->n;
        
        std::vector<CheckResultComponent> components(count);
        
        for (int i = 0; i < count; i++)
        {
            BOX* box = boxaGetBox(boxes, i, L_CLONE);
            _tessAPI->SetRectangle(box->x, box->y, box->w, box->h);
            
            char *ocrResult = _tessAPI->GetUTF8Text();
            int conf = _tessAPI->MeanTextConf();
            
            CheckResultComponent component = CheckResultComponent(type, box, conf, ocrResult);
            components.at(i) = component;
            
            if(_perComponentCallback != nullptr && _callbackContext != nullptr)
            {
                (*_perComponentCallback)(_callbackContext, &component, i, count);
            }
            
            delete[] ocrResult;
        }
        
        CheckResult *result = new CheckResult(type, components);
        
        _isRecognizing = false;
        
        return result;
    }
    
    CheckResult* CheckAPI::Recognize(CheckResultComponentCallback *perComponentCallback, void *callbackContext, ComponentType type)
    {
        _perComponentCallback = perComponentCallback;
        _callbackContext = callbackContext;
        
        CheckResult *result = Recognize(type);
        
        _perComponentCallback = nullptr;
        _callbackContext = nullptr;
        
        return  result;
    }
}