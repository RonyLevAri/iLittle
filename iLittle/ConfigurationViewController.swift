//
//  ConfigurationViewController.swift
//  iLittle
//
//  Created by rony_temp on 03/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit
import UserNotifications

class ConfigurationViewController: UIViewController {
    
    //MARK: properties
    var username: String?
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
    fileprivate let columns = CGFloat(2)
    fileprivate let inset = CGFloat(8)
    fileprivate let columnSpacing = CGFloat(8)
    fileprivate let rowSpacing = CGFloat(8)
    @IBOutlet weak var notificationCollectionView: UICollectionView!
    
    // todo: extract to external configuration file
    var data = [NotificationCategory]()
    
    //MARK view controller setup
    override func viewDidLoad() {
        print(username!)
        notificationCollectionView.delegate = self
        notificationCollectionView.dataSource = self
        notificationCollectionView.register(UINib(nibName: "ConfigurationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectionCell")
        data.append(NotificationCategory(protocolName: "hara"))
        data.append(NotificationCategory(protocolName: "pipi"))
        data.append(NotificationCategory(protocolName: "kaki"))
    }
    
    //MARK: custom methods
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
}

extension ConfigurationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ConfigurationCollectionViewCell {
            cell.icon.image = UIImage(named: "heartbeat256")
        } else {
            print("no such cell")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tappedt at \(indexPath.section) \(indexPath.item)")
    }
}

extension ConfigurationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let rows = Int((data.count / Int(columns))) + 1
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(columns)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! ConfigurationCollectionViewCell
        return cell
    }
    
}

extension ConfigurationViewController: UICollectionViewDelegateFlowLayout {

    // add insets to the entire collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    // row spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return rowSpacing
    }
    
    // column spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return columnSpacing
    }
    
    // set each cell's width and height, taking into account the inset size and column spacing (no need to calc for row spacing since view scrolls vertically)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((notificationCollectionView.frame.width / columns) - (inset + columnSpacing))
        return CGSize(width: width, height: width)
    }
    
}
