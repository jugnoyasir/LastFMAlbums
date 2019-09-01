//
//  AlbumDetailsTrackTableViewCell.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 24/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

class AlbumDetailsTrackTableViewCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var listenersLabel: UILabel!

  func setUp(track: Track) {
    reset()
    nameLabel.text = track.name ?? ""
    listenersLabel.text = track.duration == nil ? ""
      : "Duration \(track.duration!)"
  }
  
  private func reset() {
    nameLabel.text = nil
    listenersLabel.text = nil
  }
}
