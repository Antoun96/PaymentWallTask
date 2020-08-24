//
//  ProfileViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var labelUsername: UILabel!
    
    var manager: SettingsManager!
    
    @IBOutlet weak var viewLogout: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = SettingsManager()
        
        labelUsername.text = "\(manager.getFirstName()) \(manager.getLastName())"
        
        viewLogout.addTapGestureRecognizer {
            
            self.manager.setLoggedIn(value: false)
            
            let vc = UIStoryboard(name: "Account", bundle: nil).instantiateInitialViewController()
            
            let window = UIApplication.shared.keyWindow!
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
    
}
