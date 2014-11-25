//
//  CRCheckAPI.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^OCRRecognitionCallback)(NSString *text, NSError *error, BOOL success);

@interface CRCheckAPI : NSObject

+ (instancetype)sharedAPI;

- (void)processImage:(UIImage *)image withCallback:(OCRRecognitionCallback)callback;

@end
