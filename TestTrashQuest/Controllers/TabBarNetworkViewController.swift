//
//  TabBarNetworkViewController.swift
//  TestTrashQuest
//
//  Created by student on 26/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class TabBarNetworkViewController: UITabBarController, UITabBarControllerDelegate {
    
    var ref : DatabaseReference!
    var db : Firestore?
    
    var mail = String()
    var currentUser : User!
    var profilePicture: UIImage!
    var collects = [Collect]()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        db = Firestore.firestore()
        
       self.delegate = self

        print("balbalablablabalba", mail)
        print("\(User.currentUser.name)")
        
        if User.currentUser.name == nil {
            getCurrentUser(email: mail)
            print("passage par méthode")
        }
        

    }
    

    func getCurrentUser(email: String) {
        db?.collection("user").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, error) in
            if let doc = querySnapshot?.documents.first {
                guard let name = doc["name"] as? String else {
                    print("error handling firebase")
                    return
                }
                let userName = name
                let userMail = doc["email"] as? String ?? ""
                let userBadge = doc["badge"] as? String ?? ""
                let userImageProfileURL = doc["imageProfileURL"] as? String ?? ""
                let userNbCollect = doc["nbCollect"] as? Int ?? nil
                if let nbCollect = userNbCollect {
                    let user = User(name: userName, email: userMail, badge: userBadge, imageProfileURL: userImageProfileURL, nbCollect: nbCollect)
                    print(user)
                    User.currentUser = user
                }
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("passage par tabbarcontroller")
        let newIndex = tabBarController.selectedIndex
        print(newIndex)
        switch newIndex {
        case 0:
            if let map = viewController as? MapViewController {
                print("passe par mapview")
                print("username + \(User.currentUser.name)")
                map.labelTest.text = User.currentUser.name
                break
            }
        case 1:
            
            if let profile = viewController as? ProfileViewController {
                
                db?.collection("quest").whereField("organizer", isEqualTo: User.currentUser.name).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("no quest for user \(User.currentUser.name) + \(error)")
                    }
                    else if let querySnapshot = querySnapshot {
                        for document in querySnapshot.documents {
                            let data = document.data()
                            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            if let jsonData = jsonData {
                                let decoder = JSONDecoder()
                                let quest = try? decoder.decode(Collect.self, from: jsonData)
                                guard let myQuest = quest else {return}
                                    self.collects.append(myQuest)
                                    print("\(self.collects)")
                                    profile.collects = self.collects
                                if let profilePic = User.currentUser.imageProfileURL, let name = User.currentUser.name, let userBadge = User.currentUser.badge {
                                    self.getProfilePicture(picture: profilePic)
                                    profile.profilePicture.image = self.profilePicture
                                    profile.nameLabel.text! = name
                                    profile.levelLabel.text! = userBadge
                                    let badge = self.getBadge(badge: userBadge)
                                    profile.badgePicture.image = badge
                                    //profile.collects = collects
                                }
                                }
                            
                        }
                    }
                }
                
                
            }
        default:
            break
        }
    }
    
    
    func getBadge(badge: String) -> UIImage? {
        var currentUserBadge = UIImage()
        switch badge {
        case "debutant":
            if let seed = UIImage(named: "seed") {currentUserBadge = seed}
        case "talented":
            if let sprout = UIImage(named: "sprout") {currentUserBadge = sprout}
        case "intermediate":
            if let plant = UIImage(named: "plant") {currentUserBadge = plant}
        case "experienced":
            if let shrub = UIImage(named: "shrub") {currentUserBadge = shrub}
        case "expert":
            if let tree = UIImage(named: "tree") {currentUserBadge = tree}
        default:
            break
        }
        return currentUserBadge
    }
    
    func getProfilePicture(picture: String) {
        let storRef = Storage.storage().reference(forURL: picture)
        storRef.getData(maxSize: (1 * 2048 * 2048)) {(data, error) in
            if let error = error {
                print("Erreur récupération image = \(error)")
            }
            else if let data = data {
                let myImage: UIImage! = UIImage(data: data)
                print(myImage)
                self.profilePicture = myImage
            }
        }
    }
    
    func getCollectList() {
//        db?.collection("quest").whereField("organizer", isEqualTo: User.currentUser.name).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("no quest for user \(User.currentUser.name) + \(error)")
//            }
//            else if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
//                    let data = document.data()
//                    let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//                    if let jsonData = jsonData {
//                        let decoder = JSONDecoder()
//                        let quest = try? decoder.decode(Collect.self, from: jsonData)
//                        guard let myQuest = quest else {return}
//                        self.collects?.append(myQuest)
//                        print("\(myQuest)") }
//                    }
//            }
//        }
        //print("collectes for current user \(self.collects)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
