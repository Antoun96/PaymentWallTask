//
//  Validate.swift
//  PaymentWallTask
//
//  Created by Antoun on 21/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation

public class Validate {
    
    public static func email(_ string: String) -> Bool {
        
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: string)
    }
    
    public static func phone(_ string: String) -> Bool {
        
        let regex = "(\\+|00[\\d]{1,4}[\\d]{5,11})|([\\d]{1,4}[\\d]{5,11})"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: string)
    }
    
    public static func password(_ string: String) -> Bool {
        
        let regex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: string)
    }
}
