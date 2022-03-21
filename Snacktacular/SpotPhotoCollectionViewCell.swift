//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by song on 3/20/22.
//

import UIKit

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageVIew: UIImageView!
    
    var spot: Spot!
    var photo: Photo! {
        didSet {
            photo.loadImage(spot: spot) { (success) in
                if success {
                    self.photoImageVIew.image = self.photo.image
                } else {
                    print("😡 ERROR: no success in loading photo in SpotPhotoCollectionViewCell")
                }
            }
            
        }
    }
    
}
