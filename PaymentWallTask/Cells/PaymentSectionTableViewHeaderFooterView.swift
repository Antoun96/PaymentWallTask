//
//  PaymentSectionTableViewHeaderFooterView.swift
//  PaymentWallTask
//
//  Created by Antoun on 24/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import UIKit

class PaymentSectionTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    let labelDate = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(labelDate)
        contentView.backgroundColor = UIColor.white
        
        
        NSLayoutConstraint.activate([
            labelDate.heightAnchor.constraint(equalToConstant: 40),
            labelDate.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelDate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
