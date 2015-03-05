//
//  ImageFormattingView.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/2/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit
import AVFoundation

class ImageFormattingView: MemoryObservableView {

    @IBOutlet private weak var scrollViewContent: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var cropView: UIView!
    @IBOutlet private weak var blackoutView: BlackoutView!
    
    @IBOutlet private weak var scrollContentTop: NSLayoutConstraint!
    @IBOutlet private weak var scrollContentLeading: NSLayoutConstraint!
    
    @IBOutlet weak var cropViewTop: NSLayoutConstraint!
    @IBOutlet weak var cropViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cropViewLeft: NSLayoutConstraint!
    @IBOutlet weak var cropViewRight: NSLayoutConstraint!
    
    private let IMAGE_MAXIMUM_SCALE : CGFloat = 5.0
    
    var image : UIImage? {
        didSet {
            if image? != nil {
                self.imageView.image = self.image
                layoutImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cropView.layer.borderColor = UIColor.yellowColor().CGColor
        self.cropView.layer.borderWidth = 1.0
    }
    
    // MARK: Layout
    
    private func layoutBlackoutView() {
        self.blackoutView.clippingPath = UIBezierPath(rect: cropView.frame)
    }
    
    private func layoutImage() {
        
        let rect = AVMakeRectWithAspectRatioInsideRect(self.image!.size, self.bounds);
        let imgSize : CGSize = self.image!.size
        let scale = rect.width / imgSize.width
        
        self.cropViewTop.constant = rect.origin.y
        self.cropViewLeft.constant = rect.origin.x
        self.cropViewRight.constant = self.frame.width - rect.maxX
        self.cropViewBottom.constant = self.frame.height - rect.maxY
        
        self.scrollView.minimumZoomScale = scale
        self.scrollView.zoomScale = scale
        self.scrollView.maximumZoomScale = IMAGE_MAXIMUM_SCALE
        self.scrollView.contentSize = self.scrollView.frame.size
        
        let size = CGRectIntegral(rect).size
        let topInset = fmax(floor((self.frame.height - size.height) * 0.5), 0.0)
        let leftInset = fmax(floor((self.frame.width - size.width) * 0.5), 0.0)
        self.scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0.0, 0.0)
        
        self.layoutIfNeeded()
        layoutBlackoutView()
    }
    
    private func updateImageCenter() {
        let size = self.scrollView.contentSize
        let topInset = fmax(floor((self.frame.height - size.height) * 0.5), 0.0)
        let leftInset = fmax(floor((self.frame.width - size.width) * 0.5), 0.0)
        self.scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0.0, 0.0)
    }
    
    // MARK: Formatting logic
    
    private enum FormattingFrameCorner {
        case TopLeft, TopRight, BottomLeft, BottomRight
    }

    private var frameDragging : Bool = false
    private var touchedCorner : FormattingFrameCorner?
    private var previousTouch : CGPoint = CGPointZero
    
    private func convertedCropViewRect() -> CGRect {
        let rect = self.convertRect(self.cropView.frame, toView: self.scrollViewContent)
        return CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(self.image!.scale, self.image!.scale))
    }
    
    private func convertedScrollContentRect() -> CGRect {
        return self.convertRect(self.scrollViewContent.frame, toView: self)
    }
    
    private func layoutCropView() {
        let x = (self.frame.width - self.scrollViewContent.frame.width) / 2.0
        let y = (self.frame.height - self.scrollViewContent.frame.height) / 2.0
        
        self.cropViewTop.constant = fmax(fmax(self.cropViewTop.constant, y), 0.0)
        self.cropViewLeft.constant = fmax(fmax(self.cropViewLeft.constant, x), 0.0)
        self.cropViewRight.constant = fmax(fmax(self.cropViewRight.constant, x), 0.0)
        self.cropViewBottom.constant = fmax(fmax(self.cropViewBottom.constant, y), 0.0)
    }
    
    func getFormattedImage() -> UIImage? {
        if self.image? == nil {
            return nil
        }
        
        var size = self.image!.size
        var imgScale = self.image!.scale
      
        UIGraphicsBeginImageContextWithOptions(size, true,  imgScale)
        let ctx = UIGraphicsGetCurrentContext();
        
        self.image!.drawInRect(CGRectMake(0.0, 0.0, size.width, size.height))
  
        let img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        let rect = convertedCropViewRect()
        
        let croppedCGImage = CGImageCreateWithImageInRect(img.CGImage, rect)
        let croppedImage = UIImage(CGImage: croppedCGImage, scale: imgScale, orientation: img.imageOrientation)
        
        return croppedImage?.CR_blackAndWhite()
    }
    
    // MARK: Actions
    
    @IBAction func didRecognizePanGesture(sender: UIPanGestureRecognizer) {
        if sender.view? == self.cropView {
            let touch = sender.locationInView(self)
            
            switch sender.state {
                
            case .Began:
                let center = CGPointMake(self.cropView.frame.midX, self.cropView.frame.midY)
                
                if touch.x <= center.x {
                    self.touchedCorner = touch.y <= center.y ? .TopLeft : .BottomLeft
                }
                else {
                    self.touchedCorner = touch.y <= center.y ? .TopRight : .BottomRight
                }
                
                self.frameDragging = true
                self.previousTouch = touch
                
            case .Changed:
                let diffX = touch.x - self.previousTouch.x
                let diffY = touch.y - self.previousTouch.y
                
                switch touchedCorner! {
                case .TopLeft:
                    self.cropViewLeft.constant += diffX
                    self.cropViewTop.constant  += diffY
                    
                case .TopRight:
                    self.cropViewRight.constant -= diffX
                    self.cropViewTop.constant   += diffY
                    
                case .BottomLeft:
                    self.cropViewLeft.constant   += diffX
                    self.cropViewBottom.constant -= diffY
                    
                case .BottomRight:
                    self.cropViewRight.constant  -= diffX
                    self.cropViewBottom.constant -= diffY
                }
                
                layoutCropView()
                
                self.previousTouch = touch
                self.layoutIfNeeded()
                layoutBlackoutView()
                
            default:
                self.frameDragging = false
            }
        }
    }
    
}

extension ImageFormattingView : UIScrollViewDelegate {
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateImageCenter()
        Logger.debug(scrollViewContent.frame)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        Logger.debug("content size: \(scrollView.contentSize)")
        return scrollViewContent
    }
    
}

extension ImageFormattingView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
}