//
//  CRCheckResult.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRCheckResult : NSObject

@property (nonatomic, readonly) NSArray *components;

- (instancetype)initWithComponents:(NSArray *)components;

@end
