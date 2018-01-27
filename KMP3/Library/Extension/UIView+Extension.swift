//
//  UIView+Extension.swift
//  KMP3
//
//  Created by KhuongPham on 1/26/18.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T : UIView>() -> T {
        let className = String(describing: self)
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)![0] as! T
    }
    
    class func fromNib<T : UIView>(type: T.Type) -> T {
        let className = String(describing: self)
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)![0] as! T
    }
    
    func roundRect(_ round : Float) {
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(round)
    }
    
    func roundCircle() {
        roundRect(Float(frame.width / 2))
    }
    
    func roundHeight() {
        roundRect(Float(frame.height / 2))
    }
    
    var scale: CGFloat {
        set(value) {
            transform = CGAffineTransform(scaleX: value, y: value)
        }
        get {
            return 0
        }
    }
    
}
