//
//  Artist.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import ObjectMapper

// Model class for Artist
class Artist: Mappable {
  var name: String?
  var mbid: String?
  var listeners: String?

  func mapping(map: Map) {
    name <- map["name"]
    mbid <- map["mbid"]
    listeners <- map["listeners"]
  }

  required convenience init?(map: Map) {
    self.init()
  }
}
