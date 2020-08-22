//
//  DatabaseHelper.swift
//  PaymentWallTask
//
//  Created by Antoun on 22/08/2020.
//  Copyright © 2020 PaymentWall. All rights reserved.
//

import Foundation
import SQLite3

class DataBaseHelper{
    
    var db: OpaquePointer!
    
    var part1DbPath: URL!
    
    private static var instance: DataBaseHelper!
    
    public class func getInstance()-> DataBaseHelper{
        if instance == nil{
            instance = DataBaseHelper()
        }
        
        return instance
    }
    
    private init() {
        
        part1DbPath = try! FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("PaymentWall.db")
        
        openDatabase()
    }
    
    func openDatabase() {
      var db: OpaquePointer?
      guard let part1DbPath = part1DbPath else {
        print("part1DbPath is nil.")
        self.db = nil
        return
      }
        if sqlite3_open(part1DbPath.path, &db) == SQLITE_OK {
        print("Successfully opened connection to database at \(part1DbPath)")
        self.db = db
      } else {
        print("Unable to open database.")
        self.db = db
      }
    }
    
//    func isTablesCreated() {
//
//
//
//    }
    
    public func createTables(){
        
        createUserTable()
        createTransactionTable()
        
    }
    
    private func createUserTable(){
 
        let createUserTableString = """
        CREATE TABLE IF NOT EXISTS USERS(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        FirstName CHAR(255),
        LastName CHAR(255),
        Password CHAR(255),
        Email CHAR(255) NOT NULL UNIQUE,
        Balance DOUBLE);
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createUserTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
          
          if sqlite3_step(createTableStatement) == SQLITE_DONE {
            print("\nUSERS table created.")
          } else {
            print("\nUSERS table is not created.")
          }
        } else {
          print("\nCREATE TABLE statement is not prepared.")
        }
        
        sqlite3_finalize(createTableStatement)
    }
    
    private func createTransactionTable(){
        
        let createTransactionTableString = """
        CREATE TABLE IF NOT EXISTS TRANSACTIONS(
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        UserId INTEGER NOT Null,
        ProductName CHAR(255),
        Price DOUBLE,
        ProductDescription CHAR(255),
        ProductImage CHAR(255),
        Date CHAR(255),
        FOREIGN KEY (UserId) REFERENCES USERS (Id));
        """
        
        var createTransTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTransactionTableString, -1, &createTransTableStatement, nil) ==
            SQLITE_OK {
          if sqlite3_step(createTransTableStatement) == SQLITE_DONE {
            print("\nTRANSACTIONS table created.")
          } else {
            print("\nTRANSACTIONS table is not created.")
          }
        } else {
          print("\nCREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTransTableStatement)
        
    }
    
    func insert (user: User, action: ((_: Int)-> Void)){
     
        let insertStatementString = "INSERT INTO USERS (FirstName, LastName, Password, Email, Balance) VALUES (?, ?, ?, ?, ?);"
        
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
//          let name: NSString = "Ray"
//          sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 1, user.firstName, -1, nil)
            sqlite3_bind_text(insertStatement, 2, user.lastName, -1, nil)
            sqlite3_bind_text(insertStatement, 3, user.password, -1, nil)
            sqlite3_bind_text(insertStatement, 4, user.email, -1, nil)
            sqlite3_bind_double(insertStatement, 5, user.balance)
            
          if sqlite3_step(insertStatement) == SQLITE_DONE {
            
            let lastRowId = sqlite3_last_insert_rowid(db);
            print(lastRowId)
            
            action(Int(lastRowId))
            print("\nSuccessfully inserted row.")
            
          } else {
            action(-1)
            print("\nCould not insert row.")
          }
        } else {
            action(-1)
          print("\nINSERT statement is not prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func signIn(email: String, password: String, userAction: ((_:User?)-> Void)){
        
        let queryStatementString = "SELECT * FROM USERS WHERE Email = '\(email)' AND Password = '\(password)';"
        
        var user = User()
        
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                
                user.id = Int(sqlite3_column_int(queryStatement, 0))
                
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    userAction(nil)
                    return
                }
                user.firstName = String(cString: queryResultCol1)
                user.lastName = String(cString: sqlite3_column_text(queryStatement, 2))
                user.password = String(cString: sqlite3_column_text(queryStatement, 3))
                user.email = String(cString: sqlite3_column_text(queryStatement, 4))
                user.balance = sqlite3_column_double(queryStatement, 5)
                
                userAction(user)
                
            } else {
                print("\nQuery returned no results.")
                userAction(nil)
            }
        } else {
            
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
            userAction(nil)
        }
        
        sqlite3_finalize(queryStatement)
    }
}
