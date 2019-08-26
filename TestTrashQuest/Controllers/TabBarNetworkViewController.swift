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

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        db = Firestore.firestore()
        
        self.delegate = self
        
        print("balbalablablabalba", mail)
        getCurrentUser(email: mail)

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
                    self.currentUser = user
                }
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("passage par tabbarcontroller")
        let newIndex = tabBarController.selectedIndex
        switch newIndex {
        case 0:
            if let map = viewController as? MapViewController {
                map.labelTest.text = currentUser.name
                break
            }
        case 1:
            if let profile = viewController as? ProfileViewController {
                profile.nameLabel.text! = currentUser.name
                profile.levelLabel.text! = currentUser.badge
            }
        default:
            break
        }
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
