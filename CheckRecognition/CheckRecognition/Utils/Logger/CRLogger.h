//
//  Logger.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 11/25/14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckRecognition_CRLogger_h
#define CheckRecognition_CRLogger_h

#import "CheckRecognition-Swift.h"

#define ILog(fmt, ...) [Logger logI:[NSString stringWithFormat:fmt, ##__VA_ARGS__] file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]
#define DLog(fmt, ...) [Logger logD:[NSString stringWithFormat:fmt, ##__VA_ARGS__] file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]
#define WLog(fmt, ...) [Logger logW:[NSString stringWithFormat:fmt, ##__VA_ARGS__] file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]
#define ELog(fmt, ...) [Logger logE:[NSString stringWithFormat:fmt, ##__VA_ARGS__] file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]

#endif
