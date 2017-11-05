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
    
    deinit {
        print("configuration dismissed")
    }
    
    //MARK: properties
    var username: String?
    fileprivate let columns = CGFloat(2)
    fileprivate let inset = CGFloat(8)
    fileprivate let columnSpacing = CGFloat(8)
    fileprivate let rowSpacing = CGFloat(8)
    @IBOutlet weak var notificationCollectionView: UICollectionView!
    @IBOutlet weak var welcomLabel: UILabel!
    private var notificationsAuthorizedByUser = false
    
    // todo: extract to external configuration file
    var data = [NotificationItem]()
    
    //MARK: actions
    @IBAction func gotoMainAppScreen(_ sender: UIButton) {
        doInitialAuthorizationFlow()
        if(notificationsAuthorizedByUser) {
            //todo: why isn't call on second time??
        } else {
            //todo: complete non happy path
        }
        FirebaseAccessObject.sharedInstance.saveNotifications(data)
        performSegue(withIdentifier: "mainScreensegue", sender: self)
    }
    
    //MARK view controller setup
    override func viewDidLoad() {
        welcomLabel.text = "Welcome \(username!)!"
        notificationCollectionView.delegate = self
        notificationCollectionView.dataSource = self
        notificationCollectionView.register(UINib(nibName: "ConfigurationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectionCell")
        data.append(NotificationItem(category: "drinking", image: "lemonade_glass256", user: username!))
        data.append(NotificationItem(category: "moving", image: "step256", user: username!))
        data.append(NotificationItem(category: "nositting", image: "heartbeat256", user: username!))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mainViewController = segue.destination as? MainAppViewController {
            mainViewController.username = username
            mainViewController.data = data
            mainViewController.onBoardFlowNavigationController = self.view.window!.rootViewController as? UINavigationController
        }
    }
    
    //MARK: custom methods
    func doInitialAuthorizationFlow() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings(completionHandler: { [unowned self] (settings) in
            if(settings.authorizationStatus == .authorized) {
                self.notificationsAuthorizedByUser = true
            } else {
                // User has not given permissions
                center.requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {(granted, error) in
                    if let error = error {
                        print(error)
                    } else {
                        if(granted) {
                            self.notificationsAuthorizedByUser = true
                        }
                    }
                })
            }
        })
    }
}

//MARK: flow collectionview delegate
extension ConfigurationViewController: UICollectionViewDelegate {
    
    // cell specific display setup
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ConfigurationCollectionViewCell
        let item = data[indexPath.item]
        cell.icon.image = UIImage(named: item.image)
        cell.checkFeedback.image = item.isActive ? UIImage(named: "green_circle_check") : UIImage(named: "gray_circle_check")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data[indexPath.item].isActive = !data[indexPath.item].isActive
        let indexes = [indexPath,]
        notificationCollectionView.reloadItems(at: indexes)
    }
}

//MARK: flow datasource delegate
extension ConfigurationViewController: UICollectionViewDataSource {
    
    // return number of sections in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // returns how many items in each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    // return cell type for item at
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! ConfigurationCollectionViewCell
        return cell
    }
    
}

//MARK: flow layout delegate
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
