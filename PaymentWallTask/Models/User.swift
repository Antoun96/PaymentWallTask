//
//  User.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import CoreData

class User{
    
    var id: Int!
    var email: String!
    var firstName: String!
    var lastName: String!
    var password: String!
    var balance: Double!
    
    init() {
        
    }
    
    init(email: String, firstName: String, lastName: String, password: String, balance: Double) {
        
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.balance = balance
        
    }
    
    func setValues(data: NSManagedObject){
        
        self.id = data.value(forKey: "id") as? Int
        self.email = data.value(forKey: "email") as? String
        self.firstName = data.value(forKey: "firstName") as? String
        self.lastName = data.value(forKey: "lastName") as? String
        self.password = data.value(forKey: "password") as? String
        self.balance = data.value(forKey: "balance") as? Double
        
    }
    
}
