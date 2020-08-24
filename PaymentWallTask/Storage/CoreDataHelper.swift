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
    
    
    public func createPaymet(product: Product, action: ((_: Bool)-> Void)){
        
        let entity = NSEntityDescription.entity(forEntityName: "TRANSACTIONS", in: context)
        let newPayment = NSManagedObject(entity: entity!, insertInto: context)
        
        let manager = SettingsManager()
        
        newPayment.setValue(product.name, forKey: "productName")
        newPayment.setValue(product.image_url, forKey: "productImage")
        newPayment.setValue(product.description, forKey: "productDescription")
        newPayment.setValue(manager.getId(), forKey: "userId")
        newPayment.setValue(product.currency, forKey: "currency")
        
        let total = product.price + product.tax
        newPayment.setValue(total, forKey: "price")
        
        let date = Date()
        newPayment.setValue(date, forKey: "date")
        
        let id = getAutoIncremenet(name: "TRANSACTIONS")
        newPayment.setValue(id, forKey: "id")
        
        do {
            try context.save()
            action(true)
            
            changeBalance(id: manager.getId(), newBalance: manager.getBalance()-product.priceInDollar)
          
        } catch {
           print("Failed saving")
            
            action(false)
        }
    }
    
    private func changeBalance(id: Int, newBalance: Double){
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(id)")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.count > 0{
                
                (result as! [NSManagedObject])[0].setValue(newBalance, forKey: "balance")
                SettingsManager().setBalance(value: newBalance)
                try context.save()
            }
        } catch {
            
            print("Failed")
        }
    }
    
    public func getPaymentHistory(id: Int, products:((_: [Product])-> Void)){
        
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "userId = \(id)")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        
        request.fetchLimit = 10
        request.returnsObjectsAsFaults = false
        
        var productsArray = [Product]()
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject]{
                
                let product = Product()
                product.setValues(data: data)
                productsArray.append(product)
                
            }
            
            products(productsArray)
            
        } catch {
            
            print("Failed")
            products(productsArray)
        }
    }
    
    func registerBasicAccounts(){
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.count == 0{
               
                let user1 = User()
                user1.email = "a@mail.com"
                user1.firstName = "Antoun"
                user1.lastName = "William"
                user1.password = "Passw0rd"
                user1.balance = 600
                user1.register(action: nil)
                
                let user2 = User()
                user2.email = "antoun@mail.com"
                user2.firstName = "Antoun"
                user2.lastName = "William"
                user2.password = "Passw0rd"
                user2.balance = 600
                user2.register(action: nil)
                
                let user3 = User()
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
    
    public func getAutoIncremenet(name: String) -> Int   {
        
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
            return newId
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return -1
        }
    }
}
