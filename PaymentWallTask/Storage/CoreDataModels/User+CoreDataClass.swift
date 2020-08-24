//
//  User+CoreDataClass.swift
//  
//
//  Created by Antoun on 24/08/2020.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {
    
    init() {
        super.init(entity: NSEntityDescription.entity(forEntityName: "User", in: CoreDataHelper.getInstance().context)!, insertInto: CoreDataHelper.getInstance().context)
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public func register(action: ((_: User?)-> Void)?){
        
        let newUser = User.init(entity: self.entity, insertInto: CoreDataHelper.getInstance().context)
        newUser.balance = self.balance
        newUser.password = self.password
        newUser.firstName = self.firstName
        newUser.lastName = self.lastName
        newUser.email = self.email
        
        let id = CoreDataHelper.getInstance().getAutoIncremenet(name: "User")
        
        newUser.id = Int32(id)
        
        do {
            try CoreDataHelper.getInstance().context.save()
            if action != nil{
                action!(newUser)
            }
        } catch {
            print("Failed saving")
            if action != nil{
                action!(nil)
            }
        }
    }
    
    public func signIn(email: String, password: String, usr:((_: User?)-> Void)){
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email = %@", email)
        request.predicate = NSPredicate(format: "password = %@", password)
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataHelper.getInstance().context.fetch(request)
            
            if let user = result.first{
                usr(user)
            }else{
                usr(nil)
            }
        } catch {
            
            print("Failed")
            usr(nil)
        }
    }
}
