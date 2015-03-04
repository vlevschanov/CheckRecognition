//
//  PreviewViewController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 30.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

private extension BaseViewController.SegueID {
    static let RESULT_SEGUE = "resultSegue"
}

class PreviewViewController: BaseViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImageFormattingView: ImageFormattingView!
    
    var photoImage : UIImage?
    var recognizedText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        var loaded = self.isLoaded
        super.viewDidAppear(animated)
        
        if !loaded {
            photoImageFormattingView.image = photoImage
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case SegueID.RESULT_SEGUE:
            let vc = segue.destinationViewController as ResultViewController
            //vc.text = recognizedText
            vc.image = photoImageFormattingView.getFormattedImage()
        default:
            break
        }
    }
    
    @IBAction func scanButtonDidTap(sender: UIBarButtonItem) {
        performSegueWithIdentifier(SegueID.RESULT_SEGUE, sender: self)
//        loadingIndicator.hidden = false
//        CRCheckAPI.sharedAPI().recognizeImage(photoImage!, withCallback: { [weak self] (text: String!, error: NSError!, succes: Bool) -> Void in
//            if let strong = self {
//                strong.loadingIndicator.hidden = true
//                strong.recognizedText = text!
//                strong.performSegueWithIdentifier(SegueID.RESULT_SEGUE, sender: strong)
//            }
//        })
    }
}
