//
//  CheckResultComponentType.cpp
//  CheckOCR
//
//  Created by Viktor Levshchanov on 3/4/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#include "CheckResultComponentType.h"
#include "publictypes.h"

namespace CheckOCR
{
    ComponentType ComponentTypeFromIteratorLevel(unsigned int level)
    {
        switch (level)
        {
            case tesseract::RIL_PARA: return CT_PARAGRAPH;
            case tesseract::RIL_TEXTLINE: return CT_TEXTLINE;
            case tesseract::RIL_WORD: return CT_WORD;
            case tesseract::RIL_SYMBOL: return CT_SYMBOL;
                
            default: return CT_BLOCK;
        }
    }
    
    unsigned int PageIteratorLevelFromComponentType(ComponentType type)
    {
        switch (type)
        {
            case CT_PARAGRAPH: return tesseract::RIL_PARA;
            case CT_TEXTLINE: return tesseract::RIL_TEXTLINE;
            case CT_WORD: return tesseract::RIL_WORD;
            case CT_SYMBOL: return tesseract::RIL_SYMBOL;
                
            default: return tesseract::RIL_BLOCK;
        }
    }

}