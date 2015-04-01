//
//  CRCheckAPICommon.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 01.04.15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckRecognition_CRCheckAPICommon_h
#define CheckRecognition_CRCheckAPICommon_h

@class CheckResult;

typedef void (^CRRecognitionCallback)(CheckResult *result);
typedef void (^CRRecognitionProgressCallback)(CheckResult *result, int current, int total);

#endif
