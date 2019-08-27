//
//  Utility.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

// Utility class to group some common utitily function in the app
class Utility {
  static func createAlert(title: String?, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(alertAction)
    return alert
  }
}
