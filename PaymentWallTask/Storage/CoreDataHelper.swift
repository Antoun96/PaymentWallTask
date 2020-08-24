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
            if action != nil{
                action!(user)
            }
          } catch {
           print("Failed saving")
            if action != nil{
                action!(nil)
            }
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
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "USERS")
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
    
    public func getPaymentHistory(id: Int, products:((_: [Product]?)-> Void)?){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TRANSACTIONS")
        request.predicate = NSPredicate(format: "userId = \(id)")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        
        request.returnsObjectsAsFaults = false
        
        var productsArray = [Product]()
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject]{
                
                let product = Product()
                product.setValues(data: data)
                productsArray.append(product)
                
            }
            
            if productsArray.count > 0{
                products!(productsArray)
            }else {
                products!(nil)
            }
            
        } catch {
            
            print("Failed")
            products!(nil)
        }
    }
    
    func getAutoIncremenet(name: String) -> Int   {
        
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
