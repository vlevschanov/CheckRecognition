//
//  NSString+CRFilePath.h
//  CheckRecognition
//
//  Created by Admin on 24.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CRFilePath)

- (NSString *)CR_bundleResourcePath;
- (NSString *)CR_pathAtDocumentDirectory;

+ (NSString *)CR_documentsDirectoryPath;

@end
