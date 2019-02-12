//
//  CompletedBookingsVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/11/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit

class CompletedBookingsVC: UIViewController {

    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var clientEmail: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    @objc func editSegue() {
        performSegue(withIdentifier: "editFromCompletedProject", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editFromCompletedProject") {
            let editBookingsVC = segue.destination as! EditBookingsVC
            editBookingsVC.documentID = completedBookings?.documents[indexCurrentBookings].documentID
            editBookingsVC.collectionName = "completedJobs"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add edit button to our nav bar, and connect to functionality
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSegue))
        
        bookingTitle.text = completedBookings?.documents[indexCurrentBookings].data()["bookingTitle"] as? String
        date.text = completedBookings?.documents[indexCurrentBookings].data()["date"] as? String
        phoneNumber.text = completedBookings?.documents[indexCurrentBookings].data()["phoneNumber"] as? String
        location.text = completedBookings?.documents[indexCurrentBookings].data()["location"] as? String
        clientEmail.text = completedBookings?.documents[indexCurrentBookings].data()["email"] as? String
        let startTime = completedBookings?.documents[indexCurrentBookings].data()["startTime"] as? String
        let endTime = completedBookings?.documents[indexCurrentBookings].data()["endTime"] as? String
        timing.text = startTime! + " - " + endTime!
        notes.text = completedBookings?.documents[indexCurrentBookings].data()["notes"] as? String
        let firstName = completedBookings?.documents[indexCurrentBookings].data()["firstName"] as! String
        let lastName = completedBookings?.documents[indexCurrentBookings].data()["lastName"] as! String
        clientName.text = firstName + " " + lastName
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func reviveBooking(_ sender: Any) {
    
        let acceptedJobData: [String: Any] = [
            "accepted": true,
            "bookingTitle": completedBookings?.documents[indexCurrentBookings].data()["bookingTitle"] ?? "N/A",
            "acceptedAt": completedBookings?.documents[indexCurrentBookings].data()["acceptedAt"] ?? "N/A",
            "created": completedBookings?.documents[indexCurrentBookings].data()["created"] ?? "N/A",
            "date": completedBookings?.documents[indexCurrentBookings].data()["date"] ?? "N/A",
            "email": completedBookings?.documents[indexCurrentBookings].data()["email"] ?? "N/A",
            "endTime": completedBookings?.documents[indexCurrentBookings].data()["endTime"] ?? "N/A",
            "firstName": completedBookings?.documents[indexCurrentBookings].data()["firstName"] ?? "N/A",
            "lastName": completedBookings?.documents[indexCurrentBookings].data()["lastName"] ?? "N/A",
            "location": completedBookings?.documents[indexCurrentBookings].data()["location"] ?? "N/A",
            "notes": completedBookings?.documents[indexCurrentBookings].data()["notes"] ?? "N/A",
            "phoneNumber": completedBookings?.documents[indexCurrentBookings].data()["phoneNumber"] ?? "N/A",
            "startTime": completedBookings?.documents[indexCurrentBookings].data()["startTime"] ?? "N/A"
        ]
        
        docRef.document((user?.email!)!).collection("activeJobs").document().setData(acceptedJobData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Job written to Active Jobs Collection! 😂")
                let documentID = completedBookings?.documents[indexCurrentBookings].documentID
                let jobRef = docRef.document((user?.email!)!).collection("completedJobs").document(documentID!)
                jobRef.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Job deleted from Completed Jobs 😂")
                    }
                }
            }
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let pBookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        self.present(pBookingsVC, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
