//
//  MainNotificationCollectionViewCell.swift
//  iLittle
//
//  Created by rony_temp on 04/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit

protocol MainNotificationCellDelegate: class {
    func done(deledatedFrom cell: MainNotificationCollectionViewCell)
    func refresh(deledatedFrom cell: MainNotificationCollectionViewCell)
    func cont(deledatedFrom cell: MainNotificationCollectionViewCell)
    func showStatistics(deledatedFrom cell: MainNotificationCollectionViewCell)
    func edit(deledatedFrom cell: MainNotificationCollectionViewCell)
    func trash(deledatedFrom cell: MainNotificationCollectionViewCell)
}
// class built with the help of https://www.youtube.com/watch?v=3d3vvqy37iA
class MainNotificationCollectionViewCell: UICollectionViewCell {
    
    //MARK: properties
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var label: UILabel!
    weak var notificationCellDelegate: MainNotificationCellDelegate?
    
    //MARK: actions
    @IBAction func done(_ sender: UIBarButtonItem) {
        notificationCellDelegate?.done(deledatedFrom: self)
    }
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        notificationCellDelegate?.refresh(deledatedFrom: self)
    }
    @IBAction func cont(_ sender: UIBarButtonItem) {
        notificationCellDelegate?.cont(deledatedFrom: self)
    }
    @IBAction func showStatistics(_ sender: UIBarButtonItem) {
        notificationCellDelegate?.showStatistics(deledatedFrom: self)
    }
    @IBAction func edit(_ sender: UIBarButtonItem) {
        notificationCellDelegate?.edit(deledatedFrom: self)
    }
    @IBAction func trash(_ sender: UIBarButtonItem) {
        notificationCellDelegate?.trash(deledatedFrom: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
