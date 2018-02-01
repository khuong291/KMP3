//
//  PlayerService.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import AVFoundation
import UIKit

final class PlayerService: NSObject {
    private let cacheService: CacheService
    private(set) var player: AVPlayer!
    private var progressSet = Set<URL>() // Use for checking which song is being downloaded
    
    /// Signal for the current playing song. Initially there is no playing song yet
    let currentSongSignal = Binding<Song?>(value: nil)
    
    init(cacheService: CacheService) {
        player = AVPlayer()
        self.cacheService = cacheService
    }
    
    
    /// Check if current song is playing
    func isPlaying() -> Bool {
        guard currentSongSignal.value != nil else {
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
            // Seek time to 0
            player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        } else {
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
        }
        
        currentSongSignal.value = currentSongSignal.value
    }

    /// Seek player to time
    func seekToTime(_ time: Double) {
        player.seek(to: CMTime(value: CMTimeValue(time), timescale: 1))
    }
    
    /// Pause current playing song
    func pause() {
        if isPlaying() {
            player.pause()
            currentSongSignal.value = currentSongSignal.value
        }
    }

    /// Fetch audio file then assign currentSongSignal to a new value
    private func fetchAndPlayAsNew(song: Song) {
        // Check if this song was cached
        if let url = cacheService.exists(url: song.audioLink) {
            let item = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: item)
            player.play()
        } else { // Otherwise play stream this song from network
            let item = AVPlayerItem(url: song.audioLink)
            player.replaceCurrentItem(with: item)
            player.play()
            
            // In parallel, if this song is not in download progress then save this song data
            if !progressSet.contains(song.audioLink) {
                downloadAndSave(url: song.audioLink)
            }
            // insert the download progress of this song into Set
            progressSet.insert(song.audioLink)
        }
        
        self.currentSongSignal.value = song
    }
    
    /// fetch song from memory, if there is no data then fetch song from disk, if there is no data then download song from network
    ///
    /// - Parameters:
    ///   - url: the url to fetch from memory, disk or download from network
    ///   - completion: callback to return data
    private func fetch(url: URL, completion: @escaping (Data?) -> Void) {
        cacheService.loadData(url: url, completion: { [weak self] data in
            if let data = data { // If audio data was cached
                completion(data)
            } else if let data = try? Data(contentsOf: url) { // Download audio data and save to memory and disk
                completion(data)
                self?.cacheService.save(data: data, url: url)
            } else {
                completion(nil)
            }
        })
    }
    
    // Download audio data and save to memory and disk
    private func downloadAndSave(url: URL) {
        DispatchQueue.global().async { // Use background queue because Data(contentOf: url) dispatched in main thread
            if let data = try? Data(contentsOf: url) {
                self.cacheService.save(data: data, url: url)
            }
        }
    }

}

