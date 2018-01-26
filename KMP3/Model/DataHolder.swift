//
//  DataHolder.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

struct DataHolder<T: Codable>: Codable {
    let data: [T]
}
