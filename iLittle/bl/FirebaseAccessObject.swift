//
//  firebaseAccessObject.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAccessObject {
    
    
    //MARK: object singleton reference
    static let sharedInstance = FirebaseAccessObject()
    private init() {

    }
    
    //MARK: properties
    let rootRef = Database.database().reference().child("user1")
    var currentUser: User?
    var authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
        guard user != nil else {
            // alert app that login is needed
            return
        }
    }
    
    func write(data: String) {
        
    }
    
    func readData(forUser user: String) {
        let userRef = rootRef.child(user)
        userRef.observe(.value, with: { (snap) in
            print(snap.value.debugDescription)
        })
    }
    
    // Three functions taken from https://code.tutsplus.com/tutorials/get-started-with-firebase-authentication-for-ios--cms-29227
    func createnewUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // ...
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
