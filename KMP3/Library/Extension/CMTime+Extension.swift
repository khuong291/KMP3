//
//  CMTime+Extension.swift
//  KMP3
//
//  Created by KhuongPham on 2/2/18.
//

import Foundation
import AVFoundation

extension CMTime {
    func toSecond() -> Double {
        return CMTimeGetSeconds(self)
    }
}
