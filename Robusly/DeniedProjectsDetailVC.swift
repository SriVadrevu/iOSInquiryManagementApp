//
//  DeniedProjectsDetailVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/9/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

class DeniedProjectsDetailVC: UIViewController {
    
    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientEmail: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstName = deniedProjects?.documents[indexDeniedProjects].data()["firstName"] as? String
        let lastName = deniedProjects?.documents[indexDeniedProjects].data()["lastName"] as? String
        clientName.text = firstName! + " " + lastName!
        date.text = deniedProjects?.documents[indexDeniedProjects].data()["date"] as? String
        phone.text = deniedProjects?.documents[indexDeniedProjects].data()["phoneNumber"] as? String
        location.text = deniedProjects?.documents[indexDeniedProjects].data()["location"] as? String
        clientEmail.text = deniedProjects?.documents[indexDeniedProjects].data()["email"] as? String
        let startTime = deniedProjects?.documents[indexDeniedProjects].data()["startTime"] as? String
        let endTime = deniedProjects?.documents[indexDeniedProjects].data()["endTime"] as? String
        timing.text = startTime! + " - " + endTime!
        notes.text = deniedProjects?.documents[indexDeniedProjects].data()["notes"] as? String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptDeniedProjects(_ sender: Any) {
        let acceptedJobData: [String: Any] = [
            "accepted": true,
            "bookingTitle": deniedProjects?.documents[indexDeniedProjects].data()["bookingTitle"] ?? "N/A",
            "created": deniedProjects?.documents[indexDeniedProjects].data()["created"] ?? "N/A",
            "date": deniedProjects?.documents[indexDeniedProjects].data()["date"] ?? "N/A",
            "email": deniedProjects?.documents[indexDeniedProjects].data()["email"] ?? "N/A",
            "endTime": deniedProjects?.documents[indexDeniedProjects].data()["endTime"] ?? "N/A",
            "firstName": deniedProjects?.documents[indexDeniedProjects].data()["firstName"] ?? "N/A",
            "lastName": deniedProjects?.documents[indexDeniedProjects].data()["lastName"] ?? "N/A",
            "location": deniedProjects?.documents[indexDeniedProjects].data()["location"] ?? "N/A",
            "notes": deniedProjects?.documents[indexDeniedProjects].data()["notes"] ?? "N/A",
            "phoneNumber": deniedProjects?.documents[indexDeniedProjects].data()["phoneNumber"] ?? "N/A",
            "startTime": deniedProjects?.documents[indexDeniedProjects].data()["startTime"] ?? "N/A",
            "acceptedAt": NSDate()
        ]
        
        docRefDPT.document((user?.email!)!).collection("activeJobs").document().setData(acceptedJobData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Job written to Active Jobs Collection! 😂")
                var documentID = deniedProjects?.documents[indexDeniedProjects].documentID
                let jobRef = docRefDPT.document((user?.email!)!).collection("deniedJobs").document(documentID!)
                jobRef.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Job deleted from Denied Jobs 😂")
                    }
                }
            }
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let bookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        self.present(bookingsVC, animated: true, completion: nil)
    }


}
