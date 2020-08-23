//
//  PaymentHistoryTableViewCell.swift
//  PaymentWallTask
//
//  Created by Antoun on 24/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewPayment: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDesc: UILabel!
    
    @IBOutlet weak var buttonPrice: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDetails(product: Product){
        
    }
    
}
