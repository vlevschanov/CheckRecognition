//
//  Logger.h
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 11/25/14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#ifndef CheckRecognition_Logger_h
#define CheckRecognition_Logger_h

#import "CheckRecognition-Swift.h"

#define ILog(fmt, ...) [Logger logI:fmt file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]
#define DLog(fmt, ...) [Logger logD:fmt file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]
#define WLog(fmt, ...) [Logger logW:fmt file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]
#define ELog(fmt, ...) [Logger logE:fmt file:[NSString stringWithFormat:@"%s", __FILE__] function:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] line:__LINE__]

#endif
