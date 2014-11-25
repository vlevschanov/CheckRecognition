//
//  CheckResult.cpp
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#include "CheckResult.h"

namespace CheckOCR {
    
    CheckResult::CheckResult(const char* result) {
        _result = result;
    }
    
    CheckResult::~CheckResult() {
        delete _result;
    }
    const char* CheckResult::GetResult() {
        return _result;
    }
    
}