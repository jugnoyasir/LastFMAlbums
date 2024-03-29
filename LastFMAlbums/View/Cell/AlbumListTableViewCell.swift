//
//  AlbumListTableViewCell.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 23/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import AlamofireImage
import UIKit

class AlbumListTableViewCell: UITableViewCell {
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var playCountLabel: UILabel!
  @IBOutlet var albumImageView: UIImageView!
  @IBOutlet var savedImageView: UIImageView!
  
  func setUp(album: Album, isSaved: Bool) {
    reset()
    nameLabel.text = album.name
    playCountLabel.text = album.playCount == nil ? ""
      : "Play count \(album.playCount!)"
    
    if let url = URL(string: album.imageUrl ?? "") {
      albumImageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "loading"))
    }else {
      albumImageView.image = UIImage(named: "notfound")
    }
    
    savedImageView.image = isSaved ? UIImage(named: "saved") : nil
  }
  
  private func reset() {
    nameLabel.text = nil
    playCountLabel.text = nil
    albumImageView.image = nil
    savedImageView.image = nil
  }
}
