//
//  AlbumListViewModelTest.swift
//  LastFMAlbumsTests
//
//  Created by Yasir Perwez on 27/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

@testable import LastFMAlbums
import Moya
import ObjectMapper
import XCTest

// Test classfor AlbumListViewModel
class AlbumListViewModelTest: XCTestCase, Reachable {
  var isReachable: Bool = true

  var isUpdateAlbumOfDelegateCalled = false
  var isNoNetworkOfDelegateCalled = false
  var isAlbumReceivedOfDelegateCalled = false

  func testGetTopAlbumSetsTheAlbumCountRight() {
    let artist = Mapper<Artist>().map(JSONString: TestData.Artist.artistJson)
    
    let provider = MoyaProvider<LastFMApi>(endpointClosure: testClosureForTestingGetTopAlbumRequest, stubClosure: MoyaProvider.immediatelyStub)

    let sut = AlbumsListViewModel(artist: artist!, provider: provider, reachable: self, realmManager: RealmManager())

    sut.getTopAlbum()
    XCTAssertEqual(50, sut.albums.count)
    
  }
  
  func testGetTopAlbumCallsTheUpdateAlbumOfDelegate() {
    let artist = Mapper<Artist>().map(JSONString: TestData.Artist.artistJson)
    
    let provider = MoyaProvider<LastFMApi>(endpointClosure: testClosureForTestingGetTopAlbumRequest, stubClosure: MoyaProvider.immediatelyStub)
    
    let sut = AlbumsListViewModel(artist: artist!, provider: provider, reachable: self, realmManager: RealmManager())
    sut.delegate = self
    isUpdateAlbumOfDelegateCalled = false
    sut.getTopAlbum()
    XCTAssertTrue(isUpdateAlbumOfDelegateCalled)
  }
  
  func testGetTopAlbumCallsErrorReceivedOfDelegateInCaseofNoNework() {
    let artist = Mapper<Artist>().map(JSONString: TestData.Artist.artistJson)
    
    let provider = MoyaProvider<LastFMApi>(endpointClosure: testClosureForTestingGetTopAlbumRequest, stubClosure: MoyaProvider.immediatelyStub)
    
    let sut = AlbumsListViewModel(artist: artist!, provider: provider, reachable: self, realmManager: RealmManager())
    sut.delegate = self
    isNoNetworkOfDelegateCalled = false
    isReachable = false
    sut.getTopAlbum()
    XCTAssertTrue(isNoNetworkOfDelegateCalled)
  }
  
  func testThatGetAlbumInfoCallsDelegatesAlbumReceived() {
    let artist = Mapper<Artist>().map(JSONString: TestData.Artist.artistJson)
    let provider = MoyaProvider<LastFMApi>(endpointClosure: testClosureForTestingAlbumInfoRequest, stubClosure: MoyaProvider.immediatelyStub)
    
    let sut = AlbumsListViewModel(artist: artist!, provider: provider, reachable: self, realmManager: RealmManager())
    sut.delegate = self
    isAlbumReceivedOfDelegateCalled = false
    let album = Mapper<Album>().map(JSONString: TestData.Album.singleAlbumArray)
    sut.albums = [album!]
    
    sut.getAlbumInfo(index: 0)
    XCTAssertTrue(isAlbumReceivedOfDelegateCalled)
  }
}

extension AlbumListViewModelTest: AlbumsListViewModelDelegate {
  func updateAlbum() {
    isUpdateAlbumOfDelegateCalled = true
  }
  
  func albumReceived(savedAlbum: SavedAlbum) {
    isAlbumReceivedOfDelegateCalled = true
  }
  
  func receivedError(error: LastFMAlbumsError) {
    if error == .noNetwork {
      isNoNetworkOfDelegateCalled = true
    }
  }
  func stopLoading() {
    
  }
  
  func startProgress() {
    
  }
  
  func stopProgress() {
    
  }
  
  func startLoading() {
    
  }

}

extension AlbumListViewModelTest {
  func testClosureForTestingGetTopAlbumRequest(_ target: LastFMApi) -> Endpoint {
    return Endpoint(url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, target.testResponseSuccessData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
  }
  
  func testClosureForTestingAlbumInfoRequest(_ target: LastFMApi) -> Endpoint {
    return Endpoint(url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200, target.testResponseSuccessData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
  }
  
}
