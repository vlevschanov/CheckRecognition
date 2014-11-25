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
    
    let captureSession = AVCaptureSession()
    let captureOutput  = AVCaptureStillImageOutput()
    
    var captureDevice  : AVCaptureDevice?
    var sessionPresset : String?
    var previewLayer   : AVCaptureVideoPreviewLayer?
    
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
    
    func start(onLayer layer: CALayer) {
        if captureSession.running {
            self.stop()
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.addSublayer(previewLayer)
        previewLayer?.frame = layer.bounds
        
        captureSession.startRunning()
    }
    
    func stop() {
        if captureSession.running {
            captureSession.stopRunning()
            previewLayer?.removeFromSuperlayer()
        }
    }
    
    func pause() {
        
    }
    
    func resume() {
        
    }
}
