//
//  HomeCollectionViewCell.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 25/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
  @IBOutlet var albumImageView: UIImageView!
  
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var albumName: UILabel!
  @IBOutlet var artistName: UILabel!
  
  func setUp(album: SavedAlbum) {
    albumName.text = album.name
    artistName.text = album.artist
    albumImageView.image = nil
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    
    if let url = URL(string: album.imageUrl ?? "") {
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
