//
//  ArrayTransform.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 24/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import RealmSwift
import ObjectMapper

class ArrayTransform<T: RealmSwift.Object>: TransformType where T: Mappable {
  typealias Object = List<T>
  typealias JSON = Array<AnyObject>
  
  /**
   - Parameter value: JSON Value
   - Returns: if value is `nil` or not Array will be return empty List<T>
   */
  func transformFromJSON(_ value: Any?) -> Object? {
    let result = Object()
    guard let _value = value,
      let objectArray = _value as? Array<AnyObject> else { return result }
    
    let mapper = Mapper<T>()
    
    for object in objectArray {
      //if model is `nil` continue to next object
      guard let model = mapper.map(JSONObject: object) else {
        continue
      }
      
      result.append(model)
    }
    
    return result
  }
  
  /**
   - Parameter value: RealmSwift Object
   - Returns: if value is `nil` or empty will be return empty Array<AnyObject>
   */
  func transformToJSON(_ value: Object?) -> JSON? {
    var result = JSON()
    guard let _value = value, _value.count > 0 else { return  result }
    
    result = _value.map { $0 }
    
    
    return result
  }
}
