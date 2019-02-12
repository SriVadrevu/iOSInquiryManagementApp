//
//  ProfileRegistrationVC.swift
//  quokka
//
//  Created by Sri Vadrevu on 9/25/18.
//  Copyright © 2018 PostBite. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class ProfileRegistrationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // End editing for keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // Display profile picture as round
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //--------------------------------------------------------------
    // Select Button to Pick Image & Set-Up Image Picker Controller
    //--------------------------------------------------------------
    @IBAction func chooseProfilePicture(_ sender: UIButton) {
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
            profilePicture.image = selectedPic
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
    @IBAction func registerProfileInfo(_ sender: UIButton) {
        
        let storageRef = Storage.storage().reference()
        let dbRef = Firestore.firestore()
        
        // Let's create user in Firebase and update FireStore
        Auth.auth().createUser(withEmail: profileData.email!, password: profileData.password!) { (authResult, error) in
            
            // If auth function didn't execute properly, user not created, print out error and exit
            guard let user = authResult?.user else {
                print("User Account unable to be created 🐜")
                print(error)
                
                return
            }
            print("Account registered (FireStore Users) 😂")
            
            // now after creating the user, let's the registration info to our fireStore as well, else prudce error
            dbRef.collection("Photographers").document(profileData.email!).setData([
                "first_name": profileData.firstName ?? "N/A",
                "last_name": profileData.lastName ?? "N/A",
                "email": profileData.email ?? "N/A",
                "phone": profileData.phoneNumber ?? "N/A",
                "username": profileData.username ?? "N/A"
            ]) { err in
                if let err = err {
                    print("Error writing registration info as document 🐜: \(err)")
                } else {
                    print("Basic registration info uploaded (FireStore) 😂")
                    
                    let data = UIImagePNGRepresentation(self.profilePicture.image!)
                    
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
                            dbRef.collection("Photographers").document(profileData.email!).setData(["profile_url": downloadURL.absoluteString, "bio": self.bioInfo.text], merge: true) { err in
                                if let err = err {
                                    print("Error adding video url: \(err) 🐜")
                                } else {
                                    print("Added profile pic url + bio info. (FireStore) 😂")
                                    
                                    Auth.auth().signIn(withEmail: profileData.email!, password: profileData.password!) { (user, error) in
                                        if let error = error {
                                            print("could not sign in")
                                        }
                                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                                        let bookingsVC = storyboard.instantiateViewController(withIdentifier: "UserTabBarController")
                                        self.present(bookingsVC, animated: true, completion: nil)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
