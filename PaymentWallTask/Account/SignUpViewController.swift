//
//  SignUpViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    
    @IBOutlet weak var textFieldLastName: UITextField!
    
    @IBOutlet weak var switchTerms: UISwitch!
    
    @IBOutlet weak var labelTerms: UILabel!
    
    var user = User.init(entity: User().entity, insertInto: CoreDataHelper.getInstance().context)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTerms.isUserInteractionEnabled = true
        labelTerms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
        
    }
    

    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = labelTerms.attributedText?.string else {
            return
        }

        if let range = text.range(of: "User Agreement"),
            recognizer.didTapAttributedTextInLabel(label: labelTerms, inRange: NSRange(range, in: text)) {
            UIApplication.shared.open(URL(string: "https://www.paymentwall.com/en")!)
        } else if let range = text.range(of: "Privacy Policy"),
            recognizer.didTapAttributedTextInLabel(label: labelTerms, inRange: NSRange(range, in: text)) {
            UIApplication.shared.open(URL(string: "https://www.paymentwall.com/about")!)
        }
    }
    
    func validateSignUp() -> Bool {
        if !Validate.email(textFieldEmail.text ?? ""){
            
            Toast.showAlert(viewController: self, text: NSLocalizedString("invalid_email", comment: ""))
            return false
        }else
            if !Validate.password(textFieldPassword.text ?? ""){
                
            Toast.showAlert(viewController: self, text: NSLocalizedString("invalid_password", comment: ""))
            return false
        }else if textFieldFirstName.text?.isEmpty ?? true{
            
            Toast.showAlert(viewController: self, text: NSLocalizedString("invalid_firstname", comment: ""))
            
            return false
        }else if textFieldLastName.text?.isEmpty ?? true{
            
            Toast.showAlert(viewController: self, text: NSLocalizedString("invalid_lastname", comment: ""))
            
            return false
        }else if !switchTerms.isOn{
            
            Toast.showAlert(viewController: self, text: NSLocalizedString("accept_terms", comment: ""))
            return false
        }
        
        user.email = textFieldEmail.text
        user.firstName = textFieldFirstName.text
        user.lastName = textFieldLastName.text
        user.password = textFieldPassword.text
        user.balance = 600.00
        
        return true
    }

    @IBAction func actionSignUp(_ sender: Any) {
       
        if validateSignUp(){
            
            user.register { (usr) in
           
                if usr != nil{
                    
                    SettingsManager().updateUser(user: usr)
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    
                    let window = UIApplication.shared.keyWindow!
                    
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }else {
                    Toast.showAlert(viewController: self, text: "registration_error")
                }
                
            }
        }
    }
    
    @IBAction func actionSignIn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

