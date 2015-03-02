//
//  ImageFormattingView.swift
//  CheckRecognition
//
//  Created by Viktor Levshchanov on 3/2/15.
//  Copyright (c) 2015 Viktor Levshchanov. All rights reserved.
//

import UIKit

class ImageFormattingView: MemoryObservableView {

    @IBOutlet private weak var scrollContent: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var scrollContentTop: NSLayoutConstraint!
    @IBOutlet private weak var scrollContentLeading: NSLayoutConstraint!
    
    private let IMAGE_MAXIMUM_SCALE : CGFloat = 5.0
    
    var image : UIImage? {
        didSet {
            if image? != nil {
                imageView.image = image
                layoutImage()
            }
        }
    }
    
    private func layoutImage() {
        var viewSize : CGSize = scrollView.frame.size
        var imgSize : CGSize = image!.size
        var scale = fmin(viewSize.width / imgSize.width, viewSize.height / imgSize.height)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        scrollView.maximumZoomScale = IMAGE_MAXIMUM_SCALE * scale
        
        var xOffset = floor((viewSize.width - imgSize.width * scale) / 2.0)
        var yOffset = floor((viewSize.height - imgSize.height * scale) / 2.0)
        scrollContentLeading.constant = xOffset
        scrollContentTop.constant = yOffset
    }
    
    private func updateImageCenter() {
        scrollContentLeading.constant = fmax((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        scrollContentTop.constant = fmax((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        layoutIfNeeded()
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