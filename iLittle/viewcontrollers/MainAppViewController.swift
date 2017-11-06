//
//  MainAppControlScreenViewController.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class MainAppViewController: UIViewController {

    deinit {
        print("initial login dismissed")
    }
    
    //MARK: propertires
    var username: String?
    var data = [NotificationItem]()
    weak var onBoardFlowNavigationController: UINavigationController?
    fileprivate let columns = CGFloat(1)
    fileprivate let inset = CGFloat(8)
    fileprivate let columnSpacing = CGFloat(0)
    fileprivate let rowSpacing = CGFloat(8)
    @IBOutlet weak var viewCollection: UICollectionView!
    @IBOutlet weak var alabel: UILabel!
    lazy var dataAccessObject: FirebaseAccessObject = FirebaseAccessObject.sharedInstance
    private var isAuthorized = false
    var notificationCenterAccessObject: NotificatoinsController?
   
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call notification center to request authorization
        notificationCenterAccessObject = NotificatoinsController.sharedInstance
        notificationCenterAccessObject!.delegate = self
        isAuthorized = notificationCenterAccessObject!.notificationAuthorization()
        if(!isAuthorized) {
            // implement non happy path
        }
        // hook with database
        if let uid = AppFileDataAccessObject.sharedInstance.readNameFromFile() {
            dataAccessObject.delegate = self
            dataAccessObject.listenToDataChanges(forUser: uid)
        }
        
        // configure collection view
        viewCollection.delegate = self
        viewCollection.dataSource = self
        viewCollection.register(UINib(nibName: "MainNotificationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "notificationCell")
    }
}

extension MainAppViewController: FirebasedataAccessDelgate {
    
    func dataChangedFor(_ user: User) {
        self.user = user
        data = user.notifications
        viewCollection.reloadData()
        alabel.text = user.username
    }
}

extension MainAppViewController: MainNotificationCellDelegate {
    
    func done(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            data[indexPath.item].hits += 1
            dataAccessObject.updateHitFor(uid: (user?.uid)!, nid: (data[indexPath.item].uid)!, hits: data[indexPath.item].hits)
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func refresh(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
            // resert notification
            dataAccessObject.startTimerFor(uid: (user?.uid)!, nid: (data[indexPath.item].uid)!, interval: data[indexPath.item].intervalInMinutes)
        }
    }
    func cont(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            data[indexPath.item].isActive = !data[indexPath.item].isActive
            notificationCenterAccessObject?.schedule(data[indexPath.item])
            dataAccessObject.startTimerFor(uid: (user?.uid)!, nid: (data[indexPath.item].uid)!, interval: data[indexPath.item].intervalInMinutes)
            // viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func showStatistics(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
            // fetch relevant data and suege to stat view
        }
    }
    func edit(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
            // fetch relevant data and segue to edit page
        }
    }
    func trash(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
            // update database and clear from UI 
        }
    }
}

extension MainAppViewController: UICollectionViewDelegate {
    // cell specific display setup
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! MainNotificationCollectionViewCell
        cell.notificationCellDelegate = self
        let item = data[indexPath.item]
        cell.mainImage.image = UIImage(named: item.image)
        cell.setToolBar(play: item.isActive)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped at \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false // all cell items you do not want to be selectable
    }
}

extension MainAppViewController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notificationCell", for: indexPath) as! MainNotificationCollectionViewCell
        return cell
    }
}

//MARK: flow layout delegate
extension MainAppViewController: UICollectionViewDelegateFlowLayout {
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
        let width = Int((collectionView.frame.width / columns) - (inset * 2))
        return CGSize(width: width, height: (width / 2))
    }
}

extension MainAppViewController: NotificationControllerDelegate {
    func userCompliedWith(notification: UNNotificationResponse) {
        // update database
    }
}
