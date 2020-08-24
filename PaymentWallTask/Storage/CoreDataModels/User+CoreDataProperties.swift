//
//  User+CoreDataProperties.swift
//  
//
//  Created by Antoun on 24/08/2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var balance: Double
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: Int32
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?
    @NSManaged public var relationship_id: NSSet?

}

// MARK: Generated accessors for relationship_id
extension User {

    @objc(addRelationship_idObject:)
    @NSManaged public func addToRelationship_id(_ value: Transaction)

    @objc(removeRelationship_idObject:)
    @NSManaged public func removeFromRelationship_id(_ value: Transaction)

    @objc(addRelationship_id:)
    @NSManaged public func addToRelationship_id(_ values: NSSet)

    @objc(removeRelationship_id:)
    @NSManaged public func removeFromRelationship_id(_ values: NSSet)

}
