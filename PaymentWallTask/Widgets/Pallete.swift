//
//  Pallete.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    class func parse(rgb hex: String) -> UIColor {
        
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        if hex.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var orange: UIColor {
        
        get {
            //FEC013
            return UIColor(red: 0xFE / 255, green: 0xc0 / 255, blue: 0x13 / 255, alpha: 1)
        }
    }
    
//    static var blue: UIColor {
//
//        get {
//            //094484
//            return UIColor(red: 0x09 / 255, green: 0x44 / 255, blue: 0x84 / 255, alpha: 1)
//        }
//    }
//
//    static var blueDark: UIColor {
//
//        get {
//            //06305d
//            return UIColor(red: 0x06 / 255, green: 0x30 / 255, blue: 0x5d / 255, alpha: 1)
//        }
//    }
//
//    static var grayLight: UIColor {
//
//        get {
//            //D5DAE1
//            return UIColor(red: 0xd5 / 255, green: 0xda / 255, blue: 0xe1 / 255, alpha: 1)
//        }
//    }
//
//    static var greenLight: UIColor {
//
//        get {
//            //7ffe9d
//            return UIColor(red: 0x7f / 255, green: 0xfe / 255, blue: 0x9d / 255, alpha: 1)
//        }
//    }
//
//    static var whiteOff: UIColor {
//
//        get {
//            //fcfcfc
//            return UIColor(red: 0xf4 / 255, green: 0xf4 / 255, blue: 0xf4 / 255, alpha: 1)
//        }
//    }
//
//    static var purple: UIColor {
//
//        get {
//            //6c63ff
//            return UIColor(red: 0x6c / 255, green: 0x63 / 255, blue: 0xff / 255, alpha: 1)
//        }
//    }
//
//    static var pink: UIColor {
//
//        get {
//            //fe7f7f
//            return UIColor(red: 0xFe / 255, green: 0x7f / 255, blue: 0x7f / 255, alpha: 1)
//        }
//    }
//
//    static var paleYellow: UIColor {
//
//           get {
//               //FCC778
//               return UIColor(red: 0xFC / 255, green: 0xC7 / 255, blue: 0x78 / 255, alpha: 1)
//           }
//       }
//
//    static var lightGreenWhite: UIColor {
//
//        get {
//            //F7F7F1
//            return UIColor(red: 0xF7 / 255, green: 0xF7 / 255, blue: 0xF1 / 255, alpha: 1)
//        }
//    }
}
