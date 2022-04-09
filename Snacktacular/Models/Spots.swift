//
//  Spots.swift
//  Snacktacular
//
//  Created by song on 3/12/22.
//

import Foundation
import Firebase


class Spots {
    var spotArray: [Spot] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping() -> ()) {
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                
                return completed()
            }
            self.spotArray = [] // Clean out existing spotArray since new data will load
            
            // There are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let spot = Spot(dictionary: document.data())
                
                spot.documentID = document.documentID
                self.spotArray.append(spot)
                
            }
            completed()
        }
    }
    
}
