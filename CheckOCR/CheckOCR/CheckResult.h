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
    
    class CheckResult {
    private:
        int _status;
        ComponentType _componentsType;
        std::vector<CheckResultComponent> _components;
        
    public:
        CheckResult(int status);
        CheckResult(int status, ComponentType componentsType, const std::vector<CheckResultComponent> components);
        ~CheckResult();
        
        int GetStatus();
        ComponentType getComponentsType();
        const std::vector<CheckResultComponent> GetComponents();
        
        bool IsSuccess();
    };    
}

#endif /* defined(__CheckOCR__CheckResult__) */
