//
//  CircularImageView.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = frame.size.width
        self.layer.cornerRadius = size / 2
        clipsToBounds = true
    }
}
