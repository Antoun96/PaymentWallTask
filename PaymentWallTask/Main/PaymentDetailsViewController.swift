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
    
    var product: Product!
    
    var manager: SettingsManager!
    
    var coreDataHelper: CoreDataHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = SettingsManager()
        
        display(p: product)
        
        buttonPay.addTapGestureRecognizer {
            
            // check you balance before paying
            if self.product.priceInDollar > self.manager.getBalance(){
                
                Toast.showAlert(viewController: self, text: NSLocalizedString("not_enough_balance", comment: ""))
                return
            }else{
                
                self.coreDataHelper = CoreDataHelper.getInstance()
                
                self.coreDataHelper.createPaymet(product: self.product) { (status) in
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
    
    func display(p: Product){
        
        labelName.text = p.name
        var currency = p.currency.uppercased()
        if currency.contains("DOLLAR"){
            currency = "$"
        }
        labelBalance.text = "\(currency) \(String(format: "%.2f", SettingsManager().getBalance()))"
        labelTax.text = "\(currency) \(String(format: "%.2f", p.tax))"
        labelsubTotal.text = "\(currency) \(String(format: "%.2f", p.price))"
        let total = p.tax + p.price
        labelTotalPrice.text = "\(currency) \(String(format: "%.2f", total))"
        labelDescription.text = "\(p.description ?? "")"
        
        buttonPay.setTitle("Pay \(currency) \(String(format: "%.2f", total))", for: .normal)
        
        imageViewProductImage.sd_setImage(with: URL(string: p.image_url))
        { (image, error, cache, url) in
            
            if let _ = error {
                // default_profile_photo
                self.imageViewProductImage.image = UIImage(named: "default")
            }
        }
    }
}
