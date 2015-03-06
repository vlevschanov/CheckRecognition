//
//  CheckResultController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit

class CheckResultController: NSObject {
    
    let checkResult : CheckResult
    private var currentComponent : CheckResultComponent?
   
    init(checkResult: CheckResult) {
        self.checkResult = checkResult
        
        super.init()
    }
    
    func moveToComponent(location: CGPoint) -> Bool {
        for component in self.checkResult.components {
            if CGRectContainsPoint(component.rect, location) {
                self.currentComponent = component
                return true
            }
        }
        return false
    }
    
    func changeCurrentComponentSelection() {
        if let current = self.currentComponent {
            current.selected = !current.selected
        }
    }
    
    func selectedComponents() -> [CheckResultComponent] {
        var comps: [CheckResultComponent] = Array()
        for component in self.checkResult.components {
            if component.selected {
                comps.append(component)
            }
        }
        return comps
    }
    
    func getSumOfSelectedComponents() -> NSNumber {
        var sum = NSDecimalNumber.zero()
        for component in selectedComponents() {
            if let number = component.digitValue {
                sum = sum.decimalNumberByAdding(number)
            }
        }
        return sum
    }
}
