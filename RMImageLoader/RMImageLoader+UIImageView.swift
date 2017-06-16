//
//  RMImageLoader+UIImageView.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import Foundation
import UIKit

var UImageViewURLKey: UInt = 0
var UImageViewURLLoadedKey: UInt = 1

extension UIImageView {
  
  var url: URL? {
    get {
      return objc_getAssociatedObject(self, &UImageViewURLKey) as? URL
    } set {
      objc_setAssociatedObject(self, &UImageViewURLKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  var urlLoaded: Bool? {
    get {
      return objc_getAssociatedObject(self, &UImageViewURLLoadedKey) as? Bool
    } set {
      objc_setAssociatedObject(self, &UImageViewURLLoadedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
    }
  }
  
  
  /// Loading an async URL
  /// Discussion: When loading an URL for an imageView we should cancel the previous subscription.
  /// For the download, it's optional since we might want to show it later.
  /// Useful when reusing cells and
  public func loadURL(url: URL, cancelPrevious: Bool? = false) {
    if let previousURL = self.url, self.urlLoaded == false, cancelPrevious == true {
      RMImageLoader.default.cancel(url: previousURL, forSubscriber: self)
    }
    self.url = url
    self.urlLoaded = false
    RMImageLoader.default.loadImage(url: url, subscriber: self, success: {[weak self] in
      if (self?.url == url) {
        self?.image = $0
        self?.urlLoaded = true
      }
      }, failure: {
        print($0)
    })
  }
  
  /// Cancel the download of a specific URL for an UIImageView
  public func cancel(url: URL) {
    RMImageLoader.default.cancel(url: url, forSubscriber: self)
  }
}
