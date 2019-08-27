//
//  Reachable.swift
//  LastFMAlbums
//
//  Created by Yasir Perwez on 22/08/19.
//  Copyright © 2019 Yasir Perwez. All rights reserved.
//

import Alamofire

// Protocol to check if the phone is currently connected to network
protocol Reachable {
  var isReachable: Bool { get }
}

extension NetworkReachabilityManager: Reachable {}
