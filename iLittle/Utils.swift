//
//  Utils.swift
//  iLittle
//
//  Created by rony_temp on 06/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation

class Utils {
    // taken from https://www.safaribooksonline.com/library/view/programming-ios-11/9781491999219/part04app02.html#appb

    static func delay(_ delay:Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}
