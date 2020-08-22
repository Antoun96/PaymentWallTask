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
    
    var loadingView: LoadingView!
    
    var coreDataHelper: CoreDataHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView = LoadingView(frame: self.view.frame)
        loadingView.setLoadingImage(image: UIImage(named: "ic_loading")!)
        loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        loadingView.setIsLoading(false)
        self.view.addSubview(loadingView)
        
        coreDataHelper = CoreDataHelper.getInstance()
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
        
        loadingView.setIsLoading(true)
        
        if validateLogin(){
            
            coreDataHelper.signIn(email: textFieldEmail.text!, password: textFieldPassword.text!) { (usr) in
                
                if usr != nil{
                    
                    SettingsManager().updateUser(user: usr)
                    
                    loadingView.setIsLoading(false)
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    
                    let window = UIApplication.shared.keyWindow!
                    
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }else {
                    loadingView.setIsLoading(false)
                    Toast.showAlert(viewController: self, text: "wrong_credintials")
                }
            }
            
//            let db = DataBaseHelper.getInstance()
//            db.signIn(email: textFieldEmail.text!, password: textFieldPassword.text!) { (usr) in
//                
//                if usr != nil{
//                    
//                    SettingsManager().updateUser(user: usr)
//                    
//                    loadingView.setIsLoading(false)
//                    
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
//                    
//                    let window = UIApplication.shared.keyWindow!
//                    
//                    window.rootViewController = vc
//                    window.makeKeyAndVisible()
//                }else {
//                    loadingView.setIsLoading(false)
//                    Toast.showAlert(viewController: self, text: "wrong_credintials")
//                }
//            }
        }
        
        loadingView.setIsLoading(false)
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true, completion: nil)
    }
}
