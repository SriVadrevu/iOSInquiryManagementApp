//
//  SettingsVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/3/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------
    // Log Out User and Go Back to Log In Screen
    //-------------------------------------------
    @IBAction func LogOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        print("(Settings) Successfully Logged Out 😂")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let bookingsVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
        self.present(bookingsVC, animated: true, completion: nil)
    }

}
