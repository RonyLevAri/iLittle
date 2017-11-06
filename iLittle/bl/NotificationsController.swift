//
//  NotificationsController.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import UserNotifications

protocol NotificationControllerDelegate: class {
    
}

class NotificatoinsController: NSObject {
    
    //MARK: object singleton reference
    static let sharedInstance = NotificatoinsController()
    
    private override init() {
        
    }
    
    //MARK: propertires
    var settings: UNNotificationSettings?
    weak var delegate: NotificationControllerDelegate?
    
    //MARK: api
    
    func registerCustomNotification() {
        let action1 = UNNotificationAction(identifier: NotificationIdentifier.actionOneIdentifier.rawValue, title: NotificationIdentifier.actionOneTitle.rawValue)
        let action2 = UNNotificationAction(identifier: NotificationIdentifier.actionTwoIdentifier.rawValue, title: NotificationIdentifier.actiontwoTitle.rawValue)
        //let action3 = UNNotificationAction(identifier: "reconfigure", title: "Reconfigure", options: [.foreground])
        let cat = UNNotificationCategory(identifier: NotificationIdentifier.categoryIdentifier.rawValue,
                                         actions: [action1, action2],
                                         intentIdentifiers: [],
                                         options: [.customDismissAction])
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([cat])
    }
    
    func notificationAuthorization() -> Bool {
        var isAuthorized = false
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options:[.alert, .sound]) { ok, err in
                    if let err = err {
                        print(err); return
                    }
                    if ok {
                        isAuthorized = true
                    }
                }
            case .denied: break
            case .authorized:
                isAuthorized = true
            }
        }
        return isAuthorized
    }
    
    func schedule(_ notification: NotificationItem) {
        let interval = Double(notification.intervalInMinutes)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval * 15, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = notification.category
        content.body = notification.alertText
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = NotificationIdentifier.categoryIdentifier.rawValue
        let url = Bundle.main.url(forResource: notification.image, withExtension: "png")!
        if let att = try? UNNotificationAttachment(
            identifier: "att", url: url, options:nil) {
            content.attachments = [att]
        }
        let req = UNNotificationRequest(identifier: NotificationIdentifier.requestIdentifier.rawValue, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(req)
    }
    
    
    func loadNotificationData(callback: (() -> ())? = .none) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let group = DispatchGroup()
        let dataSaveQueue = DispatchQueue(label: "com.ronylevari.iLittle.dataSave")
        
        group.enter()
        notificationCenter.getNotificationSettings { (settings) in
            dataSaveQueue.async(execute: {
                let settingProvider = settings
                //update something
                group.leave()
            })
        }
        
        group.enter()
        notificationCenter.getPendingNotificationRequests { (requests) in
            dataSaveQueue.async(execute: {
                let pendingProvider = requests
                //update something
                group.leave()
            })
            
        }
        
        group.enter()
        notificationCenter.getDeliveredNotifications { (notifications) in
            dataSaveQueue.async(execute: {
                let deliveredProvider = notifications
                //update something
                group.leave()
            })
            
        }
        
        group.notify(queue: DispatchQueue.main) {
            if let callback = callback {
                callback()
            } else {
                // reload data
            }
        }
    }
    
    func removependingNotification(request: UNNotificationRequest) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [request.identifier])
        loadNotificationData(callback: {
            // delete the notification from where ever
        })
    }
    
    func applicationNotificationSettings() {
        
//        soundSetting
//        badgeSetting
//        alertSetting
//        notificationCenterSetting
//        lockScreenSetting
//        A UNNotificationSetting: .enabled, .disabled, or .notSupported.
//
//        alertStyle
//        A UNAlertStyle: .banner, .alert, or .none.
        
        let auth = settings?.authorizationStatus == .authorized
        let enabled = settings?.notificationCenterSetting == .enabled
        let sound = settings?.soundSetting == .enabled
        let badge = settings?.badgeSetting == .enabled
        let alert = settings?.alertSetting == .enabled
        let lockscreen = settings?.lockScreenSetting == .enabled
        let car = settings?.carPlaySetting == .enabled
        let banner = settings?.alertStyle == .banner
        print(auth, enabled, sound, badge, alert, lockscreen, car, banner)
    }
    
    func getPendingNotifications(request: UNNotificationRequest) {
        if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
            print("Scheduled: \(trigger.nextTriggerDate()!)")
        }
        
    }
    
    func getDeliveredNotifications(notification: UNNotification) {
        print(notification.request.content.title)
        print(notification.date)
    }
    
    func listen() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationReceived), name: userNotificationReceivedNotificationName, object: .none)
    }
    
    @objc func handleNotificationReceived() {
        loadNotificationData()
    }
    
    //    func scheduleNotification() {
    //        let content = UNMutableNotificationContent()
    //        content.title = "kusemek"
    //        content.subtitle = "ars"
    //        content.body = "arsabuk"
    //        content.categoryIdentifier = iLittleCategoryName
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
    //        let notificationRequest = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
    //
    //        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: {(error) in
    //            if let error = error {
    //                print(error)
    //            } else {
    //                print("notification scheduled")
    //            }
    //        })
    //    }

}

extension NotificatoinsController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // update database
        completionHandler(.sound)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> ()) {
        let id = response.actionIdentifier
        // Determine the user action
        switch id {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case NotificationIdentifier.actionOneIdentifier.rawValue:
            // update database for a hit
            print("done")
        case NotificationIdentifier.actionTwoIdentifier.rawValue:
            print("undone")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}
