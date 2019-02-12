//
//  AddBookingVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/18/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

class AddBookingVC: UIViewController {

    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var location: UITextField!
    
    private var datePicker: UIDatePicker?
    private var startTimePicker: UIDatePicker?
    private var endTimePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // End editing for keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //---------------------------------------------
        // Set Up Bottom Border Styles for Text Fields
        //---------------------------------------------
        jobTitle.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        firstName.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        lastName.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        date.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        startTime.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        endTime.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        location.setBottomBorderStyle(color: UIColor.lightGray.cgColor)
        
        //--------------------
        // Set up Date Picker
        //--------------------
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        date.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AddBookingVC.dateChanged))
        toolbar.setItems([doneButton], animated: true)
        date.inputAccessoryView = toolbar
        
        //--------------------------
        // Set up Start Time Picker
        //--------------------------
        startTimePicker = UIDatePicker()
        startTimePicker?.datePickerMode = .time
        startTime.inputView = startTimePicker
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AddBookingVC.startTimeChanged))
        toolbar2.setItems([doneButton2], animated: true)
        startTime.inputAccessoryView = toolbar2
        
        //------------------------
        // Set up End Time Picker
        //------------------------
        endTimePicker = UIDatePicker()
        endTimePicker?.datePickerMode = .time
        endTime.inputView = endTimePicker
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AddBookingVC.endTimeChanged))
        toolbar3.setItems([doneButton3], animated: true)
        endTime.inputAccessoryView = toolbar3
    }
    
    //----------------------
    //  Set up Date Picker
    //----------------------
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        date.text = dateFormatter.string(from: datePicker!.date)
        self.view.endEditing(true)
    }

    //--------------------------
    // Set up Start Time Picker
    //--------------------------
    @objc func startTimeChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        startTime.text = dateFormatter.string(from: (startTimePicker?.date)!)
        view.endEditing(true)
    }
    
    //------------------------
    // Set up End Time Picker
    //------------------------
    @objc func endTimeChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        endTime.text = dateFormatter.string(from: (endTimePicker?.date)!)
        view.endEditing(true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------
    // Add Booking
    //--------------
    @IBAction func addBooking(_ sender: Any) {
        
        let newBookingData: [String: Any] = [
            "accepted": true,
            "bookingTitle": jobTitle.text ?? "N/A",
            "created": NSDate(),
            "date": date.text ?? "N/A",
            "email": "N/A",
            "endTime": endTime.text ?? "N/A",
            "firstName": firstName.text ?? "N/A",
            "lastName": lastName.text ?? "N/A",
            "location": location.text ?? "N/A",
            "notes": "N/A",
            "phoneNumber": "N/A",
            "startTime": startTime.text ?? "N/A",
            "acceptedAt": NSDate(),
        ]
        
        docRef.document((user?.email!)!).collection("activeJobs").document().setData(newBookingData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("New Booking written to Active Jobs Collection! 😂")
            }
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let bookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
        self.present(bookingsVC, animated: true, completion: nil)
    }
    


}
