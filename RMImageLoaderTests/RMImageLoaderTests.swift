//
//  RMImageLoaderTests.swift
//  RMImageLoaderTests
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import XCTest
@testable import RMImageLoader

class RMImageLoaderTests: XCTestCase {
  
  static let bundle = Bundle.init(for: RMImageLoaderTests.classForCoder())
  var timeout:TimeInterval = 100
  var fakeDelay:TimeInterval = 1
  
  var imageLoader: RMImageLoader!
  var mockRetriever: MockRetriever!
  
  override func setUp() {
    super.setUp()
    mockRetriever = MockRetriever()
    mockRetriever.fakeDelay = fakeDelay
    imageLoader = RMImageLoader.init(retriever: mockRetriever)
  }
  
  static func getImage(named: String) -> UIImage? {
    guard let path = RMImageLoaderTests.bundle.path(forResource: named, ofType: "") else {
      return nil
    }
    return UIImage(contentsOfFile: path)
  }
  
  static func getImageURL(named: String) -> URL? {
    return RMImageLoaderTests.bundle.url(forResource: named, withExtension: "")
  }
  
  func testSimpleLoader() {
    let expectation = self.expectation(description: #function)
    let imageName = "img1.png"
    let url = RMImageLoaderTests.getImageURL(named: imageName)
    let image = RMImageLoaderTests.getImage(named: imageName)
    
    imageLoader.loadImage(url: url!, subscriber: self, success: {
      XCTAssertEqual(UIImagePNGRepresentation($0), UIImagePNGRepresentation(image!))
      expectation.fulfill()
    })
    self.waitForExpectations(timeout: timeout, handler: nil)
  }
  
  func testMultipleSubscribersSameURL() {
    let expSubscriber1 = self.expectation(description: "\(#function)-subscriber1")
    let expSubscriber2 = self.expectation(description: "\(#function)-subscriber2")
    
    let imageName = "img1.png"
    let url = RMImageLoaderTests.getImageURL(named: imageName)
    let image = RMImageLoaderTests.getImage(named: imageName)
    
    imageLoader.loadImage(url: url!, subscriber: self, success: {
      XCTAssertEqual(UIImagePNGRepresentation($0), UIImagePNGRepresentation(image!))
      expSubscriber1.fulfill()
    })
    
    let tmpOwner = UIImageView()
    imageLoader.loadImage(url: url!, subscriber: tmpOwner, success: {
      XCTAssertEqual(UIImagePNGRepresentation($0), UIImagePNGRepresentation(image!))
      expSubscriber2.fulfill()
    })
    self.waitForExpectations(timeout: timeout, handler: nil)
  }
  
  func testMultipleSubscribersMultipleURLs() {
    let expSubscriber1 = self.expectation(description: "\(#function)-subscriber1")
    let expSubscriber2 = self.expectation(description: "\(#function)-subscriber2")
    
    let imageName1 = "img1.png"
    let url1 = RMImageLoaderTests.getImageURL(named: imageName1)
    let image1 = RMImageLoaderTests.getImage(named: imageName1)
    
    imageLoader.loadImage(url: url1!, subscriber: self, success: {
      XCTAssertEqual(UIImagePNGRepresentation($0), UIImagePNGRepresentation(image1!))
      expSubscriber1.fulfill()
    })
    
    let imageName2 = "img2.png"
    let url2 = RMImageLoaderTests.getImageURL(named: imageName2)
    let image2 = RMImageLoaderTests.getImage(named: imageName2)
    
    
    imageLoader.loadImage(url: url2!, subscriber: self, success: {
      XCTAssertEqual(UIImagePNGRepresentation($0), UIImagePNGRepresentation(image2!))
      expSubscriber2.fulfill()
    })
    self.waitForExpectations(timeout: timeout, handler: nil)
  }
  
  func testError() {
    let expSubscriber1 = self.expectation(description: "\(#function)-subscriber1")
    imageLoader.loadImage(url: URL(string: "file://dummy_should_fail")!, subscriber: self, success: {_ in
      XCTFail("Should fail since the file doesnt exist")
    }, failure: {
      XCTAssertNotNil($0)
      expSubscriber1.fulfill()
    })
    self.waitForExpectations(timeout: timeout, handler: nil)
  }
  
  func testCancel() {
    let imageName1 = "img1.png"
    let url1 = RMImageLoaderTests.getImageURL(named: imageName1)!
    
    imageLoader.loadImage(url: url1, subscriber: self, success: { _ in
      XCTFail("Should not be called since we canceled the request")
    }, failure: { _ in
      XCTFail("Should not be called since we canceled the request")
    })
    imageLoader.cancel(url: url1, forSubscriber: self)
    sleep(2)
  }
  
  func testPartialCancel() {
    let expSubscriber1 = self.expectation(description: "\(#function)-subscriber1")
    
    let imageName1 = "img1.png"
    let url1 = RMImageLoaderTests.getImageURL(named: imageName1)!
    let image1 = RMImageLoaderTests.getImage(named: imageName1)!
    
    imageLoader.loadImage(url: url1, subscriber: self, success: {
      XCTAssertEqual(UIImagePNGRepresentation($0), UIImagePNGRepresentation(image1))
      expSubscriber1.fulfill()
    })
    
    let imageName2 = "img2.png"
    let url2 = RMImageLoaderTests.getImageURL(named: imageName2)!
    
    imageLoader.loadImage(url: url2, subscriber: self, success: { _ in
      XCTFail("Should not be called since we canceled the request")
    }, failure: { _ in
      XCTFail("Should not be called since we canceled the request")
    })
    
    imageLoader.cancel(url: url2, forSubscriber: self)
    sleep(2)
    self.waitForExpectations(timeout: timeout, handler: nil)
  }
}
