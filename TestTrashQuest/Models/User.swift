//
//  User.swift
//  TestTrashQuest
//
//  Created by student on 20/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var email: String
    var badge: String
    var imageProfileURL : String
    var nbCollect : Int
}

enum Badge {
    case debutant, middle, confirmed, expert
}


