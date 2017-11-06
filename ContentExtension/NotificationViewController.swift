//
//  NotificationViewController.swift
//  ContentExtension
//
//  Created by rony_temp on 06/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 320, height: 80)
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let req = notification.request
        let content = req.content
        let atts = content.attachments
        
        self.label.text = content.body
        
        if let att = atts.first, att.identifier == "att" {
            if att.url.startAccessingSecurityScopedResource() {
                if let data = try? Data(contentsOf: att.url) {
                    self.image.image = UIImage(data: data)
                }
                att.url.stopAccessingSecurityScopedResource()
            }
        }
        self.view.setNeedsLayout()
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        let id = response.actionIdentifier
        // Determine the user action and provide visual feedback accordingly
        switch id {
        case UNNotificationDismissActionIdentifier:
            label.text = "Dismiss Action"
        case UNNotificationDefaultActionIdentifier:
            label.text = "Default"
        case "done":
            label.text = "done"
        case "undone":
            label.text = "undone"
        default:
            print("Unknown action")
        }
        
        NotificationViewController.delay(0.4) {
            completion(.dismissAndForwardAction)
        }
    }
}

extension NotificationViewController {
    static func delay(_ delay:Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
