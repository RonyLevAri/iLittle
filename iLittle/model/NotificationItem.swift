//
//  NotificationProtocol.swift
//  iLittle
//
//  Created by rony_temp on 03/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct NotificationItem {
    
    var uid: String?
    let category: String
    let image: String
    var isActive = false
    var date: Date?

    init(category: String, image: String) {
        self.category = category
        self.image = image
    }
    
    init(uid: String, category: String, image: String, isActive: Bool, date: Date) {
        self.uid = uid
        self.category = category
        self.image = image
        self.isActive = isActive
        self.date = date
    }
    
    public var description: String { return "NotificationItem: \(String(describing: uid)), \(category), \(image), \(isActive), \(String(describing: date))" }
}
