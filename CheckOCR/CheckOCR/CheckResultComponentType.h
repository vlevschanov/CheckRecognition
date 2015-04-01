//
//  CheckResultComponentType.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 3/4/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckOCR_CheckResultComponentType_h
#define CheckOCR_CheckResultComponentType_h

namespace CheckOCR
{
    enum ComponentType : unsigned int
    {
        CT_BLOCK,     // Block of text/image/separator line.
        CT_PARAGRAPH, // Paragraph within a block.
        CT_TEXTLINE,  // Line within a paragraph.
        CT_WORD,      // Word within a textline.
        CT_SYMBOL     // Single symbol.
    };
    
    ComponentType ComponentTypeFromIteratorLevel(unsigned int level);
    unsigned int PageIteratorLevelFromComponentType(ComponentType type);
}

#endif
