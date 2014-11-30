//
//  CRCameraCapture.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 22.11.14.
//  Copyright (c) 2014 Viktor Levshchanov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCapture {
    
    var isRunning : Bool {
        return captureSession.running
    }
    
    private let captureSession = AVCaptureSession()
    private let captureOutput  = AVCaptureStillImageOutput()
    
    private var captureDevice  : AVCaptureDevice?
    private var sessionPresset : String?
    private var previewLayer   : AVCaptureVideoPreviewLayer?
    
    init?(sessionPresset: String, cameraPosition: AVCaptureDevicePosition) {
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo);
        for device in devices {
            let captureDevice = device as AVCaptureDevice
            if captureDevice.position == cameraPosition {
                self.captureDevice = captureDevice
            }
        }
        if(self.captureDevice == nil) {
            self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        }
        if(self.captureDevice == nil) {
            return nil
        }
        
        self.sessionPresset = sessionPresset
        
        if(!configSession()) {
            return nil
        }
    }
    
    convenience init?() {
        self.init(sessionPresset: AVCaptureSessionPreset640x480, cameraPosition: .Back)
    }
    
    convenience init?(sessionPresset: String) {
        self.init(sessionPresset: sessionPresset, cameraPosition: .Back)
    }
    
    //MARK: - Private
    
    private func configSession() -> Bool {
        captureSession.beginConfiguration()
        var error : NSError? = nil
        let captureInput : AVCaptureDeviceInput = AVCaptureDeviceInput(device: captureDevice, error: &error)
        
        if captureSession.canAddInput(captureInput) {
            captureSession.addInput(captureInput)
        }
        else {
            assert(false, "Cannot add capture input")
            return false
        }
        
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        else {
            assert(false, "Cannot add capture output")
            return false
        }
        
        if let presset = sessionPresset {
            if captureSession.canSetSessionPreset(presset) {
                captureSession.sessionPreset = presset
            }
            else {
                assert(false, "Cannot set session presset: \(presset)")
                return false
            }
        }
        
        captureSession.commitConfiguration()
        
        return true
    }
    
    //MARK: - Public
    
    func start(onLayer layer: CALayer, moveToBack: Bool = false) {
        if captureSession.running {
            self.stop()
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = layer.bounds
        
        if(moveToBack) {
            layer.insertSublayer(previewLayer, atIndex: 0)
        }
        else {
            layer.addSublayer(previewLayer)
        }
        
        captureSession.startRunning()
    }
    
    func stop() {
        if captureSession.running {
            captureSession.stopRunning()
            previewLayer?.removeFromSuperlayer()
        }
    }
    
    func updatePreview(bounds: CGRect) {
        if captureSession.running {
            previewLayer?.frame = bounds
        }
    }
    
    func capturePhoto(handler: (capturedImage: UIImage?, error: NSError?) -> ()) {
        if captureOutput.capturingStillImage {
            Logger.debug("camera is already capturing still image")
            handler(capturedImage: nil, error: nil)
            return
        }
        
        captureOutput.captureStillImageAsynchronouslyFromConnection(captureOutput.connections[0] as AVCaptureConnection, completionHandler: { (buffer: CMSampleBuffer!, error: NSError!) -> Void in
            let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            let image = UIImage(data: data)
            handler(capturedImage: image, error: error)
        })
    }
}
