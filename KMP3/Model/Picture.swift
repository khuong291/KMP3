//
//  Picture.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

struct Picture: Codable {
    let small: URL
    let medium: URL
    let large: URL
    let extraSmall: URL
    let normal: URL
    
    enum CodingKeys: String, CodingKey {
        case small = "s"
        case medium = "m"
        case large = "l"
        case extraSmall = "xs"
        case normal = "url"
    }
}
