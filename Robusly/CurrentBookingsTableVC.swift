//
//  CurrentBookingsTableVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/4/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

let userCBT = Auth.auth().currentUser
var currentBookings: QuerySnapshot? = nil
var completedBookings: QuerySnapshot? = nil
let reuseIdentifierCBT = "currentBookingsCell"
let docRefCBT = Firestore.firestore().collection("Photographers")
var indexCurrentBookings: Int! = 1
var currentBookingsListener: ListenerRegistration!

var numberOfRowsCBT = [0,0]
var titles = ["Accepted Jobs","Completed Jobs"]

class CurrentBookingsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register default table view cell as Nib so we can use it if no projects
        self.tableView.register(UINib(nibName: "NoProjectsCell", bundle: nil), forCellReuseIdentifier: "noProjectsCell")
        
        // Delete lines from table view and add gray background
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Set up our logo as the nav bar title
        let logo = UIImage(named: "robuslylogo.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit // set imageview's content mode
        self.navigationItem.titleView = imageView
        
        if let user = user {
            docRef.document(user.email!).collection("activeJobs").whereField("accepted", isEqualTo: true)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        currentBookings = querySnapshot
                        numberOfRowsCBT[0] = currentBookings!.count
                        
                        docRef.document(user.email!).collection("completedJobs").getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                }
                                else {
                                    completedBookings = querySnapshot
                                    numberOfRowsCBT[1] = completedBookings!.count
                                    self.tableView.reloadData()
                                }
                        }
                    }
            }
            
        } else {
            print("failed")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // if we have no completed projects, let's hide the job label header (section 2)
        if numberOfRowsCBT[1] == 0 {
            return 1
        }
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return 1 row to show no active projects in section 1
        if section == 0, numberOfRowsCBT[0] == 0 {
            return 1
        }
        return numberOfRowsCBT[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create cell that shows no projects in section 1 if we have no active projects
        if indexPath.section == 0, numberOfRowsCBT[0] == 0 {
            let noProjects = tableView.dequeueReusableCell(withIdentifier: "noProjectsCell", for: indexPath) as! NoProjectsCell
            return noProjects
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCBT, for: indexPath) as! CurrentBookingCell
        
        if indexPath.section == 0 {
            cell.bookingTitle.text = currentBookings?.documents[indexPath.row].data()["bookingTitle"] as? String
            cell.location.text = currentBookings?.documents[indexPath.row].data()["location"] as? String
            let startTime = currentBookings?.documents[indexPath.row].data()["startTime"] as? String
            let endTime = currentBookings?.documents[indexPath.row].data()["endTime"] as? String
            let timing = startTime! + " - " + endTime!
            cell.timing.text = timing
            cell.date.text = currentBookings?.documents[indexPath.row].data()["date"] as? String
            
        }
        if indexPath.section == 1 {
            cell.bookingTitle.text = completedBookings?.documents[indexPath.row].data()["bookingTitle"] as? String
            cell.location.text = completedBookings?.documents[indexPath.row].data()["location"] as? String
            let startTime = completedBookings?.documents[indexPath.row].data()["startTime"] as? String
            let endTime = completedBookings?.documents[indexPath.row].data()["endTime"] as? String
            let timing = startTime! + " - " + endTime!
            cell.timing.text = timing
            cell.date.text = completedBookings?.documents[indexPath.row].data()["date"] as? String
        }

        return cell
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
        label.text = titles[section]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexCurrentBookings = indexPath.row
        if indexPath.section == 0, numberOfRowsCBT[0] != 0 {
             performSegue(withIdentifier: "showCurrentBookingsTableVC", sender: self)
        }
        if indexPath.section == 1 {
             performSegue(withIdentifier: "showCompletedBookingsVC", sender: self)
        }
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentBookingsListener = docRef.document((user?.email!)!).collection("activeJobs").whereField("accepted", isEqualTo: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                currentBookings = querySnapshot
                numberOfRowsCBT[0] = currentBookings!.count
                docRef.document((user?.email!)!).collection("completedJobs").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        completedBookings = querySnapshot
                        numberOfRowsCBT[1] = completedBookings!.count
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        currentBookingsListener.remove()
    }

}
