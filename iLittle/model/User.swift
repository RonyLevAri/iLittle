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
    var email: String = "notrelevantnow@gmail.com"
    var username: String
    var notifications = [NotificationItem]()
    
    init(uid: String, username: String, notifications: [NotificationItem]) {
         //todo: take care firebase user logic via authentication
        self.uid = uid
        self.username = username
        self.notifications = notifications
    }
    
    public var description: String { return "NotificationItem: \(uid), \(email), \(username), \(notifications)" }
}
