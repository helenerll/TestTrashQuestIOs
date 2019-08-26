//
//  MapViewController.swift
//  TestTrashQuest
//
//  Created by student on 20/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase

class MapViewController: UIViewController {

    
    
    
    var currentUser : User!
    
    var userEmail = String()

    @IBOutlet weak var labelTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        //print("useremail \(userEmail)")
        
            //getCurrentUser(email: userEmail)
            //helloLabel.text = "Hello \(currentUser.name)"
        
        }
 
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Connexion is ok for user : \(user)")
            } else {
                //traitement si perte authentification
                let alertLoggedOut = UIAlertController(title: "Server alert", message: "Sorry you've been logged out, please log in to pursue with your quest !", preferredStyle: .alert)
                let backToLogAction = UIAlertAction(title: "Back to Log In", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "backToLogIn", sender: nil)
                })
                alertLoggedOut.addAction(backToLogAction)
                self.present(alertLoggedOut, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToLogIn" {
            if let loginViewController = segue.destination as? ViewController {
                loginViewController.userEmail = userEmail
            }
        }
    }
    
    
    
//    func renvoiUser(user: User) -> User {
//
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
