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
    let dataRef = Database.database().reference().child("data")
    
    //MARK: database listeners
    var authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
        guard user != nil else {
            // alert app that login is needed
            return
        }
    }
    
    var usersListener = Database.database().reference().child("users").observe(.value, with: {(snapshot) in
        // call delegate
        //print("users changed")
        //print(snapshot)
    })
    
    var notificationListener = Database.database().reference().child("notifications").observe(.value, with: {(snapshot) in
        // call delegate
        //print("notifications changed")
        //print(snapshot)
    })
    
    //MARK: helper functions
    private func formatDate(dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ""
    }
    
    //MARK: api
    // constructed with the help of https://www.youtube.com/watch?v=YqpdgJ24R7E
    func saveUserConfiguration(username: String, notifications: [NotificationItem]) -> String{
        let key = saveUser(username)
        saveNotifications(forUserAt: key, notifications)
        return key
    }
    
    func saveUser(_ username: String) -> String {
        let key = dataRef.childByAutoId().key
        let params = ["username": username]
        dataRef.child(key).setValue(params)
        dataRef.child(key).child("timestamp").setValue(ServerValue.timestamp())
        return key
    }
    // todo: chane notification structure (username is redundant)
    func saveNotifications(forUserAt key: String, _ notifications: [NotificationItem]) {
        notifications.forEach { (notification) in
            let notificationKey = dataRef.child(key).childByAutoId().key
            let stringParams = [
                "user": notification.user,
                "category": notification.category,
                "image": notification.image,
                "isActive": notification.isActive ? "Y" : "N"
            ]
            dataRef.child(key).child(notificationKey).setValue(stringParams)
            dataRef.child(key).child(notificationKey).child("timestamp").setValue(ServerValue.timestamp())
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
