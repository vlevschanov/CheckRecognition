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

    @IBOutlet private weak var scrollContent: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var frameView: UIView!
    @IBOutlet private weak var blackoutView: BlackoutView!
    
    @IBOutlet private weak var scrollContentTop: NSLayoutConstraint!
    @IBOutlet private weak var scrollContentLeading: NSLayoutConstraint!
    
    @IBOutlet weak var frameViewTop: NSLayoutConstraint!
    @IBOutlet weak var frameViewBottom: NSLayoutConstraint!
    @IBOutlet weak var frameViewLeft: NSLayoutConstraint!
    @IBOutlet weak var frameViewRight: NSLayoutConstraint!
    
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
        self.frameView.layer.borderColor = UIColor.yellowColor().CGColor
        self.frameView.layer.borderWidth = 1.0
    }
    
    // MARK: Layout
    
    private func layoutBlackoutView() {
        self.blackoutView.clippingPath = UIBezierPath(rect: frameView.frame)
    }
    
    private func layoutImage() {
        
        let rect = AVMakeRectWithAspectRatioInsideRect(self.image!.size, self.frame);
        let imgSize : CGSize = self.image!.size
        let scale = rect.width / imgSize.width
        
        self.scrollView.minimumZoomScale = scale
        self.scrollView.zoomScale = scale
        self.scrollView.maximumZoomScale = IMAGE_MAXIMUM_SCALE
        self.scrollView.contentSize = self.scrollView.frame.size
        
        let size = CGRectIntegral(rect).size
        let topInset = fmax(floor((self.frame.height - size.height) * 0.5), 0.0)
        let leftInset = fmax(floor((self.frame.width - size.width) * 0.5), 0.0)
        self.scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0.0, 0.0)
        
        layoutBlackoutView()
    }
    
    private func updateImageCenter() {
        let size = self.scrollView.contentSize
        let topInset = fmax(floor((self.frame.height - size.height) * 0.5), 0.0)
        let leftInset = fmax(floor((self.frame.width - size.width) * 0.5), 0.0)
        self.scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0.0, 0.0)
    }
    
    // MARK: Formatting logic
    
    enum FormattingFrameCorner {
        case TopLeft, TopRight, BottomLeft, BottomRight
    }

    var frameDragging : Bool = false
    var touchedCorner : FormattingFrameCorner?
    var previousTouch : CGPoint = CGPointZero
    
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
        
        var rect = self.convertRect(self.frameView.frame, toView: self.scrollContent)
        
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(imgScale, imgScale))
        
        let croppedCGImage = CGImageCreateWithImageInRect(img.CGImage, rect)
        let croppedImage = UIImage(CGImage: croppedCGImage, scale: imgScale, orientation: img.imageOrientation)
        
        return croppedImage?.CR_blackAndWhite()
    }
    
    // MARK: Actions
    
    @IBAction func didRecognizePanGesture(sender: UIPanGestureRecognizer) {
        if sender.view? == self.frameView {
            let touch = sender.locationInView(self)
            
            switch sender.state {
                
            case .Began:
                let center = CGPointMake(self.frameView.frame.midX, self.frameView.frame.midY)
                
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
                    self.frameViewLeft.constant += diffX
                    self.frameViewTop.constant  += diffY
                    
                case .TopRight:
                    self.frameViewRight.constant -= diffX
                    self.frameViewTop.constant   += diffY
                    
                case .BottomLeft:
                    self.frameViewLeft.constant   += diffX
                    self.frameViewBottom.constant -= diffY
                    
                case .BottomRight:
                    self.frameViewRight.constant  -= diffX
                    self.frameViewBottom.constant -= diffY
                }
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
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        Logger.debug("content size: \(scrollView.contentSize)")
        return scrollContent
    }
    
}

extension ImageFormattingView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
}