//
//  CameraView.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

class CameraView: UIView {
    
    let camera : CameraCapture

    required init(coder aDecoder: NSCoder) {
        camera = CameraCapture()!
        super.init(coder: aDecoder)
    }
    
}
