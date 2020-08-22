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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "USERS")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{
               
                register(user: User(email: "a@mail.com", firstName: "Antoun", lastName: "William", password: "Passw0rd", balance: 600), action: nil)
                
                register(user: User(email: "antoun@mail.com", firstName: "Antoun", lastName: "William", password: "Passw0rd", balance: 600), action: nil)
            
                register(user: User(email: "ab@mail.com", firstName: "Antoun", lastName: "William", password: "Passw0rd", balance: 600), action: nil)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    public func register(user: User, action: ((_: User?)-> Void)?){
        
        let entity = NSEntityDescription.entity(forEntityName: "USERS", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(user.balance, forKey: "balance")
        newUser.setValue(user.password, forKey: "password")
        newUser.setValue(user.firstName, forKey: "firstName")
        newUser.setValue(user.lastName, forKey: "lastName")
        newUser.setValue(user.email, forKey: "email")
        
        let id = getAutoIncremenet(name: "USERS")
        
        newUser.setValue(id, forKey: "id")
        
        user.id = id
        
        do {
           try context.save()
            action!(user)
          } catch {
           print("Failed saving")
            action!(nil)
        }
    }
    
    public func signIn(email: String, password: String, usr:((_: User?)-> Void)){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "USERS")
        request.predicate = NSPredicate(format: "email = %@", email)
        request.predicate = NSPredicate(format: "password = %@", password)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            let user = User()
            
            if result.count > 0{
                
                user.setValues(data: (result as! [NSManagedObject])[0])
                usr(user)
            }else{
                usr(nil)
            }
        } catch {
            
            print("Failed")
            usr(nil)
        }
    }
    
    func getAutoIncremenet(name: String) -> Int   {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)

        // Sort Descriptor
        var idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
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
            return newId
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return -1
        }
    }
}
