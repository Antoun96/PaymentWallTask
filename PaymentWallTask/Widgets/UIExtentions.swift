//
//  UIExtentions.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    var isHiddenAnimated: Bool {
        
        set {
                
            UIView.animate(withDuration: 0.3, animations: {
                
                self.isHidden = newValue
                
                self.layoutIfNeeded()
            }) { (isComplete) in
                
                if isComplete {
                    
                    self.isHidden = newValue
                }
            }
        }
        
        get {
            
            return isHidden
        }
    }
    
    class func loadFromNib<T: UIView>(named: String) -> T {
        return Bundle.main.loadNibNamed(named, owner: nil, options: nil)![0] as! T
    }
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map(UIColor.init)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension UIImageView {
    
    @IBInspectable var imageTintColor: UIColor! {
        
        set {
            
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 1)
            newValue.setFill()
            
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: self.frame.height)
            context.scaleBy(x: 1, y: -1)
            context.setBlendMode(CGBlendMode.normal)
            
            let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            context.clip(to: rect, mask: self.image!.cgImage!)
            context.fill(rect)
            
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            self.image = colorImage
            
            self.tintColor = newValue
        }
        
        get {
            
            return self.tintColor
        }
    }
}
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UITextField{
    
    @IBInspectable var PlaceHolderColor: UIColor{
        get{
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: .none) as! UIColor
        }
        set{
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: newValue])
        }
    }
    
}
