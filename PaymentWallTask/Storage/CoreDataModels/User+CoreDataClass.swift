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
        
        CoreDataHelper.getInstance().getAutoIncremenet(name: "User") { (id) in
            
            self.id = Int32(id)
            
            do {
                try CoreDataHelper.getInstance().context.save()
                if action != nil{
                    action!(self)
                }
            } catch {
                print("Failed saving")
                if action != nil{
                    action!(nil)
                }
            }
        }
    
    }
    
    public func signIn(email: String, password: String, usr:((_: User?)-> Void)){
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email = %@", email)
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataHelper.getInstance().context.fetch(request)
            
            if let user = result.first, user.password == password{
                
                usr(user)
            }else{
                usr(nil)
            }
        } catch {
            
            print("Failed")
            usr(nil)
        }
    }
    
    public func changeBalance(newBalance: Double){
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(SettingsManager().getId())")
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataHelper.getInstance().context.fetch(request)
            
            if let r = result.first{
                
                r.balance = newBalance
                SettingsManager().setBalance(value: newBalance)
                try CoreDataHelper.getInstance().context.save()
            }
        } catch {
            
            print("Failed")
        }
    }
}
