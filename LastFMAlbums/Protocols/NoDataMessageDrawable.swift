//
//  EmptyViewDrawable.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import UIKit

// Protocal to display a message when Collection View or Table View do not have any data. Both table view and collection will have to conform to this protocal if they want use the basic function, provided by the extention of this protocol, to display a message when they do not have any data.

protocol NoDataMessageDrawable: class {
  var backgroundView: UIView? { get set }
  var bounds: CGRect { get set }

  func setEmptyMessage(_ message: String)
  func clearMessage()
}

extension NoDataMessageDrawable {
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.font = UIFont.systemFont(ofSize: 15)
    messageLabel.sizeToFit()

    self.backgroundView = messageLabel
  }

  func clearMessage() {
    self.backgroundView = nil
  }
}

extension UICollectionView: NoDataMessageDrawable {}
extension UITableView: NoDataMessageDrawable {}
