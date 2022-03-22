//
//  SnackUsers.swift
//  Snacktacular
//
//  Created by song on 3/21/22.
//

import Foundation
import Firebase


class SnackUsers {
    var userArray: [SnackUser] = []
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping() -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("😡 ERROR: adding the snapshot listener \(error!.localizedDescription)")
                
                return completed()
            }
            self.userArray = [] // Clean out existing spotArray since new data will load
            
            // There are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let snackUser = SnackUser(dictionary: document.data())
                
                snackUser.documentID = document.documentID
                self.userArray.append(snackUser)
                
            }
            completed()
        }
    }
    
}
