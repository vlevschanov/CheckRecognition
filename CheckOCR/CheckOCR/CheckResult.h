//
//  CheckResult.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef __CheckOCR__CheckResult__
#define __CheckOCR__CheckResult__

#include <stdio.h>
#include <vector>

#include "CheckResultComponentType.h"

namespace CheckOCR {
    class CheckResultComponent;
    
    enum CheckResultStatus : int {
        CHECK_OCR_SUCCESS = 0,
        CHECK_OCR_TESSERACT_ERROR,
        CHECK_OCR_ERROR
    };
    
    class CheckResult
    {
    private:
        ComponentType _componentsType;
        CheckResultStatus _status;
        int _errorCode;
        
        std::vector<CheckResultComponent> _components;
        
    public:
        CheckResult(CheckResultStatus status, int errorCode);
        CheckResult(ComponentType componentsType, const std::vector<CheckResultComponent> components);
        ~CheckResult();
        
        ComponentType GetComponentsType();
        CheckResultStatus GetStatus();
        int GetErrorCode();
        const std::vector<CheckResultComponent> GetComponents();
        
        bool IsSuccess();
    };    
}

#endif /* defined(__CheckOCR__CheckResult__) */
