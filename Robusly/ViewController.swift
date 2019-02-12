//
//  ViewController.swift
//  quokka
//
//  Created by Sri Vadrevu on 9/20/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension UITextField {
    func setBottomBorderStyle(color: CGColor) {
        
        // set proper padding & change color of placeholder text
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        // set bottom border
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

class ViewController: UIViewController {

    var handle: NSObjectProtocol?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setBottomBorderStyle(color: UIColor.white.cgColor)
        passwordTextField.setBottomBorderStyle(color: UIColor.white.cgColor)
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Attaching listener to FIRAuth object to see if user is logged in.
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if Auth.auth().currentUser != nil {
                print("Successfully logged in with UserID: \(user!.uid) and Email: \(user!.email!) 😂")
                self.displayBookingsLoggedIn(userID: user!.uid)
            } else {
                print("Not Signed in")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Detach listener when leaving the view
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    //---------------------
    // Log in User to App
    //---------------------
    @IBAction func logIn(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            // If forms are filled out, let's call sign in method from Firebase Auth
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let FirebaseError = error {
                    print("Log In failed")
                } else {
                    //Since user successfully signed in, let's get current user info
                    let user = Auth.auth().currentUser
                    if let user = user {
                        print("Successfully logged in with UserID: \(user.uid) and Email: \(user.email!) 😂")
                        self.displayBookingsLoggedIn(userID: user.uid)
                    }
                }
            }
        }
    }
    
    func displayBookingsLoggedIn(userID: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let bookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        self.present(bookingsVC, animated: true, completion: nil)
    }
}

