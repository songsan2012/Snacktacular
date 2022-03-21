//
//  Photos.swift
//  Snacktacular
//
//  Created by song on 3/20/22.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping() -> ()) {
        guard spot.documentID != "" else {
            return
        }
        db.collection("spots").document(spot.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                
                return completed()
            }
            self.photoArray = [] // Clean out existing spotArray since new data will load
            
            // There are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
                
            }
            completed()
        }
    }
    
}
