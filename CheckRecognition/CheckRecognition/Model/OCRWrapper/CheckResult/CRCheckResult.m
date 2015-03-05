//
//  CRCheckResult.m
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#import "CRCheckResult.h"

@implementation CRCheckResult

- (instancetype)initWithComponents:(NSArray *)components {
    if(self = [super init]) {
        _components = components;
    }
    return self;
}

@end
