//
//  FirstViewController.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var image : UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Logger.logI("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapButton(sender: UIButton) {
        let picker : UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        self.presentViewController(picker, animated: false, completion: nil)
        
        
    }
}

extension FirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        CRCheckAPI.sharedAPI().processImage(image, withCallback: { (result :String!, error :NSError!, success :Bool) -> Void in
            self.textView.text = result;
            Logger.logI("\(result)")
        });
    }
}

