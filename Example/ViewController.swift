//
//  ViewController.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  private enum Constants {
    static let imageCell = "ImageCell"
  }
  
  private let photos: [URL] = [
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/1.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/2.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/3.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/4.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/5.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/6.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/7.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/8.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/9.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/10.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/11.jpg")!,
    URL(string: "https://s3.eu-west-2.amazonaws.com/algolia-interview/photos/12.jpg")!
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView!.register(UINib.init(nibName: Constants.imageCell, bundle: nil), forCellWithReuseIdentifier: Constants.imageCell)
  }
  
  // MARK - UICollectioNView Management
  override internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  override internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCell, for: indexPath) as! ImageCell
    //cell.load(withURL: photos[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 150, height: 150)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let layout = UICollectionViewFlowLayout()
    let controller = ViewController(collectionViewLayout: layout)
    show(controller, sender: self)
  }
}
