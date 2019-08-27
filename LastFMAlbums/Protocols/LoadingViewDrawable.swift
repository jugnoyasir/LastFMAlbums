//
//  LoadingViewDrawable.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 25/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

// Protocal to display a loading indicator when Collection View or Table View is loading data. Both table view and collection will have to conform to this protocal if they want use the basic function, provided by the extention of this protocol, to display a loading indicator when they do not have any data.

protocol LoadingViewDrawable: class {
  var backgroundView: UIView? { get set }
  var bounds: CGRect { get set }

  func startLoading()
  func stopLoading()
}

extension LoadingViewDrawable {
  func startLoading() {
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
    activityIndicator.startAnimating()

    self.backgroundView = activityIndicator
  }

  func stopLoading() {
    self.backgroundView = nil
  }
}

extension UICollectionView: LoadingViewDrawable {}
extension UITableView: LoadingViewDrawable {}
