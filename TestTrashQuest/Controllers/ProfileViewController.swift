//
//  ProfileViewController.swift
//  TestTrashQuest
//
//  Created by student on 26/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var badgePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
   
    @IBOutlet weak var tableView: UITableView!
    
    var collects = [Collect]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // set all rounded corners
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        badgePicture.layer.cornerRadius = badgePicture.frame.size.width / 2
        
//        let myCol = Collect(organizer: "test", title: "test", type: "test", date: "test", streetNumber: "ttest", streetName: "test", zipcode: "test", city: "test", comment: "test", privat: true)
//        let myCol1 = Collect(organizer: "test", title: "test", type: "test", date: "test", streetNumber: "ttest", streetName: "test", zipcode: "test", city: "test", comment: "test", privat: true)
//        let myCol2 = Collect(organizer: "test", title: "test", type: "test", date: "test", streetNumber: "ttest", streetName: "test", zipcode: "test", city: "test", comment: "test", privat: true)
//        collects.append(myCol)
//        collects.append(myCol1)
//        collects.append(myCol2)
        
        print("passage dans view suivante\(collects)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("passage dans view willappear\(collects)")
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectCell", for: indexPath)
        let quest = collects[indexPath.row]
        cell.detailTextLabel?.text = quest.city
        
        return cell
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
