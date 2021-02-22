//
//  ImageScrollView.swift
//  TestPhotoApp
//
//  Created by Даниил Статиев on 21.02.2021.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    var imageZoomView: UIImageView?
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        zoomingTap.numberOfTouchesRequired = 2
        return zoomingTap
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView ?? UIImageView())
        configureFor(imageSize: image.size)
    }
    
    func configureFor(imageSize: CGSize) {
        self.contentSize = imageSize
        setCurrentMaxAndMinZoomScale()
        self.zoomScale = self.minimumZoomScale
        self.imageZoomView?.addGestureRecognizer(self.zoomingTap)
        self.imageZoomView?.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        superview?.layoutSubviews()
        self.centerImage()
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animeted: true)
    }
   
    func zoom(point: CGPoint, animeted: Bool) {
        let currentScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animeted)
        
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        
        return zoomRect
    }

    
    func setCurrentMaxAndMinZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView?.bounds.size
        
        let xScale = boundsSize.width / imageSize!.width
        let yScale = boundsSize.height / imageSize!.height
        
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }
    
    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageZoomView?.frame ?? CGRect.zero
        
        if frameToCenter.size.width < bounds.size.width {
            frameToCenter.origin.x = (bounds.size.width - frameToCenter.size.width) / 2
            
        } else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.size.height < bounds.size.height {
            frameToCenter.origin.y = (bounds.size.height - frameToCenter.size.height) / 2
            
        } else {
            frameToCenter.origin.y = 0
        }
        imageZoomView?.frame = frameToCenter
    }
    
}

// MARK: - UIScrollViewDelegate

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageZoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
    
}
