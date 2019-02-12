//
//  DeniedProjectsTableVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/9/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase

let userDPT = Auth.auth().currentUser
var deniedProjects: QuerySnapshot? = nil
let reuseIdentifierDPT = "deniedProjectsCell"
let docRefDPT = Firestore.firestore().collection("Photographers")
var numberOfRowsDPT: Int! = 0
var indexDeniedProjects: Int! = 1
var deniedProjectsListener: ListenerRegistration!

class DeniedProjectsTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = userDPT {
            docRefDPT.document(user.email!).collection("deniedJobs").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else {
                        deniedProjects = querySnapshot
                        numberOfRowsDPT = deniedProjects!.count
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
        return numberOfRowsDPT
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierDPT, for: indexPath) as! DeniedProjectsCell
        
        let firstName = deniedProjects?.documents[indexPath.row].data()["firstName"] as! String
        let lastName = deniedProjects?.documents[indexPath.row].data()["lastName"] as! String
        cell.clientName.text = firstName + " " + lastName
        cell.clientBookingTitle.text = (deniedProjects?.documents[indexPath.row].data()["location"] as! String)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexDeniedProjects = indexPath.row
        performSegue(withIdentifier: "showDeniedProjectsDetailVC", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deniedProjectsListener = docRefDPT.document((user?.email!)!).collection("deniedJobs").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                deniedProjects = querySnapshot
                numberOfRowsDPT = deniedProjects!.count
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deniedProjectsListener.remove()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
