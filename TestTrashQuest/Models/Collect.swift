//
//  Collect.swift
//  TestTrashQuest
//
//  Created by student on 27/08/2019.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

struct Collect: Codable {
    var organizer: String
    var title: String
    var type: String
    var date: String
    var streetNumber: String
    var streetName: String
    var zipcode: String
    var city: String
    var comment: String
    var privat: Bool
    
    enum CodingKeys: String, CodingKey {
        case organizer = "organizer"
        case title = "title"
        case type = "type"
        case date = "date"
        case streetNumber = "streetNumber"
        case streetName = "streetName"
        case zipcode = "zipcode"
        case city = "city"
        case comment = "comment"
        case privat = "privacy"
    }
    
    init(organizer: String, title: String, type: String, date: String, streetNumber: String, streetName : String, zipcode: String, city: String, comment: String, privat: Bool) {
        self.organizer = organizer
        self.title = title
        self.type = type
        self.date = date
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.zipcode = zipcode
        self.city = city
        self.comment = comment
        self.privat = privat
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        organizer = try values.decode(String.self, forKey: CodingKeys.organizer)
        title = try values.decode(String.self, forKey: CodingKeys.title)
        type = try values.decode(String.self, forKey: CodingKeys.type)
        date = try values.decode(String.self, forKey: CodingKeys.date)
        streetNumber = try values.decode(String.self, forKey: CodingKeys.streetNumber)
        streetName = try values.decode(String.self, forKey: CodingKeys.streetName)
        zipcode = try values.decode(String.self, forKey: CodingKeys.zipcode)
        city = try values.decode(String.self, forKey: CodingKeys.city)
        comment = try values.decode(String.self, forKey: CodingKeys.comment)
        privat = try values.decode(Bool.self, forKey: CodingKeys.privat)
    }
}

struct Collects: Codable {
    var collects: [Collect]
}
