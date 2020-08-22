//
//  SettingsManager.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation

class SettingsManager {
    
    enum Settings : String {
        case IsLoggedIn, Id, FirstName, LastName, Email, Balance
    }
    
    var userDefault: UserDefaults
    
    init() {
        userDefault = UserDefaults.standard
    }
    
    func setLoggedIn(value:Bool) {
        if (!value) {
                resetAccount()
        }
        let _ = save(object: value, setting: Settings.IsLoggedIn)
    }
    
    func updateUser(user: User!) {
        
        if let user = user {

            if user.id > 0{
                setIsloggedIn(value: true)
                setId(value: user.id)
                setFirstName(value: user.firstName)
                setLastName(value: user.lastName)
                setBalance(value: user.balance)
                setEmail(value: user.email)
            }
            
        } else {
            
            resetAccount()
        }
    }
    
    private func resetAccount() {
        setId(value: -1)
        setEmail(value: "")
        setBalance(value: -1)
        setFirstName(value: "")
        setLastName(value: "")
    }
    
    func setIsloggedIn (value:Bool){
        setLoggedIn(value: value)
    }
    
    func isLoggedIn() -> Bool {
        if let object = userDefault.object(forKey: Settings.IsLoggedIn.rawValue) {
            return object as! Bool
        }
        return false
    }
    
    func setFirstName (value:String){
        let _ =  save(object: value, setting: Settings.FirstName)
    }
    
    func getFirstName() -> String {
        return userDefault.object(forKey: Settings.FirstName.rawValue) as! String
    }

    func setLastName (value:String){
        let _ =  save(object: value, setting: Settings.LastName)
    }
    
    func getLastName() -> String {
        return userDefault.object(forKey: Settings.LastName.rawValue) as! String
    }
    
    func setEmail (value:String){
        let _ =  save(object: value, setting: Settings.Email)
    }
    
    func getEmail() -> String {
        return userDefault.object(forKey: Settings.Email.rawValue) as! String
    }
    
    func setId (value:Int){
        let _ =  save(object: value, setting: Settings.Id)
    }
    
    func getId() -> String {
        return userDefault.object(forKey: Settings.Id.rawValue) as! String
    }
    
    func setBalance (value:Double){
        let _ =  save(object: value, setting: Settings.Balance)
    }
    
    func getBalance() -> Double {
        return userDefault.object(forKey: Settings.Balance.rawValue) as! Double
    }
    
    private func save(object: Any, setting: Settings) -> Bool {
        if (object is Int) {
            userDefault.set(object as! Int, forKey: setting.rawValue)
        } else if (object is Bool) {
            userDefault.set(object as! Bool, forKey: setting.rawValue)
        } else if (object is String) {
            userDefault.set(object as! String, forKey: setting.rawValue)
        } else {
            userDefault.set(object, forKey: setting.rawValue)
        }
        return userDefault.synchronize()
    }
}
