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


// Please Read:
/*
  I have used two approaches to test AlbumListViewModel networking and delegation.
 1- Using Async Moya stub, XCTestExpectation and callback closure to fullfil those expection. This approach needs some experiece to understand and maintain.
 
 2- The second approach simple, easy to understand for new comers. In this approach Immediate Moya stub is used with a boolean flag to check that right method of delegates are called.
 
 Only one approache of testing should be use in a project but I just wanted to show how I generally do unit testing depending on the team and project.
 */

class AlbumListViewModelTest: XCTestCase, Reachable {
  var isReachable: Bool = true
  
  var albumUpdatedSuccessClosure: (() -> Void)?
  
  var isNoNetworkOfDelegateCalled = false
  var isAlbumReceivedOfDelegateCalled = false
  
  func testGetTopAlbumSetsTheAlbumCountRight() {
    
    let artist = Mapper<Artist>().map(JSONString: TestData.Artist.artistJson)
    let provider = MoyaProvider<LastFMApi>(endpointClosure: testClosureForTestingGetTopAlbumRequest, stubClosure: MoyaProvider.delayedStub(1))
    
    let sut = AlbumsListViewModel(artist: artist!, provider: provider, reachable: self, realmManager: RealmManager())
    sut.delegate = self
    
    let exp = expectation(description: "testGetTopAlbumSetsTheAlbumCountRight")
    
    albumUpdatedSuccessClosure = {
      exp.fulfill()
    }
    
    sut.getTopAlbum()
    
    waitForExpectations(timeout: 2)
    XCTAssertEqual(50, sut.albums.count)
    
    albumUpdatedSuccessClosure = nil
  }
  
  func testGetTopAlbumCallsTheUpdateAlbumOfDelegate() {
    
    let artist = Mapper<Artist>().map(JSONString: TestData.Artist.artistJson)
    let provider = MoyaProvider<LastFMApi>(endpointClosure: testClosureForTestingGetTopAlbumRequest, stubClosure: MoyaProvider.immediatelyStub)
    
    let sut = AlbumsListViewModel(artist: artist!, provider: provider, reachable: self, realmManager: RealmManager())
    sut.delegate = self
    
    let exp = expectation(description: "testGetTopAlbumSetsTheAlbumCountRight")
    
    albumUpdatedSuccessClosure = {
      exp.fulfill()
    }
    
    sut.getTopAlbum()
    waitForExpectations(timeout: 2)
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
    albumUpdatedSuccessClosure?()
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
