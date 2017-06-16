//
//  MockLoader.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import Foundation

class MockRetriever: Retriever {
  public var fakeDelay: TimeInterval = 0
  
  override public func loadRequest(url: URL, for subscriber: AnyObject, completion: @escaping RetrieverCompletion) {
    let superLoad = super.loadRequest
    let mockCompletion: RetrieverCompletion = { [weak self] res in
      guard let this = self else {
        return
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + this.fakeDelay, execute: {
        completion(res)
      })
    }
    return superLoad(url, subscriber, mockCompletion)
  }
}
