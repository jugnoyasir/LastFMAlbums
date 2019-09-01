//
//  HomeCollectionViewCell.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 25/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import AlamofireImage
import UIKit

class MainCollectionViewCell: UICollectionViewCell {
  @IBOutlet var albumImageView: UIImageView!
  
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var albumName: UILabel!
  @IBOutlet var artistName: UILabel!
  
  func setUp(album: SavedAlbum) {
    reset()
    albumName.text = album.name
    artistName.text = album.artist
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
          } else {
            if let error = closureResponse.result.error as? AlamofireImage.AFIError {
              if error != AlamofireImage.AFIError.requestCancelled {
                self?.loadNoFoundImage()
              }
            } else {
              self?.loadNoFoundImage()
            }
          }
        }
      )
    } else {
      loadNoFoundImage()
    }
  }
  
  private func reset() {
    albumName.text = nil
    artistName.text = nil
    albumImageView.image = nil
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
  }
  
  private func loadNoFoundImage() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    albumImageView.image = UIImage(named: "notfound")
  }
}
