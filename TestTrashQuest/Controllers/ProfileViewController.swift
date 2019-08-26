//
//  ProfileViewController.swift
//  TestTrashQuest
//
//  Created by student on 26/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var badgePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set all rounded corners
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        badgePicture.layer.cornerRadius = badgePicture.frame.size.width / 2
        
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
