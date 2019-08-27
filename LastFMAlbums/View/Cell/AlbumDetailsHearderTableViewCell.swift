//
//  AlbumDetailsHearderTableViewCell.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 24/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import AlamofireImage
import UIKit

class AlbumDetailsHearderTableViewCell: UITableViewCell {
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var artistNameLabel: UILabel!
  @IBOutlet var albumNameLabel: UILabel!
  @IBOutlet var albumImageView: UIImageView!
  func setup(savedAlbum: SavedAlbum) {
    albumNameLabel.text = savedAlbum.name
    artistNameLabel.text = savedAlbum.artist
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()

    if let url = URL(string: savedAlbum.imageUrl ?? "") {
      albumImageView.af_setImage(
        withURL: url,
        placeholderImage: nil,
        filter: nil,
        imageTransition: .crossDissolve(0.5),
        completion: { [weak self] closureResponse in
          if closureResponse.result.isSuccess {
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
          }
        }
      )
    }
  }
}
