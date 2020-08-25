//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Antoun on 24/08/2020.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var currency: String?
    @NSManaged public var date: Date
    @NSManaged public var id: Int32
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    @NSManaged public var productImage: String?
    @NSManaged public var productName: String?
    @NSManaged public var userId: Int32
    @NSManaged public var origin: User?

}
