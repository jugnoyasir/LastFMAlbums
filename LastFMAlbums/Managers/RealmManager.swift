//
//  RealmManager.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol: class {
  
  func write(codeToExecute: () -> Void, realm: Realm?)
  func getObjects(type: Object.Type, realm: Realm?) -> Results<Object>
  func getObject(type: Object.Type, primaryKey: String, realm: Realm?) -> Object?
  func saveObject(obj: Object, realm: Realm?)
  func deleteObject(object: Object, realm: Realm?)
  func getNewRealm() -> Realm
}

// A wrapper class around Realm to provide all basic operation using Realm
class RealmManager: RealmManagerProtocol {
  // Main thread Realm object. Should be used in all request that comes from main there
  private let mainRealm = try! Realm()
  
  // delete an object
  func deleteObject(object: Object, realm: Realm?) {
    let realm = realm ?? mainRealm
    try! realm.write {
      realm.delete(object)
    }
  }
  
  // save single object
  func saveObject(obj: Object, realm: Realm?) {
    let realm = realm ?? mainRealm
    try! realm.write {
      realm.add(obj, update: .all)
    }
  }
    
  // get objects
  func getObjects(type: Object.Type, realm: Realm?) -> Results<Object> {
    let realm = realm ?? mainRealm
    return realm.objects(type)
  }
  
  // get objects
  func getObject(type: Object.Type, primaryKey: String, realm: Realm?) -> Object? {
    let realm = realm ?? mainRealm
    return realm.object(ofType: SavedAlbum.self, forPrimaryKey: primaryKey)
  }
  
//  // create a new Realm Object. And use it, may be any  background thread
  func getNewRealm() -> Realm {
    return try! Realm()
  }
  
  // To edit a realm object. It basically execute any closure after opening a write context
  func write(codeToExecute: () -> Void, realm: Realm?) {
    let realm = realm ?? mainRealm
    try! realm.write {
      codeToExecute()
    }
  }
}
