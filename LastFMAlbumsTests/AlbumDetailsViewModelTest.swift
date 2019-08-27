//
//  AlbumDetailsViewControllerTest.swift
//  LastFMAlbumsTests
//
//  Created by Yasir Perwez on 26/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

@testable import LastFMAlbums
import ObjectMapper
import RealmSwift
import XCTest

class AlbumDetailsViewModelTest: XCTestCase {
  var sut: AlbumDetailsViewModel!

  override func setUp() {
    // create an in memory Realm for testing and clean it
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
    // creat an album object from json
    let album = Mapper<SavedAlbum>().map(JSONString: TestData.Album.albumJsonResponse)
    // create sut
    sut = AlbumDetailsViewModel(savedAlbum: album!)
  }

  override func tearDown() {
    sut = nil
  }

  func testThatAlbumIsSaved() {
    sut.saveAlbum()
    var count = 0

    let expectation = self.expectation(description: "testThatAlbumIsSaved")
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      count = try! Realm().objects(SavedAlbum.self).count
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)
    
    XCTAssertEqual(1, count)
  }

  func testThatAlbumIsDeleted() {
    // save an album in Realm
    let realm = try! Realm()
    try! realm.write {
      realm.add(sut.savedAlbum)
    }
    // delete album
    sut.deleteAlbum()

    var count = 0

    let expectation = self.expectation(description: "testThatAlbumIsDeleted")
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      count = try! Realm().objects(SavedAlbum.self).count
      expectation.fulfill()
    }
    waitForExpectations(timeout: 10, handler: nil)

    XCTAssertEqual(0, count)
  }

  func testThatAnAlbumExists() {
    // save an album in Realm
    let realm = try! Realm()
    try! realm.write {
      realm.add(sut.savedAlbum)
    }

    XCTAssertTrue(sut.isSaved())
  }
}
