//
//  FormViewController.swift
//  quokka
//
//  Created by Sri Vadrevu on 9/24/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import FirebaseAuth

class FormViewController: UIViewController {

    var handle: NSObjectProtocol?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var pricingDescriptionTextField: UITextField!
    @IBOutlet weak var venmoTagTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordReenterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        // Attaching listener to FIRAuth object to see if user is logged in.
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            // ...
//        }
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
        if let email = emailTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let password = passwordTextField.text, let reenterPassword = passwordReenterTextField.text {
        
            // Let's create user in Firebase and update FireStore
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                guard let user = authResult?.user else {
                    print("User Account unable to be created")
                    return
                }
                print("Account Successfully Registered! :-D!")
            }
        
        }
    }
    
    
}
