//
//  Constraint.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation
import UIKit

/// Use for adding constraint without resizing mask
struct Constraint {
    static func on(constraints: [NSLayoutConstraint]) {
        constraints.forEach {
            ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
            $0.isActive = true
        }
    }
    
    static func on(_ constraints: NSLayoutConstraint ...) {
        on(constraints: constraints)
    }
}
