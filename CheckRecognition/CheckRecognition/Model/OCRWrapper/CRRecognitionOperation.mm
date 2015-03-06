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
    CheckResult *_result;
    
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
    _result = nil;
    _ocrAPI = new CheckOCR::CheckAPI();
    BOOL result = _ocrAPI->Init(_dataPath.UTF8String, _language.UTF8String);
    NSAssert(result, @"Couldn't initialize OCR API with data path: %@ and labguage: %@", _dataPath, _language);
    
    if(self.isCancelled) return;
    
    _ocrImage = [_srcImage CR_checkImage];
    
    if(self.isCancelled) return;
    
    _ocrResult = _ocrAPI->Recognize(_ocrImage, CheckOCR::CT_WORD);
    if(!_ocrResult->IsSuccess()) {
        DLog(@"OCR has failed with status %d", _ocrResult->GetStatus());
        //TODO: think about error handling
        return;
    }
    
    if(self.isCancelled) return;
    
    const std::vector<CheckOCR::CheckResultComponent> components = _ocrResult->GetComponents();
    NSMutableArray *componentsArray = [NSMutableArray arrayWithCapacity:components.size()];
    
    for(std::vector<CheckOCR::CheckResultComponent>::const_iterator it = components.begin(); it != components.end(); ++it) {
        if(self.isCancelled) return;
        
        CheckOCR::CheckResultComponent component = *it;
        
        NSString *text = [NSString stringWithCString:component.GetText().c_str() encoding:NSUTF8StringEncoding];
        CheckOCR::ComponentRect compRect = component.GetRect();
        CGRect rect = CGRectMake(compRect.x, compRect.y, compRect.width, compRect.height);
        
        CheckResultComponent *comp = [[CheckResultComponent alloc] initWithText:text rect:rect confidence:component.GetConfidence()];
        [componentsArray addObject:comp];
    }
    
    _result = [[CheckResult alloc] initWithComponents:componentsArray];
    
    ILog(@"did recognize with result: %@", _result);
}

- (CheckResult *)result {
    return _result;
}

@end
