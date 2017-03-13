//
//  CustomRefreshLoadingView.swift
//  RefreshView
//
//  Created by bruce on 16/5/20.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

open class CustomRefreshLoadingView: UIView {
    fileprivate weak var scrollView: UIScrollView?
    fileprivate var imageViewLogo: UIImageView!
    fileprivate var imageViewLoading: UIImageView!
    fileprivate var loadingImage: UIImage?
    fileprivate var logoImage: UIImage?

    open var offsetX: CGFloat?
    open var offsetY: CGFloat?
    fileprivate let loadingWidth: CGFloat = 26.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    fileprivate func prepare() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    fileprivate func placeSubviews() {
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        if let offsetX = offsetX {
            originX = offsetX
        } else {
            originX = (sizeWidth - loadingWidth) / 2.0
        }
        if let offsetY = offsetY {
            originY = offsetY
        } else {
            originY = (sizeHeight - loadingWidth) / 2.0 - 30
        }
        self.imageViewLogo.frame = CGRect(x: originX, y: originY, width: loadingWidth, height: loadingWidth)
        self.imageViewLoading.frame = CGRect(x: originX, y: originY, width: loadingWidth, height: loadingWidth)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if let newScrollView = newSuperview as? UIScrollView {
            scrollView = newScrollView
            scrollView?.bounces = false
            sizeWidth = newScrollView.sizeWidth
            sizeHeight = newScrollView.sizeHeight
            commonInit()
            backgroundColor = scrollView?.backgroundColor
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        placeSubviews()
    }

    fileprivate func commonInit() {
        UIImageView.appearance(for: UITraitCollection(displayScale: 3))
        self.imageViewLogo = UIImageView()
        self.imageViewLoading = UIImageView()
        self.imageViewLogo.image = getLogoImage()
        self.imageViewLoading.image = getLoadingImage()
        self.imageViewLogo.backgroundColor = UIColor.clear
        self.imageViewLoading.backgroundColor = UIColor.clear
        self.addSubview(self.imageViewLogo)
        self.addSubview(self.imageViewLoading)
        self.placeSubviews()
    }
    
    fileprivate func getLogoImage() -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        guard let customImageLogo = logoImage else {
            let bundle = Bundle(for: classForCoder)
            let image = UIImage(named: "loading_logo", in: bundle, compatibleWith: traitCollection)
            guard let newImage = image else {
                return UIImage()
            }
            return newImage
        }
        return customImageLogo
    }
    
    fileprivate func getLoadingImage() -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        guard let customLoadingImage = loadingImage else {
            let bundle = Bundle(for: classForCoder)
            let image = UIImage(named: "loading_circle", in: bundle, compatibleWith: traitCollection)
            guard let newImage = image else {
                return UIImage()
            }
            return newImage
        }
        return customLoadingImage
    }

    open func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        rotateAnimation.isRemovedOnCompletion = false
        self.imageViewLoading.layer.add(rotateAnimation, forKey: "rotation")
    }

    open func stopAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.scrollView?.bounces = true
        }, completion: { (_) -> Void in
            self.imageViewLoading.layer.removeAnimation(forKey: "rotation")
            self.removeFromSuperview()
            self.alpha = 1
        })
    }
    
    open func customLoadingViewWith(_ customLogoImage: UIImage? = nil, customLoadingImage: UIImage? = nil) {
        logoImage = customLogoImage
        loadingImage = customLoadingImage
        imageViewLogo.image = getLogoImage()
        imageViewLoading.image = getLoadingImage()
    }
}
