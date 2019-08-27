//
//  Error.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation

// Error that need to propagate while calling Internal API
enum LastFMAlbumsError: Error {
  case noNetwork
  case badResponse
  case unknown
  case invalidArgument
}
