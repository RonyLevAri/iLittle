//
//  User.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    
    var uid: String
    var email: String
    var username: String
    var notifications = [NotificationItem]()
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
    }
    
    init(user: User) {
         //todo: take care firebase user logic via authentication
        self.uid = user.uid
        self.email = user.email
        self.username = AppFileDataAccessObject.sharedInstance.readNameFromFile() ?? "Jon Doe"
    }
}
