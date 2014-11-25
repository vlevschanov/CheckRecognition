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

namespace CheckOCR {
    
    class CheckResult {
    private:
        const char* _result;
        
    public:
        CheckResult(const char* result);
        ~CheckResult();
        
        const char* GetResult();
    };    
}

#endif /* defined(__CheckOCR__CheckResult__) */
