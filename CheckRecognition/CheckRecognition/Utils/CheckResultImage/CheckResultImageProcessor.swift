//
//  CheckResultController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import Foundation

class CheckResultImageProcessor: NSObject {
    
    private let image : UIImage
    private let ocrResult : CRCheckResult

    
    init(image: UIImage, ocrResult: CRCheckResult) {
        
        self.image = image
        self.ocrResult = ocrResult
        
        super.init()
    }
    
    func generateCheckResultImage(completion: ((image : UIImage!) -> Void)!) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            let image = self.dynamicType.imageWithResults(self.image, result: self.ocrResult)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(image: image)
            })
        })
    }
    
    private class func imageWithResults(image: UIImage, result: CRCheckResult) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, true,  image.scale)
        
        image.drawInRect(CGRectMake(0.0, 0.0, image.size.width, image.size.height))
        
        let filterCharSet = NSCharacterSet.newlineCharacterSet()
        
        var count = 0
        
        for component in result.components as [CRCheckResultComponent]  {
            var text : NSString = ((component.text as NSString).componentsSeparatedByCharactersInSet(filterCharSet) as NSArray).componentsJoinedByString("")
            
            if text.length == 0 {
                continue
            }
            
            let rect = component.rect
            
            UIColor.whiteColor().colorWithAlphaComponent(0.7).setFill()
            CGContextFillRect(UIGraphicsGetCurrentContext(), component.rect)
            
            let font = fontForText(text, rect: rect)
            let textFontAttributes: [String: AnyObject] = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blueColor()]
            
            //Logger.debug(text)
            text.drawInRect(component.rect, withAttributes: textFontAttributes)
            
            count++
        }
        
        Logger.debug("\(count) components was drawn")
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return newImage
    }
    
    private class func fontForText(text :NSString, rect :CGRect) -> UIFont {
        let font = UIFont.systemFontOfSize(10.0)
        let size = text.sizeWithAttributes([NSFontAttributeName : font])
        let scale = scaleToAspectFit(size, dest: rect.size, padding: 0.0)

        return UIFont.systemFontOfSize(scale * font.pointSize)
    }
    
    private class func scaleToAspectFit(source: CGSize, dest: CGSize, padding: CGFloat) -> CGFloat {
        return fmin((dest.width - padding) / source.width, (dest.height - padding) / source.height)
    }
}
