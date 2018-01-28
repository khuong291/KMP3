//
//  Song.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import Foundation

// Use class instead of struct to update isPlaying status
final class Song: Codable {
    let author: Author
    let createdOn: Date
    let modifiedOn: Date
    let picture: Picture
    let audioLink: URL
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case createdOn
        case modifiedOn
        case picture
        case audioLink
        case id
        case name
    }
    
    // Not come from json, use to check the song is playing or not
    var isPlaying = false
}
