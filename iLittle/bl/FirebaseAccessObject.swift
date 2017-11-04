//
//  firebaseAccessObject.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import Firebase
//todo: add authentication logic to get the user details
class FirebaseAccessObject {
    
    //MARK: object singleton reference
    static let sharedInstance = FirebaseAccessObject()
    private init() {

    }
    
    //MARK: properties
    let usersRef = Database.database().reference().child("users")
    var currentUser: User?
    var authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
        guard user != nil else {
            // alert app that login is needed
            return
        }
    }
    
    func saveUser(username: String) {
        let dateString = String(describing: Date())
        let params = ["username": username, "date": dateString]
        usersRef.childByAutoId().setValue(params)
    }
    
    func getUserPrefs(forUser user: String) {
        let usernameRef = usersRef.child("username")
        usernameRef.observe(.value, with: { (snap) in
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
