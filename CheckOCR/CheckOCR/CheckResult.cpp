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
    
    CheckResult::CheckResult(int status) : _status(status) {};
    
    CheckResult::CheckResult(int status, ComponentType componentsType, const std::vector<CheckResultComponent> components) :
    _status(status), _componentsType(componentsType), _components(components) {};
    
    CheckResult::~CheckResult() { }
    
    int CheckResult::GetStatus() {
        return _status;
    }
    ComponentType CheckResult::getComponentsType() {
        return _componentsType;
    }
    
    const std::vector<CheckResultComponent> CheckResult::GetComponents() {
        return _components;
    }
    
    bool CheckResult::IsSuccess() {
        return _status == 0;
    }
    
}