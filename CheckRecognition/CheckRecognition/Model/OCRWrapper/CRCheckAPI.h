//
//  CRCheckAPI.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CRCheckAPICommon.h"

@interface CRCheckAPI : NSObject

+ (instancetype)sharedAPI;

- (void)recognizeImage:(UIImage *)image withCallback:(CRRecognitionCallback)callback progressCallback:(CRRecognitionProgressCallback)progressCallback;
- (void)cancelCurrentRecognition;

@end
