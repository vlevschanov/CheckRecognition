//
//  ScanViewController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov 25.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

private extension BaseViewController.SegueID {
    static let PREVIEW_SEGUE = "previewSegue"
}

class ScanViewController: BaseViewController {
    
    @IBOutlet weak var cameraView: CameraView!
    
    var scanImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        cameraView.start()
    }
    
    override func viewDidDisappear(animated: Bool) {
        cameraView.stop()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case SegueID.PREVIEW_SEGUE:
            let vc = segue.destinationViewController as PreviewViewController
            vc.photoImage = scanImage
        default:
            break
        }
    }
    
    //MARK: - Actions
    
    @IBAction func didTapGalleryButton(sender: UIBarButtonItem) {
        var picker = UIImagePickerController();
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
}

extension ScanViewController : CameraViewDelegate {
    func cameraView(view: CameraView, didCapture image: UIImage?, error: NSError?) {
        scanImage = image
        if scanImage != nil {
            performSegueWithIdentifier(SegueID.PREVIEW_SEGUE, sender: self)
        }
    }
}

extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        scanImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if scanImage != nil {
            performSegueWithIdentifier(SegueID.PREVIEW_SEGUE, sender: self)
        }
    }
}
