//
//  CRRecognitionOperation.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 25.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CRCheckResult;

@interface CRRecognitionOperation : NSOperation

@property (nonatomic, readonly) CRCheckResult *result;

- (instancetype)initWithImage:(UIImage *)image dataPath:(NSString *)dataPath andLanguage:(NSString *)language;

@end