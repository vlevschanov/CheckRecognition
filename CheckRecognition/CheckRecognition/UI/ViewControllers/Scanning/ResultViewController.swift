//
//  ResultViewController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 30.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

class ResultViewController: BaseViewController {
    
    @IBOutlet weak var imageView: ImageFormattingView!
    
    var image : UIImage?
    var resultController : CheckResultController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageView.delegate = self
        self.navigationItem.title = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.imageView.image = image
    }
    
    @IBAction func didTappedScanButton(sender: UIBarButtonItem) {
        let progress = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        progress.labelText = "Scanning..."
        progress.detailsLabelText = "Please wait"
        CRCheckAPI.sharedAPI().recognizeImage(self.image!, withCallback: { [weak self] (result: CheckResult!) -> Void in
            if let strong = self {
                if result.components.count > 0 {
                    strong.handleResult(result)
                }
                progress.hide(true)
            }
        })
    }
    
    private func handleResult(result: CheckResult) {
        self.resultController = CheckResultController(checkResult: result)
        let resultProcessor = CheckResultImageProcessor(image: self.image!, ocrResult: result)
        resultProcessor.generateCheckResultImage { [weak self] (image) -> Void in
            if let strong = self {
                strong.imageView.image = image
            }
        }
    }
}

extension ResultViewController : ImageFormattingViewDelegate {
    
    func formattingViewDidTapImage(view: ImageFormattingView, point: CGPoint) {
        if self.resultController!.moveToComponent(point) {
            self.resultController!.changeCurrentComponentSelection()
            let resultProcessor = CheckResultImageProcessor(image: self.image!, ocrResult: self.resultController!.checkResult)
            resultProcessor.generateCheckResultImage { [weak self] (image) -> Void in
                if let strong = self {
                    strong.imageView.image = image
                    if let sum = strong.resultController?.getSumOfSelectedComponents() {
                        strong.navigationItem.title! = sum.stringValue
                    }
                    else {
                        strong.navigationItem.title! = ""
                    }
                    
                }
            }
        }
    }
}
