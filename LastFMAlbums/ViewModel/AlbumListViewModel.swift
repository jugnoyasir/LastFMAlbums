//
//  AlbumsListViewModel.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 23/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import ObjectMapper

protocol AlbumsListViewModelDelegate: class {
  func updateAlbum()
  func startLoading() // for table view data
  func stopLoading()
  func startProgress() // Modal progress for album fetch
  func stopProgress()
  func albumReceived(savedAlbum: SavedAlbum)
  func receivedError(error: LastFMAlbumsError)
}

protocol AlbumsListViewModelProtocol: class {
  var albums: [Album] { get set }
  var delegate: AlbumsListViewModelDelegate? { get set }
  func getTopAlbum()
  func getAlbumInfo(index: Int)
  func isSaved(url: String) -> Bool
  func getArtistName()-> String?
}

class AlbumsListViewModel: AlbumsListViewModelProtocol {
  var albums: [Album] = []
  var artist: Artist
  weak var delegate: AlbumsListViewModelDelegate?
  
  private var provider: MoyaProvider<LastFMApi>
  private var reachable: Reachable?
  private var page = 1
  private let limit = 50
  private var realmManager: RealmManagerProtocol
  
  init(artist: Artist, provider: MoyaProvider<LastFMApi> = MoyaProvider<LastFMApi>(), reachable: Reachable? = NetworkReachabilityManager(), realmManager: RealmManagerProtocol = RealmManager()) {
    self.artist = artist
    self.provider = provider
    self.reachable = reachable
    self.realmManager = realmManager
  }
  
  func getArtistName()-> String? {
    return artist.name
  }
  
  func isSaved(url: String) -> Bool {
    return realmManager.getObject(type: SavedAlbum.self, primaryKey: url, realm: nil) == nil ? false : true
  }
  
  func getAlbumInfo(index: Int) {
    if let albumName = albums[index].name, let artistName = artist.name {
      getAlbumInfo(albumName: albumName, artistName: artistName)
    }
  }
  // get top album for an artist from LastFM
  func getTopAlbum() {
    
    guard let name = artist.name else {
      delegate?.receivedError(error: .invalidArgument)
      return
    }
    if let connected = reachable?.isReachable, connected == false {
      delegate?.receivedError(error: .noNetwork)
      return
    }
    
    delegate?.startLoading()
    provider.request(.getTopAlbum(artist: name, page: page, limit: limit)) { [weak self] result in
      guard let confirmedSelf = self else {
        return
      }
      confirmedSelf.delegate?.stopLoading()
      
      switch result {
      case .success(let responseData):
        
        if let filteredResponse = try? responseData.filterSuccessfulStatusCodes(), let jsonResponse = try? filteredResponse.mapJSON() as? [String: Any], let topAlbums = jsonResponse["topalbums"] as? [String: Any], let albumsJson = topAlbums["album"] as? [[String: Any]] {
          let newAlbums = Mapper<Album>().mapArray(JSONArray: albumsJson)
          confirmedSelf.albums.append(contentsOf: newAlbums)
          confirmedSelf.page += 1
          confirmedSelf.delegate?.updateAlbum()
        } else {
          confirmedSelf.delegate?.receivedError(error: .badResponse)
        }
        
      case .failure:
        confirmedSelf.delegate?.receivedError(error: .unknown)
      }
    }
  }
  // get album details from LastFM
  private func getAlbumInfo(albumName: String, artistName: String) {
    if let connected = reachable?.isReachable, connected == false {
      delegate?.receivedError(error: .noNetwork)
      return
    }
    delegate?.startProgress()
    provider.request(.getAlbumDetails(artist: artistName, album: albumName)) { [weak self] result in
      guard let confirmedSelf = self else {
        return
      }
      confirmedSelf.delegate?.stopProgress()
      switch result {
      case .success(let responseData):

        if let filteredResponse = try? responseData.filterSuccessfulStatusCodes(), let jsonResponse = try? filteredResponse.mapJSON() as? [String: Any], let album = Mapper<SavedAlbum>().map(JSON: jsonResponse) {
          confirmedSelf.delegate?.albumReceived(savedAlbum: album)
        }else {
            confirmedSelf.delegate?.receivedError(error: .badResponse)
        }
      case .failure:
        confirmedSelf.delegate?.receivedError(error: .unknown)
      }
    }
  }
}
