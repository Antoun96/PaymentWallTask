//
//  Toast.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import UIKit

public class Toast {
    
    public static let PRIMARY_COLOR = UIColor.orange
    
    public static func showAlert(viewController: UIViewController,  title: String! = nil, text: String, okActionHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: okActionHandler)
        
        action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
        
        Toast.showAlert(viewController: viewController, text: text, style: UIAlertController.Style.actionSheet, action)
    }
    
    public static func showAlert(viewController: UIViewController, title: String! = nil, text: String, style: UIAlertController.Style, _ actions: UIAlertAction...) {
        Toast.showAlert(viewController: viewController, title: title, text: text, style: style, actions: actions)
    }
    
    public static func showAlert(viewController: UIViewController, title: String! = nil, text: String, style: UIAlertController.Style, actions: [UIAlertAction]) {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: style)
        
        if actions.count == 1 {
            
            let action = actions[0]
            
            action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
            
            alert.addAction(action)
            
            alert.preferredAction = action
        } else {
            
            for i in 0..<actions.count {
                let action = actions[i]
                if i == 0 {
                    
                    action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
                } else {
                    
                    action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
                }
                
                alert.addAction(action)
                alert.preferredAction = action
            }
        }
        
        alert.popoverPresentationController?.sourceView = viewController.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0,y: 0,width: 1,height: 1)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func showAlert(viewController: UIViewController, title: String! = nil, text: String, fieldHint: String!, _ actions: UIAlertAction...) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = fieldHint
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        
        if actions.count == 1 {
            
            let action = actions[0]
            
            action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
            
            alert.addAction(action)
            
            alert.preferredAction = action
        } else {
            
            for i in 0..<actions.count {
                
                let action = actions[i]
                
                if i == 0 {
                    
                    action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
                } else {
                    
                    action.setValue(PRIMARY_COLOR, forKey: "titleTextColor")
                }
                
                alert.addAction(action)
                alert.preferredAction = action
            }
        }
        
        alert.view.backgroundColor = UIColor.white
        alert.view.layer.cornerRadius = 10
        
        alert.popoverPresentationController?.sourceView = viewController.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0,y: 0,width: 1,height: 1)
        viewController.present(alert, animated: true, completion: nil)
        
        return alert
    }
}
