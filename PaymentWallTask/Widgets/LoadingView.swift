//
//  LoadingView.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    var loadingSize: Int = 70
    
    var imageView: UIImageView = UIImageView()
    
    func setLoadingImage(image: UIImage) {
        
        imageView.image = image
        
        imageView.frame = CGRect(x: self.frame.width / 2 - CGFloat(loadingSize / 2), y: self.frame.height / 2 - CGFloat(loadingSize / 2), width: CGFloat(loadingSize), height: CGFloat(loadingSize))
        
        addSubview(imageView)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        if isLoading {
            isHidden = false
            superview?.bringSubviewToFront(self)
            imageView.startAnimating()
            if !imageView.isAnimating {
                
                let rotation = CABasicAnimation(keyPath: "transform.rotation")
                rotation.fromValue = 0
                rotation.toValue = (2 * Double.pi)
                rotation.duration = 1.5
                rotation.repeatCount = Float.greatestFiniteMagnitude
                
                imageView.layer.removeAllAnimations()
                imageView.layer.add(rotation, forKey: "rotation")
            }
        } else {
            isHidden = true
            imageView.stopAnimating()
        }
    }
}
