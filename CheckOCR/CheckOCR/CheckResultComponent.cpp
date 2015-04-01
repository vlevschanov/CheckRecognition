//
//  CheckResultComponent.cpp
//  CheckOCR
//
//  Created by Viktor Levshchanov on 3/4/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#include "CheckResultComponent.h"
#include "baseapi.h"
#include "allheaders.h"

namespace CheckOCR
{
    static inline ComponentRect CreateComponentRect(int x, int y, int width, int height)
    {
        ComponentRect rect =
        {
            .x = x,
            .y = y,
            .width = width,
            .height = height
        };
        return rect;
    }
    
    CheckResultComponent::CheckResultComponent() { }
        
    CheckResultComponent::CheckResultComponent(ComponentType type, const Box *box, int conf, const char* text)
    {
        _type = type;
        _rect = CreateComponentRect(box->x, box->y, box->w, box->h);
        _confidence = conf;
        _text = std::string(text);
    }
    
    CheckResultComponent::~CheckResultComponent() { }
    
    ComponentRect CheckResultComponent::GetRect()
    {
        return _rect;
    }
    
    ComponentType CheckResultComponent::GetType()
    {
        return _type;
    }
    
    int CheckResultComponent::GetConfidence()
    {
        return _confidence;
    }
    
    std::string CheckResultComponent::GetText()
    {
        return _text;
    }
}