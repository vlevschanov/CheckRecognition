//
//  NSString+CRFilePath.m
//  CheckRecognition
//
//  Created by Admin on 24.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

#import "NSString+CRFilePath.h"

@implementation NSString (CRFilePath)

- (NSString *)CR_bundleResourcePath {
    if (self.length) {
        NSString* fname = [self lastPathComponent];
        return [[NSBundle mainBundle] pathForResource:[fname stringByDeletingPathExtension]
                                               ofType:[fname pathExtension]
                                          inDirectory:[self stringByDeletingLastPathComponent]];
    }
    return nil;
}

- (NSString *)CR_pathAtDocumentDirectory {
    if (self.length) {
        return [[self.class CR_documentsDirectoryPath] stringByAppendingPathComponent:self];
    }
    return nil;
}

+ (NSString *)CR_documentsDirectoryPath {
    static NSString *_documentsDir = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        assert(path.count);
        _documentsDir = path[0];
    });
    return _documentsDir;
}

@end
