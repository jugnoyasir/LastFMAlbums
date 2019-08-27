//
//  LastFMApi+Test.swift
//  LastFMAlbumsTests
//
//  Created by Yasir Perwez on 27/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
@testable import LastFMAlbums

// Extension on LastFMApi for custom test data
extension LastFMApi {
  var testResponseSuccessData: Data {
    switch self {
    case .getTopAlbum:
      return TestData.Album.topAlbumsJsonResponse.data(using: .utf8) ?? Data()
    case .getAlbumDetails:
      return TestData.Album.albumJsonResponse.data(using: .utf8) ?? Data()
    default:
      return Data()
    }
  }
}
