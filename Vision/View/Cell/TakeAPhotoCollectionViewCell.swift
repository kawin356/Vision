//
//  TakeAPhotoCollectionViewCell.swift
//  Vision
//
//  Created by Kittikawin Sontinarakul on 27/4/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import UIKit

class TakeAPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configImage(image: UIImage){
        imageView.image = image
    }
}
