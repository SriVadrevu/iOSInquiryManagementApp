//
//  PotentialBookingsTableVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/3/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

let user = Auth.auth().currentUser
var potentialBookings: QuerySnapshot? = nil
let reuseIdentifier = "potentialBookingsCell"
let docRef = Firestore.firestore().collection("Photographers")
var numberOfRows: Int! = 0
var indexPotentialBookings: Int! = 1
var potentialBookingsListener: ListenerRegistration!

class PotentialBookingsTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register default table view cell as Nib so we can use it if no projects
        self.tableView.register(UINib(nibName: "NoProjectsCell", bundle: nil), forCellReuseIdentifier: "noProjectsCell")

        // Take out table lines and gray color
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Set up our logo as the nav bar title
        let logo = UIImage(named: "robuslylogo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        if let user = user {
            docRef.document(user.email!).collection("activeJobs").whereField("accepted", isEqualTo: false)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        potentialBookings = querySnapshot
                        numberOfRows = potentialBookings!.count
                        self.tableView.reloadData()
                    }
            }
            
        } else {
            print("failed")
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //--------------------------------------------------------------
    // Number of Sections (1 section needed for Potential Bookings)
    //--------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if numberOfRows == 0 {
            return 1
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if numberOfRows == 0 {
            let noBookings = tableView.dequeueReusableCell(withIdentifier: "noProjectsCell", for: indexPath) as! NoProjectsCell
            return noBookings
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PotentialBookingCell
        
        let firstName = potentialBookings?.documents[indexPath.row].data()["firstName"] as? String
        let lastName = potentialBookings?.documents[indexPath.row].data()["lastName"] as? String
        cell.clientName.text = firstName! + " " + lastName!
        let startTime = potentialBookings?.documents[indexPath.row].data()["startTime"] as? String
        let endTime = potentialBookings?.documents[indexPath.row].data()["endTime"] as? String
        let timing = startTime! + " - " + endTime!
        cell.clientBookingDate.text = potentialBookings?.documents[indexPath.row].data()["date"] as? String
        cell.clientBookingTime.text = timing
        cell.clientBookingLocation.text = potentialBookings?.documents[indexPath.row].data()["location"] as? String
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPotentialBookings = indexPath.row
        if numberOfRows != 0 {
            performSegue(withIdentifier: "showPotentialBookingsTableVC", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        potentialBookingsListener = docRef.document((user?.email!)!).collection("activeJobs").whereField("accepted", isEqualTo: false).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                potentialBookings = querySnapshot
                numberOfRows = potentialBookings!.count
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        potentialBookingsListener.remove()
    }
    
    //---------------------------------
    //  UI Design for our Job Headers
    //---------------------------------
    class JobsLabelHeader: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor(red:0.96, green:0.29, blue:0.25, alpha:1.0)
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = 10
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 16, height: originalContentSize.height + 12)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = JobsLabelHeader()
        label.text = "Potential Jobs"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

}
