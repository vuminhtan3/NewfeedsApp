//
//  Conectivity.swift
//  NewfeedsApp
//
//  Created by Minh Tan Vu on 23/06/2023.
//

import Foundation
import Alamofire

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!

  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
