//
//  PlayerService.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import AVFoundation
import UIKit

final class PlayerService: NSObject, AVAudioPlayerDelegate {
    let cacheService: CacheService
    var player: AVAudioPlayer!
    
    init(cacheService: CacheService) {
        self.cacheService = cacheService
    }
    
    func play(from url: URL) {
        fetch(url: url, completion: { data in
            if let data = data {
                self.player = try! AVAudioPlayer(data: data)
                self.player.delegate = self
                self.player.play()
            }
        })
    }
    
    
    /// fetch song from memory, if there is no data then fetch song from disk, if there is no data then download song from network
    ///
    /// - Parameters:
    ///   - url: the url to fetch from memory, disk or download from network
    ///   - completion: callback to return data
    private func fetch(url: URL, completion: @escaping (Data?) -> Void) {
        cacheService.loadData(url: url, completion: { [weak self] data in
            if let data = data {
                completion(data)
            } else if let data = try? Data(contentsOf: url) {
                completion(data)
                self?.cacheService.save(data: data, url: url)
            } else {
                completion(nil)
            }
        })
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
}

