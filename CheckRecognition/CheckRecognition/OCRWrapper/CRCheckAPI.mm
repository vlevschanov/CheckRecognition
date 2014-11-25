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
        
        NSLog(@"%s", result->GetResult());
        self.callback([NSString stringWithUTF8String:result->GetResult()], nil, YES);
    });
}

+ (void)setupEnvironment {
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *documentsPath = [kCRDataPath CR_pathAtDocumentDirectory];
//    
//    if (![fm fileExistsAtPath:documentsPath]) {
//        [fm createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:NULL];
//    }
//    
//    NSString *bundleDataPath = [kCRDataPath CR_bundleResourcePath];
//    
//    NSLog(@"%@ -> %@", bundleDataPath, documentsPath);
//    
//    NSError *error = nil;
//    
//    if(![fm fileExistsAtPath:bundleDataPath]) {
//        [fm copyItemAtPath:documentsPath toPath:bundleDataPath error:&error];
//        
//        if(error) {
//            NSLog(@"%@", error);
//        }
//    }
//    
//    NSArray *fList = [fm contentsOfDirectoryAtPath:bundleDataPath error:&error];
//    if(!error) {
//        for(NSString *s in fList) {
//            NSString *newFilePath = [documentsPath stringByAppendingPathComponent:s];
//            NSString *oldFilePath = [bundleDataPath stringByAppendingPathComponent:s];
//            
//            if (![fm fileExistsAtPath:newFilePath]) {
//                NSLog(@"copying: %@", oldFilePath);
//                [fm copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
//                if(!error) {
//                    NSLog(@"success");
//                }
//                else {
//                    NSLog(@"%@", error);
//                }
//            }
//            else {
//                NSLog(@"already exists: %@", newFilePath);
//            }
//        }
//    }
//    else {
//        NSLog(@"%@", error);
//    }
//    
//    setenv("TESSDATA_PREFIX", [[[NSString CR_documentsDirectoryPath] stringByAppendingString:@"/"] UTF8String], 1);
    NSString *datapath = [NSString stringWithFormat:@"%@/", [NSString stringWithString:[[NSBundle mainBundle] bundlePath]]];
    setenv("TESSDATA_PREFIX", datapath.UTF8String, 1);
}

@end
