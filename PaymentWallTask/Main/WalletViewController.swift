//
//  WalletViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var labelBalance: UILabel!
    
    @IBOutlet weak var labelNoRecords: UILabel!
    
    @IBOutlet weak var tableViewPaymentHistory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelBalance.text = "$\(String(format: "%.2f", SettingsManager().getBalance()))"
    
        tableViewPaymentHistory.isHidden = true
        
    }

}
