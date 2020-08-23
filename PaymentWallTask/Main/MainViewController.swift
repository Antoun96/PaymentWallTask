//
//  MainViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    
    private var childViewController: UIViewController!
    
    @IBOutlet var tabButton: [UIButton]!
    
    @IBOutlet var tabLabels: [UILabel]!
    
    var selectedBarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !SettingsManager().isLoggedIn(){
            
            let vc = UIStoryboard(name: "Account", bundle: nil).instantiateInitialViewController()
            
            let window = UIApplication.shared.keyWindow!
            
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }else{
            actionTab(tabButton[0])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        let imageView = UIImageView(image: UIImage(named: "ic_fasterpay_small"))
        self.navigationItem.titleView = imageView
        
    }

    @IBAction func actionTab(_ sender: UIButton) {
        
        if sender.tag != selectedBarButton?.tag {
            
            switch selectedBarButton?.tag ?? -1 {
            case 0:
                
                tabLabels[0].textColor = .black
                tabButton[0].setImage(UIImage(named: "ic_wallet"), for: .normal)
                break
            case 1:
                tabLabels[1].textColor = .black
                tabButton[1].setImage(UIImage(named: "ic_qrcode"), for: .normal)
                break
            case 2:
                tabLabels[2].textColor = .black
                tabButton[2].setImage(UIImage(named: "ic_profile"), for: .normal)
                break
            default:
                break
            }
            
            switch sender.tag {
            case 0:
                
                tabLabels[0].textColor = .orange
                tabButton[0].setImage(UIImage(named: "ic_wallet_selected"), for: .normal)
                wallet()
                break
            case 1:
                
                tabLabels[1].textColor = .orange
                tabButton[1].setImage(UIImage(named: "ic_qrcode_selected"), for: .normal)
                qrScanner()
                break
            case 2:
                
                tabLabels[2].textColor = .orange
                tabButton[2].setImage(UIImage(named: "ic_profile_selected"), for: .normal)
                profile()
                break
            default:
                break
            }
            
            selectedBarButton = sender
        }
        
    }
    
    func wallet() {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        
        replaceChild(viewController: vc)
    }
    
    func qrScanner() {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        
        replaceChild(viewController: vc)
    }
    
    func profile() {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        replaceChild(viewController: vc)
    }
    
    func replaceChild(viewController: UIViewController) {
        
        if let view = self.container.subviews.last {
            
            view.removeFromSuperview()
        }
        
        if let viewController = self.children.last {
            
            viewController.removeFromParent()
        }
        
        self.addChild(viewController)
        
        self.container.addSubview(viewController.view)
        self.container.bringSubviewToFront(viewController.view)
        viewController.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.width, height: self.container.frame.height)

        childViewController = viewController
    }
}

