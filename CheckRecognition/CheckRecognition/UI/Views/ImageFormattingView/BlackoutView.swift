//
//  BlackoutView.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/3/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//
//

import UIKit

class BlackoutView: UIView {

    var blackoutColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
    
    var clippingPath : UIBezierPath? {
        didSet {
            if clippingPath? != nil {
                self.setNeedsDisplay()
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        
        blackoutColor.setFill()
        UIRectFill(rect)
        
        if let path = clippingPath {
            UIColor.clearColor().setFill()
            path.fillWithBlendMode(kCGBlendModeClear, alpha: 1.0)
        }
    }
}
