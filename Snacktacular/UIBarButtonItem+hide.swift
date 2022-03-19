//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by song on 3/18/22.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
