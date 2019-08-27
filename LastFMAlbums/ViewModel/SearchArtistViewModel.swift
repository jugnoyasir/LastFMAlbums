//
//  SearchArtistViewModel.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import ObjectMapper

protocol SearchArtistViewModelDelegate: class {
  func updateArtist()
  func startLoading()
  func stopLoading()
  func scrollToTop()
  func receivedError(error: LastFMAlbumsError)
}

protocol SearchArtistViewModelProtocol: class {
  var artists: [Artist] { get set }
  var delegate: SearchArtistViewModelDelegate? { get set }
  var query: String { get set }
  func fetchArtist()
  func fetchNextPage()
}

class SearchArtistViewModel: SearchArtistViewModelProtocol {
  var artists: [Artist] = []
  weak var delegate: SearchArtistViewModelDelegate?
  
  var query: String = "" {
    didSet {
      fetchArtist()
    }
  }
  
  private var provider: MoyaProvider<LastFMApi>
  private var reachable: Reachable?
  private var request: Cancellable?
  private var page = 1
  private let limit = 50
  
  init(provider: MoyaProvider<LastFMApi> = MoyaProvider<LastFMApi>(), reachable: Reachable? = NetworkReachabilityManager()) {
    self.provider = provider
    self.reachable = reachable
  }
  
  // fetch first page
  func fetchArtist() {
    guard query.count > 0 else{
      return
    }
    // Cancel any previous request because the search string has been already changed by user
    request?.cancel()
    page = 1
    fetchArtist(isFirstPage: true)
  }
  
  // fetch next page
  func fetchNextPage() {
    page += 1
    fetchArtist(isFirstPage: false)
  }
  
  private func fetchArtist(isFirstPage: Bool) {
    if let connected = reachable?.isReachable, connected == false {
      delegate?.receivedError(error: .noNetwork)
      return
    }
    if artists.count == 0 {
      delegate?.startLoading()
    }
    
    request = provider.request(.searchArtist(name: query, page: page, limit: limit)) { [weak self] result in
      
      guard let confirmedSelf = self else {
        return
      }
      confirmedSelf.delegate?.stopLoading()
      
      switch result {
      case .success(let responseData):
 
        if let filteredResponse = try? responseData.filterSuccessfulStatusCodes(), let responseJson = try? filteredResponse.mapJSON() as? [String: Any], let result = responseJson["results"] as? [String: Any], let artistMacthed = result["artistmatches"] as? [String: Any], let artistDict = artistMacthed["artist"] as? [[String: Any]] {
          let newArtist = Mapper<Artist>().mapArray(JSONArray: artistDict)
          if isFirstPage {
            confirmedSelf.delegate?.scrollToTop()
            confirmedSelf.artists.removeAll()
          }
          
          confirmedSelf.artists.append(contentsOf: newArtist)
          confirmedSelf.delegate?.updateArtist()
          
        } else {
          confirmedSelf.delegate?.receivedError(error: .badResponse)
        }
      case .failure(let error):
        switch error {
        case .underlying(let error as NSError, _):
          // filter out request cancelltion error
          if error.code == -999 {
          } else {
            confirmedSelf.delegate?.receivedError(error: .unknown)
          }
         default:
          confirmedSelf.delegate?.receivedError(error: .unknown)
        }
      }
    }
  }
}
