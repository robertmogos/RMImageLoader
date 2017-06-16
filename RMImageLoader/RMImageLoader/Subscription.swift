//
//  OwnerRequest.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import Foundation
import UIKit

public struct Subscription {
  weak var subscriber: AnyObject?
  let completion: RetrieverCompletion
  
  init(subscriber: AnyObject, completion: @escaping RetrieverCompletion) {
    self.subscriber = subscriber
    self.completion = completion
  }
}
