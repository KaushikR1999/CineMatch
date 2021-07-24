//
//  AuthManager.swift
//  CineMatch_v2
//
//  Created by Kaushik Kumar on 16/7/21.
//

import Foundation
import Firebase

public class AuthManager {
    
    static let shared = AuthManager()
    
    
    //MARK: - Public
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        DatabaseManager.shared.canCreateUser(with: email, username: username) { (canCreateUser) in
            if canCreateUser {
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    guard error == nil, result != nil else {
                        completion(false)
                        return
                    }
                    
                    let uid = Auth.auth().currentUser!.uid
                    DatabaseManager.shared.insertNewUser(with: email, username: username, uid: uid) { (inserted) in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            completion(false)
                            return
                        }
                    }
                    
                    
                }
            }
            
            else {
                completion(false)
                
            }
        }
        
    }
    
    public func loginUser(email: String?, password: String, completion: @escaping (Bool) -> Void) {
        
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    public func logoutUser(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch let signOutError as NSError{
            print ("Error signing out: %@", signOutError)
            completion(false)
            return
            
        }
    }
}


