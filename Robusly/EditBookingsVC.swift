//
//  EditBookingsVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/20/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

class EditBookingsVC: UIViewController {

    
    @IBOutlet weak var bookingTitle: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var clientFirstName: UITextField!
    @IBOutlet weak var clientLastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var clientEmail: UITextField!
    @IBOutlet weak var notes: UITextField!
    
    var documentID: String?
    var collectionName: String?
    var editedDocRef: DocumentReference?
    //var documentReference
    
    @IBAction func makeChangesBooking(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        let editedJobData: [String: Any] = [
            "bookingTitle": self.bookingTitle.text!,
            "date": self.date.text!,
            "email": self.clientEmail.text!,
            "startTime": self.startTime.text!,
            "endTime": self.endTime.text!,
            "firstName": self.clientFirstName.text!,
            "lastName": self.clientLastName.text!,
            "location": self.location.text!,
            "notes": self.notes.text!,
            "phoneNumber": self.phoneNumber.text!
        ]
        
        editedDocRef!.setData(editedJobData, merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Job edited successfully! 😂")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Booking"
        
        // End editing for keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        print(self.documentID!)
        print(self.collectionName!)
        self.editedDocRef = Firestore.firestore().collection("Photographers").document((user?.email!)!).collection(collectionName!).document(documentID!)
        self.editedDocRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                print(type(of: document))
                self.bookingTitle.text = document.data()?["bookingTitle"] as? String
                self.date.text = document.data()?["date"] as? String
                self.startTime.text = document.data()?["startTime"] as? String
                self.endTime.text = document.data()?["endTime"] as? String
                self.location.text = document.data()?["location"] as? String
                self.clientFirstName.text = document.data()?["firstName"] as? String
                self.clientLastName.text = document.data()?["lastName"] as? String
                self.phoneNumber.text = document.data()?["phoneNumber"] as? String
                self.clientEmail.text = document.data()?["email"] as? String
                self.notes.text = document.data()?["notes"] as? String
            } else {
                print("Document does not exist")
            }
        }
    }

}
