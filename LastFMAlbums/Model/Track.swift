//
//  Track.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

// Model class for storing required information for track. This conform to Mappable to provide Object mapping functionality of ObjectMapper and derives from Object class to make is a model for Realm

class Track: Object, Mappable {
  @objc dynamic var name: String?
  @objc dynamic var duration: String?
//  @objc dynamic var imageURL: String?

  func mapping(map: Map) {
    name <- map["name"]
    duration <- map["duration"]
//    imageURL <- map["imageURL"]
  }

  required convenience init?(map: Map) {
    self.init()
  }
}
