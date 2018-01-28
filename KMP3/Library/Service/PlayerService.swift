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
    
    /// Signal for the current playing song. Initially there is no playing song yet
    let currentSongSignal = Binding<Song?>(value: nil)
    
    init(cacheService: CacheService) {
        self.cacheService = cacheService
    }
    
    
    /// Check if current song is playing
    func isPlaying() -> Bool {
        guard currentSongSignal.value != nil else {
            return false
        }
        
        guard player != nil else {
            return false
        }
            
        return player.isPlaying
    }
    
    /// Play a song
    func play(song: Song, forcePlayAgain: Bool = false) {
        guard let currentSong = currentSongSignal.value, currentSong.id == song.id else {
            fetchAndPlayAsNew(song: song)
            return
        }
        
        if forcePlayAgain {
            player.currentTime = 0
        } else {
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
        }
        
        currentSongSignal.value = currentSongSignal.value
    }

    /// Fetch audio file then assign currentSongSignal to a new value
    private func fetchAndPlayAsNew(song: Song) {
        fetch(url: song.audioLink, completion: { data in
            guard let data = data else {
                return
            }
            
            self.player = try! AVAudioPlayer(data: data)
            self.player.delegate = self
            self.player.play()
            
            // Signal that the song is in current
            self.currentSongSignal.value = song
        })
    }
    
    /// Pause current playing song
    func pause() {
        if isPlaying() {
            player.pause()
            currentSongSignal.value = currentSongSignal.value
        }
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

