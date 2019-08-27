//
//  StoryboardInitializable.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

// Protocol which should be conformed by the viewcontrollers to provide a uniform way of creation
protocol StoryboardInitializable where Self: UIViewController {
  static func instantiateFromStoryboard() -> Self
}
