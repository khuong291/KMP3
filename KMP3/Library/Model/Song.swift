//
//  Song.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

struct Song: Codable {
    let author: Author
    let createdOn: Date
    let modifiedOn: Date
    let picture: Picture
    let audioLink: URL
    let id: String
    let name: String
}
