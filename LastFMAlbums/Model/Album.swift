//
//  Album.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import ObjectMapper

// Model class for album
class Album: Mappable {
  var name: String?
  var mbid: String?
  var imageUrl: String?
  var playCount: Int?
  var url: String?
//  var artist: String?

  func mapping(map: Map) {
    name <- map["name"]
    mbid <- map["mbid"]
    imageUrl <- map["image.1.#text"]
    playCount <- map["playcount"]
    url <- map["url"]
  }

  required convenience init?(map: Map) {
    self.init()
  }
}
