//
//  Config.swift
//  iLittle
//
//  Created by rony_temp on 05/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation

struct Config {
    
    var initialNotifications = [NotificationItem]()
    
    init() {
        populateNotifications()
    }
    
    mutating func populateNotifications() {
        initialNotifications.append(NotificationItem(category: "drinking", image: "lemonade_glass256"))
        initialNotifications.append(NotificationItem(category: "moving", image: "step256"))
        initialNotifications.append(NotificationItem(category: "nositting", image: "heartbeat256"))
    }
}
