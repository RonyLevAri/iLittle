//
//  ViewController.swift
//  iLittle
//
//  Created by rony_temp on 31/10/2017.
//  Copyright © 2017 rony_temp. All rights reserved.
//

import UIKit

class InitialLoginViewController: UIViewController {
    
    deinit {
        print("initial login dismissed")
    }
    
    //MARK: properties
    private var username: String?
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: view controller setup
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
    }
    
    //MARK: actions
    @IBAction func setInitialConfiguration(_ sender: UIButton) {
        usernameTextField.resignFirstResponder()
        username = usernameTextField.text == "" ? "Jhon Doe" : usernameTextField.text
        performSegue(withIdentifier: "configurationSegue", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let configurationViewController = segue.destination as? ConfigurationViewController {
            configurationViewController.username = username
        }
    }
}

extension InitialLoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


