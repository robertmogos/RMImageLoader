//
//  Retriever.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import Foundation

public typealias RetrieverCompletion = (Result<(Data)>) -> Void

/// Protocol that need to be implemented by any retriever
public protocol Retrieve {
  func loadRequest(url: URL, for subscriber: AnyObject, completion: @escaping RetrieverCompletion)
  func cancel(url: URL, for subscriber: AnyObject)
}


/// Class for fetching data.
/// Multiple subscribers can attach to the same URL in order to avoid re-downloading the same content
public class Retriever: Retrieve {
  private enum Constants {
    static let queue = "com.robert-mogos.retriever"
    static let diskPath = "com.robert-mogos.cache"
  }
  
  private enum Memory {
    static let diskCapacity = 100 * 1024 * 1024
    static let capacity = 20 * 1024 * 1024
  }
  
  private let session: URLSession
  private let queue = DispatchQueue(label: Constants.queue, qos: .userInitiated)
  private var tasks: [URL: URLSessionDataTask] = [:]
  private var subscriptions: [URL: [Subscription]] = [:]
  
  
  /// Creates a new Retriever with an URLSessionConfiguration given as a parameter or `defaultSessionConfiguration` by default
  public init(_ sessionConfiguration: URLSessionConfiguration = Retriever.defaultSessionConfiguration()) {
    self.session = URLSession(configuration: sessionConfiguration)
  }
  
  private static func defaultSessionConfiguration() -> URLSessionConfiguration {
    let conf = URLSessionConfiguration.default
    conf.urlCache = URLCache(memoryCapacity: Memory.capacity,
                             diskCapacity: Memory.diskCapacity,
                             diskPath: Constants.diskPath)
    conf.requestCachePolicy = .returnCacheDataElseLoad
    return conf
  }
  
  /// Download an URL for a `subscriber`
  /// + Note: If the url was already asked by someone else, we would just append a new subscription to the task
  /// Otherwise, we create a new dataTask and attach the subscription to it
  public func loadRequest(url: URL, for subscriber: AnyObject, completion: @escaping RetrieverCompletion) {
    queue.sync { [weak self] in
      guard let this = self else {
        return
      }
      defer {
        let subscription = Subscription(subscriber: subscriber, completion: completion)
        if this.subscriptions[url] == nil {
          this.subscriptions[url] = [subscription]
        } else {
          this.subscriptions[url]?.append(subscription)
        }
      }
      if (self?.subscriptions[url] != nil) {
        return
      }
      let urlRequest = URLRequest(url: url)
      let dataTask = this.session.dataTask(with: urlRequest, completionHandler: { data, _, error in
        if let data = data {
          this.subscriptions[url]?.forEach({
            $0.completion(.success(data))
          })
        } else {
          let err = error ?? NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
          this.subscriptions[url]?.forEach({
            $0.completion(.fail(err))
          })
        }
        this.tasks.removeValue(forKey: url)
        this.subscriptions.removeValue(forKey: url)
      })
      
      this.tasks[url] = dataTask
      dataTask.resume()
    }
  }
  
  
  /// When canceling a request for an URL and Subscriber we check to see if aren't other subscribers
  /// for the same url. If that's the case, we just remove the subscription but we keep on downloading the content
  public func cancel(url: URL, for subscriber: AnyObject) {
    _ = queue.sync {
      if tasks[url] == nil {
        return
      }
      if subscriptions[url] == nil {
        return
      }
      
      guard let existingSubIndex = subscriptions[url]?.index(where: {
        guard let existingSubscriber = $0.subscriber else {
          return false
        }
        return existingSubscriber === subscriber
      }) else {
        return
      }
      subscriptions[url]?.remove(at: existingSubIndex)
      if (subscriptions[url]?.isEmpty)! {
        let task = tasks[url]
        task?.cancel()
        tasks.removeValue(forKey: url)
        subscriptions.removeValue(forKey: url)
      }
    }
  }

  deinit {
    session.invalidateAndCancel()
  }
}
