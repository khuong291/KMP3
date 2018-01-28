//
//  TimeInterval+Extension.swift
//  KMP3
//
//  Created by KhuongPham on 1/28/18.
//

import Foundation

extension TimeInterval {
    func toTime() -> String {
        let currentTime = Int(self)
        let minutes = currentTime / 60
        let seconds = (currentTime - minutes / 60) % 60
        let string = NSString(format: "%d:%02d", minutes, seconds) as String
        return string
    }
}
