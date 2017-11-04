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
    var date: Date?
    
    var key: String? {
        set {  }
        get { return self.key }
    }

    init(category: String, image: String, user: String) {
        self.category = category
        self.image = image
        self.user = user
    }
}
