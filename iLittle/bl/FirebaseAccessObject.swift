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
    func dataChangedFor(_ user: User)
}

//todo: add authentication logic to get the user details
class FirebaseAccessObject {
    
    //MARK: object singleton reference
    static let sharedInstance = FirebaseAccessObject()
    private init() {

    }
    
    //MARK: properties
    weak var delegate: FirebasedataAccessDelgate?
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
                "category": notification.category,
                "image": notification.image,
                "isActive": notification.isActive ? "Y" : "N"
            ]
            dataRef.child(key).child("notifications").child(notificationKey).setValue(stringParams)
            dataRef.child(key).child("notifications")
                .child(notificationKey).child("timestamp").setValue(ServerValue.timestamp())
        }
    }
    
    func listenToDataChanges(forUser uid: String) {
        dataRef.child(uid).observe(.value, with: { [unowned self] (snapshot) in
            var notifications = [NotificationItem]()
            var v  = snapshot.value as? NSDictionary
            let username = v?["username"] as! String
            let enumerator = snapshot.childSnapshot(forPath: "notifications").children
            
            while let rest = enumerator.nextObject() as? DataSnapshot {
                v = rest.value as? NSDictionary
                let k = rest.key
                let category = v?["category"] as! String
                let image = v?["image"] as! String
                let active = v?["isActive"] as! String
                let timestamp = v?["timestamp"] as! NSNumber
                let isActive = active == "Y" ? true : false
                let t = Date(timeIntervalSince1970: Double(truncating: timestamp))
                notifications.append(NotificationItem(uid: k, category: category, image: image, isActive: isActive, date: t))
            }
            let user = User(uid: snapshot.key, username: username, notifications: notifications)
            self.delegate?.dataChangedFor(user)
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
