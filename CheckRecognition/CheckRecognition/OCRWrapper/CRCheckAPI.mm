//
//  CRCheckAPI.m
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import "CRCheckAPI.h"
#include <CheckOCR/CheckOCR.h>

#import "NSString+CRFilePath.h"
#import "UIImage+CRCheckImage.h"

#import "Logger.h"

static CRCheckAPI*_sharedInstance = nil;
static NSString * const kCRDataPath = @"tessdata";

@interface CRCheckAPI () {
    CheckOCR::CheckAPI *_ocrAPI;
    CheckOCR::CheckImage *_ocrImage;
}

@property (nonatomic, copy) OCRRecognitionCallback callback;

@end

@implementation CRCheckAPI

+ (instancetype)sharedAPI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupEnvironment];
        _sharedInstance = [CRCheckAPI new];
#if DEBUG
        DLog(@"");
#endif
    });
    return _sharedInstance;
}

- (instancetype)init {
    NSAssert(_sharedInstance == nil, @"Only one instance of OCRAPI is allowed");
    if(self = [super init]) {
        _ocrAPI = new CheckOCR::CheckAPI();
        BOOL result = _ocrAPI->init(kCRDataPath.UTF8String, @"eng".UTF8String);
        NSAssert(result, @"Couldn't initialize OCR API");
        if(!result) {
            return nil;
        }
    }
    return self;
}

- (void)processImage:(UIImage *)image withCallback:(OCRRecognitionCallback)callback {
    NSParameterAssert(image && callback);
    self.callback = callback;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _ocrImage = [image CR_CheckImage];
        CheckOCR::CheckResult *result = _ocrAPI->recognize(_ocrImage);
        
        NSString *resultString = [NSString stringWithUTF8String:result->GetResult()];
        DLog(@"%@", resultString);
        
        delete _ocrImage;
        delete result;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.callback(resultString, nil, YES);
        });
    });
}

+ (void)setupEnvironment {
    NSString *datapath = [NSString stringWithFormat:@"%@/", [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]];
    setenv("TESSDATA_PREFIX", datapath.UTF8String, 1);
}

@end
