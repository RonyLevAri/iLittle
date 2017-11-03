//
//  AppFileDataAccessObject.swift
//  iLittle
//
//  Created by rony_temp on 03/11/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import Foundation
import UIKit

class AppFileDataAccessObject {
    
    //MARK: object singleton reference
    static let sharedInstance = AppFileDataAccessObject()
    
    private init() {
        
    }
    
    //MARK: properties
    let filename = "username"
    lazy var filepath: URL? = {
        do {
            let fm = FileManager.default
            let suppurl = try fm.url(for:.applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let file = suppurl.appendingPathComponent(filename).appendingPathExtension("txt")
            return file
        } catch {
            return nil
        }
    }()
    
    //MARK: actions
    // function assambled based on following SOF thread: https://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
    func saveUserNameToFile(_ name: String) {
        do {
            if let file = filepath {
                try name.write(to: file, atomically: true, encoding:.utf8)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readNameFromFile() -> String? {
        var username = ""
        do {
            if let file = filepath {
                username = try String(contentsOf: file)
            }
            return username
        } catch {
            return nil
        }
    }
    
    func deleteFile() {
        do {
            let fm = FileManager.default
            if let file = filepath {
                try fm.removeItem(at: file)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
