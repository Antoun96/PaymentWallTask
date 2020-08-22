//
//  Transactions+CoreDataProperties.swift
//  
//
//  Created by Antoun on 22/08/2020.
//
//

import Foundation
import CoreData


extension Transactions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transactions> {
        return NSFetchRequest<Transactions>(entityName: "Transactions")
    }

    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var price: Double
    @NSManaged public var productImage: String?
    @NSManaged public var date: TimeInterval
    @NSManaged public var origin: USERS?

}
