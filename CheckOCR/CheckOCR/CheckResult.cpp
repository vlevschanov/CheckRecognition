//
//  CheckResult.cpp
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#include "CheckResult.h"
#include "CheckResultComponent.h"

namespace CheckOCR {
    
    CheckResult::CheckResult(CheckResultStatus status, int errorCode) : _status(status), _errorCode(errorCode)
    {
    };
    
    CheckResult::CheckResult(ComponentType componentsType, const std::vector<CheckResultComponent> components) :
    _status(CHECK_OCR_SUCCESS), _componentsType(componentsType), _components(components)
    {
    };
    
    CheckResult::~CheckResult() { }
    
    CheckResultStatus CheckResult::GetStatus()
    {
        return _status;
    }
    
    int CheckResult::GetErrorCode()
    {
        return _errorCode;
    }
    
    ComponentType CheckResult::GetComponentsType()
    {
        return _componentsType;
    }
    
    const std::vector<CheckResultComponent> CheckResult::GetComponents()
    {
        return _components;
    }
    
    bool CheckResult::IsSuccess()
    {
        return _status == CHECK_OCR_SUCCESS && _errorCode == 0;
    }
    
}