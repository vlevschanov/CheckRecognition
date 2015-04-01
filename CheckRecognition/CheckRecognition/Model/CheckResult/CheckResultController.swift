//
//  CheckResultController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/5/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit

protocol CheckResultControllerDelegate {
    func didGeneratedCheckResultImage(resultController : CheckResultController, image: UIImage)
    func didUpdateRecognitionProgress(resultController : CheckResultController, currentProgress: Float);
}

class CheckResultController: NSObject {
    
    private let image : UIImage
    private var checkResult : CheckResult?
    private var interCheckResult : CheckResult?
    private var currentComponent : CheckResultComponent?
    private var isProcessing = false

    var delegate : CheckResultControllerDelegate
   
    init(image: UIImage, delegate: CheckResultControllerDelegate) {
        self.image = image
        self.delegate = delegate
        super.init()
    }
    
    func startImageProcessing(completion: () -> Void) {
        isProcessing = true;
        
        var recognitionCompletion = { [weak self] (result: CheckResult!) -> Void in
            if let strong = self {
                strong.isProcessing = false
                strong.checkResult = result;
                strong.generateResultImage(result)
                completion();
            }
        }
        
        var recognitionInProgress = { [weak self] (result: CheckResult!, current: Int32, total: Int32) -> Void in
            if let strong = self {
                strong.generateResultImage(result)
                strong.delegate.didUpdateRecognitionProgress(strong, currentProgress: Float(current) / Float(total))
            }
        }
        
        CRCheckAPI.sharedAPI().recognizeImage(self.image, withCallback: recognitionCompletion, progressCallback: recognitionInProgress);
    }
    
    private func generateResultImage(result: CheckResult) {
        let resultProcessor = CheckResultImageProcessor(image: self.image, ocrResult: result)
        resultProcessor.generateCheckResultImage { [weak self] (image) -> Void in
            if let strong = self {
                strong.delegate.didGeneratedCheckResultImage(strong, image: image)
            }
        }
    }
    
    // MARK: - Components interaction
    
    func moveToComponent(location: CGPoint) -> Bool {
        for component in self.checkResult!.components {
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
        for component in self.checkResult!.components {
            if component.selected {
                comps.append(component)
            }
        }
        return comps
    }
    
    func getSumOfSelectedComponents() -> NSNumber {
        var sum = NSDecimalNumber.zero()
        for component in selectedComponents() {
            if component.isDigit() {
                if let number = component.digitValue? {
                    sum = sum.decimalNumberByAdding(number)
                }
            }
        }
        return sum
    }
}
