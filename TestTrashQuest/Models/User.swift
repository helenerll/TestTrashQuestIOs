//
//  User.swift
//  TestTrashQuest
//
//  Created by student on 20/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class User {
    var name: String?
    var email: String?
    var badge: String?
    var imageProfileURL : String?
    var nbCollect : Int?
    
    private init(){}
    
    init(name: String, email: String, badge: String, imageProfileURL: String, nbCollect: Int) {
        self.name = name
        self.email = email
        self.badge = badge
        self.imageProfileURL = imageProfileURL
        self.nbCollect = nbCollect
    }
    
    static var currentUser = User()
}


