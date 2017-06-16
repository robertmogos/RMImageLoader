//
//  ImageCellCollectionViewCell.swift
//  RMImageLoader
//
//  Created by Robert D. Mogos.
//  Copyright © 2017 Robert D. Mogos. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  func load(withURL URL: URL) {
    imageView.image = nil
    imageView.loadURL(url: URL)
  }
}
