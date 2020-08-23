//
//  TransactionSuccessViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 23/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class TransactionSuccessViewController: UIViewController {
    
    private var action: (() -> Void)!
    
    class func getInstance(_ action: (() -> Void)!) -> TransactionSuccessViewController {
        let d = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionSuccessViewController") as! TransactionSuccessViewController
        d.modalPresentationStyle = .overCurrentContext
        d.action = action
        return d
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func actionOk(_ sender: Any) {
        
        action()
        dismiss(animated: true, completion: nil)
    }
    
}
