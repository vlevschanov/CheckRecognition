//
//  CRCheckAPI.m
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import "CRCheckAPI.h"

#import "CRRecognitionOperation.h"
#import "NSString+CRFilePath.h"
#import "UIImage+CRCheckImage.h"

#import "CRLogger.h"

static CRCheckAPI*_sharedInstance = nil;
static NSString * const kCRDataPath = @"tessdata";

@interface CRCheckAPI ()

@property (nonatomic) NSOperationQueue *recognitionQueue;
@property (nonatomic) CRRecognitionOperation *currentOperation;
@property (nonatomic, copy) OCRRecognitionCallback callback;

@end

@implementation CRCheckAPI

+ (void)setupEnvironment {
    NSString *datapath = [NSString stringWithFormat:@"%@/", [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]];
    setenv("TESSDATA_PREFIX", datapath.UTF8String, 1);
}

+ (void)initialize {
    [self setupEnvironment];
}

+ (instancetype)sharedAPI {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [CRCheckAPI new];
    });
    return _sharedInstance;
}

- (instancetype)init {
    NSAssert(_sharedInstance == nil, @"Only one instance of OCRAPI is allowed");
    if(self = [super init]) {
        _recognitionQueue = [[NSOperationQueue alloc] init];
        _recognitionQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)setCurrentOperation:(CRRecognitionOperation *)currentOperation {
    _currentOperation.completionBlock = nil;
    _currentOperation = currentOperation;
    if(_currentOperation) {
        __weak CRCheckAPI *weak = self;
        _currentOperation.completionBlock = ^{
            [weak performSelectorOnMainThread:@selector(didFinishRecognition) withObject:nil waitUntilDone:NO];
        };
    }
}

- (void)recognizeImage:(UIImage *)image withCallback:(OCRRecognitionCallback)callback {
    NSParameterAssert(image && callback);
    self.callback = callback;
    
    self.currentOperation = [[CRRecognitionOperation alloc] initWithImage:image dataPath:kCRDataPath andLanguage:@"eng+ukr+rus"];
    [self.recognitionQueue addOperation:self.currentOperation];
}

- (void)cancelCurrentRecognition {
    [self.currentOperation cancel];
    self.currentOperation = nil;
}

- (void)didFinishRecognition {
    if(self.callback) {
        self.callback(self.currentOperation.result, nil, YES);
        self.callback = nil;
        self.currentOperation = nil;
    }
}

@end
