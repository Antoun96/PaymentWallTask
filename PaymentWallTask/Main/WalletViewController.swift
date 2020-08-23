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
    
    var coreDataHelper: CoreDataHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        labelBalance.text = "$\(String(format: "%.2f", SettingsManager().getBalance()))"
        
        coreDataHelper.getPaymentHistory(id: SettingsManager().getId()) { (products) in
            
            if products == nil{
                
                self.tableViewPaymentHistory.isHidden = true
                
            }else if products?.count == 0{
                self.tableViewPaymentHistory.isHidden = true
            }else {
                self.tableViewPaymentHistory.isHidden = false
                self.labelNoRecords.isHidden = true
                
                
            }
            
        }
    }

}
