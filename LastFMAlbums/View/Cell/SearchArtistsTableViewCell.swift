//
//  SearchArtistsTableViewCell.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 23/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import AlamofireImage
import UIKit

class SearchArtistsTableViewCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var listenersLabel: UILabel!

  func setUp(artist: Artist) {
    nameLabel.text = artist.name ?? ""
    listenersLabel.text = artist.listeners == nil ? ""
      : "Listners counts \(artist.listeners!)"
  }
}
