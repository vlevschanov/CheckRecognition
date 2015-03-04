//
//  CheckResultComponent.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 3/4/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#ifndef __CheckOCR__CheckResultComponent__
#define __CheckOCR__CheckResultComponent__

#include <stdio.h>
#include <string>

#include "CheckResultComponentType.h"

struct Box;

namespace CheckOCR {
    
    struct ComponentRect {
        int x;
        int y;
        int width;
        int height;
    };
    
    class CheckResultComponent {
    private:
        ComponentType _type;
        ComponentRect _rect;
        int _confidence;
        std::string _text;
        
    public:
        CheckResultComponent();
        CheckResultComponent(ComponentType type, const Box *box, int conf, const char* text);
        ~CheckResultComponent();
        
        ComponentType GetType();
        ComponentRect GetRect();
        int GetConfidence();
        std::string GetText();
    };
}

#endif /* defined(__CheckOCR__CheckResultComponent__) */
