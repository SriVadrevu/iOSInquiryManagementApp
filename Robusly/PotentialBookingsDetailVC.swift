//
//  PotentialBookingsDetailVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/4/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

class PotentialBookingsDetailVC: UIViewController {

    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var clientEmail: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    @objc func editSegue() {
        performSegue(withIdentifier: "editFromPotentialProject", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editFromPotentialProject") {
            let editBookingsVC = segue.destination as! EditBookingsVC
            editBookingsVC.documentID = potentialBookings?.documents[indexPotentialBookings].documentID
            editBookingsVC.collectionName = "activeJobs"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add edit button to our nav bar, and connect to functionality
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSegue))
        
        bookingTitle.text  = potentialBookings?.documents[indexPotentialBookings].data()["bookingTitle"] as? String
        var firstName = potentialBookings?.documents[indexPotentialBookings].data()["firstName"] as? String
        var lastName = potentialBookings?.documents[indexPotentialBookings].data()["lastName"] as? String
        clientName.text = firstName! + " " + lastName!
        
        date.text = potentialBookings?.documents[indexPotentialBookings].data()["date"] as? String
        phone.text = potentialBookings?.documents[indexPotentialBookings].data()["phoneNumber"] as? String
        location.text = potentialBookings?.documents[indexPotentialBookings].data()["location"] as? String
        clientEmail.text = potentialBookings?.documents[indexPotentialBookings].data()["email"] as? String
        let startTime = potentialBookings?.documents[indexPotentialBookings].data()["startTime"] as? String
        let endTime = potentialBookings?.documents[indexPotentialBookings].data()["endTime"] as? String
        timing.text = startTime! + " - " + endTime!
        notes.text = potentialBookings?.documents[indexPotentialBookings].data()["notes"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func acceptPotentialBooking(_ sender: Any) {
        let documentID = potentialBookings?.documents[indexPotentialBookings].documentID
        let jobRef = docRef.document((user?.email!)!).collection("activeJobs").document(documentID!)
        jobRef.updateData([
            "accepted": true,
            "acceptedAt": NSDate()
        ]) { err in
            if let err = err {
                print("Error updating job to be accepted: \(err) 🐜")
            } else {
                print("Successfully set job as accepted. 😂")
            }
        }
        
        print("Booking to be Accepted")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let pBookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        self.present(pBookingsVC, animated: true, completion: nil)

    }
    
    
    @IBAction func declinePotentialBooking(_ sender: Any) {
        
        let deniedJobData: [String: Any] = [
            "bookingTitle": potentialBookings?.documents[indexPotentialBookings].data()["bookingTitle"] ?? "N/A",
            "created": potentialBookings?.documents[indexPotentialBookings].data()["created"] ?? "N/A",
            "date": potentialBookings?.documents[indexPotentialBookings].data()["date"] ?? "N/A",
            "email": potentialBookings?.documents[indexPotentialBookings].data()["email"] ?? "N/A",
            "endTime": potentialBookings?.documents[indexPotentialBookings].data()["endTime"] ?? "N/A",
            "firstName": potentialBookings?.documents[indexPotentialBookings].data()["firstName"] ?? "N/A",
            "lastName": potentialBookings?.documents[indexPotentialBookings].data()["lastName"] ?? "N/A",
            "location": potentialBookings?.documents[indexPotentialBookings].data()["location"] ?? "N/A",
            "notes": potentialBookings?.documents[indexPotentialBookings].data()["notes"] ?? "N/A",
            "phoneNumber": potentialBookings?.documents[indexPotentialBookings].data()["phoneNumber"] ?? "N/A",
            "startTime": potentialBookings?.documents[indexPotentialBookings].data()["startTime"] ?? "N/A",
            "deniedAt": NSDate()
        ]
        
        docRef.document((user?.email!)!).collection("deniedJobs").document().setData(deniedJobData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Job written to Denied Jobs Collection! 😂")
                let documentID = potentialBookings?.documents[indexPotentialBookings].documentID
                let jobRef = docRef.document((user?.email!)!).collection("activeJobs").document(documentID!)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
