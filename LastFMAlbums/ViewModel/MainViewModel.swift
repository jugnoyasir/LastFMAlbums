//
//  MainViewModel.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import RealmSwift


protocol MainViewModelDelegate: class {
  func updateAlbums()
}

protocol MainViewModelProtocol: class {
  var savedAlbums: Results<Object>? { get set }
  var delegate: MainViewModelDelegate? { get set }
  func setUp()
}
// ViewModel for Main View
class MainViewModel: MainViewModelProtocol {
  
  weak var delegate: MainViewModelDelegate?
  var savedAlbums: Results<Object>?

  private var token: NotificationToken?
  private var realmManager: RealmManagerProtocol

  init(realmManager: RealmManagerProtocol = RealmManager()) {
    self.realmManager = realmManager
  }

  func setUp() {
    
    token = realmManager.getObjects(type: SavedAlbum.self, realm: nil).sorted(byKeyPath: "name", ascending: true).observe { [weak self] changes in

      switch changes {
        case .initial(let collection):
          self?.savedAlbums = collection
          self?.delegate?.updateAlbums()
      case .update:
          self?.delegate?.updateAlbums()
        case .error(let err):
          fatalError("\(err.localizedDescription)")
      }
    }
  }
}
