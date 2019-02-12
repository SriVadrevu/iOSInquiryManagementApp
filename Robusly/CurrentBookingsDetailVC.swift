//
//  CurrentBookingsDetailVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/4/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

class CurrentBookingsDetailVC: UIViewController {

    // Declare all connections for our labels
    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var clientEmail: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var completeButton: UIImageView!
    
    @objc func editSegue() {
        performSegue(withIdentifier: "editFromCurrentProject", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editFromCurrentProject") {
            let editBookingsVC = segue.destination as! EditBookingsVC
            editBookingsVC.documentID = currentBookings?.documents[indexCurrentBookings].documentID
            editBookingsVC.collectionName = "activeJobs"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add edit button to our nav bar, and connect to functionality
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSegue))

        // Add tap gesture recognizer so check mark image can act as button
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(completeButtonTapped(tapGestureRecognizer:)))
        completeButton.isUserInteractionEnabled = true
        completeButton.addGestureRecognizer(tapGestureRecognizer)
        
        // Let's assign labels with data dependent on which current booking user clicked
        bookingTitle.text = currentBookings?.documents[indexCurrentBookings].data()["bookingTitle"] as? String
        date.text = currentBookings?.documents[indexCurrentBookings].data()["date"] as? String
        phoneNumber.text = currentBookings?.documents[indexCurrentBookings].data()["phoneNumber"] as? String
        location.text = currentBookings?.documents[indexCurrentBookings].data()["location"] as? String
        clientEmail.text = currentBookings?.documents[indexCurrentBookings].data()["email"] as? String
        let startTime = currentBookings?.documents[indexCurrentBookings].data()["startTime"] as? String
        let endTime = currentBookings?.documents[indexCurrentBookings].data()["endTime"] as? String
        timing.text = startTime! + " - " + endTime!
        let firstName = currentBookings?.documents[indexCurrentBookings].data()["firstName"] as! String
        let lastName = currentBookings?.documents[indexCurrentBookings].data()["lastName"] as! String
        clientName.text = firstName + " " + lastName
        notes.text = currentBookings?.documents[indexCurrentBookings].data()["notes"] as? String
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //----------------------------------------------------
    // Set Booking as Completed & Reflect Change Database
    //----------------------------------------------------
    @objc func completeButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let completedJobData: [String: Any] = [
            "accepted": true,
            "bookingTitle": currentBookings?.documents[indexCurrentBookings].data()["bookingTitle"] ?? "N/A",
            "created": currentBookings?.documents[indexCurrentBookings].data()["created"] ?? "N/A",
            "date": currentBookings?.documents[indexCurrentBookings].data()["date"] ?? "N/A",
            "email": currentBookings?.documents[indexCurrentBookings].data()["email"] ?? "N/A",
            "startTime": currentBookings?.documents[indexCurrentBookings].data()["startTime"] ?? "N/A",
            "endTime": currentBookings?.documents[indexCurrentBookings].data()["endTime"] ?? "N/A",
            "firstName": currentBookings?.documents[indexCurrentBookings].data()["firstName"] ?? "N/A",
            "lastName": currentBookings?.documents[indexCurrentBookings].data()["lastName"] ?? "N/A",
            "location": currentBookings?.documents[indexCurrentBookings].data()["location"] ?? "N/A",
            "notes": currentBookings?.documents[indexCurrentBookings].data()["notes"] ?? "N/A",
            "phoneNumber": currentBookings?.documents[indexCurrentBookings].data()["phoneNumber"] ?? "N/A",
            "acceptedAt": currentBookings?.documents[indexCurrentBookings].data()["acceptedAt"] ?? "N/A",
            "completedAt": NSDate()
        ]
        
        docRefCBT.document((user?.email!)!).collection("completedJobs").document().setData(completedJobData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Job written to Completed Jobs Collection! 😂")
                let documentID = currentBookings?.documents[indexCurrentBookings].documentID
                let jobRef = docRefCBT.document((user?.email!)!).collection("activeJobs").document(documentID!)
                jobRef.delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Job deleted from Active Jobs 😂")
                    }
                }
            }
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let pBookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        self.present(pBookingsVC, animated: true, completion: nil)
        
    }

    
    
}
