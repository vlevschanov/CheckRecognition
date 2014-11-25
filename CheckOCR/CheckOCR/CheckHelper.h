//
//  CheckHelper.h
//  CheckOCR
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckOCR_CheckHelper_h
#define CheckOCR_CheckHelper_h

#define FREE_PTR(PTR) do { if(PTR != nullptr) { delete PTR; PTR = nullptr; } } while(0);

#endif
