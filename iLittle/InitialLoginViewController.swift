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
    
    //MARK: attributes
    private var username: String?
    @IBOutlet weak var usernameTextField: UITextField!
    lazy var fileDataAccessobject = AppFileDataAccessObject.sharedInstance
    
    //MARK: view controller setup
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
    }
    
    //MARK: actions
    @IBAction func setInitialConfiguration(_ sender: UIButton) {
        usernameTextField.resignFirstResponder()
        fileDataAccessobject.saveUserNameToFile(usernameTextField.text ?? "Jhon Doe")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
    }
    
    //MARK: custom functions    
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
}

extension InitialLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


