//
//  SavedAlbum.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

// Model class for storing required information for album. This conform to Mappable to provide Object mapping functionality of ObjectMapper and derives from Object class to make is a model for Realm

class SavedAlbum: Object, Mappable {
  @objc dynamic var name: String?
  @objc dynamic var artist: String?
  @objc dynamic var mbid: String?
  @objc dynamic var imageUrl: String?
  @objc dynamic var url: String?

  var tracks = List<Track>()

  func mapping(map: Map) {
    name <- map["album.name"]
    artist <- map["album.artist"]
    mbid <- map["album.mbid"]
    imageUrl <- map["album.image.3.#text"]
    url <- map["album.url"]
    tracks <- (map["album.tracks.track"], ArrayTransform<Track>())
  }

  override static func primaryKey() -> String? {
    return "url"
  }

  required convenience init?(map: Map) {
    self.init()
  }
  

  func createDetatched() -> SavedAlbum {
    let copy = SavedAlbum(value: self)
    copy.tracks.removeAll()
    for track in tracks {
      copy.tracks.append(Track(value: track))
    }
    return copy
  }
}
