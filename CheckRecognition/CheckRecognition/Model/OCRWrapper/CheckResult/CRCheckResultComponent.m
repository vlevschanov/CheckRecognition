//
//  CRCheckResultComponent.m
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#import "CRCheckResultComponent.h"

@implementation CRCheckResultComponent

- (instancetype)initWithText:(NSString *)text rect:(CGRect)rect confidence:(NSInteger)confidence {
    if(self = [super init]) {
        _text = text;
        _rect = rect;
        _confidence = confidence;
    }
    return self;
}

@end
