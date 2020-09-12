//
//  DatabaseManager.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: - Public
    /// Check if username and email is available
    /// - parameters
    ///    - email: String representing email
    ///    - username: String representing username
    public func canCreateNewUser(email: String, username: String, comletion: (Bool) -> Void) {
        comletion(true)
    }
    
    // MARK: - Public
       /// Insert new user data to database
       /// - parameters
       ///    - email: String representing email
       ///    - username: String representing username
       ///    - completion: Async callback for result if database entry succeded
    public func insertNewUser(email: String, username: String, completion: @escaping (Bool) -> Void) {
        let key = email.safeDatabaseKey()
        
        database.child(key).setValue(["username": username]) { error, _ in
            if error == nil {
                //succeded
                completion(true)
                return
            }
            else {
                // Faild
                completion(false)
                return
            }
            
        }
    }
    
    
}
