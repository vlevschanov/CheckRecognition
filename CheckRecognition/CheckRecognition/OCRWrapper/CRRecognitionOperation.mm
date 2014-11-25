//
//  CRRecognitionOperation.m
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 25.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import "CRRecognitionOperation.h"
#import "CRLogger.h"

#import "UIImage+CRCheckImage.h"

#include <CheckOCR/CheckOCR.h>

@interface CRRecognitionOperation() {
    UIImage *_srcImage;
    NSString *_dataPath;
    NSString *_language;
    NSString *_result;
    
    CheckOCR::CheckAPI *_ocrAPI;
    CheckOCR::CheckImage *_ocrImage;
    CheckOCR::CheckResult *_ocrResult;
}

@end

@implementation CRRecognitionOperation

- (void)dealloc {
    delete _ocrAPI;
    delete _ocrImage;
    delete _ocrResult;
}

- (instancetype)initWithImage:(UIImage *)image dataPath:(NSString *)dataPath andLanguage:(NSString *)language {
    if(self = [super init]) {
        _srcImage = image;
        _dataPath = dataPath;
        _language = language;
    }
    return self;
}

- (void)main {
    _ocrAPI = new CheckOCR::CheckAPI();
    BOOL result = _ocrAPI->init(_dataPath.UTF8String, _language.UTF8String);
    NSAssert(result, @"Couldn't initialize OCR API with data path: %@ and labguage: %@", _dataPath, _language);
    
    if(self.isCancelled) return;
    
    _ocrImage = [_srcImage CR_CheckImage];
    
    if(self.isCancelled) return;
    
    _ocrResult = _ocrAPI->recognize(_ocrImage);
    
    if(self.isCancelled) return;
    
    _result = [NSString stringWithUTF8String:_ocrResult->GetResult()];
    ILog(@"did recognize text: %@", _result);
}

- (NSString *)result {
    return _result;
}

@end
