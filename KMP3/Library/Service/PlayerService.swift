//
//  PlayerService.swift
//  KMP3
//
//  Created by KhuongPham on 1/27/18.
//

import AVFoundation

final class PlayerService: NSObject, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer!
    
    func play(song: Song) {
        do {
            DispatchQueue.global().async {
                let data = try! Data(contentsOf: song.audioLink)
                self.player = try! AVAudioPlayer(data: data)
                self.player.delegate = self
                self.player.play()
            }
        }
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

