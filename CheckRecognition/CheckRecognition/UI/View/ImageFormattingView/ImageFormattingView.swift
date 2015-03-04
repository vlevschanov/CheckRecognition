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
                imageView.image = image
                layoutImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frameView.layer.borderColor = UIColor.yellowColor().CGColor
        frameView.layer.borderWidth = 1.0
    }
    
    // MARK: Layout
    
    private func layoutBlackoutView() {
        blackoutView.clippingPath = UIBezierPath(rect: frameView.frame)
    }
    
    private func layoutImage() {
        
        let rect = AVMakeRectWithAspectRatioInsideRect(image!.size, self.frame);
        let imgSize : CGSize = image!.size
        let scale = rect.width / imgSize.width
        
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        scrollView.maximumZoomScale = IMAGE_MAXIMUM_SCALE
        
        updateImageCenter()
        layoutBlackoutView()
    }
    
    private func updateImageCenter() {
        let rect = CGRectIntegral(AVMakeRectWithAspectRatioInsideRect(image!.size, self.frame));
        scrollContentLeading.constant = floor((self.frame.width - rect.width) * 0.5)
        scrollContentTop.constant = floor((self.frame.height - rect.height) * 0.5)
        layoutIfNeeded()
    }
    
    // MARK: Formatting logic
    
    enum FormattingFrameCorner {
        case TopLeft, TopRight, BottomLeft, BottomRight
    }

    var frameDragging : Bool = false
    var touchedCorner : FormattingFrameCorner?
    var previousTouch : CGPoint = CGPointZero
    
    func getFormattedImage() -> UIImage? {
        if image? == nil {
            return nil
        }
        
        var size = image!.size
        var imgScale = image!.scale
      
        UIGraphicsBeginImageContextWithOptions(size, true,  imgScale)
        let ctx = UIGraphicsGetCurrentContext();
        
        image!.drawInRect(CGRectMake(0.0, 0.0, size.width, size.height))
  
        let img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        var rect = self.convertRect(frameView.frame, toView: scrollContent)
        
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(imgScale, imgScale))
        
        let croppedImage = CGImageCreateWithImageInRect(img.CGImage, rect)
        return UIImage(CGImage: croppedImage, scale: imgScale, orientation: img.imageOrientation)
    }
    
    // MARK: Actions
    
    @IBAction func didRecognizePanGesture(sender: UIPanGestureRecognizer) {
        if sender.view? == frameView {
            let touch : CGPoint = sender.locationInView(self)
            
            switch sender.state {
                
            case .Began:
                let center : CGPoint = CGPointMake(frameView.frame.midX, frameView.frame.midY)
                if touch.x < center.x && touch.y < center.y {
                    touchedCorner = .TopLeft
                }
                else if touch.x > center.x && touch.y < center.y {
                    touchedCorner = .TopRight
                }
                else if touch.x < center.x && touch.y > center.y {
                    touchedCorner = .BottomLeft
                }
                else if touch.x > center.x && touch.y > center.y {
                    touchedCorner = .BottomRight
                }
                frameDragging = true
                previousTouch = touch
                
            case .Changed:
                let x = touch.x - previousTouch.x
                let y = touch.y - previousTouch.y
                
                switch touchedCorner! {
                case .TopLeft:
                    frameViewLeft.constant += x
                    frameViewTop.constant += y
                case .TopRight:
                    frameViewRight.constant -= x
                    frameViewTop.constant + y
                case .BottomLeft:
                    frameViewLeft.constant   += x
                    frameViewBottom.constant -= y
                case .BottomRight:
                    frameViewRight.constant -= x
                    frameViewBottom.constant -= y
                }
                previousTouch = touch
                self.layoutIfNeeded()
                layoutBlackoutView()
                
            default:
                frameDragging = false
            }
        }
    }
    
}

extension ImageFormattingView : UIScrollViewDelegate {
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateImageCenter()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollContent
    }
    
}

extension ImageFormattingView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
}