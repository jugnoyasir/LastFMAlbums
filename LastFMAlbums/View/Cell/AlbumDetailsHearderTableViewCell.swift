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
    reset()
    albumNameLabel.text = savedAlbum.name
    artistNameLabel.text = savedAlbum.artist

    if let url = URL(string: savedAlbum.imageUrl ?? "") {
      activityIndicator.isHidden = false
      activityIndicator.startAnimating()
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
    }else{
      self.loadNoFoundImage()
    }
  }

  private func loadNoFoundImage() {
    activityIndicator.stopAnimating()
    activityIndicator.isHidden = true
    albumImageView.image = UIImage(named: "notfound")
  }
  
  private func reset() {
    albumNameLabel.text = nil
    artistNameLabel.text = nil
    albumImageView.image = nil
    activityIndicator.isHidden = true
    activityIndicator.stopAnimating()
  }
  
}
