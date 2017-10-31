//
//  ViewController.swift
//  iLittle
//
//  Created by rony_temp on 31/10/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit
import UserNotifications

class InitialLoginViewController: UIViewController {
    
    //MARK: actions
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "kusemek"
        content.body = "arsabuk"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: {(error) in
            if let error = error {
                print(error)
            } else {
                print("notification scheduled")
            }
        })
    }
    
    func doInitialAuthorizationFlow() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { (settings) in
            if(settings.authorizationStatus == .authorized) {
                // go to configuration screen
                self.scheduleNotification()
            } else {
                // User has not given permissions
                center.requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {(granted, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if(granted) {
                            // go to configuration screen
                            self.scheduleNotification()
                        }
                    }
                })
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}


