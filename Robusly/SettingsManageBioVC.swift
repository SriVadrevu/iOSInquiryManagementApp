//
//  SettingsManageBioVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 10/2/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingsManageBioVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var CurrentProfilePic: UIImageView!
    @IBOutlet weak var CurrentProfileBio: UITextView!
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display Current Profile Picture as Round
        CurrentProfilePic.layer.cornerRadius = CurrentProfilePic.frame.size.width / 2
        CurrentProfilePic.clipsToBounds = true
        
        // End editing for keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //------------------------------
        // Display Current Profile Info
        //------------------------------
        if let user = user {
            let docRef = Firestore.firestore().collection("Photographers").document(user.email!)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Obtain Profile Bio
                    if let bio = document["bio"] as? String {
                        self.CurrentProfileBio.text = bio
                    } else { print("Error retrieving Profile Bio 🐜")}
                    // Obtain Profile Pic
                    if let url = document["profile_url"] as? String {
                        let imageUrl = URL(string: url)!
                        let imageData = try! Data(contentsOf: imageUrl)
                        self.CurrentProfilePic.image = UIImage(data: imageData)!
                    } else { print("Error retrieving Profile Picture 🐜")}
                } else {
                    print("Could not obtain logged in user information 🐜")
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
    

    //--------------------------------------------------------------
    // Select Button to Pick Image & Set-Up Image Picker Controller
    //--------------------------------------------------------------
    @IBAction func chooseProfilePic(_ sender: Any) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow videos to be picked from photolibrary, not taken.
        imagePickerController.sourceType = .photoLibrary
        // default restricted to just photos
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //---------------------------------------------
    // what to do when user picks the actual image
    //---------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if  let selectedPic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            CurrentProfilePic.image = selectedPic
            print("Properly picked profile image. 😂")
        } else {
            print("Error in unwrapping selected video as a local file URL! 🐜")
        }
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    //---------------------------------------
    // Remove Image Picker when User Cancels
    //---------------------------------------
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    //------------------------------------------------
    // Upload Profile Info into FireStore and Storage
    //------------------------------------------------
    @IBAction func updateProfileInfo(_ sender: Any) {
        let storageRef = Storage.storage().reference()
        let dbRef = Firestore.firestore()
        
        let data = UIImagePNGRepresentation(CurrentProfilePic.image!)
        
        // Create a reference to the file you want to upload + specify file name (random generate)
        var uuid = UUID().uuidString
        uuid = "profilepics/" + uuid + ".png"
        let profilePicRef = storageRef.child(uuid)
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = profilePicRef.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Uh-oh, could not store profile picture in Firebase Storage! 🐜")
                return
            }
            print("Uploaded profile picture (Storage) 😂")
            
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            
            profilePicRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Could not obtain download url for uploaded profile picture! 🐜")
                    return
                }
                print("Obtained download url of uploaded file. (Storage) 😂")
                
                // Add reference under profile user in FireStore for profile picture
                dbRef.collection("Photographers").document(self.user!.email!).setData(["profile_url": downloadURL.absoluteString, "bio": self.CurrentProfileBio.text], merge: true) { err in
                    if let err = err {
                        print("Error adding video url: \(err) 🐜")
                    } else {
                        print("Added profile pic url + bio info. (FireStore) 😂")
                    }
                }
            }
        }
    }


}
