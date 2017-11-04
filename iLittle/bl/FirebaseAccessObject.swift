//
//  firebaseAccessObject.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import Firebase

protocol FirebasedataAccessDelgate: class {
    
}

//todo: add authentication logic to get the user details
class FirebaseAccessObject {
    
    //MARK: object singleton reference
    static let sharedInstance = FirebaseAccessObject()
    private init() {

    }
    
    //MARK: properties
    weak var delegat: FirebasedataAccessDelgate?
    let usersRef = Database.database().reference().child("users")
    let notificationRef = Database.database().reference().child("notifications")
    
    //MARK: database listeners
    var authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
        guard user != nil else {
            // alert app that login is needed
            return
        }
    }
    
    var usersListener = Database.database().reference().child("users").observe(.value, with: {(snapshot) in
        // call delegate
        print("users changed")
        print(snapshot)
    })
    
    var notificationListener = Database.database().reference().child("notifications").observe(.value, with: {(snapshot) in
        // call delegate
        print("notifications changed")
        print(snapshot)
    })
    
    //MARK: helper functions
    private func formatDate(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ""
    }
    
    //MARK: api
    func saveUser(username: String) {
        let key = usersRef.childByAutoId().key
        let params = ["username": username]
        usersRef.child(key).setValue(params)
        usersRef.child(key).child("timestamp").setValue(ServerValue.timestamp())
    }
    
    func saveNotifications(_ notifications: [NotificationItem]) {
        notifications.forEach { (notification) in
            let key = notificationRef.childByAutoId().key
            let stringParams = [
                "user": notification.user,
                "category": notification.category,
                "image": notification.image,
                "isActive": notification.isActive ? "Y" : "N"
            ]
            notificationRef.child(key).setValue(stringParams)
            notificationRef.child(key).child("timestamp").setValue(ServerValue.timestamp())
        }
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
