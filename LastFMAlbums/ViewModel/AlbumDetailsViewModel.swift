//
//  AlbumDetailsViewModel.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 24/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation

protocol AlbumDetailsViewModelProtocol: class {
  var savedAlbum: SavedAlbum { get set }
  func saveAlbum()
  func deleteAlbum()
  func isSaved() -> Bool
}

class AlbumDetailsViewModel: AlbumDetailsViewModelProtocol {
  var savedAlbum: SavedAlbum
  private let realmManager: RealmManagerProtocol

  init(savedAlbum: SavedAlbum, realmManager: RealmManagerProtocol = RealmManager()) {
    self.savedAlbum = savedAlbum
    self.realmManager = realmManager
  }

  func isSaved() -> Bool {
    if let url = savedAlbum.url {
      return realmManager.getObject(type: SavedAlbum.self, primaryKey: url, realm: nil) == nil ? false : true
    }
    return false
  }

  // save album to realm
  func saveAlbum() {
    let albumCopy = savedAlbum.createDetatched()
    saveAlbum(album: albumCopy)
  }

  // delete album from realm
  func deleteAlbum() {
    if let url = savedAlbum.url {
      savedAlbum = savedAlbum.createDetatched()
      deleteAlbum(primaryKey: url)
    }
  }

  private func saveAlbum(album: SavedAlbum) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      
      let realm = self?.realmManager.getNewRealm()
      self?.realmManager.saveObject(obj: album, realm: realm)
    }

  }

  private func deleteAlbum(primaryKey: String) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in

      let realm = self?.realmManager.getNewRealm()
      if let albumToDelete = self?.realmManager.getObject(type: SavedAlbum.self, primaryKey: primaryKey, realm: realm) {
        self?.realmManager.deleteObject(object: albumToDelete, realm: realm)
      }
    }
  }
}
