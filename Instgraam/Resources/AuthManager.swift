//
//  AuthManager.swift
//  Instgraam
//
//  Created by sa3doola on 8/24/20.
//  Copyright © 2020 saad sherif. All rights reserved.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    // MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, comletion: @escaping (Bool) -> Void) {
        
        /*
         - Ckeck if username is avaliable
         - check if email is avaliable
         
         */
        DatabaseManager.shared.canCreateNewUser(email: email, username: username) { canCreate in
            if canCreate {
                /*
                 - Create account
                 - Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error == nil, result != nil {
                        // Firebase auth could not create account
                        comletion(false)
                        return
                    }
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(email: email, username: username) { inserted in
                        if inserted {
                            comletion(true)
                            return
                        }
                        else {
                            // Faild to insert to database
                            comletion(false)
                            return
                        }
                    }
                }
            }
            else {
                // either username or email does not exist
                comletion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            // email log in
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            // username log in
            print(username)
        }
    }
    
    /// Attempt to log out firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch  {
            print(error.localizedDescription)
            completion(false)
            return
        }
    }
}
