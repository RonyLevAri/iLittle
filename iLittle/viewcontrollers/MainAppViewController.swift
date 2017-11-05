//
//  MainAppControlScreenViewController.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit

class MainAppViewController: UIViewController {

    //MARK: propertires
    var username: String?
    var data = [NotificationItem]()
    weak var onBoardFlowNavigationController: UINavigationController?
    fileprivate let columns = CGFloat(1)
    fileprivate let inset = CGFloat(8)
    fileprivate let columnSpacing = CGFloat(0)
    fileprivate let rowSpacing = CGFloat(20)
    @IBOutlet weak var viewCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCollection.delegate = self
        viewCollection.dataSource = self
        viewCollection.register(UINib(nibName: "MainNotificationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "notificationCell")
        loadUserData()
//        if onBoardFlowNavigationController != nil {
//            print("there is a view controller in prop!")
//            //onBoardFlowNavigationController?.popViewController(animated: true)
//            //onBoardFlowNavigationController?.dismiss(animated: true, completion: nil)
//        }
    }
    
    func loadUserData() {
        print(AppFileDataAccessObject.sharedInstance.readNameFromFile()!)
        // use file user key to retrieve data
    }
}

extension MainAppViewController: MainNotificationCellDelegate {
    
    func done(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func refresh(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func cont(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func showStatistics(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func edit(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
    func trash(deledatedFrom cell: MainNotificationCollectionViewCell) {
        if let indexPath = viewCollection.indexPath(for: cell) {
            viewCollection.reloadItems(at: [indexPath,])
        }
    }
}

extension MainAppViewController: UICollectionViewDelegate {
    // cell specific display setup
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("preparing cell")
        let cell = cell as! MainNotificationCollectionViewCell
        cell.notificationCellDelegate = self
        let item = data[indexPath.item]
        // cell.label.text = item.category
        if(cell.label.text == item.category) {
            cell.label.text = "changed"
        } else {
            cell.label.text = item.category
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped at \(indexPath)")
//        data[indexPath.item].isActive = !data[indexPath.item].isActive
//        let indexes = [indexPath,]
//        viewController.reloadItems(at: indexes)
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return false // all cell items you do not want to be selectable
//    }
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
