//
//  NotificationProtocol.swift
//  iLittle
//
//  Created by rony_temp on 03/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation

class NotificationCategory {
    let category: String
    let image: String
    var chosen: Bool = false
    
    init(category: String, image: String) {
        self.category = category
        self.image = image
    }
}
