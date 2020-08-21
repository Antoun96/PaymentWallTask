//
//  SignInViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateLogin() -> Bool {
        if !Validate.email(textFieldEmail.text ?? ""){
            
            Toast.showAlert(viewController: self, text: NSLocalizedString("invalid_email", comment: ""))
            
            return false
        }else if textFieldPassword.text?.count ?? 0<8{
            Toast.showAlert(viewController: self, text: NSLocalizedString("invalid_password", comment: ""))
            
            return false
        }
        
        return true
    }
    
    @IBAction func actionFingerPrint(_ sender: Any) {
    }
    
    @IBAction func actionForgetPassword(_ sender: Any) {
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        
        if validateLogin(){
            
        }
        
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true, completion: nil)
    }
}
