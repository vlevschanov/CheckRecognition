//
//  CameraView.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 23.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewDelegate {
    func cameraView(view: CameraView, didCapture image: UIImage?, error: NSError?)
}

class CameraView: MemoryObservableView {
    
    @IBOutlet private weak var cameraView: UIView!
    
    @IBInspectable var autoStart : Bool = false
    
    var delegate : CameraViewDelegate?
    
    private let camera = CameraCapture(sessionPresset: AVCaptureSessionPresetHigh)
    
    private var capturedImage : UIImage?
    
    //MARK: - Override
    
    override func didReceiveMemoryWarning() {
        capturedImage = nil
    }
    
    override func didMoveToSuperview() {
        if (self.superview == nil) {
            stop();
        }
        else if autoStart {
            start();
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        camera?.updatePreview(cameraView.bounds)
    }
    
    //MARK: - Public
    
    func start() {
        if let cam = self.camera {
            if(cam.isRunning) {
                return;
            }
            cam.start(onLayer: cameraView.layer, moveToBack: true)
        }
    }
    
    func stop() {
        if let cam = self.camera {
            if(!cam.isRunning) {
                return;
            }
            cam.stop()
        }
    }
    
    //MARK: - Actions
    
    @IBAction func cameraButtonDidTap(sender: UIButton) {
        if (camera?.isRunning != nil) {
            camera?.capturePhoto({ (capturedImage: UIImage?, error: NSError?) -> () in
                if let delegate = self.delegate {
                    delegate.cameraView(self, didCapture: capturedImage, error: error)
                }
            })
        }
    }
}
