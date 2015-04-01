//
//  CheckResult.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/6/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit

class CheckResult: NSObject {
   
    let components: [CheckResultComponent]
    
    init(components: [AnyObject]) {
        self.components = components as [CheckResultComponent] //TODO: check if this line is safe
        super.init()
    }
}

class MutableCheckResult: NSObject {
    var components: [CheckResultComponent]
    
    override init() {
        components = [CheckResultComponent]()
        super.init()
    }
    
    func addComponent(component: CheckResultComponent) {
        components.append(component)
    }
    
    func result() -> CheckResult {
        return CheckResult(components: components)
    }
}