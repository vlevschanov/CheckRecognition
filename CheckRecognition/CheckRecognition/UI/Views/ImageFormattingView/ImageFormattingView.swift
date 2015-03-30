//
//  ImageFormattingView.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/2/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol ImageFormattingViewDelegate {
    optional func formattingViewDidTapImage(view: ImageFormattingView, point: CGPoint)
}

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
    
    @IBInspectable var cropViewIsShown : Bool = true {
        didSet {
            if cropViewIsShown != oldValue {
                setupCropView()
                resetCropView()
            }
        }
    }
    
    private let IMAGE_MAXIMUM_SCALE : CGFloat = 5.0
    
    var delegate : ImageFormattingViewDelegate?
    var resetOnImageChange : Bool = true
    
    var image : UIImage? {
        didSet {
            if image != nil {
                self.imageView.image = self.image
                setupContent()
            }
        }
    }
    
    // MARK: Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCropView()
    }
    
    // MARK: Layout
    
    private var imageAspectRect = CGRectZero
    
//    private func needContentResetForNewAspecRect(erct: CGRect) -> Bool {
//        
//    }
    
    private func setupContent() {
        self.imageAspectRect = AVMakeRectWithAspectRatioInsideRect(self.image!.size, self.bounds);
        let imgSize : CGSize = self.image!.size
        let scale = self.imageAspectRect.width / imgSize.width
        
        if self.scrollView.minimumZoomScale == scale && !self.resetOnImageChange {
            return
        }
        
        resetCropView()
        
        self.scrollView.minimumZoomScale = scale
        self.scrollView.zoomScale = scale
        self.scrollView.maximumZoomScale = IMAGE_MAXIMUM_SCALE
        self.scrollView.contentSize = self.scrollView.frame.size
        
        let size = CGRectIntegral(self.imageAspectRect).size
        let topInset = fmax(floor((self.frame.height - size.height) * 0.5), 0.0)
        let leftInset = fmax(floor((self.frame.width - size.width) * 0.5), 0.0)
        self.scrollView.contentInset = UIEdgeInsetsMake(topInset, leftInset, 0.0, 0.0)
        
        self.layoutIfNeeded()
        
        layoutBlackoutView()
    }
    
    private func layoutBlackoutView() {
        self.blackoutView.clippingPath = UIBezierPath(rect: cropView.frame)
    }
    
    private func setupCropView() {
        if self.cropViewIsShown {
            cropView.layer.borderColor = UIColor.yellowColor().CGColor
            self.cropView.layer.borderWidth = 1.0
            self.cropView.hidden = false
            self.blackoutView.hidden = false
        }
        else {
            self.cropView.hidden = true
            self.blackoutView.hidden = true
        }
    }
    
    private func resetCropView() {
        self.cropViewTop.constant = self.imageAspectRect.origin.y
        self.cropViewLeft.constant = self.imageAspectRect.origin.x
        self.cropViewRight.constant = self.frame.width - self.imageAspectRect.maxX
        self.cropViewBottom.constant = self.frame.height - self.imageAspectRect.maxY
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
    
    private func convertRectToContentView(rect: CGRect) -> CGRect {
        let _rect = self.convertRect(rect, toView: self.scrollViewContent)
        return CGRectApplyAffineTransform(_rect, CGAffineTransformMakeScale(self.image!.scale, self.image!.scale))
    }
    
    private func convertPointToContentView(point: CGPoint) -> CGPoint {
        let _point = self.convertPoint(point, toView: self.scrollViewContent)
        return CGPointApplyAffineTransform(_point, CGAffineTransformMakeScale(self.image!.scale, self.image!.scale))
    }
    
    private func scrollViewContentOffset() -> (x: CGFloat, y: CGFloat) {
        let x = (self.frame.width - self.scrollViewContent.frame.width) / 2.0
        let y = (self.frame.height - self.scrollViewContent.frame.height) / 2.0
        return (x, y)
    }
    
    private func restrainCropView() {
        let offset = scrollViewContentOffset()
        
        self.cropViewTop.constant = fmax(fmax(self.cropViewTop.constant, offset.y), 0.0)
        self.cropViewLeft.constant = fmax(fmax(self.cropViewLeft.constant, offset.x), 0.0)
        self.cropViewRight.constant = fmax(fmax(self.cropViewRight.constant, offset.x), 0.0)
        self.cropViewBottom.constant = fmax(fmax(self.cropViewBottom.constant, offset.y), 0.0)
    }
    
    func getFormattedImage() -> UIImage? {
        if self.image == nil {
            return nil
        }
        
        var size = self.image!.size
        var imgScale = self.image!.scale
      
        UIGraphicsBeginImageContextWithOptions(size, true,  imgScale)
        let ctx = UIGraphicsGetCurrentContext();
        
        self.image!.drawInRect(CGRectMake(0.0, 0.0, size.width, size.height))
  
        let img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        let rect = convertRectToContentView(self.cropView.frame)
        
        let croppedCGImage = CGImageCreateWithImageInRect(img.CGImage, rect)
        let croppedImage = UIImage(CGImage: croppedCGImage, scale: imgScale, orientation: img.imageOrientation)
        
        return croppedImage?.CR_blackAndWhite()
    }
    
    // MARK: Actions
    
    @IBAction func didRecognizePanGesture(sender: UIPanGestureRecognizer) {
        if sender.view == self.cropView {
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
                
                restrainCropView()
                
                self.previousTouch = touch
                self.layoutIfNeeded()
                layoutBlackoutView()
                
            default:
                self.frameDragging = false
            }
        }
    }
    
    @IBAction func didRecognizeTapGesture(sender: UITapGestureRecognizer) {
        if sender.view == self.scrollView {
            let touch = sender.locationInView(self)
            let offset = scrollViewContentOffset()
            let contentRect = CGRectInset(self.bounds, offset.x, offset.y)
            
            if CGRectContainsPoint(contentRect, touch) {
                let point = convertPointToContentView(touch)
                self.delegate?.formattingViewDidTapImage?(self, point: point)
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