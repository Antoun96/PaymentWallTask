//
//  PaymentHistoryTableViewCell.swift
//  PaymentWallTask
//
//  Created by Antoun on 24/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit
import SDWebImage

class PaymentHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPayment: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var buttonPrice: UIButton!
    
    @IBOutlet weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDetails(product: Product){
       
        labelTitle.text = product.name
        labelDesc.text = product.description
        labelPrice.text = "- \(product.currency.uppercased())\(String(format: "%.2f",product.price ?? 0))"
        
        imageViewPayment.sd_setImage(with: URL(string: product.image_url))
        { (image, error, cache, url) in
            
            if let _ = error {
                // default_profile_photo
                self.imageViewPayment.image = UIImage(named: "default")
            }
        }
    }
    
}
