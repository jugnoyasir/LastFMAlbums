//
//  LastFMApi.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import Moya

enum LastFMApi {
  case searchArtist(name: String, page: Int, limit: Int)
  case getTopAlbum(artist: String, page: Int, limit: Int)
  case getAlbumDetails(artist: String, album: String)
}

extension LastFMApi: TargetType {
  var baseURL: URL {
    return URL(string: Constants.Api.baseURL)!
  }
  
  var path: String {
    return ""
  }
  
  var method: Moya.Method {
    switch self {
    case .searchArtist, .getTopAlbum, .getAlbumDetails:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .searchArtist(let name, let page, let limit):
      return .requestParameters(parameters: ["method": "artist.search", "artist": name, "api_key": Constants.Api.key, "format": "json", "page": page, "limit": limit], encoding: URLEncoding.default)
    case .getTopAlbum(let artist, let page, let limit):
      return .requestParameters(parameters: ["method": "artist.gettopalbums", "artist": artist, "api_key": Constants.Api.key, "format": "json", "page": page, "limit": limit], encoding: URLEncoding.default)
    case .getAlbumDetails(let artist, let album):
      return .requestParameters(parameters: ["method": "album.getinfo", "artist": artist, "album": album, "api_key": Constants.Api.key, "format": "json"], encoding: URLEncoding.default)
    }
  }
  
  var headers: [String: String]? {
    return ["Content-type": "application/json",
            "Accept": "application/json"]
  }
}
