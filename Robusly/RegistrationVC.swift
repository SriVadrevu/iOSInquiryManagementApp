//
//  RegistrationVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 9/27/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

struct ProfileData {
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var username: String?
    var phoneNumber: String?
}

var profileData = ProfileData(firstName: "N/A", lastName: "N/A", email: "N/A", password: "N/A", username: "N/A", phoneNumber: "N/A")

class RegistrationVC: UIViewController {
    
    var handle: NSObjectProtocol?
    let db = Firestore.firestore()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordReenterTextField: UITextField!
    @IBOutlet weak var username: UITextField!
    var accountToBeCreated: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // End editing for keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        emailTextField.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        firstNameTextField.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        lastNameTextField.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        phoneNumberTextField.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        passwordTextField.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        passwordReenterTextField.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        username.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Detach listener when leaving the view
        //        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    //------------------------------------
    // Register Account Information First
    //------------------------------------
    @IBAction func registerAccountInfo(_ sender: UIButton) {
        // Let's use nil coalescing to unwrap all the text fields
        if let email = emailTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let password = passwordTextField.text, let reenterPassword = passwordReenterTextField.text, let username = username.text {
            
            profileData.firstName = firstName
            profileData.email = email
            profileData.lastName = lastName
            profileData.password = password
            profileData.username = username
            profileData.phoneNumber = self.phoneNumberTextField.text
            self.performSegue(withIdentifier: "segueProfileRegistration", sender: self)
            
        }
    }
    
    
}

//                if Sri (sucks) at code
//                THREAD_NULL
//                shut
//                -Nadim was here, CEO baby ;) 🙂
