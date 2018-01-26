//
//  SongTests.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import XCTest

final class SongTests: XCTest {
    func testDecode() throws {
        let json: [String: Any] = [
            "author": [
                "name":"Aleks",
                "picture": [
                    "s": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/360x360",
                    "m": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/640x640",
                    "l": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/1024x1024",
                    "xs": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/100x100",
                    "url": "https://bandlab-test-images.azureedge.net/v1.0/users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/"
                ]
            ],
            "createdOn":"2016-09-23T08:15:13Z",
            "modifiedOn":"2016-09-23T08:15:13Z",
            "picture": [
                "s": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/360x360",
                "m": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/640x640",
                "l": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/1024x1024",
                "xs": "https://bandlab-test-images.azureedge.net/v1.0/Users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/100x100",
                "url": "https://bandlab-test-images.azureedge.net/v1.0/users/71c81538-4e88-e511-80c6-000d3aa03fb0/636016633463395803/"
            ],
            "audioLink":"https://a.clyp.it/iv1xl24p.mp3",
            "id":"0",
            "name":"Song 1"
        ]
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let song = try decoder.decode(Song.self, from: data)
        
        XCTAssertEqual(song.author.name, "Aleks")
        XCTAssertEqual(song.audioLink, URL(string: "https://a.clyp.it/iv1xl24p.mp3")!)
    }
}

