//
//  Product.swift
//  PaymentWallTask
//
//  Created by Antoun on 23/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import CoreData

class Product{
    
    var image_url: String!
    
    var name: String!
    
    var price: Double!
    
    var tax: Double!
    
    var description: String!
    
    var currency: String!
    
    var date: String!
    
    init() {
        
    }
    
    init(json: [String:Any]) {
        
        image_url = json["image_url"] as? String ?? ""
        
        name = json["product"] as? String ?? ""
        
        price = json["price"] as? Double ?? 0
        
        tax = json["tax"] as? Double ?? 0
        
        description = json["product_description"] as? String ?? ""
        
        currency = json["currency"] as? String ?? ""
        
    }
    
    func setValues(data: NSManagedObject){
        
        self.image_url = data.value(forKey: "productImage") as? String
        self.name = data.value(forKey: "productName") as? String
        self.price = data.value(forKey: "price") as? Double
        self.description = data.value(forKey: "productDescription") as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        self.date = formatter.string(from: data.value(forKey: "date") as! Date)
        
    }
}
