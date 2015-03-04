//
//  CRCheckResultComponent.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CRCheckResultComponent : NSObject

@property (nonatomic, readonly) NSInteger confidence;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) CGRect rect;

- (instancetype)initWithText:(NSString *)text rect:(CGRect)rect confidence:(NSInteger)confidence;

@end
