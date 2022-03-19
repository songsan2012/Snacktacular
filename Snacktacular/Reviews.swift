//
//  Reviews.swift
//  Snacktacular
//
//  Created by song on 3/18/22.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(spot: Spot, completed: @escaping() -> ()) {
        guard spot.documentID != "" else {
            return
        }
        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                
                return completed()
            }
            self.reviewArray = [] // Clean out existing spotArray since new data will load
            
            // There are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let review = Review(dictionary: document.data())
                
//                spot.documentID = document.documentID
                review.documentID = document.documentID
                self.reviewArray.append(review)
                
            }
            completed()
        }
    }
    
}
