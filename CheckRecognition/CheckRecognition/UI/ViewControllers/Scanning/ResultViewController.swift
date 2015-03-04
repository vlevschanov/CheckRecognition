//
//  ResultViewController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 30.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

class ResultViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage?
    var text : String? {
        didSet {
            if text? == nil || text!.isEmpty {
                text = "No results"
            }
            self.textView.text = text
            if self.isAppeared && self.textView.hidden {
                self.textView.hidden = false
                self.textView.alpha = 0.0
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.textView.alpha = 1.0
                    self.imageView.alpha = 0.0
                }, completion: { (Bool) -> Void in
                    self.imageView.hidden = true
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageView.image = image
    }
    
    @IBAction func didTappedScanButton(sender: UIBarButtonItem) {
        CRCheckAPI.sharedAPI().recognizeImage(self.image!, withCallback: { [weak self] (result: CRCheckResult!) -> Void in
            if let strong = self {
                if result.components.count > 0 {
                    let component = result.components[0] as CRCheckResultComponent
                    strong.text = component.text
                }
                else {
                    strong.text = nil
                }
            }
        })
    }
}
