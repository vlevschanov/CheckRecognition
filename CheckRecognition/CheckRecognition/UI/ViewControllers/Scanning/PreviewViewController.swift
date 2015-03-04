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
            self.photoImageFormattingView.image = self.photoImage
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case SegueID.RESULT_SEGUE:
            let vc = segue.destinationViewController as ResultViewController
            //vc.text = recognizedText
            vc.image = self.photoImageFormattingView.getFormattedImage()
        default:
            break
        }
    }
    
    @IBAction func scanButtonDidTap(sender: UIBarButtonItem) {
        performSegueWithIdentifier(SegueID.RESULT_SEGUE, sender: self)
    }
}
