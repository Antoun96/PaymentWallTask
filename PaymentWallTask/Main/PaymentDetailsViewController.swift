//
//  PaymentDetailsViewController.swift
//  PaymentWallTask
//
//  Created by Antoun on 23/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit
import SDWebImage

class PaymentDetailsViewController: UIViewController {

    @IBOutlet weak var imageViewProductImage: UIImageView!
   
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var labelTotalPrice: UILabel!
    
    @IBOutlet weak var labelsubTotal: UILabel!
    
    @IBOutlet weak var labelTax: UILabel!
    
    @IBOutlet weak var labelBalance: UILabel!
    
    @IBOutlet weak var buttonPay: UIButton!
    
    var transaction: Transaction!
    
    var manager: SettingsManager!
    
    var coreDataHelper: CoreDataHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = SettingsManager()
        
        display(p: transaction)
        
        buttonPay.addTapGestureRecognizer {
            
            // check you balance before paying
            if self.transaction.priceInDollar > self.manager.getBalance(){
                
                Toast.showAlert(viewController: self, text: NSLocalizedString("not_enough_balance", comment: ""))
                return
            }else{
                
                self.coreDataHelper = CoreDataHelper.getInstance()
                
                self.transaction.createPayment { (status) in
                    if status{
                        
                        let vc = TransactionSuccessViewController.getInstance {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        self.present(vc, animated: true, completion: nil)
                        
                    }else {
                        Toast.showAlert(viewController: self, text: NSLocalizedString("error_while_transaction", comment: ""))
                        
                        return
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let title = UILabel()
        title.textColor = .white
        title.text = "Payment"
        self.navigationItem.titleView = title
    }
    
    func display(p: Transaction){
        
        labelName.text = p.productName
        let currency = p.currency!.uppercased()
        
        labelBalance.text = "\(currency) \(String(format: "%.2f", SettingsManager().getBalance()))"
        labelTax.text = "\(currency) \(String(format: "%.2f", p.tax))"
        labelsubTotal.text = "\(currency) \(String(format: "%.2f", p.subPrice))"
        let total = p.tax + p.subPrice
        labelTotalPrice.text = "\(currency) \(String(format: "%.2f", total))"
        labelDescription.text = "\(p.productDescription ?? "")"
        
        buttonPay.setTitle("Pay \(currency) \(String(format: "%.2f", total))", for: .normal)
        
        imageViewProductImage.sd_setImage(with: URL(string: p.productImage!))
        { (image, error, cache, url) in
            
            if let _ = error {
                // default_profile_photo
                self.imageViewProductImage.image = UIImage(named: "default")
            }
        }
    }
}
