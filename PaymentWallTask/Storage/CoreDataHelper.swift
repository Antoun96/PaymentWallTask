//
//  CoreDataHelper.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    private static var instance: CoreDataHelper!
    
    var persistentContainer: NSPersistentContainer!
    
    var context: NSManagedObjectContext!
    
    public class func getInstance()-> CoreDataHelper{
        if instance == nil{
            instance = CoreDataHelper()
        }
        
        return instance
    }
    
    private init() {
        
        let persistentContainer: NSPersistentContainer = {

            let container = NSPersistentContainer(name: "PaymentWall")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {

                    fatalError("Unresolved error, \((error as NSError).userInfo)")
                }
            })
            return container
        }()
        
        self.persistentContainer = persistentContainer
        
        context = persistentContainer.viewContext
    }
    
    func registerBasicAccounts(){
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{
               
                let user1 = User.init(entity: User().entity, insertInto: context)
                user1.email = "a@mail.com"
                user1.firstName = "Antoun"
                user1.lastName = "William"
                user1.password = "Passw0rd"
                user1.balance = 600
                user1.register(action: nil)
                
                let user2 = User.init(entity: User().entity, insertInto: context)
                user2.email = "antoun@mail.com"
                user2.firstName = "Antoun"
                user2.lastName = "William"
                user2.password = "Passw0rd"
                user2.balance = 600
                user2.register(action: nil)
                
                let user3 = User.init(entity: User().entity, insertInto: context)
                user3.email = "ab@mail.com"
                user3.firstName = "Antoun"
                user3.lastName = "William"
                user3.password = "Passw0rd"
                user3.balance = 600
                user3.register(action: nil)
                
               
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    public func getAutoIncremenet(name: String, action: (_: Int)-> Void)  {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)

        // Sort Descriptor
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [idDescriptor]

        fetchRequest.fetchLimit = 1

        var newId = 0;

        do {
            let results = try self.context.fetch(fetchRequest)

            if(results.count == 1){
                newId = ((results[0] as AnyObject).value(forKey: "id") as? Int ?? 0)+1
            }else {
                newId = 1
            }
            action(newId)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            action(-1)
        }
    }
}
