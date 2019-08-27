//
//  Constants.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation

class Constants {
  struct Api {
    static let baseURL = "http://ws.audioscrobbler.com/2.0/"
    static let key = "991ec724fc3bbf6ecc3615af972a90ed"
  }

  struct ErrorMessages {
    static let warning = "Warning"
    static let error = "Error"
    static let tryAfterSometime = "There is some error in fetching images. Try after some time"
    static let noNetwork = "Kein Netzwerk. Please connect to Internet and try again"
    static let noAlbumSaved = "You have not saved any ablum. Please save some album by clicking on the search button"
  }
}
