//
//  RMImageLoader.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import Foundation
import UIKit



public typealias Success = (UIImage) -> ()
public typealias Failure = (Error) -> ()

///
/// RMImageLoader
///
/// Improvements: add a memory cache at this layer <URL, Image>
/// to avoid converting from Data to Image every time
class RMImageLoader {
  
  private enum Constants {
    static let queue = "com.robert-mogos.loader"
  }
  private let queue: DispatchQueue = DispatchQueue(label: Constants.queue, qos: .userInitiated)
  private let retriever: Retrieve
  
  public static let `default` = RMImageLoader(retriever: Retriever())
  
  /// Init the loader with any retriever who respects the Retrieve protocol
  public init(retriever: Retrieve) {
    self.retriever = retriever
  }
  
  
  /// Download an URL for a subscriber
  public func loadImage(url: URL, subscriber: AnyObject, success: @escaping Success, failure: Failure? = nil) {
    retriever.loadRequest(url: url, for: subscriber, completion: {[weak self] res in
      self?.queue.async {
        switch res {
        case let .success(data):
          if let image = self?.decode(data) {
            DispatchQueue.main.async {
              success(image)
            }
          } else {
            self?.handleError(NSError(domain: NSCocoaErrorDomain, code: -1, userInfo: nil), failure: failure)
          }
        case let .fail(err): self?.handleError(err, failure: failure)
        }
      }
    })
  }
  
  public func cancel(url: URL, forSubscriber subscriber: AnyObject) {
    queue.async { [weak self] in
      self?.retriever.cancel(url: url, for: subscriber)
    }
  }
  
  private func handleError(_ err: Error, failure: Failure?) {
    guard let failure = failure else {
      return
    }
    DispatchQueue.main.async {
      failure(err)
    }
  }
  
  private func decode(_ data: Data) -> UIImage? {
    guard let image = UIImage(data: data) else {
      return nil
    }
    return image
  }
}
