//
//  UserTabBarController.swift
//  quokka
//
//  Created by Sri Vadrevu on 9/28/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

var tabBarListener: ListenerRegistration!

class UserTabBarController: UITabBarController {

    @IBOutlet weak var appTabBar: UITabBar!
    var badgeNumber: String?
    let linkButton = UIButton.init(type: .custom)
    
    var popup:UIView!
    var alert: UIAlertController!
    
    func showAlert() {
        self.alert = UIAlertController(title: "Copied!", message: "Your personal link has been copied!", preferredStyle: UIAlertControllerStyle.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(UserTabBarController.dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    func addLinkButton() {
        linkButton.setImage(UIImage(named: "red_link"), for: .normal)
        linkButton.frame = CGRect(x: 100, y: 0, width: 70, height: 70)
        linkButton.addTarget(self, action: #selector(buttonCopyLink), for: .touchUpInside)
        self.view.insertSubview(linkButton, aboveSubview: self.tabBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        linkButton.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 70, height: 70)
        linkButton.layer.cornerRadius = 32
    }
    
    @objc func buttonCopyLink() {
        print("Button tapped")
        UIPasteboard.general.string = "postbite.co/ask/" + "\(String(describing: (user?.email!)!))"
        showAlert()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 0
        
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        addLinkButton()
        
        if let user = user {
            docRef.document(user.email!).collection("activeJobs").whereField("accepted", isEqualTo: false)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        self.tabBar.items?[1].badgeValue = "\(querySnapshot!.count)"
                        self.tabBar.items?[1].badgeColor = UIColor.red
                        if querySnapshot!.count == 0 {
                            self.tabBar.items?[1].badgeValue = nil
                        }
                    }
            }
        } else {
            print("failed")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarListener = docRef.document((user?.email!)!).collection("activeJobs").whereField("accepted", isEqualTo: false).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                self.tabBar.items?[1].badgeValue = "\(querySnapshot!.count)"
                self.tabBar.items?[1].badgeColor = UIColor.red
                if querySnapshot!.count == 0 {
                    self.tabBar.items?[1].badgeValue = nil
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tabBarListener.remove()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
