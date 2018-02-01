//
//  AVPlayer+Extension.swift
//  KMP3
//
//  Created by KhuongPham on 2/2/18.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0
    }
    
    var duration: Double? {
        return currentItem?.asset.duration.toSecond()
    }
}
