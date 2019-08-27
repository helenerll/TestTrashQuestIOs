//
//  ViewController.swift
//  TestTrashQuest
//
//  Created by student on 20/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets vue acceuil
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notAMemberButton: UIButton!
    
    //Outlets registerView
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var setName: UITextField!
    @IBOutlet weak var setEmail: UITextField!
    @IBOutlet weak var setPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    //var utilisée pour récup mail depuis segue perte de connexion
    var userEmail = String()
    
    var ref : DatabaseReference!
    var refDoc : DocumentReference?
    var db : Firestore?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        db = Firestore.firestore()
        
        //set all rounded corners
        loginButton.layer.cornerRadius = 10
        notAMemberButton.layer.cornerRadius = 10
        registerView.layer.cornerRadius = 10
        profilePicture.backgroundColor = .gray
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        registerButton.layer.cornerRadius = 10
        
        //hide register form
        registerView.isHidden = true
        
        //recup mail depuis autres views
        guard userEmail.isEmpty else {
            mailText.text = userEmail
            return
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Connexion is ok for user : \(user)")
            }
            //traitement si perte authentification
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //passage mail à TabBarNetworkController
        if segue.identifier == "showMapController" {
            if let tabBarNetworkViewController = segue.destination as? TabBarNetworkViewController {
                if mailText.text!.isEmpty {
                    tabBarNetworkViewController.mail = setEmail.text!
                }
                else if setEmail.text!.isEmpty {
                    tabBarNetworkViewController.mail = mailText.text!
                }
            }
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        let email = mailText.text
        let password = passwordText.text
        if let email = email, let password = password {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let user = user {
                    self.performSegue(withIdentifier: "showMapController", sender: nil)
                }
                else {
                    print("Error type : \(error)")
                        if password.count < 6 {
                            //set toast (from Alert swift file)
                            let errorLogPwd = "Password must be more than 6 characters"
                            Toast.show(message: errorLogPwd, controller: self)
                            return
                        }
                        let errorLogin = "Error during login"
                        Toast.show(message: errorLogin, controller: self)
                }
            }
        }
    }
    
    //reveal form
    @IBAction func registerFormAppear(_ sender: Any) {
        registerView.isHidden = false
        loginButton.isEnabled = false
    }
    
    @IBAction func registerProtocol(_ sender: Any) {
        let registerName = setName.text
        let registerEmail = setEmail.text
        let registerPassword = setPassword.text
        print(registerPassword)
        if let mail = registerEmail, let password = registerPassword {
            print(password)
            Auth.auth().createUser(withEmail: mail, password: password) { (authResult, error) in
                if let error = error {
                    print("unable to reach Firebase error : \(error)")
                    if password.count < 6 {
                        //set toast (from Alert swift file)
                        let errorLogPwd = "Password must be more than 6 characters"
                        Toast.show(message: errorLogPwd, controller: self)
                        return
                    }
                    let errorLogin = "Error during login"
                    Toast.show(message: errorLogin, controller: self)
                    return
                }
                else if let authResult = authResult {
                    //add image to storage
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                    let uploadData = self.profilePicture.image!.pngData()
                    if let data = uploadData {
                        storageRef.putData(data, metadata: nil) { (metadata, error) in
                            if let error = error {
                                print("unable to store data + error : \(error)")
                            }
                            else if let metadata = metadata {
                                print(metadata)
                                storageRef.downloadURL() { (url, error) in
                                    if let error = error {
                                        print("unable to get url + \(error)")
                                    }
                                    if let imageURL = url?.absoluteString {
                                        print("\(imageURL)")
                                        let data : [String: Any] = ["name": registerName,
                                                                    "email": registerEmail,
                                                                    "nbCollect": 0,
                                                                    "badge": "debutant",
                                                                    "imageProfileURL": imageURL]
                                        self.registerNewUser(data: data)
                                    }
                                }
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func registerNewUser(data: [String: Any]) {
        self.refDoc = self.db?.collection("user").addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to add new user + \(error)")
            }
            else {
                self.registerView.isHidden = true
                self.performSegue(withIdentifier: "showMapController", sender: nil)
            }
        }
    }
    
    //image picker
    @IBAction func choosePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePicture.contentMode = .scaleToFill
            profilePicture.image = image
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture.contentMode = .scaleToFill
            profilePicture.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backToMainPage(_ sender: Any) {
        print("passe par bouton effacer + back")
        setName.text = ""
        setEmail.text = ""
        setPassword.text = ""
        registerView.isHidden = true
        loginButton.isEnabled = true
    }
    
    
    
    
    
}

