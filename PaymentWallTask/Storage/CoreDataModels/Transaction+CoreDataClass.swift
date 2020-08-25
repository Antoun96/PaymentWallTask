//
//  Transaction+CoreDataClass.swift
//  
//
//  Created by Antoun on 24/08/2020.
//
//

import Foundation
import CoreData


public class Transaction: NSManagedObject {
    
    var subPrice: Double!
    
    var priceInDollar: Double!
    
    var tax: Double!
    
    init() {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Transaction", in: CoreDataHelper.getInstance().context)!, insertInto: CoreDataHelper.getInstance().context)
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(json: [String:Any]) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "Transaction", in: CoreDataHelper.getInstance().context)!, insertInto: CoreDataHelper.getInstance().context)
        
           productImage = json["image_url"] as? String ?? ""
           
           productName = json["product"] as? String ?? ""
           
           subPrice = json["price"] as? Double ?? 0
           
           tax = json["tax"] as? Double ?? 0
           
           productDescription = json["product_description"] as? String ?? ""
           
           currency = json["currency"] as? String ?? ""
           
           switch self.currency{
               // change total price currency to dollar
           case "aed":
               priceInDollar = (tax + subPrice) * 0.27
               break
           case "egp":
               priceInDollar = (tax + subPrice) * 0.063
               break
           case "€":
               priceInDollar = (tax + subPrice) * 1.18
               break
           default:
               priceInDollar = tax + subPrice
               break
           }
           
       }
    
    public func createPayment(action: ((_: Bool)-> Void)){
        
        let manager = SettingsManager()
        self.userId = Int32(manager.getId())
        let total = subPrice + tax
        self.price = total
        
        let date = Date()
        self.date = date
        
        CoreDataHelper.getInstance().getAutoIncremenet(name: "Transaction"){(id)
            in
         
            self.id = Int32(id)
            do {
                try CoreDataHelper.getInstance().context.save()
                
                User().changeBalance(newBalance: manager.getBalance()-self.priceInDollar)
                
                action(true)
                
            } catch {
                print("Failed saving")
                
                action(false)
            }
        }
        
    }
    
    
    public func getPaymentHistory(id: Int, transactions:((_: [Transaction]?)-> Void)?){
        
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "userId = \(id)")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        
        request.fetchLimit = 10
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try CoreDataHelper.getInstance().context.fetch(request)
            
            transactions!(result)
            
        } catch {
            
            print("Failed")
            transactions!(nil)
        }
    }
}
