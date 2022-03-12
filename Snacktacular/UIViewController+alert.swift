//
//  UIViewController+alert.swift
//  ToDo List
//
//  Created by song on 1/17/22.
//  Copyright © 2022 song. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func oneButtonAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
