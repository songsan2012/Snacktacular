//
//  SpotPhotoCollectionViewCell.swift
//  Snacktacular
//
//  Created by song on 3/20/22.
//

import UIKit
import SDWebImage

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageVIew: UIImageView!
    
    var spot: Spot!
    var photo: Photo! {
        didSet {
            
            if let url = URL(string: self.photo.photoURL) {
                self.photoImageVIew.sd_imageTransition = .fade
                self.photoImageVIew.sd_imageTransition?.duration = 0.2
                self.photoImageVIew.sd_setImage(with: url)
            } else {
                print("URL didn't work \(self.photo.photoURL)")
                
                // -- Load the existing images to add URL so it will get cached next time
                self.photo.loadImage(spot: self.spot) { (success) in
                    self.photo.saveData(spot: self.spot) { (success) in
                        print("image updated with URL \(self.photo.photoURL)")
                    }
                }
                
            }
            
            
            
//            photo.loadImage(spot: spot) { (success) in
//                if success {
//                    self.photoImageVIew.image = self.photo.image
//                } else {
//                    print("😡 ERROR: no success in loading photo in SpotPhotoCollectionViewCell")
//                }
//            }
            
            
            
        }
    }
    
}
