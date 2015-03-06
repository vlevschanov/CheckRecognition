//
//  CheckResultComponent.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/6/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit

class CheckResultComponent: NSObject {
    
    private struct Static {
        static let nonDigitSet = NSCharacterSet(charactersInString: "0123456789. ").invertedSet
//        static let numberFormatter = Static.setupNumberFormatter()
//        
//        private static func setupNumberFormatter() -> NSNumberFormatter {
//            return NSNumberFormatter()
//        }
    }
    
    let confidence: Int
    let text: NSString
    let rect: CGRect
    
    var selected : Bool = false
    
    var digitValue : NSDecimalNumber? {
        get {
            let str = getCleanText().stringByReplacingOccurrencesOfString(" ", withString: "")
            return NSDecimalNumber(string: str)
            //return Static.numberFormatter.numberFromString(str)
        }
    }
    
    private var cleanText : NSString?
    
    init(text: NSString, rect: CGRect, confidence: Int) {
        self.text = text
        self.rect = rect
        self.confidence = confidence
        super.init()
    }
    
    func getCleanText() -> NSString {
        if cleanText? == nil {
            cleanText = ((self.text as NSString).componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as NSArray).componentsJoinedByString("")
        }
        return cleanText!
    }
    
    func isDigit() -> Bool {
        return getCleanText().rangeOfCharacterFromSet(Static.nonDigitSet).location == NSNotFound
    }
}
