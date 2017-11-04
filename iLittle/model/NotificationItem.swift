//
//  NotificationProtocol.swift
//  iLittle
//
//  Created by rony_temp on 03/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationItem {
    
    let category: String
    let image: String
    let user: String
    var isActive = false
    
    var key: String?
    var ref: DatabaseReference?

    init(category: String, image: String, user: String) {
        self.category = category
        self.image = image
        self.user = user
    }
    
//    init(snapshot: DataSnapshot) {
//        key = snapshot.key
//        ref = snapshot.ref
//        if let category = snapshot.value(forKey: "category") as? String {
//            self.category = category
//        }
//        if let image = snapshot.value(forKey: "image") as? String {
//            self.image = image
//        }
//        if let user = snapshot.value(forKey: "user") as? String {
//            self.user = user
//        }
//        if let isActive = snapshot.value(forKey: "isActive") as? Bool {
//            self.isActive = isActive
//        }
//    }
}
