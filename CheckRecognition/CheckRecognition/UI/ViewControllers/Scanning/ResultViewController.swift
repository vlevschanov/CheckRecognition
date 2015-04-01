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
    
    var resultController : CheckResultController?
    var hudView : MBProgressHUD?
    
    var image : UIImage? {
        didSet {
            if let img = image {
                self.resultController = CheckResultController(image: img, delegate: self)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageView.delegate = self
        self.imageView.resetOnImageChange = false
        self.navigationItem.title = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.imageView.image = image
    }
    
    @IBAction func didTappedScanButton(sender: UIBarButtonItem) {
        hudView = MBProgressHUD.showHUDAddedTo(self.view.window, animated: true)
        hudView?.labelText = "Scanning..."
        hudView?.detailsLabelText = "Please wait"
        
        resultController?.startImageProcessing({ [weak self] () -> Void in
            if let strong = self {
                strong.hudView?.hide(true)
            }
        })
    }
}

extension ResultViewController : CheckResultControllerDelegate {
    
    func didGeneratedCheckResultImage(resultController : CheckResultController, image: UIImage) {
        imageView.image = image;
    }
    
    func didUpdateRecognitionProgress(resultController: CheckResultController, currentProgress: Float) {
        hudView?.detailsLabelText = String(format: "%.0f %%", currentProgress * 100)
    }
}

extension ResultViewController : ImageFormattingViewDelegate {
    
    func formattingViewDidTapImage(view: ImageFormattingView, point: CGPoint) {
//        if self.resultController!.moveToComponent(point) {
//            self.resultController!.changeCurrentComponentSelection()
//            let resultProcessor = CheckResultImageProcessor(image: self.image!, ocrResult: self.resultController!.checkResult)
//            resultProcessor.generateCheckResultImage { [weak self] (image) -> Void in
//                if let strong = self {
//                    strong.imageView.image = image
//                    if let sum = strong.resultController?.getSumOfSelectedComponents() {
//                        strong.navigationItem.title! = sum.stringValue
//                    }
//                    else {
//                        strong.navigationItem.title! = ""
//                    }
//                    
//                }
//            }
//        }
    }
}
