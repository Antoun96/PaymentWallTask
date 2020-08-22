//
//  USERS+CoreDataProperties.swift
//  
//
//  Created by Antoun on 22/08/2020.
//
//

import Foundation
import CoreData


extension USERS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<USERS> {
        return NSFetchRequest<USERS>(entityName: "USERS")
    }

    @NSManaged public var id: NSDecimalNumber?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var balance: Double
    @NSManaged public var password: String?
    @NSManaged public var relationship_id: NSSet?

}

// MARK: Generated accessors for relationship_id
extension USERS {

    @objc(addRelationship_idObject:)
    @NSManaged public func addToRelationship_id(_ value: Transactions)

    @objc(removeRelationship_idObject:)
    @NSManaged public func removeFromRelationship_id(_ value: Transactions)

    @objc(addRelationship_id:)
    @NSManaged public func addToRelationship_id(_ values: NSSet)

    @objc(removeRelationship_id:)
    @NSManaged public func removeFromRelationship_id(_ values: NSSet)

}
