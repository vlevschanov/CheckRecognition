//
//  CRCheckAPI.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CheckResult;

typedef void (^OCRRecognitionCallback)(CheckResult *result);

@interface CRCheckAPI : NSObject

+ (instancetype)sharedAPI;

- (void)recognizeImage:(UIImage *)image withCallback:(OCRRecognitionCallback)callback;
- (void)cancelCurrentRecognition;

@end
